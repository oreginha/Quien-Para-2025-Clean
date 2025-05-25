// lib/domain/usecases/plan/get_plan_by_id_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/usecases/base/usecase_interface.dart';

/// Caso de uso para obtener un plan por ID
///
/// Este caso de uso implementa la interfaz UseCaseInterface y utiliza el repositorio
/// de planes para obtener un plan específico por su ID.
class GetPlanByIdUseCase implements UseCaseInterface<PlanEntity?, String> {
  final PlanRepository _planRepository;
  final Logger _logger = Logger();

  GetPlanByIdUseCase(this._planRepository);

  @override
  Future<Either<AppFailure, PlanEntity?>> execute(String planId) async {
    _logger.d('GetPlanByIdUseCase: Obteniendo plan con ID: $planId');

    // Validar parámetros
    if (planId.isEmpty) {
      _logger.w('GetPlanByIdUseCase: ID de plan vacío');
      return Left(ValidationFailure(
        message: 'El ID del plan no puede estar vacío',
        field: 'planId',
        code: '',
      ));
    }

    // Delegar al repositorio
    return _planRepository.getById(planId);
  }

  /// Método de conveniencia para usar el caso de uso como una función.
  Future<Either<AppFailure, PlanEntity?>> call(String planId) =>
      execute(planId);
}
