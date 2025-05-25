// lib/domain/usecases/plan/create_plan_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/usecases/base/usecase_interface.dart';

/// Caso de uso para crear un nuevo plan
///
/// Este caso de uso implementa la interfaz UseCaseInterface y utiliza el repositorio
/// de planes para crear un nuevo plan.
class CreatePlanUseCase implements UseCaseInterface<PlanEntity, PlanEntity> {
  final PlanRepository _planRepository;
  final Logger _logger = Logger();

  CreatePlanUseCase(this._planRepository);

  @override
  Future<Either<AppFailure, PlanEntity>> execute(PlanEntity plan) async {
    _logger.d('CreatePlanUseCase: Creando plan: ${plan.title}');

    // Validar plan
    if (!plan.isValid) {
      _logger.w('CreatePlanUseCase: Plan inválido');
      return Left(ValidationFailure(
        message: 'El plan no es válido, faltan campos requeridos',
        code: '',
        field: '',
      ));
    }

    // Delegar al repositorio
    return _planRepository.create(plan);
  }

  /// Método de conveniencia para usar el caso de uso como una función.
  Future<Either<AppFailure, PlanEntity>> call(PlanEntity plan) => execute(plan);
}
