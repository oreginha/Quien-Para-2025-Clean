// lib/domain/usecases/search/filter_plans_by_category_usecase.dart

import 'package:dartz/dartz.dart';
import '../../entities/failure.dart';
import '../../entities/plan/plan_with_creator_entity.dart';
import '../../repositories/plan/plan_repository.dart';

/// Caso de uso para filtrar planes por categoría
///
/// Permite filtrar planes según diferentes categorías predefinidas
class FilterPlansByCategoryUseCase {
  final PlanRepository repository;

  const FilterPlansByCategoryUseCase(this.repository);

  /// Categorías disponibles para filtrar
  static const List<String> availableCategories = [
    'Social',
    'Cultural',
    'Deportivo',
    'Entretenimiento',
    'Gastronomía',
    'Aventura',
    'Educativo',
    'Familiar',
    'Nocturno',
    'Arte',
    'Música',
    'Tecnología',
    'Naturaleza',
    'Fitness',
    'Gaming',
    'Viajes',
  ];

  /// Filtra planes por categoría específica
  ///
  /// [category] - Categoría a filtrar
  /// [limit] - Límite de resultados (por defecto 20)
  /// [lastDocumentId] - Para paginación (opcional)
  ///
  /// Retorna planes de la categoría especificada
  Future<Either<Failure, List<PlanWithCreatorEntity>>> execute({
    required String category,
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      // Validar entrada
      if (category.trim().isEmpty) {
        return const Left(
          ValidationFailure('La categoría no puede estar vacía'),
        );
      }

      final cleanCategory = category.trim();

      // Verificar que la categoría sea válida
      if (!availableCategories.contains(cleanCategory)) {
        return Left(
          ValidationFailure(
            'Categoría inválida. Categorías disponibles: ${availableCategories.join(', ')}',
          ),
        );
      }

      // Ejecutar filtro por categoría
      final result = await repository.filterPlansByCategory(
        category: cleanCategory,
        limit: limit,
        lastDocumentId: lastDocumentId,
      );

      return result;
    } catch (e) {
      return Left(
        ServerFailure(null, 'Error al filtrar por categoría: ${e.toString()}'),
      );
    }
  }

  /// Filtra planes por múltiples categorías
  ///
  /// [categories] - Lista de categorías a incluir
  /// [limit] - Límite de resultados (por defecto 20)
  /// [lastDocumentId] - Para paginación (opcional)
  ///
  /// Retorna planes que pertenecen a cualquiera de las categorías especificadas
  Future<Either<Failure, List<PlanWithCreatorEntity>>> executeMultiple({
    required List<String> categories,
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      // Validar entrada
      if (categories.isEmpty) {
        return const Left(
          ValidationFailure('Debe especificar al menos una categoría'),
        );
      }

      if (categories.length > 5) {
        return const Left(
          ValidationFailure('No se pueden especificar más de 5 categorías'),
        );
      }

      // Limpiar y validar categorías
      final cleanCategories = categories.map((c) => c.trim()).toList();

      for (final category in cleanCategories) {
        if (!availableCategories.contains(category)) {
          return Left(
            ValidationFailure(
              'Categoría inválida: $category. Categorías disponibles: ${availableCategories.join(', ')}',
            ),
          );
        }
      }

      // Ejecutar filtro por múltiples categorías
      final result = await repository.filterPlansByMultipleCategories(
        categories: cleanCategories,
        limit: limit,
        lastDocumentId: lastDocumentId,
      );

      return result;
    } catch (e) {
      return Left(
        ServerFailure(
          null,
          'Error al filtrar por múltiples categorías: ${e.toString()}',
        ),
      );
    }
  }

  /// Obtiene planes populares por categoría
  ///
  /// [category] - Categoría específica
  /// [limit] - Límite de resultados (por defecto 10)
  ///
  /// Retorna planes más populares de la categoría (ordenados por número de aplicantes)
  Future<Either<Failure, List<PlanWithCreatorEntity>>> getPopularByCategory({
    required String category,
    int limit = 10,
  }) async {
    try {
      if (category.trim().isEmpty) {
        return const Left(
          ValidationFailure('La categoría no puede estar vacía'),
        );
      }

      final cleanCategory = category.trim();

      if (!availableCategories.contains(cleanCategory)) {
        return const Left(ValidationFailure('Categoría inválida'));
      }

      // Ejecutar filtro de planes populares por categoría
      final result = await repository.getPopularPlansByCategory(
        category: cleanCategory,
        limit: limit,
      );

      return result;
    } catch (e) {
      return Left(
        ServerFailure(
          null,
          'Error al obtener planes populares: ${e.toString()}',
        ),
      );
    }
  }

  /// Obtiene sugerencias de categorías basadas en el historial del usuario
  ///
  /// [userId] - ID del usuario
  /// [limit] - Límite de sugerencias (por defecto 3)
  ///
  /// Retorna categorías sugeridas para el usuario
  Future<Either<Failure, List<String>>> getSuggestedCategories({
    required String userId,
    int limit = 3,
  }) async {
    try {
      if (userId.trim().isEmpty) {
        return const Left(
          ValidationFailure('El ID del usuario no puede estar vacío'),
        );
      }

      // Obtener categorías sugeridas del repositorio
      final result = await repository.getSuggestedCategories(
        userId: userId.trim(),
        limit: limit,
      );

      return result;
    } catch (e) {
      return Left(
        ServerFailure(
          null,
          'Error al obtener categorías sugeridas: ${e.toString()}',
        ),
      );
    }
  }

  /// Obtiene todas las categorías disponibles
  List<String> getAvailableCategories() {
    return List.from(availableCategories);
  }

  /// Valida si una categoría es válida
  bool isValidCategory(String category) {
    return availableCategories.contains(category.trim());
  }
}
