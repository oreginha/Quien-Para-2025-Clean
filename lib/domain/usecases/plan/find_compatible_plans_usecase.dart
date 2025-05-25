// lib/domain/usecases/find_compatible_plans_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:quien_para/domain/failures/app_failures.dart';

import '../../entities/plan/plan_entity.dart';
import '../../services/matching_service.dart';
import '../../repositories/plan/plan_repository.dart';

/// Caso de uso para encontrar planes compatibles con un usuario
///
/// Este caso de uso utiliza el servicio de matching para encontrar
/// planes que sean compatibles con los intereses y ubicación del usuario.
class FindCompatiblePlansUseCase {
  final PlanRepository _planRepository;
  final MatchingService _matchingService;

  FindCompatiblePlansUseCase(
    this._planRepository,
    this._matchingService,
  );

  /// Encuentra planes compatibles para un usuario
  ///
  /// Parámetros:
  /// - userInterests: Lista de intereses del usuario
  /// - userLocation: Ubicación del usuario
  /// - limit: Número máximo de planes a retornar (opcional)
  /// - minimumScore: Puntuación mínima de compatibilidad (opcional)
  Future<List<Map<String, dynamic>>> call({
    required List<String> userInterests,
    required String userLocation,
    int limit = 10,
    double minimumScore = 0.4,
  }) async {
    try {
      // Obtener todos los planes disponibles
      final Either<AppFailure, List<PlanEntity>> plansResult =
          await _planRepository.getAll(limit: 50);

      // Manejar el resultado usando fold
      final List<Map<String, dynamic>> plansData = plansResult.fold(
        (failure) => [], // En caso de fallo, retornar lista vacía
        (plans) => plans
            .map((plan) => <String, dynamic>{
                  'id': plan.id,
                  'title': plan.title,
                  'description': plan.description,
                  'category': plan.category,
                  'location': plan.location,
                  'date': plan.date?.toIso8601String(),
                  'imageUrl': plan.imageUrl,
                  'creatorId': plan.creatorId,
                  'tags': plan.tags,
                })
            .toList(),
      );

      // Filtrar planes compatibles usando el servicio de matching
      final List<Map<String, dynamic>> compatiblePlans =
          _matchingService.filterCompatiblePlans(
        plans: plansData,
        userInterests: userInterests,
        userLocation: userLocation,
        minimumScore: minimumScore,
      );

      // Limitar el número de resultados
      return compatiblePlans.take(limit).toList();
    } catch (e) {
      throw Exception('Error al buscar planes compatibles: $e');
    }
  }
}
