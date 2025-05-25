// lib/core/utils/data_loading/cached_item.dart

/// Clase genérica para almacenar datos en caché con tiempo de expiración
class CachedItem<T> {
  /// El elemento almacenado en caché
  final T? item;
  
  /// Momento en que se guardó en caché
  final DateTime timestamp;
  
  /// Tiempo después del cual el elemento se considera expirado
  final Duration expirationTime;
  
  /// Constructor con parámetros opcionales 
  CachedItem(this.item, {
    DateTime? timestamp,
    Duration? expirationTime,
  }) : 
    timestamp = timestamp ?? DateTime.now(),
    expirationTime = expirationTime ?? const Duration(minutes: 5);
  
  /// Constructor para crear un elemento nulo en caché
  factory CachedItem.empty({
    Duration? expirationTime
  }) => CachedItem(null, expirationTime: expirationTime);
  
  /// Verifica si el elemento está expirado
  bool get isExpired => 
      DateTime.now().difference(timestamp) > expirationTime;
      
  /// Verifica si el elemento existe
  bool get hasItem => item != null;
  
  /// Crea una copia con nuevo timestamp
  CachedItem<T> copyWithRenewedTimestamp() {
    return CachedItem<T>(
      item, 
      timestamp: DateTime.now(),
      expirationTime: expirationTime,
    );
  }
  
  /// Crea una copia con nuevo tiempo de expiración
  CachedItem<T> copyWithExpirationTime(Duration newExpirationTime) {
    return CachedItem<T>(
      item, 
      timestamp: timestamp,
      expirationTime: newExpirationTime,
    );
  }
}
