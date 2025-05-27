// lib/domain/usecases/plan/save_plan_usecase.dart

// ignore_for_file: unused_field

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/usecases/base/usecase_interface.dart';
import 'package:quien_para/domain/usecases/plan/create_plan_usecase.dart';
import 'package:quien_para/domain/usecases/plan/update_plan_usecase.dart';

/// Caso de uso para guardar un plan (crear nuevo o actualizar existente)
///
/// Este caso de uso implementa la interfaz UseCaseInterface y utiliza
/// CreatePlanUseCase o UpdatePlanUseCase según corresponda.
class SavePlanUseCase implements UseCaseInterface<PlanEntity, PlanEntity> {
  final PlanRepository _planRepository;
  final CreatePlanUseCase _createPlanUseCase;
  final UpdatePlanUseCase _updatePlanUseCase;
  final Logger _logger = Logger();

  SavePlanUseCase(
    this._planRepository, {
    CreatePlanUseCase? createPlanUseCase,
    UpdatePlanUseCase? updatePlanUseCase,
  })  : _createPlanUseCase =
            createPlanUseCase ?? CreatePlanUseCase(_planRepository),
        _updatePlanUseCase =
            updatePlanUseCase ?? UpdatePlanUseCase(_planRepository);

  @override
  Future<Either<AppFailure, PlanEntity>> execute(PlanEntity plan) async {
    _logger.d(
      'SavePlanUseCase: Guardando plan: ${plan.id.isEmpty ? "nuevo" : plan.id}',
    );

    // Validar plan
    if (!plan.isValid) {
      _logger.w('SavePlanUseCase: Plan inválido');
      return Left(
        ValidationFailure(
          message: 'El plan no es válido, faltan campos requeridos',
          code: '',
          field: '',
        ),
      );
    }

    // Determinar si es un plan nuevo o existente
    if (plan.id.isEmpty) {
      _logger.d('SavePlanUseCase: Creando nuevo plan');
      return _createPlanUseCase.execute(plan);
    } else {
      _logger.d('SavePlanUseCase: Actualizando plan existente');
      return _updatePlanUseCase.execute(plan);
    }
  }

  /// Método de conveniencia para usar el caso de uso como una función.
  Future<Either<AppFailure, PlanEntity>> call(PlanEntity plan) => execute(plan);
}
