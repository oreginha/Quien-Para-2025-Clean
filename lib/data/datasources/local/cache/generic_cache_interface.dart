// lib/data/datasources/local/cache/generic_cache_interface.dart

/// Interfaz genérica para implementaciones de caché de cualquier tipo de entidad
abstract class GenericCacheInterface<T> {
  /// Indica si el caché está disponible para su uso
  bool get isAvailable;
  
  /// Obtiene la tasa de aciertos del caché (hit rate)
  double get hitRate;
  
  /// Inicializa el sistema de caché
  Future<void> init();
  
  /// Almacena una lista de entidades en caché
  Future<void> cacheItems(List<T> items, {
    bool isPriority = false,
    String? collectionKey,
    Duration? customDuration,
  });
  
  /// Obtiene entidades desde el caché
  Future<List<T>?> getCachedItems({
    bool isPriority = false,
    String? collectionKey,
  });
  
  /// Invalida una entidad específica en todas las colecciones del caché
  Future<void> invalidateItem(String itemId);
  
  /// Invalida una colección específica del caché
  Future<void> invalidateCollection(String collectionKey);
  
  /// Limpia todo el caché
  Future<void> clearCache();
  
  /// Obtiene el tamaño del caché
  Future<Map<String, int>> getCacheSize();
  
  /// Obtiene estadísticas de rendimiento del caché
  Map<String, dynamic> getPerformanceStats();

  /// Registra un callback para procesar las entidades durante la serialización
  void registerSerializeCallback(String Function(T) callback);
  
  /// Registra un callback para procesar las entidades durante la deserialización
  void registerDeserializeCallback(T Function(String) callback);
  
  /// Configura la duración del caché por defecto
  void setDefaultCacheDuration(Duration duration);
  
  /// Configura la duración del caché para entidades prioritarias
  void setPriorityCacheDuration(Duration duration);
  
  /// Configura el límite máximo de elementos a cachear
  void setMaxCachedItems(int max);
  
  /// Establece una política de invalidación para el caché
  void setInvalidationPolicy(CacheInvalidationPolicy policy);
}

/// Enum que define las políticas de invalidación del caché
enum CacheInvalidationPolicy {
  /// Descarta entradas cuando se supera el límite de tamaño (más antiguas primero)
  leastRecentlyUsed,
  
  /// Descarta entradas cuando se supera el límite de tamaño (menos usadas primero)
  leastFrequentlyUsed,
  
  /// Descarta entradas aleatorias cuando se supera el límite de tamaño
  random,
  
  /// Descarta todas las entradas cuando se supera el límite de tamaño
  clearAll,
}
