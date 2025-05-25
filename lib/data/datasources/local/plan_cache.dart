// lib/data/datasources/local/plan_cache.dart
// ignore_for_file: always_specify_types

import 'dart:convert';
import 'dart:io';
import '../../../core/logger/logger.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import '../../mappers/plan_mapper.dart';
import 'cache_interface.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Importar hive_flutter en vez de hive
import 'package:path_provider/path_provider.dart'; // Necesario para obtener el directorio de la app

class PlanCache implements Cache<PlanEntity> {
  static const String _plansCacheBox = 'plans_cache';
  static const String _lastFetchKey = 'last_fetch_time';
  static const String _otherUserPlansCachePrefix = 'other_user_plans_';
  static Duration _cacheDuration = const Duration(minutes: 15);

  final PlanMapper _mapper;

  static bool _initialized = false;

  PlanCache({PlanMapper? mapper}) : _mapper = mapper ?? const PlanMapper();

  /// Inicializa Hive de forma segura
  @override
  Future<void> init() async {
    try {
      if (!_initialized) {
        try {
          // Inicializar Hive con un directorio de la aplicación
          final Directory appDir = await getApplicationDocumentsDirectory();
          await Hive.initFlutter(appDir.path);
        } catch (e) {
          // Si path_provider falla, inicializar Hive sin una ruta específica
          // Esto usará una ubicación temporal en memoria durante el desarrollo
          logger.w(
              'Path provider no disponible, usando inicialización básica de Hive');
          await Hive.initFlutter();
        }

        // Abrir el box para los planes, con manejo de errores
        try {
          await Hive.openBox<dynamic>(_plansCacheBox);
          _initialized = true;
          logger.d('Plan cache initialized successfully');
        } catch (boxError) {
          logger.e('Error opening Hive box:', error: boxError);
          _initialized = false;
        }
      }
    } catch (e) {
      logger.e('Error initializing plan cache:', error: e);
      // Podemos seguir funcionando sin caché
      _initialized = false;
    }
  }

  /// Método para verificar si el cache está disponible
  @override
  bool get isAvailable => _initialized;

  // Métodos de compatibilidad hacia atrás para facilitar la transición
  // Estos métodos usan la nueva implementación internamente

  /// Método anterior - ahora usa cacheItems internamente
  Future<void> cachePlans(final List<PlanEntity> plans) async {
    await cacheItems(plans);
  }

  /// Método anterior - ahora usa cacheItems internamente
  Future<void> cacheCategoryPlans(
      final String category, final List<PlanEntity> plans) async {
    await cacheItems(plans, key: 'category_$category');
  }

  /// Método anterior - ahora usa getCachedItems internamente
  Future<List<PlanEntity>?> getCachedPlans() async {
    return await getCachedItems();
  }

  /// Método anterior - ahora usa getCachedItems internamente
  Future<List<PlanEntity>?> getCachedCategoryPlans(
      final String category) async {
    return await getCachedItems(key: 'category_$category');
  }

  /// Implementa el método cacheItems de la interfaz Cache
  @override
  Future<void> cacheItems(List<PlanEntity> items, {String? key}) async {
    if (!isAvailable) {
      logger.w('Cache not available, skipping cacheItems');
      return;
    }

    final String cacheKey = key ?? 'all_plans';
    final String timeKey = key != null ? '${key}_time' : _lastFetchKey;

    try {
      final Box<dynamic> box = Hive.box(_plansCacheBox);

      // Usar el mapper para convertir las entidades a JSON
      final List<Map<String, dynamic>> itemsJson = _mapper.toJsonList(items);
      final List<String> serializedItems =
          itemsJson.map((json) => jsonEncode(json)).toList();

      await box.put(cacheKey, serializedItems);
      await box.put(timeKey, DateTime.now().millisecondsSinceEpoch);

      logger.d('Cached ${items.length} items with key: $cacheKey');
    } catch (e) {
      logger.e('Error caching items:', error: e);
    }
  }

  /// Implementa el método getCachedItems de la interfaz Cache
  @override
  Future<List<PlanEntity>?> getCachedItems({String? key}) async {
    if (!isAvailable) {
      logger.w('Cache not available, returning null from getCachedItems');
      return null;
    }

    final String cacheKey = key ?? 'all_plans';
    final String timeKey = key != null ? '${key}_time' : _lastFetchKey;

    try {
      final Box<dynamic> box = Hive.box(_plansCacheBox);
      final int lastFetchTime = box.get(timeKey, defaultValue: 0) as int;

      // Verificar si la caché ha expirado
      final int now = DateTime.now().millisecondsSinceEpoch;
      if (now - lastFetchTime > _cacheDuration.inMilliseconds) {
        logger.d('Cache expired for key: $cacheKey');
        return null;
      }

      final cachedData = box.get(cacheKey);
      if (cachedData == null) {
        return null;
      }

      final List<dynamic> itemsJson = cachedData as List<dynamic>;
      final List<Map<String, dynamic>> decodedItems = itemsJson
          .map((jsonStr) =>
              jsonDecode(jsonStr as String) as Map<String, dynamic>)
          .toList();

      final List<PlanEntity> items = _mapper.fromJsonList(decodedItems);

      logger
          .d('Retrieved ${items.length} items from cache with key: $cacheKey');
      return items;
    } catch (e) {
      logger.e('Error retrieving cached items:', error: e);
      return null;
    }
  }

  /// Limpia toda la caché
  @override
  Future<void> clearCache() async {
    if (!isAvailable) {
      logger.w('Cache not available, skipping clearCache');
      return;
    }

    try {
      final Box<dynamic> box = Hive.box(_plansCacheBox);
      await box.clear();
      logger.d('Cache cleared successfully');
    } catch (e) {
      logger.e('Error clearing cache:', error: e);
    }
  }

  /// Almacena planes de otros usuarios en la caché con un identificador asociado al usuario actual
  /// @param currentUserId ID del usuario actual (para excluir sus planes)
  /// @param plans Lista de planes de otros usuarios para almacenar
  Future<void> storeOtherUserPlans(
      String currentUserId, List<PlanEntity> plans) async {
    final String key = _otherUserPlansCachePrefix + currentUserId;
    await cacheItems(plans, key: key);
  }

  /// Obtiene los planes de otros usuarios desde la caché
  /// @param currentUserId ID del usuario actual
  /// @return Lista de planes o null si no están en caché o la caché está expirada
  Future<List<PlanEntity>?> getOtherUserPlans(String currentUserId) async {
    final String key = _otherUserPlansCachePrefix + currentUserId;
    return await getCachedItems(key: key);
  }

  /// Invalida la caché de planes de otros usuarios para un usuario específico
  /// @param currentUserId ID del usuario actual
  Future<void> invalidateOtherUserPlans(String currentUserId) async {
    final String key = _otherUserPlansCachePrefix + currentUserId;
    await invalidateCache(key: key);
  }

  // Métodos de compatibilidad hacia atrás para facilitar la transición

  /// Método anterior - ahora usa invalidateCache internamente
  Future<void> invalidateCategoryCache(final String category) async {
    await invalidateCache(key: 'category_$category');
  }

  /// Implementa el método invalidateCache de la interfaz Cache
  @override
  Future<void> invalidateCache({String? key}) async {
    if (!isAvailable) {
      logger.w('Cache not available, skipping invalidateCache');
      return;
    }

    try {
      final Box<dynamic> box = Hive.box(_plansCacheBox);

      if (key == null) {
        // Si no se proporciona clave, invalidar caché principal
        await box.delete('all_plans');
        await box.delete(_lastFetchKey);
        logger.d('Invalidated main cache');
      } else {
        // Invalidar caché específica
        await box.delete(key);
        await box.delete('${key}_time');
        logger.d('Invalidated cache for key: $key');
      }
    } catch (e) {
      logger.e('Error invalidating cache:', error: e);
    }
  }

  /// Implementa el método hasCachedItems de la interfaz Cache
  @override
  Future<bool> hasCachedItems({String? key}) async {
    if (!isAvailable) {
      return false;
    }

    final String cacheKey = key ?? 'all_plans';
    final String timeKey = key != null ? '${key}_time' : _lastFetchKey;

    try {
      final Box<dynamic> box = Hive.box(_plansCacheBox);
      final cachedData = box.get(cacheKey);
      final int? lastFetchTime = box.get(timeKey) as int?;

      if (cachedData == null || lastFetchTime == null) {
        return false;
      }

      // Verificar si la caché ha expirado
      final int now = DateTime.now().millisecondsSinceEpoch;
      return (now - lastFetchTime <= _cacheDuration.inMilliseconds);
    } catch (e) {
      logger.e('Error checking cached items:', error: e);
      return false;
    }
  }

  /// Implementa el método getLastUpdateTime de la interfaz Cache
  @override
  Future<DateTime?> getLastUpdateTime({String? key}) async {
    if (!isAvailable) {
      return null;
    }

    final String timeKey = key != null ? '${key}_time' : _lastFetchKey;

    try {
      final Box<dynamic> box = Hive.box(_plansCacheBox);
      final int? lastFetchTime = box.get(timeKey) as int?;

      if (lastFetchTime == null) {
        return null;
      }

      return DateTime.fromMillisecondsSinceEpoch(lastFetchTime);
    } catch (e) {
      logger.e('Error getting last update time:', error: e);
      return null;
    }
  }

  /// Implementa el método setExpirationTime de la interfaz Cache
  @override
  Future<void> setExpirationTime(int seconds, {String? key}) async {
    // Actualizar la duración global de caché si no se especifica una clave
    if (key == null) {
      _cacheDuration = Duration(seconds: seconds);
      logger.d('Cache duration set to $seconds seconds globally');
      return;
    }

    // Para implementar tiempos de expiración personalizados por clave
    // necesitaríamos almacenar esta configuración en la caché
    if (isAvailable) {
      try {
        final Box<dynamic> box = Hive.box(_plansCacheBox);
        final String expirationKey = '${key}_expiration';
        await box.put(expirationKey, seconds);
        logger.d('Cache expiration for $key set to $seconds seconds');
      } catch (e) {
        logger.e('Error setting expiration time:', error: e);
      }
    }
  }

  @override
  Future<void> cacheCount(int count, {String? key}) async {
    if (!isAvailable) {
      logger.w('Cache not available, skipping cacheCount');
      return;
    }

    final String cacheKey = 'count_${key ?? 'default'}';
    try {
      final Box<dynamic> box = Hive.box(_plansCacheBox);
      await box.put(cacheKey, count);
      await box.put('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
      logger.d('Cached count $count with key: $cacheKey');
    } catch (e) {
      logger.e('Error caching count:', error: e);
    }
  }

  @override
  Future<int?> getCachedCount({String? key}) async {
    if (!isAvailable) {
      logger.w('Cache not available, returning null from getCachedCount');
      return null;
    }

    final String cacheKey = 'count_${key ?? 'default'}';
    final String timeKey = '${cacheKey}_time';

    try {
      final Box<dynamic> box = Hive.box(_plansCacheBox);
      final int? lastFetchTime = box.get(timeKey) as int?;

      // Verificar si la caché ha expirado
      if (lastFetchTime != null) {
        final int now = DateTime.now().millisecondsSinceEpoch;
        if (now - lastFetchTime > _cacheDuration.inMilliseconds) {
          logger.d('Count cache expired for key: $cacheKey');
          return null;
        }
      } else {
        // Si no hay tiempo registrado, la caché no existe o ha sido invalidada
        return null;
      }

      final int? count = box.get(cacheKey) as int?;
      if (count != null) {
        logger.d('Retrieved count $count from cache with key: $cacheKey');
      }
      return count;
    } catch (e) {
      logger.e('Error retrieving cached count:', error: e);
      return null;
    }
  }

  @override
  Future<void> invalidateCount({String? key}) async {
    if (!isAvailable) {
      logger.w('Cache not available, skipping invalidateCount');
      return;
    }

    final String cacheKey = 'count_${key ?? 'default'}';
    final String timeKey = '${cacheKey}_time';

    try {
      final Box<dynamic> box = Hive.box(_plansCacheBox);
      await box.delete(cacheKey);
      await box.delete(timeKey);
      logger.d('Invalidated count cache for key: $cacheKey');
    } catch (e) {
      logger.e('Error invalidating count cache:', error: e);
    }
  }
}
