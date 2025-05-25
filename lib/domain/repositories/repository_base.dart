// lib/domain/repositories/repository_base.dart

import 'package:dartz/dartz.dart';
import 'package:quien_para/domain/entities/entity_base.dart';
import 'package:quien_para/domain/failures/app_failures.dart';

/// Interfaz base para todos los repositorios.
///
/// Define operaciones CRUD comunes que cualquier repositorio debería implementar.
/// Cada método devuelve un Either para manejar errores de forma consistente.
abstract class RepositoryBase<T extends EntityBase> {
  /// Obtiene una entidad por su ID
  ///
  /// Puede devolver null si la entidad no existe.
  Future<Either<AppFailure, T?>> getById(String id);
  
  /// Obtiene todas las entidades, posiblemente con paginación
  Future<Either<AppFailure, List<T>>> getAll({
    int? limit,
    String? lastDocumentId,
    Map<String, dynamic>? filters,
  });
  
  /// Crea una nueva entidad
  Future<Either<AppFailure, T>> create(T entity);
  
  /// Actualiza una entidad existente
  Future<Either<AppFailure, T>> update(T entity);
  
  /// Elimina una entidad
  Future<Either<AppFailure, Unit>> delete(String id);
  
  /// Busca entidades según criterios específicos
  Future<Either<AppFailure, List<T>>> search(Map<String, dynamic> criteria, {
    int? limit,
    String? lastDocumentId,
  });
  
  /// Si el repositorio maneja streams de datos para suscripciones
  Stream<Either<AppFailure, List<T>>>? getStream({Map<String, dynamic>? filters});
  
  /// Verifica si una entidad existe
  Future<Either<AppFailure, bool>> exists(String id);
  
  /// Maneja la limpieza de recursos
  Future<void> dispose();
  
  /// Invalida la caché para este tipo de entidad
  Future<Either<AppFailure, Unit>> invalidateCache();
  
  /// Refresca los datos de una entidad específica
  Future<Either<AppFailure, T?>> refresh(String id);
  
  /// Refresca toda la colección
  Future<Either<AppFailure, List<T>>> refreshAll({Map<String, dynamic>? filters});
}
