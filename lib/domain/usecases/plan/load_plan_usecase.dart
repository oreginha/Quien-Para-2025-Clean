// lib/domain/usecases/plan/load_plan_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:logger/logger.dart';

/// Caso de uso para cargar un plan existente por su ID
class LoadPlanUseCase {
  final PlanRepository _planRepository;
  final Logger _logger = Logger();

  LoadPlanUseCase(this._planRepository);

  /// Ejecuta el caso de uso para cargar un plan por ID
  Future<Either<AppFailure, PlanEntity?>> execute(String planId) async {
    _logger.d('LoadPlanUseCase: Cargando plan con ID: $planId');

    if (planId.isEmpty) {
      _logger.w('LoadPlanUseCase: ID de plan vacío');
      return Left(
        ValidationFailure(
          message: 'El ID del plan no puede estar vacío',
          field: 'id',
          code: 'EMPTY_PLAN_ID',
        ),
      );
    }

    return _planRepository.getById(planId);
  }

  /// Método de conveniencia para usar el caso de uso como una función
  Future<Either<AppFailure, PlanEntity?>> call(String planId) =>
      execute(planId);
}

/// Caso de uso para inicializar un nuevo plan con datos predeterminados
class InitPlanUseCase {
  final PlanRepository _planRepository;

  InitPlanUseCase(this._planRepository);

  /// Crea un nuevo plan con los datos proporcionados o valores predeterminados
  Future<Either<AppFailure, PlanEntity>> execute({
    required String creatorId,
    Map<String, dynamic>? initialData,
  }) async {
    try {
      // Crear un plan nuevo con los datos proporcionados
      // Como no tenemos un método createEmptyPlan, creamos un plan básico
      // y usamos el método createPlan del repositorio

      // Aquí asumimos que tenemos un constructor o factory para crear un PlanEntity básico
      // Dependemos de la implementación específica de PlanEntity en el proyecto
      final basicPlan = _createBasicPlan(creatorId, initialData ?? {});

      // Usar el método estándar de creación de planes
      final plan = await _planRepository.create(basicPlan);

      return plan;
    } catch (e) {
      throw Exception('Error al inicializar el plan: $e');
    }
  }

  /// Crea un objeto PlanEntity básico
  ///
  /// Nota: Esta implementación depende de cómo se define PlanEntity
  /// en el proyecto real. Esta es una implementación de marcador
  /// que debe ser reemplazada con la lógica real.
  PlanEntity _createBasicPlan(
    String creatorId,
    Map<String, dynamic> initialData,
  ) {
    // IMPLEMENTACIÓN PENDIENTE: Crear un objeto PlanEntity básico
    // con los datos proporcionados

    // Ejemplo hipotético:
    // return PlanEntity(
    //   id: '',  // ID vacío para planes nuevos
    //   creatorId: creatorId,
    //   ...otros campos obligatorios...,
    //   ...inicializar con initialData donde corresponda
    // );

    throw UnimplementedError(
      'Implementación específica de _createBasicPlan debe ser proporcionada',
    );
  }
}

/// Caso de uso para cargar un plan con datos sugeridos
class LoadSuggestedPlanUseCase {
  final PlanRepository _planRepository;

  LoadSuggestedPlanUseCase(this._planRepository);

  /// Carga un plan con datos sugeridos
  Future<Either<AppFailure, PlanEntity>> execute({
    required String creatorId,
    required Map<String, dynamic> suggestedData,
  }) async {
    try {
      // Similar a InitPlanUseCase, creamos un plan básico con los datos sugeridos
      final basicPlan = _createPlanWithSuggestedData(creatorId, suggestedData);

      // Crear el plan utilizando el repositorio
      final plan = await _planRepository.create(basicPlan);

      return plan;
    } catch (e) {
      throw Exception('Error al cargar el plan sugerido: $e');
    }
  }

  /// Crea un objeto PlanEntity con datos sugeridos
  ///
  /// Nota: Esta implementación depende de cómo se define PlanEntity
  /// en el proyecto real. Esta es una implementación de marcador
  /// que debe ser reemplazada con la lógica real.
  PlanEntity _createPlanWithSuggestedData(
    String creatorId,
    Map<String, dynamic> suggestedData,
  ) {
    // IMPLEMENTACIÓN PENDIENTE: Crear un objeto PlanEntity
    // con los datos sugeridos proporcionados

    // Ejemplo hipotético:
    // return PlanEntity(
    //   id: '',  // ID vacío para planes nuevos
    //   creatorId: creatorId,
    //   ...otros campos obligatorios...,
    //   ...inicializar con suggestedData donde corresponda
    // );

    throw UnimplementedError(
      'Implementación específica de _createPlanWithSuggestedData debe ser proporcionada',
    );
  }
}
