// lib/domain/usecases/plan/delete_plan_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/usecases/base/usecase_interface.dart';

/// Caso de uso para eliminar un plan
///
/// Este caso de uso implementa la interfaz UseCaseInterface y utiliza el repositorio
/// de planes para eliminar un plan existente.
class DeletePlanUseCase implements UseCaseInterface<Unit, String> {
  final PlanRepository _planRepository;
  final Logger _logger = Logger();

  DeletePlanUseCase(this._planRepository);

  @override
  Future<Either<AppFailure, Unit>> execute(String planId) async {
    _logger.d('DeletePlanUseCase: Eliminando plan: $planId');

    // Validar parámetros
    if (planId.isEmpty) {
      _logger.w('DeletePlanUseCase: ID de plan vacío');
      return Left(ValidationFailure(
        message: 'El ID del plan no puede estar vacío',
        field: 'planId',
        code: '',
      ));
    }

    // Verificar que el plan exista
    final existsResult = await _planRepository.exists(planId);
    final exists = existsResult.fold(
      (failure) => false,
      (exists) => exists,
    );

    if (!exists) {
      _logger.w('DeletePlanUseCase: Plan no encontrado');
      return Left(NotFoundFailure(
        message: 'El plan con ID $planId no existe',
        code: '',
      ));
    }

    // Delegar al repositorio
    return _planRepository.delete(planId);
  }

  /// Método de conveniencia para usar el caso de uso como una función.
  Future<Either<AppFailure, Unit>> call(String planId) => execute(planId);
}
