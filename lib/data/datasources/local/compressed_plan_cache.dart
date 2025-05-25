import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quien_para/core/logger/logger.dart';
import 'package:quien_para/core/performance/compression_utils.dart';
import 'package:quien_para/core/performance/performance_metrics.dart';
import 'package:quien_para/data/datasources/local/plan_cache_interface.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';

/// Caché de planes con compresión de datos para reducir el uso de almacenamiento
/// Implementa métricas de rendimiento para monitorear efectividad del caché
/// Implementación avanzada del caché de planes que incluye:
/// - Compresión de datos para reducir el uso de almacenamiento
/// - Sistema LRU (Least Recently Used) para gestión de memoria
/// - Métricas de rendimiento detalladas
/// - Diferentes niveles de prioridad y duración de caché
class CompressedPlanCache implements PlanCacheInterface {
  // Constantes de caché
  static const String _plansCacheBox = 'compressed_plans_cache';
  static const String _metadataBox = 'compressed_plans_metadata';
  static const String _otherUserPlansCachePrefix = 'other_user_plans_';
  static const String _priorityPlansCachePrefix = 'priority_plans_';

  // Diferentes duraciones de caché según la prioridad
  static const Duration _regularCacheDuration = Duration(minutes: 15);
  static const Duration _priorityCacheDuration = Duration(minutes: 30);
  static const Duration _userPlansCacheDuration = Duration(hours: 1);

  // Límites para el caché
  static const int _maxCachedPlansPerCategory = 50; // Máximo por categoría

  // Estado de inicialización
  static bool _initialized =
      false; // lib/data/datasources/local/compressed_plan_cache.dart
  // Métricas y estado
  int _cacheHits = 0;
  int _cacheMisses = 0;
  int _compressionSavingsBytes = 0;

  // Métricas de rendimiento
  final PerformanceMetrics _metrics = PerformanceMetrics();

  /// Inicializar el sistema de caché
  @override
  Future<void> init() async {
    try {
      if (!_initialized) {
        // Inicializar sistema de métricas
        await _metrics.init();

        // Inicializar Hive con un directorio de la aplicación
        final Directory appDir = await getApplicationDocumentsDirectory();
        await Hive.initFlutter(appDir.path);

        // Abrir los boxes necesarios
        await Hive.openBox<dynamic>(_plansCacheBox);
        await Hive.openBox<dynamic>(_metadataBox);

        _initialized = true;
        _loadMetrics();

        // Limpiar planes expirados al iniciar
        unawaited(_cleanExpiredCache());

        logger.d('CompressedPlanCache inicializado correctamente');
      }
    } catch (e) {
      logger.e('Error inicializando CompressedPlanCache:', error: e);
      _initialized = false;
    }
  }

  /// Verificar si el caché está disponible
  @override
  bool get isAvailable => _initialized;

  /// Cargar métricas guardadas
  void _loadMetrics() {
    try {
      final Box<dynamic> box = Hive.box(_metadataBox);
      _cacheHits = box.get('cache_hits', defaultValue: 0);
      _cacheMisses = box.get('cache_misses', defaultValue: 0);
      _compressionSavingsBytes =
          box.get('compression_savings_bytes', defaultValue: 0);
    } catch (e) {
      // Si hay un error, reiniciar métricas
      _cacheHits = 0;
      _cacheMisses = 0;
      _compressionSavingsBytes = 0;
    }
  }

  /// Guardar métricas actuales
  Future<void> _saveMetrics() async {
    try {
      final Box<dynamic> box = Hive.box(_metadataBox);
      await box.put('cache_hits', _cacheHits);
      await box.put('cache_misses', _cacheMisses);
      await box.put('compression_savings_bytes', _compressionSavingsBytes);

      // También registrar en el sistema de métricas general
      _metrics.recordMetric('cache', 'hits', _cacheHits);
      _metrics.recordMetric('cache', 'misses', _cacheMisses);
      _metrics.recordMetric('cache', 'hit_rate', hitRate * 100);
      _metrics.recordMetric(
          'cache', 'compression_savings_kb', _compressionSavingsBytes / 1024);
    } catch (e) {
      logger.e('Error guardando métricas de caché:', error: e);
    }
  }

  /// Obtener tasa de aciertos del caché
  @override
  double get hitRate {
    final int total = _cacheHits + _cacheMisses;
    if (total == 0) return 0.0;
    return _cacheHits / total;
  }

  /// Limpiar entradas expiradas del caché
  Future<void> _cleanExpiredCache() async {
    if (!isAvailable) return;

    _metrics.startTimer('clean_expired_cache');

    try {
      final Box<dynamic> box = Hive.box(_plansCacheBox);
      final int now = DateTime.now().millisecondsSinceEpoch;

      // Revisar todos los timestamps de caché
      final List<String> keysToDelete = [];

      for (final dynamic rawKey in box.keys) {
        final String key = rawKey.toString();

        // Saltar claves que no tienen timestamp
        if (!key.contains('_timestamp')) {
          continue;
        }

        final int timestamp = box.get(key, defaultValue: 0);
        final String cacheKey = key.replaceAll('_timestamp', '');

        // Diferentes duraciones según prefijo
        Duration cacheDuration = _regularCacheDuration;
        if (key.startsWith(_priorityPlansCachePrefix)) {
          cacheDuration = _priorityCacheDuration;
        } else if (key.startsWith(_otherUserPlansCachePrefix)) {
          cacheDuration = _userPlansCacheDuration;
        }

        // Verificar si expiró
        if (now - timestamp > cacheDuration.inMilliseconds) {
          keysToDelete.add(cacheKey);
          keysToDelete.add(key);
        }
      }

      // Eliminar entradas expiradas
      for (final String key in keysToDelete) {
        await box.delete(key);
      }

      logger.d(
          'Limpiadas ${keysToDelete.length ~/ 2} entradas expiradas del caché');
    } catch (e) {
      logger.e('Error limpiando caché expirado:', error: e);
    } finally {
      _metrics.stopTimer('clean_expired_cache');
    }
  }

  /// Almacenar planes en caché con compresión
  @override
  Future<void> cachePlans(List<PlanEntity> plans,
      {bool isPriority = false}) async {
    if (!isAvailable) {
      logger.w('Caché no disponible, saltando cachePlans');
      return;
    }

    _metrics.startTimer('cache_plans');

    try {
      final Box<dynamic> box = Hive.box(_plansCacheBox);

      // Convertir a JSON para almacenamiento
      final List<String> plansJson =
          plans.map((PlanEntity plan) => jsonEncode(plan.toJson())).toList();

      // Medir tamaño original
      final String originalData = jsonEncode(plansJson);
      final int originalSize = originalData.length;

      // Comprimir datos
      final String compressedData = CompressionUtils.compressList(plansJson);
      final int compressedSize = compressedData.length;

      // Calcular ahorro de espacio
      final int savedBytes = originalSize - compressedSize;
      _compressionSavingsBytes += (savedBytes > 0) ? savedBytes : 0;

      // Clave basada en prioridad
      final String key =
          isPriority ? '${_priorityPlansCachePrefix}all_plans' : 'all_plans';

      // Guardar datos comprimidos
      await box.put(key, compressedData);
      await box.put('${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
      await box.put('${key}_size_original', originalSize);
      await box.put('${key}_size_compressed', compressedSize);

      // Registrar métricas
      _metrics.recordMetric('compression', 'original_size', originalSize);
      _metrics.recordMetric('compression', 'compressed_size', compressedSize);
      _metrics.recordMetric(
          'compression', 'ratio', (compressedSize / originalSize) * 100);

      // Guardar métricas
      await _saveMetrics();

      if (kDebugMode) {
        final compressionRatio = (compressedSize / originalSize) * 100;
        print(
            'Compresión de planes: ${compressionRatio.toStringAsFixed(1)}% del original. '
            'Ahorro: ${(savedBytes / 1024).toStringAsFixed(1)} KB');
      }

      logger.d(
          'Cacheados ${plans.length} planes con${isPriority ? " prioridad" : ""}');
    } catch (e) {
      logger.e('Error cacheando planes:', error: e);
    } finally {
      _metrics.stopTimer('cache_plans');
    }
  }

  /// Almacenar planes por categoría
  @override
  Future<void> cacheCategoryPlans(String category, List<PlanEntity> plans,
      {bool isPriority = false}) async {
    if (!isAvailable) {
      logger.w('Caché no disponible, saltando cacheCategoryPlans');
      return;
    }

    _metrics.startTimer('cache_category_plans');

    try {
      final Box<dynamic> box = Hive.box(_plansCacheBox);

      // Limitar el número de planes por categoría
      if (plans.length > _maxCachedPlansPerCategory) {
        plans = plans.sublist(0, _maxCachedPlansPerCategory);
      }

      // Convertir a JSON para almacenamiento
      final List<String> plansJson =
          plans.map((PlanEntity plan) => jsonEncode(plan.toJson())).toList();

      // Medir tamaño original
      final String originalData = jsonEncode(plansJson);
      final int originalSize = originalData.length;

      // Comprimir datos
      final String compressedData = CompressionUtils.compressList(plansJson);
      final int compressedSize = compressedData.length;

      // Calcular ahorro de espacio
      final int savedBytes = originalSize - compressedSize;
      _compressionSavingsBytes += (savedBytes > 0) ? savedBytes : 0;

      // Clave basada en prioridad
      final String key = isPriority
          ? '${_priorityPlansCachePrefix}category_$category'
          : 'category_$category';

      // Guardar datos comprimidos
      await box.put(key, compressedData);
      await box.put('${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
      await box.put('${key}_size_original', originalSize);
      await box.put('${key}_size_compressed', compressedSize);

      // Registrar métricas
      _metrics.recordMetric(
          'compression', 'category_original_size', originalSize);
      _metrics.recordMetric(
          'compression', 'category_compressed_size', compressedSize);

      // Guardar métricas
      await _saveMetrics();

      logger.d('Cacheados ${plans.length} planes para categoría: $category');
    } catch (e) {
      logger.e('Error cacheando planes por categoría:', error: e);
    } finally {
      _metrics.stopTimer('cache_category_plans');
    }
  }

  /// Obtener planes por categoría desde el caché
  @override
  Future<List<PlanEntity>?> getCategoryPlans(String category,
      {bool isPriority = false}) async {
    if (!isAvailable) {
      logger.w('Caché no disponible, retornando null desde getCategoryPlans');
      return null;
    }

    _metrics.startTimer('get_category_plans');

    try {
      final Box<dynamic> box = Hive.box(_plansCacheBox);

      // Clave basada en prioridad
      final String key = isPriority
          ? '${_priorityPlansCachePrefix}category_$category'
          : 'category_$category';
      final String timeKey = '${key}_timestamp';

      // Verificar si hay datos en caché
      if (!box.containsKey(key) || !box.containsKey(timeKey)) {
        _cacheMisses++;
        await _saveMetrics();
        return null;
      }

      // Verificar si el caché expiró
      final int timestamp = box.get(timeKey);
      final int now = DateTime.now().millisecondsSinceEpoch;
      final Duration cacheDuration =
          isPriority ? _priorityCacheDuration : _regularCacheDuration;

      if (now - timestamp > cacheDuration.inMilliseconds) {
        _cacheMisses++;
        await _saveMetrics();
        return null;
      }

      // Recuperar datos comprimidos
      final String compressedData = box.get(key);

      // Descomprimir datos
      final List<dynamic>? plansJson =
          CompressionUtils.decompressToList(compressedData);

      if (plansJson == null) {
        _cacheMisses++;
        await _saveMetrics();
        return null;
      }

      // Convertir JSON a PlanEntity
      final List<PlanEntity> plans = plansJson
          .map((dynamic planJson) =>
              PlanEntity.fromJson(jsonDecode(planJson as String)))
          .toList();

      _cacheHits++;
      await _saveMetrics();

      logger.d(
          'Recuperados ${plans.length} planes para categoría $category desde caché '
          '(tasa de aciertos: ${(hitRate * 100).toStringAsFixed(1)}%)');
      return plans;
    } catch (e) {
      logger.e('Error obteniendo planes por categoría desde caché:', error: e);
      _cacheMisses++;
      await _saveMetrics();
      return null;
    } finally {
      _metrics.stopTimer('get_category_plans');
    }
  }

  /// Obtener planes desde el caché
  @override
  Future<List<PlanEntity>?> getCachedPlans({bool isPriority = false}) async {
    if (!isAvailable) {
      logger.w('Caché no disponible, retornando null desde getCachedPlans');
      return null;
    }

    _metrics.startTimer('get_cached_plans');

    try {
      final Box<dynamic> box = Hive.box(_plansCacheBox);

      // Clave basada en prioridad
      final String key =
          isPriority ? '${_priorityPlansCachePrefix}all_plans' : 'all_plans';
      final String timeKey = '${key}_timestamp';

      // Verificar si hay datos en caché
      if (!box.containsKey(key) || !box.containsKey(timeKey)) {
        _cacheMisses++;
        await _saveMetrics();
        return null;
      }

      // Verificar si el caché expiró
      final int timestamp = box.get(timeKey);
      final int now = DateTime.now().millisecondsSinceEpoch;
      final Duration cacheDuration =
          isPriority ? _priorityCacheDuration : _regularCacheDuration;

      if (now - timestamp > cacheDuration.inMilliseconds) {
        _cacheMisses++;
        await _saveMetrics();
        return null;
      }

      // Recuperar datos comprimidos
      final String compressedData = box.get(key);

      // Descomprimir datos
      final List<dynamic>? plansJson =
          CompressionUtils.decompressToList(compressedData);

      if (plansJson == null) {
        _cacheMisses++;
        await _saveMetrics();
        return null;
      }

      // Convertir JSON a PlanEntity
      final List<PlanEntity> plans = plansJson
          .map((dynamic planJson) =>
              PlanEntity.fromJson(jsonDecode(planJson as String)))
          .toList();

      _cacheHits++;
      await _saveMetrics();

      logger.d('Recuperados ${plans.length} planes desde caché '
          '(tasa de aciertos: ${(hitRate * 100).toStringAsFixed(1)}%)');
      return plans;
    } catch (e) {
      logger.e('Error obteniendo planes desde caché:', error: e);
      _cacheMisses++;
      await _saveMetrics();
      return null;
    } finally {
      _metrics.stopTimer('get_cached_plans');
    }
  }

  /// Almacenar planes de otros usuarios en el caché
  @override
  Future<void> storeOtherUserPlans(
      String currentUserId, List<PlanEntity> plans) async {
    if (!isAvailable) {
      logger.w('Caché no disponible, saltando storeOtherUserPlans');
      return;
    }

    _metrics.startTimer('store_other_user_plans');

    try {
      final Box<dynamic> box = Hive.box(_plansCacheBox);

      // Convertir a JSON para almacenamiento
      final List<String> plansJson =
          plans.map((PlanEntity plan) => jsonEncode(plan.toJson())).toList();

      // Medir tamaño original
      final String originalData = jsonEncode(plansJson);
      final int originalSize = originalData.length;

      // Comprimir datos
      final String compressedData = CompressionUtils.compressList(plansJson);
      final int compressedSize = compressedData.length;

      // Calcular ahorro de espacio
      final int savedBytes = originalSize - compressedSize;
      _compressionSavingsBytes += (savedBytes > 0) ? savedBytes : 0;

      final String key = '$_otherUserPlansCachePrefix$currentUserId';

      // Guardar datos comprimidos
      await box.put(key, compressedData);
      await box.put('${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
      await box.put('${key}_size_original', originalSize);
      await box.put('${key}_size_compressed', compressedSize);

      // Registrar métricas
      _metrics.recordMetric(
          'compression', 'other_user_plans_original_size', originalSize);
      _metrics.recordMetric(
          'compression', 'other_user_plans_compressed_size', compressedSize);

      // Guardar métricas
      await _saveMetrics();

      logger.d(
          'Cacheados ${plans.length} planes de otros usuarios para usuario: $currentUserId');
    } catch (e) {
      logger.e('Error cacheando planes de otros usuarios:', error: e);
    } finally {
      _metrics.stopTimer('store_other_user_plans');
    }
  }

  /// Obtener planes de otros usuarios desde el caché
  @override
  Future<List<PlanEntity>?> getOtherUserPlans(String currentUserId) async {
    if (!isAvailable) {
      logger.w('Caché no disponible, retornando null desde getOtherUserPlans');
      return null;
    }

    _metrics.startTimer('get_other_user_plans');

    try {
      final Box<dynamic> box = Hive.box(_plansCacheBox);

      final String key = '$_otherUserPlansCachePrefix$currentUserId';
      final String timeKey = '${key}_timestamp';

      // Verificar si hay datos en caché
      if (!box.containsKey(key) || !box.containsKey(timeKey)) {
        _cacheMisses++;
        await _saveMetrics();
        return null;
      }

      // Verificar si el caché expiró
      final int timestamp = box.get(timeKey);
      final int now = DateTime.now().millisecondsSinceEpoch;

      if (now - timestamp > _userPlansCacheDuration.inMilliseconds) {
        _cacheMisses++;
        await _saveMetrics();
        return null;
      }

      // Recuperar datos comprimidos
      final String compressedData = box.get(key);

      // Descomprimir datos
      final List<dynamic>? plansJson =
          CompressionUtils.decompressToList(compressedData);

      if (plansJson == null) {
        _cacheMisses++;
        await _saveMetrics();
        return null;
      }

      // Convertir JSON a PlanEntity
      final List<PlanEntity> plans = plansJson
          .map((dynamic planJson) =>
              PlanEntity.fromJson(jsonDecode(planJson as String)))
          .toList();

      _cacheHits++;
      await _saveMetrics();

      logger
          .d('Recuperados ${plans.length} planes de otros usuarios desde caché '
              '(tasa de aciertos: ${(hitRate * 100).toStringAsFixed(1)}%)');
      return plans;
    } catch (e) {
      logger.e('Error obteniendo planes de otros usuarios desde caché:',
          error: e);
      _cacheMisses++;
      await _saveMetrics();
      return null;
    } finally {
      _metrics.stopTimer('get_other_user_plans');
    }
  }

  /// Invalidar plan específico en todas las colecciones
  @override
  Future<void> invalidatePlan(String planId) async {
    if (!isAvailable) return;

    _metrics.startTimer('invalidate_plan');

    try {
      final Box<dynamic> box = Hive.box(_plansCacheBox);

      // Obtener todas las claves que contienen planes
      final List<String> planKeys = box.keys
          .cast<String>()
          .where((key) =>
              !key.contains('_timestamp') &&
              !key.contains('_size_original') &&
              !key.contains('_size_compressed'))
          .toList();

      for (final String key in planKeys) {
        // Recuperar la lista comprimida de planes
        final String? compressedData = box.get(key);
        if (compressedData == null) continue;

        // Descomprimir para procesar
        final List<dynamic>? plansJson =
            CompressionUtils.decompressToList(compressedData);
        if (plansJson == null) continue;

        // Filtrar el plan que queremos invalidar
        bool planFound = false;
        final List<String> updatedPlansJson = [];

        for (final dynamic planJson in plansJson) {
          final Map<String, dynamic> planMap = jsonDecode(planJson);
          if (planMap['id'] != planId) {
            updatedPlansJson.add(planJson);
          } else {
            planFound = true;
          }
        }

        // Si encontramos y eliminamos el plan, actualizamos el caché
        if (planFound) {
          // Volver a comprimir los datos actualizados
          final String originalData = jsonEncode(updatedPlansJson);
          final String updatedCompressedData =
              CompressionUtils.compressList(updatedPlansJson);

          // Actualizar tamaños para métricas
          final int originalSize = originalData.length;
          final int compressedSize = updatedCompressedData.length;

          // Actualizar caché
          await box.put(key, updatedCompressedData);
          await box.put('${key}_size_original', originalSize);
          await box.put('${key}_size_compressed', compressedSize);

          logger.d('Invalidado plan $planId de caché, clave: $key');
        }
      }
    } catch (e) {
      logger.e('Error invalidando plan: $planId', error: e);
    } finally {
      _metrics.stopTimer('invalidate_plan');
    }
  }

  /// Limpiar todo el caché
  @override
  Future<void> clearCache() async {
    if (!isAvailable) return;

    _metrics.startTimer('clear_cache');

    try {
      final Box<dynamic> box = Hive.box(_plansCacheBox);
      await box.clear();

      // Guardar estadísticas antes de reiniciar
      _metrics.recordMetric('cache', 'clear_count', 1);
      _metrics.recordMetric('cache', 'lifetime_hits', _cacheHits);
      _metrics.recordMetric('cache', 'lifetime_misses', _cacheMisses);
      _metrics.recordMetric(
          'cache', 'lifetime_savings_kb', _compressionSavingsBytes / 1024);

      // Reiniciar contadores
      _cacheHits = 0;
      _cacheMisses = 0;
      _compressionSavingsBytes = 0;

      await _saveMetrics();

      logger.d('Caché limpiado exitosamente');
    } catch (e) {
      logger.e('Error limpiando caché:', error: e);
    } finally {
      _metrics.stopTimer('clear_cache');
    }
  }

  /// Obtener el tamaño aproximado del caché en bytes
  @override
  Future<Map<String, int>> getCacheSize() async {
    if (!isAvailable) {
      return {
        'raw_size': 0,
        'compressed_size': 0,
        'savings': 0,
      };
    }

    _metrics.startTimer('get_cache_size');

    try {
      final Box<dynamic> box = Hive.box(_plansCacheBox);
      int totalOriginalSize = 0;
      int totalCompressedSize = 0;

      // Buscar todos los pares de tamaños
      for (final dynamic key in box.keys) {
        if (key.toString().contains('_size_original')) {
          final int size = box.get(key, defaultValue: 0);
          totalOriginalSize += size;
        } else if (key.toString().contains('_size_compressed')) {
          final int size = box.get(key, defaultValue: 0);
          totalCompressedSize += size;
        }
      }

      final results = {
        'raw_size': totalOriginalSize,
        'compressed_size': totalCompressedSize,
        'savings': totalOriginalSize - totalCompressedSize,
      };

      // Registrar métricas
      _metrics.recordMetric(
          'cache', 'total_raw_size_kb', totalOriginalSize / 1024);
      _metrics.recordMetric(
          'cache', 'total_compressed_size_kb', totalCompressedSize / 1024);
      _metrics.recordMetric('cache', 'total_savings_kb',
          (totalOriginalSize - totalCompressedSize) / 1024);

      return results;
    } catch (e) {
      logger.e('Error calculando tamaño del caché:', error: e);
      return {
        'raw_size': 0,
        'compressed_size': 0,
        'savings': 0,
      };
    } finally {
      _metrics.stopTimer('get_cache_size');
    }
  }

  /// Obtener estadísticas de rendimiento
  @override
  Map<String, dynamic> getPerformanceStats() {
    return {
      'hits': _cacheHits,
      'misses': _cacheMisses,
      'hit_rate': hitRate,
      'compression_savings_kb': _compressionSavingsBytes / 1024,
      'metrics': _metrics.getAllMetrics(),
    };
  }
}

/// Función para no esperar a que se complete una operación asíncrona
void unawaited(Future<void> future) {
  future.then((_) {
    // Operación completada correctamente
  }).catchError((error) {
    // Capturar errores para evitar excepciones no manejadas
    debugPrint('Unhandled async error: $error');
  });
}
