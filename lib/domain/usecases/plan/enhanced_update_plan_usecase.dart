// lib/domain/usecases/plan/enhanced_update_plan_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quien_para/data/repositories/plan/plan_repository_impl.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/usecases/base/usecase.dart';

/// Parámetros para actualizar un plan
class UpdatePlanParams {
  final PlanEntity plan;

  const UpdatePlanParams({required this.plan});

  /// Validar que los parámetros sean correctos
  Either<ValidationFailure, bool> validate() {
    final List<String> errors = [];

    if (plan.id.isEmpty) {
      errors.add('El ID del plan no puede estar vacío');
    }

    if (plan.creatorId.isEmpty) {
      errors.add('El ID del creador no puede estar vacío');
    }

    if (plan.title.isEmpty) {
      errors.add('El título no puede estar vacío');
    } else if (plan.title.length < 3) {
      errors.add('El título debe tener al menos 3 caracteres');
    }

    if (plan.description.isEmpty) {
      errors.add('La descripción no puede estar vacía');
    }

    if (plan.location.isEmpty) {
      errors.add('La ubicación no puede estar vacía');
    }

    if (plan.category.isEmpty) {
      errors.add('La categoría no puede estar vacía');
    }

    if (errors.isNotEmpty) {
      final Map<String, String> fieldErrors = {};
      for (int i = 0; i < errors.length; i++) {
        fieldErrors['error_$i'] = errors[i];
      }

      return Left(
        ValidationFailure(
          message: 'Error de validación al actualizar plan',
          fieldErrors: fieldErrors,
          code: '',
          field: '',
        ),
      );
    }

    return const Right(true);
  }
}

/// Caso de uso mejorado para actualizar un plan
///
/// Este caso de uso implementa el manejo de errores consistente con Either,
/// validación de parámetros, y sigue los principios de Clean Architecture.
class EnhancedUpdatePlanUseCase
    implements UseCase<PlanEntity, UpdatePlanParams> {
  final PlanRepositoryImpl _planRepository;

  EnhancedUpdatePlanUseCase(this._planRepository);

  @override
  Future<Either<AppFailure, PlanEntity>> call(UpdatePlanParams params) async {
    try {
      // Validar parámetros
      final validationResult = params.validate();
      if (validationResult.isLeft()) {
        return validationResult.fold(
          (failure) => Left(failure),
          (_) => throw StateError(
            'Estado inesperado en validación',
          ), // Nunca debería ocurrir
        );
      }

      final plan = params.plan;

      if (kDebugMode) {
        print('Actualizando plan: ${plan.id} - ${plan.title}');
      }

      // Primero, verificar que el plan exista
      final getPlanResult = await _planRepository.getById(plan.id);

      return getPlanResult.fold(
        // Si hay error al obtener el plan, propagar el error
        (failure) => Left(failure),

        // Si se obtiene el plan correctamente
        (existingPlan) {
          // Si el plan no existe, retornar error
          if (existingPlan == null) {
            return Left(
              NotFoundFailure(
                message: 'No se encontró ningún plan con ID: ${plan.id}',
                code: '',
              ),
            );
          }

          // Si el plan existe pero el creador no coincide, retornar error de permisos
          if (existingPlan.creatorId != plan.creatorId) {
            return Left(
              PermissionFailure(
                message: 'No tienes permiso para actualizar este plan',
                code: '',
              ),
            );
          }

          // Si todo está correcto, delegar al repositorio
          return _planRepository.update(plan);
        },
      );
    } catch (e, stackTrace) {
      // Capturar cualquier excepción no manejada y convertirla a un AppFailure
      return Left(FailureHelper.fromException(e, stackTrace));
    }
  }
}
