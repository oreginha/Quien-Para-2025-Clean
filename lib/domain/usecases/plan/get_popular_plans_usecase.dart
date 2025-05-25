// lib/domain/usecases/plan/get_popular_plans_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/usecases/base/usecase_interface.dart';

/// Parámetros para obtener planes populares
class GetPopularPlansParams {
  final int? limit;
  final String? lastDocumentId;

  const GetPopularPlansParams({
    this.limit,
    this.lastDocumentId,
  });
}

/// Caso de uso para obtener los planes más populares
///
/// Este caso de uso implementa la interfaz UseCaseInterface y utiliza el repositorio
/// de planes para obtener los planes con más likes o interacciones.
class GetPopularPlansUseCase
    implements UseCaseInterface<List<PlanEntity>, GetPopularPlansParams> {
  final PlanRepository _planRepository;
  final Logger _logger = Logger();

  GetPopularPlansUseCase(this._planRepository);

  @override
  Future<Either<AppFailure, List<PlanEntity>>> execute(
      GetPopularPlansParams params) async {
    _logger.d('GetPopularPlansUseCase: Obteniendo planes populares');

    try {
      // Delegar al repositorio
      return await _planRepository.getPopularPlans(
        limit: params.limit,
        lastDocumentId: params.lastDocumentId,
      );
    } catch (e) {
      _logger.e('GetPopularPlansUseCase: Error al obtener planes populares',
          error: e);
      return Left(AppFailure(
        message: 'Error al obtener planes populares',
        code: 'error-get-popular-plans',
      ));
    }
  }

  /// Método de conveniencia para usar el caso de uso como una función.
  Future<Either<AppFailure, List<PlanEntity>>> call(
          GetPopularPlansParams params) =>
      execute(params);

  /// Método de conveniencia para obtener planes populares sin parámetros adicionales
  Future<Either<AppFailure, List<PlanEntity>>> getPopularPlans({int? limit}) {
    return execute(GetPopularPlansParams(limit: limit));
  }
}
