// lib/domain/usecases/plan/get_nearby_plans_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/usecases/base/usecase_interface.dart';

/// Parámetros para obtener planes cercanos
class GetNearbyPlansParams {
  final double latitude;
  final double longitude;
  final double radiusKm;
  final int? limit;

  const GetNearbyPlansParams({
    required this.latitude,
    required this.longitude,
    required this.radiusKm,
    this.limit,
  });
}

/// Caso de uso para obtener planes cercanos a una ubicación
///
/// Este caso de uso implementa la interfaz UseCaseInterface y utiliza el repositorio
/// de planes para obtener planes cercanos a una ubicación geográfica.
class GetNearbyPlansUseCase
    implements UseCaseInterface<List<PlanEntity>, GetNearbyPlansParams> {
  final PlanRepository _planRepository;
  final Logger _logger = Logger();

  GetNearbyPlansUseCase(this._planRepository);

  @override
  Future<Either<AppFailure, List<PlanEntity>>> execute(
    GetNearbyPlansParams params,
  ) async {
    _logger.d(
      'GetNearbyPlansUseCase: Obteniendo planes cercanos a (${params.latitude}, ${params.longitude})',
    );

    // Validar parámetros
    if (params.radiusKm <= 0) {
      _logger.w('GetNearbyPlansUseCase: Radio inválido: ${params.radiusKm}');
      return Left(
        ValidationFailure(
          message: 'El radio debe ser un número positivo',
          code: 'INVALID_RADIUS',
          field: 'radiusKm',
          fieldErrors: {'radiusKm': 'Debe ser mayor a 0'},
        ),
      );
    }

    // Delegar al repositorio
    try {
      return _planRepository.getNearbyPlans(
        latitude: params.latitude,
        longitude: params.longitude,
        radiusKm: params.radiusKm,
        limit: params.limit,
      );
    } catch (e) {
      _logger.e(
        'GetNearbyPlansUseCase: Error al obtener planes cercanos',
        error: e,
      );
      return Left(
        DatabaseFailure(
          message: 'Error al obtener planes cercanos',
          code: 'GET_NEARBY_PLANS_ERROR',
          originalError: e,
        ),
      );
    }
  }

  /// Método de conveniencia para usar el caso de uso como una función.
  Future<Either<AppFailure, List<PlanEntity>>> call(
    GetNearbyPlansParams params,
  ) =>
      execute(params);
}
