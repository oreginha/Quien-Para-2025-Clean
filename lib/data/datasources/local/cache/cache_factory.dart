// lib/data/datasources/local/cache/cache_factory.dart

import 'package:quien_para/data/datasources/local/cache/generic_cache_interface.dart';
import 'package:quien_para/data/datasources/local/cache/generic_compressed_cache.dart';
import 'package:quien_para/data/datasources/local/cache/plan_cache_adapter.dart';
import 'package:quien_para/data/datasources/local/compressed_plan_cache.dart';
import 'package:quien_para/data/datasources/local/plan_cache.dart';
import 'package:quien_para/core/config/app_config.dart';

/// Factory para creación de instancias de caché según la configuración
class CacheFactory {
  /// Crear una instancia del caché de planes
  static Object createPlanCache() {
    final config = AppConfig.instance;

    // Seleccionar la implementación según la configuración
    if (config.useCompressedCache) {
      if (config.useGenericCacheSystem) {
        // Implementación basada en el nuevo sistema genérico
        return PlanCacheAdapter();
      } else {
        // Implementación con compresión (versión anterior)
        return CompressedPlanCache();
      }
    } else {
      // Implementación sin compresión (versión básica)
      return PlanCache();
    }
  }

  /// Crear una instancia de caché genérico para cualquier tipo
  static GenericCompressedCache<T> createGenericCache<T>({
    required String cacheName,
    required String Function(T) serializeCallback,
    required T Function(String) deserializeCallback,
    Duration defaultDuration = const Duration(minutes: 15),
    Duration priorityDuration = const Duration(minutes: 30),
    int maxItems = 100,
    CacheInvalidationPolicy policy = CacheInvalidationPolicy.leastRecentlyUsed,
  }) {
    final cache = GenericCompressedCache<T>(
      cacheName: cacheName,
      serializeCallback: serializeCallback,
      deserializeCallback: deserializeCallback,
    );

    // Configurar opciones
    cache.setDefaultCacheDuration(defaultDuration);
    cache.setPriorityCacheDuration(priorityDuration);
    cache.setMaxCachedItems(maxItems);
    cache.setInvalidationPolicy(policy);

    return cache;
  }
}
