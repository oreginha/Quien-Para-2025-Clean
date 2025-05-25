// lib/domain/usecases/plan/enhanced_create_plan_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quien_para/data/repositories/plan/plan_repository_impl.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/usecases/base/usecase.dart';
import 'package:uuid/uuid.dart';

/// Parámetros para crear un plan
class CreatePlanParams {
  final String? id;
  final String creatorId;
  final String title;
  final String description;
  final String location;
  final DateTime? date;
  final String category;
  final List<String> tags;
  final String imageUrl;
  final Map<String, String> conditions;
  final List<String> selectedThemes;

  const CreatePlanParams({
    this.id,
    required this.creatorId,
    required this.title,
    required this.description,
    required this.location,
    this.date,
    required this.category,
    this.tags = const <String>[],
    this.imageUrl = '',
    this.conditions = const <String, String>{},
    this.selectedThemes = const <String>[],
  });

  /// Validar que los parámetros sean correctos
  Either<ValidationFailure, bool> validate() {
    final List<String> errors = [];

    if (creatorId.isEmpty) {
      errors.add('El ID del creador no puede estar vacío');
    }

    if (title.isEmpty) {
      errors.add('El título no puede estar vacío');
    } else if (title.length < 3) {
      errors.add('El título debe tener al menos 3 caracteres');
    }

    if (description.isEmpty) {
      errors.add('La descripción no puede estar vacía');
    }

    if (location.isEmpty) {
      errors.add('La ubicación no puede estar vacía');
    }

    if (category.isEmpty) {
      errors.add('La categoría no puede estar vacía');
    }

    if (errors.isNotEmpty) {
      final Map<String, String> fieldErrors = {};
      for (int i = 0; i < errors.length; i++) {
        fieldErrors['error_$i'] = errors[i];
      }

      return Left(ValidationFailure(
        message: 'Error de validación al crear plan',
        fieldErrors: fieldErrors,
        code: '',
        field: '',
      ));
    }

    return const Right(true);
  }

  /// Convertir parámetros a entidad
  PlanEntity toEntity() {
    // Generar un ID único si no se proporciona uno
    final String planId = id ?? const Uuid().v4();

    return PlanEntity(
      id: planId,
      creatorId: creatorId,
      title: title,
      description: description,
      location: location,
      date: date,
      category: category,
      tags: tags,
      imageUrl: imageUrl,
      conditions: conditions,
      selectedThemes: selectedThemes,
      extraConditions: conditions['extraConditions'] ?? '',
      likes: 0,
    );
  }
}

/// Caso de uso mejorado para crear un plan
///
/// Este caso de uso implementa el manejo de errores consistente con Either,
/// validación de parámetros, y sigue los principios de Clean Architecture.
class EnhancedCreatePlanUseCase
    implements UseCase<PlanEntity, CreatePlanParams> {
  final PlanRepositoryImpl _planRepository;

  EnhancedCreatePlanUseCase(this._planRepository);

  @override
  Future<Either<AppFailure, PlanEntity>> call(CreatePlanParams params) async {
    try {
      // Validar parámetros
      final validationResult = params.validate();
      if (validationResult.isLeft()) {
        return validationResult.fold(
          (failure) => Left(failure),
          (_) => throw StateError(
              'Estado inesperado en validación'), // Nunca debería ocurrir
        );
      }

      // Convertir parámetros a entidad
      final plan = params.toEntity();

      if (kDebugMode) {
        print('Creando plan: ${plan.title}');
      }

      // Delegar al repositorio
      return _planRepository.create(plan);
    } catch (e, stackTrace) {
      // Capturar cualquier excepción no manejada y convertirla a un AppFailure
      return Left(FailureHelper.fromException(e, stackTrace));
    }
  }
}
