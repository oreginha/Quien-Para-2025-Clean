// lib/data/datasources/local/cache_manager.dart

import 'package:quien_para/data/datasources/local/cache_interface.dart';
import 'package:quien_para/domain/entities/entity_base.dart';
import 'package:logger/logger.dart';

/// Gestor centralizado de caché para la aplicación.
///
/// Proporciona un punto centralizado para gestionar las políticas de caché,
/// invalidación y optimización del uso de la memoria.
class CacheManager {
  // Instancia singleton
  static final CacheManager _instance = CacheManager._internal();
  
  // Fábrica para acceder a la instancia singleton
  factory CacheManager() => _instance;
  
  // Logger para diagnóstico
  final Logger _logger = Logger();
  
  // Mapa de gestores de caché por tipo
  final Map<Type, Cache<dynamic>> _caches = {};
  
  // Configuración de duración de caché por tipo
  final Map<Type, Duration> _cacheDurations = {};
  
  // Constructor interno privado para el singleton
  CacheManager._internal();
  
  /// Registra un gestor de caché para un tipo específico.
  ///
  /// Si ya existe un gestor para ese tipo, lo reemplaza.
  void registerCache<E extends EntityBase>(Cache<E> cache, {Duration? duration}) {
    _caches[E] = cache;
    
    if (duration != null) {
      _cacheDurations[E] = duration;
      // Configurar la duración en el gestor de caché si es posible
      cache.setExpirationTime(duration.inSeconds);
    }
    
    _logger.d('Caché registrada para ${E.toString()}');
  }
  
  /// Obtiene un gestor de caché para un tipo específico.
  ///
  /// Si no existe un gestor para ese tipo, retorna null.
  Cache<E>? getCache<E extends EntityBase>() {
    return _caches[E] as Cache<E>?;
  }
  
  /// Establece la duración de caché para un tipo específico.
  ///
  /// Si no existe un gestor para ese tipo, registra solo la duración.
  void setCacheDuration<E extends EntityBase>(Duration duration) {
    _cacheDurations[E] = duration;
    
    // Si existe un gestor de caché, configurarlo
    final cache = _caches[E];
    if (cache != null) {
      cache.setExpirationTime(duration.inSeconds);
    }
    
    _logger.d('Duración de caché configurada para ${E.toString()}: ${duration.inSeconds}s');
  }
  
  /// Obtiene la duración de caché para un tipo específico.
  ///
  /// Si no se ha configurado una duración específica, retorna una duración predeterminada.
  Duration getCacheDuration<E extends EntityBase>() {
    return _cacheDurations[E] ?? const Duration(minutes: 15);
  }
  
  /// Invalida la caché para un tipo específico.
  ///
  /// Si no existe un gestor para ese tipo, no hace nada.
  Future<void> invalidateCache<E extends EntityBase>({String? key}) async {
    final cache = _caches[E];
    if (cache != null) {
      await cache.invalidateCache(key: key);
      _logger.d('Caché invalidada para ${E.toString()}${key != null ? " con clave: $key" : ""}');
    }
  }
  
  /// Invalida todas las cachés.
  Future<void> invalidateAllCaches() async {
    for (final cache in _caches.values) {
      await cache.invalidateCache();
    }
    _logger.d('Todas las cachés invalidadas');
  }
  
  /// Limpia todas las cachés completamente.
  Future<void> clearAllCaches() async {
    for (final cache in _caches.values) {
      await cache.clearCache();
    }
    _logger.d('Todas las cachés limpiadas');
  }
  
  /// Establece una política agresiva de caché para modo offline.
  ///
  /// Aumenta la duración de las cachés y configura políticas específicas.
  void setOfflineMode(bool enabled) {
    if (enabled) {
      // Aumentar la duración de todas las cachés
      for (final entry in _cacheDurations.entries) {
        final newDuration = entry.value * 4; // 4 veces más duración
        _cacheDurations[entry.key] = newDuration;
        
        final cache = _caches[entry.key];
        if (cache != null) {
          cache.setExpirationTime(newDuration.inSeconds);
        }
      }
      
      _logger.d('Modo offline activado para todas las cachés');
    } else {
      // Restaurar la duración predeterminada
      for (final entry in _cacheDurations.entries) {
        final newDuration = entry.value ~/ 4; // 1/4 de la duración
        _cacheDurations[entry.key] = newDuration;
        
        final cache = _caches[entry.key];
        if (cache != null) {
          cache.setExpirationTime(newDuration.inSeconds);
        }
      }
      
      _logger.d('Modo offline desactivado para todas las cachés');
    }
  }
  
  /// Limpia los recursos utilizados por el gestor de caché.
  Future<void> dispose() async {
    _caches.clear();
    _cacheDurations.clear();
    _logger.d('CacheManager recursos liberados');
  }
}
