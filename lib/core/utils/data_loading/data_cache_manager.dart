// lib/core/utils/data_loading/data_cache_manager.dart
import 'cached_item.dart';

/// Administrador genérico de caché de datos con control de expiración
class DataCacheManager<T> {
  /// Almacenamiento de elementos en caché
  final Map<String, CachedItem<T>> _cache = {};

  /// Tiempo de expiración predeterminado
  final Duration _defaultExpirationTime;

  /// Tamaño máximo del caché (0 = sin límite)
  final int _maxCacheSize;

  /// Política de expulsión cuando se alcanza el máximo
  final CacheEvictionPolicy _evictionPolicy;

  /// Constructor con parámetros opcionales
  DataCacheManager({
    Duration? defaultExpirationTime,
    int maxCacheSize = 0,
    CacheEvictionPolicy evictionPolicy = CacheEvictionPolicy.leastRecentlyUsed,
  })  : _defaultExpirationTime =
            defaultExpirationTime ?? const Duration(minutes: 5),
        _maxCacheSize = maxCacheSize,
        _evictionPolicy = evictionPolicy;

  /// Agrega o actualiza un elemento en el caché
  void put(String key, T? item) {
    // Si hemos alcanzado el tamaño máximo y estamos agregando un nuevo elemento
    if (_maxCacheSize > 0 &&
        _cache.length >= _maxCacheSize &&
        !_cache.containsKey(key)) {
      _evictItems(1); // Eliminar al menos un elemento
    }

    _cache[key] = CachedItem<T>(
      item,
      expirationTime: _defaultExpirationTime,
    );
  }

  /// Obtiene un elemento del caché
  /// Retorna null si no existe o está expirado
  T? get(String key) {
    final cachedItem = _cache[key];

    // Si no existe o está expirado
    if (cachedItem == null || cachedItem.isExpired) {
      // Eliminar si está expirado
      if (cachedItem != null && cachedItem.isExpired) {
        _cache.remove(key);
      }
      return null;
    }

    // Si la política es least recently used, actualizar el timestamp
    if (_evictionPolicy == CacheEvictionPolicy.leastRecentlyUsed) {
      _cache[key] = cachedItem.copyWithRenewedTimestamp();
    }

    return cachedItem.item;
  }

  /// Verifica si un elemento existe en el caché y no está expirado
  bool has(String key) {
    final cachedItem = _cache[key];
    return cachedItem != null && !cachedItem.isExpired;
  }

  /// Elimina un elemento del caché
  void remove(String key) {
    _cache.remove(key);
  }

  /// Limpia todo el caché
  void clear() {
    _cache.clear();
  }

  /// Elimina elementos expirados del caché
  void purgeExpiredItems() {
    final expiredKeys = _cache.entries
        .where((entry) => entry.value.isExpired)
        .map((entry) => entry.key)
        .toList();

    for (final key in expiredKeys) {
      _cache.remove(key);
    }
  }

  /// Obtiene varias llaves de una vez
  /// Retorna un mapa con los valores encontrados (no expirados)
  Map<String, T?> getMultiple(List<String> keys) {
    final Map<String, T?> result = {};

    for (final key in keys) {
      result[key] = get(key);
    }

    return result;
  }

  /// Verifica qué llaves no están en caché o están expiradas
  List<String> getMissingKeys(List<String> keys) {
    return keys.where((key) => !has(key)).toList();
  }

  /// Elimina elementos según la política de expulsión
  void _evictItems(int count) {
    if (_cache.isEmpty || count <= 0) return;

    switch (_evictionPolicy) {
      case CacheEvictionPolicy.leastRecentlyUsed:
        _evictLeastRecentlyUsed(count);
        break;
      case CacheEvictionPolicy.firstInFirstOut:
        _evictFirstInFirstOut(count);
        break;
      case CacheEvictionPolicy.leastFrequentlyUsed:
        // No implementado por ahora
        _evictLeastRecentlyUsed(count);
        break;
    }
  }

  /// Elimina los elementos menos usados recientemente
  void _evictLeastRecentlyUsed(int count) {
    // Ordenar por timestamp (más antiguo primero)
    final sortedEntries = _cache.entries.toList()
      ..sort((a, b) => a.value.timestamp.compareTo(b.value.timestamp));

    // Tomar las primeras 'count' entradas
    final keysToRemove =
        sortedEntries.take(count).map((entry) => entry.key).toList();

    // Eliminar del caché
    for (final key in keysToRemove) {
      _cache.remove(key);
    }
  }

  /// Elimina los elementos que entraron primero
  void _evictFirstInFirstOut(int count) {
    // En este caso, simplemente eliminamos las primeras 'count' entradas
    final keysToRemove = _cache.keys.take(count).toList();

    for (final key in keysToRemove) {
      _cache.remove(key);
    }
  }

  /// Obtiene el tamaño actual del caché
  int get size => _cache.length;

  /// Obtiene todas las llaves en el caché
  List<String> get keys => _cache.keys.toList();

  /// Obtiene todos los valores en el caché (incluso expirados)
  List<T?> get values => _cache.values.map((item) => item.item).toList();

  /// Obtiene todos los valores no expirados
  List<T?> get validValues => _cache.entries
      .where((entry) => !entry.value.isExpired)
      .map((entry) => entry.value.item)
      .toList();
}

/// Políticas de expulsión para el caché
enum CacheEvictionPolicy {
  /// Expulsa los elementos menos usados recientemente
  leastRecentlyUsed,

  /// Expulsa los elementos que entraron primero
  firstInFirstOut,

  /// Expulsa los elementos menos frecuentemente usados
  leastFrequentlyUsed
}
