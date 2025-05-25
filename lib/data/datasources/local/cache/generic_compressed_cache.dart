// lib/data/datasources/local/cache/generic_compressed_cache.dart

import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quien_para/core/logger/logger.dart';
import 'package:quien_para/core/performance/compression_utils.dart';
import 'package:quien_para/core/performance/performance_metrics.dart';
import 'package:quien_para/data/datasources/local/cache/generic_cache_interface.dart';

/// Implementación genérica del caché con compresión para cualquier tipo de entidad
class GenericCompressedCache<T> implements GenericCacheInterface<T> {
  /// Nombre del box en Hive donde se guardan los datos
  final String _cacheBoxName;

  /// Nombre del box en Hive donde se guardan los metadatos
  final String _metadataBoxName;

  /// Prefijo para identificar elementos prioritarios
  static const String _priorityPrefix = 'priority_';

  /// Control de inicialización
  bool _initialized = false;

  /// Cola LRU para gestión de memoria
  final Queue<String> _lruQueue = Queue<String>();

  /// Map para tracking de uso (LFU)
  final Map<String, int> _accessCountMap = {};

  /// Métricas de rendimiento
  final PerformanceMetrics _metrics = PerformanceMetrics();

  /// Duraciones por defecto para el caché
  Duration _regularCacheDuration = const Duration(minutes: 15);
  Duration _priorityCacheDuration = const Duration(minutes: 30);

  /// Límites para el caché
  int _maxCachedItems = 200;
  final int _maxCachedItemsPerCollection = 50;

  /// Política de invalidación del caché
  CacheInvalidationPolicy _invalidationPolicy =
      CacheInvalidationPolicy.leastRecentlyUsed;

  /// Métricas de caché
  int _cacheHits = 0;
  int _cacheMisses = 0;
  int _compressionSavingsBytes = 0;

  /// Callbacks para serialización y deserialización
  String Function(T)? _serializeCallback;
  T Function(String)? _deserializeCallback;

  /// Constructor
  GenericCompressedCache({
    required String cacheName,
    String Function(T)? serializeCallback,
    T Function(String)? deserializeCallback,
  })  : _cacheBoxName = 'compressed_${cacheName}_cache',
        _metadataBoxName = 'compressed_${cacheName}_metadata',
        _serializeCallback = serializeCallback,
        _deserializeCallback = deserializeCallback;

  @override
  bool get isAvailable => _initialized;

  @override
  double get hitRate {
    final int total = _cacheHits + _cacheMisses;
    if (total == 0) return 0.0;
    return _cacheHits / total;
  }

  @override
  Future<void> init() async {
    try {
      if (!_initialized) {
        // Inicializar sistema de métricas
        await _metrics.init();

        // Inicializar Hive con un directorio de la aplicación
        final appDir = await getApplicationDocumentsDirectory();
        await Hive.initFlutter(appDir.path);

        // Abrir los boxes necesarios
        await Hive.openBox<dynamic>(_cacheBoxName);
        await Hive.openBox<dynamic>(_metadataBoxName);

        _initialized = true;
        _loadMetrics();

        // Limpiar entradas expiradas al iniciar
        unawaited(_cleanExpiredCache());

        logger.d(
            'GenericCompressedCache $_cacheBoxName inicializado correctamente');
      }
    } catch (e) {
      logger.e('Error inicializando GenericCompressedCache:', error: e);
      _initialized = false;
    }
  }

  @override
  Future<void> cacheItems(
    List<T> items, {
    bool isPriority = false,
    String? collectionKey,
    Duration? customDuration,
  }) async {
    if (!isAvailable) {
      logger.w('Caché no disponible, saltando cacheItems');
      return;
    }

    if (_serializeCallback == null) {
      logger.e('No se ha registrado un callback de serialización');
      return;
    }

    _metrics.startTimer('cache_items');

    try {
      final Box<dynamic> box = Hive.box(_cacheBoxName);

      // Limitar el número de elementos si es necesario
      if (collectionKey != null &&
          items.length > _maxCachedItemsPerCollection) {
        items = items.sublist(0, _maxCachedItemsPerCollection);
      }

      // Convertir a JSON para almacenamiento usando el callback
      final List<String> itemsJson = items.map(_serializeCallback!).toList();

      // Medir tamaño original
      final String originalData = jsonEncode(itemsJson);
      final int originalSize = originalData.length;

      // Comprimir datos
      final String compressedData = CompressionUtils.compressList(itemsJson);
      final int compressedSize = compressedData.length;

      // Calcular ahorro de espacio
      final int savedBytes = originalSize - compressedSize;
      _compressionSavingsBytes += (savedBytes > 0) ? savedBytes : 0;

      // Clave basada en prioridad y collectionKey
      final String key = _getStorageKey(isPriority, collectionKey);

      // Guardar datos comprimidos
      await box.put(key, compressedData);
      await box.put('${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
      await box.put('${key}_size_original', originalSize);
      await box.put('${key}_size_compressed', compressedSize);

      // Si hay duración personalizada, guardarla
      if (customDuration != null) {
        await box.put('${key}_duration', customDuration.inMilliseconds);
      }

      // Actualizar cola LRU
      _updateLRUQueue(key);

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
            'Compresión de $key: ${compressionRatio.toStringAsFixed(1)}% del original. '
            'Ahorro: ${(savedBytes / 1024).toStringAsFixed(1)} KB');
      }

      logger.d('Cacheados ${items.length} elementos en $key');

      // Verificar si necesitamos aplicar la política de invalidación
      await _enforceInvalidationPolicyIfNeeded();
    } catch (e) {
      logger.e('Error cacheando elementos:', error: e);
    } finally {
      _metrics.stopTimer('cache_items');
    }
  }

  @override
  Future<List<T>?> getCachedItems({
    bool isPriority = false,
    String? collectionKey,
  }) async {
    if (!isAvailable) {
      logger.w('Caché no disponible, retornando null desde getCachedItems');
      return null;
    }

    if (_deserializeCallback == null) {
      logger.e('No se ha registrado un callback de deserialización');
      return null;
    }

    _metrics.startTimer('get_cached_items');

    try {
      final Box<dynamic> box = Hive.box(_cacheBoxName);

      // Obtener la clave de almacenamiento
      final String key = _getStorageKey(isPriority, collectionKey);
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

      // Usar duración personalizada si existe
      Duration cacheDuration;
      if (box.containsKey('${key}_duration')) {
        final int durationMs = box.get('${key}_duration');
        cacheDuration = Duration(milliseconds: durationMs);
      } else {
        cacheDuration = _getCacheDuration(isPriority);
      }

      if (now - timestamp > cacheDuration.inMilliseconds) {
        _cacheMisses++;
        await _saveMetrics();
        return null;
      }

      // Recuperar datos comprimidos
      final String compressedData = box.get(key);

      // Actualizar cola LRU y contadores de acceso
      _updateLRUQueue(key);
      _incrementAccessCount(key);

      // Descomprimir datos
      final List<dynamic>? itemsJson =
          CompressionUtils.decompressToList(compressedData);

      if (itemsJson == null) {
        _cacheMisses++;
        await _saveMetrics();
        return null;
      }

      // Convertir JSON a objetos usando el callback
      final List<T> items = itemsJson
          .map((dynamic itemJson) => _deserializeCallback!(itemJson as String))
          .toList();

      _cacheHits++;
      await _saveMetrics();

      logger.d('Recuperados ${items.length} elementos desde $key '
          '(tasa de aciertos: ${(hitRate * 100).toStringAsFixed(1)}%)');
      return items;
    } catch (e) {
      logger.e('Error obteniendo elementos desde caché:', error: e);
      _cacheMisses++;
      await _saveMetrics();
      return null;
    } finally {
      _metrics.stopTimer('get_cached_items');
    }
  }

  @override
  Future<void> invalidateItem(String itemId) async {
    if (!isAvailable) return;

    _metrics.startTimer('invalidate_item');

    try {
      final Box<dynamic> box = Hive.box(_cacheBoxName);

      // Obtener todas las claves que contienen datos
      final List<String> dataKeys = box.keys
          .cast<String>()
          .where((key) =>
              !key.contains('_timestamp') &&
              !key.contains('_size_original') &&
              !key.contains('_size_compressed') &&
              !key.contains('_duration'))
          .toList();

      for (final String key in dataKeys) {
        // Recuperar la lista comprimida de elementos
        final String? compressedData = box.get(key);
        if (compressedData == null) continue;

        // Descomprimir para procesar
        final List<dynamic>? itemsJson =
            CompressionUtils.decompressToList(compressedData);
        if (itemsJson == null) continue;

        // Verificar si hay elementos para actualizar
        bool needsUpdate = false;
        final List<String> updatedItemsJson = [];

        for (final dynamic itemJson in itemsJson) {
          // Intentar extraer el ID del elemento
          try {
            final Map<String, dynamic> itemMap = jsonDecode(itemJson);
            if (itemMap['id'] != itemId) {
              updatedItemsJson.add(itemJson);
            } else {
              needsUpdate = true;
            }
          } catch (e) {
            // Si no podemos parsear, mantener el elemento
            updatedItemsJson.add(itemJson);
          }
        }

        // Si encontramos y eliminamos el elemento, actualizamos el caché
        if (needsUpdate) {
          // Volver a comprimir los datos actualizados
          final String originalData = jsonEncode(updatedItemsJson);
          final String updatedCompressedData =
              CompressionUtils.compressList(updatedItemsJson);

          // Actualizar tamaños para métricas
          final int originalSize = originalData.length;
          final int compressedSize = updatedCompressedData.length;

          // Actualizar caché
          await box.put(key, updatedCompressedData);
          await box.put('${key}_size_original', originalSize);
          await box.put('${key}_size_compressed', compressedSize);

          logger.d('Invalidado elemento $itemId de caché, clave: $key');
        }
      }
    } catch (e) {
      logger.e('Error invalidando elemento: $itemId', error: e);
    } finally {
      _metrics.stopTimer('invalidate_item');
    }
  }

  @override
  Future<void> invalidateCollection(String collectionKey) async {
    if (!isAvailable) return;

    _metrics.startTimer('invalidate_collection');

    try {
      final Box<dynamic> box = Hive.box(_cacheBoxName);

      // Clave estándar
      final String standardKey = _getStorageKey(false, collectionKey);
      await box.delete(standardKey);
      await box.delete('${standardKey}_timestamp');
      await box.delete('${standardKey}_size_original');
      await box.delete('${standardKey}_size_compressed');
      await box.delete('${standardKey}_duration');

      // Clave prioritaria
      final String priorityKey = _getStorageKey(true, collectionKey);
      await box.delete(priorityKey);
      await box.delete('${priorityKey}_timestamp');
      await box.delete('${priorityKey}_size_original');
      await box.delete('${priorityKey}_size_compressed');
      await box.delete('${priorityKey}_duration');

      // Actualizar estructura de seguimiento
      _lruQueue.remove(standardKey);
      _lruQueue.remove(priorityKey);
      _accessCountMap.remove(standardKey);
      _accessCountMap.remove(priorityKey);

      logger.d('Invalidada colección: $collectionKey');
    } catch (e) {
      logger.e('Error invalidando colección: $collectionKey', error: e);
    } finally {
      _metrics.stopTimer('invalidate_collection');
    }
  }

  @override
  Future<void> clearCache() async {
    if (!isAvailable) return;

    _metrics.startTimer('clear_cache');

    try {
      final Box<dynamic> box = Hive.box(_cacheBoxName);
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
      _lruQueue.clear();
      _accessCountMap.clear();

      await _saveMetrics();

      logger.d('Caché limpiado exitosamente');
    } catch (e) {
      logger.e('Error limpiando caché:', error: e);
    } finally {
      _metrics.stopTimer('clear_cache');
    }
  }

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
      final Box<dynamic> box = Hive.box(_cacheBoxName);
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

  @override
  Map<String, dynamic> getPerformanceStats() {
    return {
      'hits': _cacheHits,
      'misses': _cacheMisses,
      'hit_rate': hitRate,
      'compression_savings_kb': _compressionSavingsBytes / 1024,
      'cache_entries': _lruQueue.length,
      'metrics': _metrics.getAllMetrics(),
    };
  }

  @override
  void registerSerializeCallback(String Function(T) callback) {
    _serializeCallback = callback;
  }

  @override
  void registerDeserializeCallback(T Function(String) callback) {
    _deserializeCallback = callback;
  }

  @override
  void setDefaultCacheDuration(Duration duration) {
    _regularCacheDuration = duration;
  }

  @override
  void setPriorityCacheDuration(Duration duration) {
    _priorityCacheDuration = duration;
  }

  @override
  void setMaxCachedItems(int max) {
    _maxCachedItems = max;
  }

  @override
  void setInvalidationPolicy(CacheInvalidationPolicy policy) {
    _invalidationPolicy = policy;
  }

  /// Obtiene la duración del caché según la prioridad
  Duration _getCacheDuration(bool isPriority) {
    return isPriority ? _priorityCacheDuration : _regularCacheDuration;
  }

  /// Construye la clave de almacenamiento basada en prioridad y colección
  String _getStorageKey(bool isPriority, String? collectionKey) {
    String key = '';

    // Añadir prefijo de prioridad si es necesario
    if (isPriority) {
      key += _priorityPrefix;
    }

    // Añadir clave de colección o usar 'all_items' por defecto
    key += collectionKey ?? 'all_items';

    return key;
  }

  /// Actualiza la cola LRU
  void _updateLRUQueue(String key) {
    // Remover la clave si ya existe
    _lruQueue.remove(key);

    // Añadir la clave al final de la cola (más reciente)
    _lruQueue.add(key);
  }

  /// Incrementa el contador de accesos para una clave
  void _incrementAccessCount(String key) {
    // Inicializar contador si es necesario
    if (!_accessCountMap.containsKey(key)) {
      _accessCountMap[key] = 0;
    }

    // Incrementar contador
    _accessCountMap[key] = (_accessCountMap[key] ?? 0) + 1;
  }

  /// Limpiar entradas expiradas del caché
  Future<void> _cleanExpiredCache() async {
    if (!isAvailable) return;

    _metrics.startTimer('clean_expired_cache');

    try {
      final Box<dynamic> box = Hive.box(_cacheBoxName);
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

        // Verificar si hay duración personalizada
        Duration cacheDuration;
        if (box.containsKey('${cacheKey}_duration')) {
          final int durationMs = box.get('${cacheKey}_duration');
          cacheDuration = Duration(milliseconds: durationMs);
        } else {
          // Usar duración estándar según prefijo
          cacheDuration = key.contains(_priorityPrefix)
              ? _priorityCacheDuration
              : _regularCacheDuration;
        }

        // Verificar si expiró
        if (now - timestamp > cacheDuration.inMilliseconds) {
          keysToDelete.add(cacheKey);
          keysToDelete.add(key);
          keysToDelete.add('${cacheKey}_size_original');
          keysToDelete.add('${cacheKey}_size_compressed');
          keysToDelete.add('${cacheKey}_duration');

          // Remover de estructuras de seguimiento
          _lruQueue.remove(cacheKey);
          _accessCountMap.remove(cacheKey);
        }
      }

      // Eliminar entradas expiradas
      for (final String key in keysToDelete) {
        if (box.containsKey(key)) {
          await box.delete(key);
        }
      }

      logger.d(
          'Limpiadas ${keysToDelete.length ~/ 5} entradas expiradas del caché');
    } catch (e) {
      logger.e('Error limpiando caché expirado:', error: e);
    } finally {
      _metrics.stopTimer('clean_expired_cache');
    }
  }

  /// Aplica la política de invalidación si es necesario
  Future<void> _enforceInvalidationPolicyIfNeeded() async {
    if (!isAvailable) return;

    // Verificar si hemos excedido el límite
    if (_lruQueue.length <= _maxCachedItems) {
      return;
    }

    _metrics.startTimer('enforce_invalidation_policy');

    try {
      final Box<dynamic> box = Hive.box(_cacheBoxName);
      final List<String> keysToRemove = [];

      switch (_invalidationPolicy) {
        case CacheInvalidationPolicy.leastRecentlyUsed:
          // Eliminar entradas desde el inicio de la cola (menos recientes)
          while (_lruQueue.length > _maxCachedItems * 0.8) {
            final key = _lruQueue.removeFirst();
            keysToRemove.add(key);
            keysToRemove.add('${key}_timestamp');
            keysToRemove.add('${key}_size_original');
            keysToRemove.add('${key}_size_compressed');
            keysToRemove.add('${key}_duration');
            _accessCountMap.remove(key);
          }
          break;

        case CacheInvalidationPolicy.leastFrequentlyUsed:
          // Ordenar las claves por frecuencia de acceso
          final List<MapEntry<String, int>> sortedEntries =
              _accessCountMap.entries.toList()
                ..sort((a, b) => a.value.compareTo(b.value));

          // Eliminar el 20% de las entradas menos usadas
          final int entriesToRemove = (_maxCachedItems * 0.2).ceil();

          for (int i = 0; i < min(entriesToRemove, sortedEntries.length); i++) {
            final key = sortedEntries[i].key;
            keysToRemove.add(key);
            keysToRemove.add('${key}_timestamp');
            keysToRemove.add('${key}_size_original');
            keysToRemove.add('${key}_size_compressed');
            keysToRemove.add('${key}_duration');
            _lruQueue.remove(key);
            _accessCountMap.remove(key);
          }
          break;

        case CacheInvalidationPolicy.random:
          // Eliminar entradas aleatorias
          final random = Random();
          final List<String> keys = _lruQueue.toList();
          final int entriesToRemove = (_maxCachedItems * 0.2).ceil();

          for (int i = 0; i < min(entriesToRemove, keys.length); i++) {
            final index = random.nextInt(keys.length);
            final key = keys[index];
            keys.removeAt(index);
            keysToRemove.add(key);
            keysToRemove.add('${key}_timestamp');
            keysToRemove.add('${key}_size_original');
            keysToRemove.add('${key}_size_compressed');
            keysToRemove.add('${key}_duration');
            _lruQueue.remove(key);
            _accessCountMap.remove(key);
          }
          break;

        case CacheInvalidationPolicy.clearAll:
          // Limpiar todo el caché
          await clearCache();
          return;
      }

      // Eliminar las entradas seleccionadas
      for (final key in keysToRemove) {
        if (box.containsKey(key)) {
          await box.delete(key);
        }
      }

      logger.d(
          'Política de invalidación aplicada: eliminadas ${keysToRemove.length ~/ 5} entradas');
    } catch (e) {
      logger.e('Error aplicando política de invalidación:', error: e);
    } finally {
      _metrics.stopTimer('enforce_invalidation_policy');
    }
  }

  /// Cargar métricas guardadas
  void _loadMetrics() {
    try {
      final Box<dynamic> box = Hive.box(_metadataBoxName);
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
      final Box<dynamic> box = Hive.box(_metadataBoxName);
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
