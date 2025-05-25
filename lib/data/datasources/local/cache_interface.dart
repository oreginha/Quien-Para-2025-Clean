// lib/data/datasources/local/cache_interface.dart

import 'package:quien_para/domain/entities/entity_base.dart';

/// Interfaz genérica para todos los sistemas de caché
///
/// Define operaciones comunes que cualquier implementación de caché debe proporcionar,
/// independientemente del tipo de entidad o tecnología de almacenamiento subyacente.
abstract class Cache<T extends EntityBase> {
  /// Indica si el caché está disponible para usar
  bool get isAvailable;

  /// Inicializa el sistema de caché
  Future<void> init();

  /// Almacena una lista de entidades en caché con una clave específica
  Future<void> cacheItems(List<T> items, {String? key});

  /// Obtiene una lista de entidades desde la caché usando una clave específica
  Future<List<T>?> getCachedItems({String? key});

  /// Invalida (elimina) elementos de la caché para una clave específica
  Future<void> invalidateCache({String? key});

  /// Elimina toda la caché
  Future<void> clearCache();

  /// Verifica si una clave específica tiene datos en caché que no han expirado
  Future<bool> hasCachedItems({String? key});

  /// Obtiene tiempo de la última actualización para una clave específica
  Future<DateTime?> getLastUpdateTime({String? key});

  /// Define un tiempo de expiración personalizado (en segundos) para una clave específica
  Future<void> setExpirationTime(int seconds, {String? key});

  /// Almacena un valor numérico en caché con una clave específica
  Future<void> cacheCount(int count, {String? key});

  /// Obtiene un valor numérico desde la caché usando una clave específica
  Future<int?> getCachedCount({String? key});

  /// Invalida (elimina) el conteo en caché para una clave específica
  Future<void> invalidateCount({String? key});
}
