// lib/domain/usecases/plan/update_plan_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/usecases/base/usecase_interface.dart';

/// Caso de uso para actualizar un plan existente
///
/// Este caso de uso implementa la interfaz UseCaseInterface y utiliza el repositorio
/// de planes para actualizar un plan existente.
class UpdatePlanUseCase implements UseCaseInterface<PlanEntity, PlanEntity> {
  final PlanRepository _planRepository;
  final Logger _logger = Logger();

  UpdatePlanUseCase(this._planRepository);

  @override
  Future<Either<AppFailure, PlanEntity>> execute(PlanEntity plan) async {
    _logger.d('UpdatePlanUseCase: Actualizando plan: ${plan.id}');

    // Validar plan
    if (!plan.isValid) {
      _logger.w('UpdatePlanUseCase: Plan inválido');
      return Left(
        ValidationFailure(
          message: 'El plan no es válido, faltan campos requeridos',
          code: '',
          field: '',
        ),
      );
    }

    // Verificar que el plan tenga ID
    if (plan.id.isEmpty) {
      _logger.w('UpdatePlanUseCase: ID de plan vacío');
      return Left(
        ValidationFailure(
          message: 'No se puede actualizar un plan sin ID',
          field: 'id',
          code: '',
        ),
      );
    }

    // Verificar que el plan exista
    final existsResult = await _planRepository.exists(plan.id);
    final exists = existsResult.fold((failure) => false, (exists) => exists);

    if (!exists) {
      _logger.w('UpdatePlanUseCase: Plan no encontrado');
      return Left(
        NotFoundFailure(
          message: 'El plan con ID ${plan.id} no existe',
          code: '',
        ),
      );
    }

    // Delegar al repositorio
    return _planRepository.update(plan);
  }

  /// Método de conveniencia para usar el caso de uso como una función.
  Future<Either<AppFailure, PlanEntity>> call(PlanEntity plan) => execute(plan);
}
