// lib/domain/usecases/search/search_plans_usecase.dart

import 'package:dartz/dartz.dart';
import '../../entities/failure.dart';
import '../../entities/plan/plan_with_creator_entity.dart';
import '../../repositories/plan/plan_repository.dart';

/// Caso de uso para buscar planes por texto
///
/// Permite realizar búsquedas por:
/// - Título del plan
/// - Descripción
/// - Categoría
/// - Ubicación
class SearchPlansUseCase {
  final PlanRepository repository;

  const SearchPlansUseCase(this.repository);

  /// Ejecuta la búsqueda de planes
  ///
  /// [query] - Texto de búsqueda
  /// [limit] - Límite de resultados (por defecto 20)
  /// [lastDocument] - Último documento para paginación (opcional)
  ///
  /// Retorna una lista de planes con información del creador
  Future<Either<Failure, List<PlanWithCreatorEntity>>> execute({
    required String query,
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      // Validar entrada
      if (query.trim().isEmpty) {
        return const Left(
            ValidationFailure('La consulta de búsqueda no puede estar vacía'));
      }

      // Limpiar y normalizar la consulta
      final cleanQuery = query.trim().toLowerCase();

      // Ejecutar búsqueda en el repositorio
      final result = await repository.searchPlans(
        query: cleanQuery,
        limit: limit,
        lastDocumentId: lastDocumentId,
      );

      return result;
    } catch (e) {
      return Left(
          ServerFailure(null, 'Error al buscar planes: ${e.toString()}'));
    }
  }

  /// Ejecuta búsqueda con sugerencias automáticas
  ///
  /// [query] - Texto de búsqueda parcial
  /// [limit] - Límite de sugerencias (por defecto 5)
  ///
  /// Retorna una lista de sugerencias de búsqueda
  Future<Either<Failure, List<String>>> getSuggestions({
    required String query,
    int limit = 5,
  }) async {
    try {
      if (query.trim().isEmpty) {
        return const Right([]);
      }

      final cleanQuery = query.trim().toLowerCase();

      // Obtener sugerencias del repositorio
      final result = await repository.getSearchSuggestions(
        query: cleanQuery,
        limit: limit,
      );

      return result;
    } catch (e) {
      return Left(
          ServerFailure(null, 'Error al obtener sugerencias: ${e.toString()}'));
    }
  }
}
