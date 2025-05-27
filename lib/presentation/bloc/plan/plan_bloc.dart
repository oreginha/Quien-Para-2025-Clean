// lib/presentation/bloc/plan/plan_bloc.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/usecases/plan/get_plan_by_id_usecase.dart';
import 'package:quien_para/domain/usecases/plan/save_plan_usecase.dart';
import 'package:quien_para/domain/usecases/plan/update_plan_usecase.dart';
import 'package:quien_para/domain/usecases/plan/create_plan_usecase.dart';
import 'package:quien_para/presentation/bloc/plan/plan_event.dart';
import 'package:quien_para/presentation/bloc/plan/plan_state.dart';
import 'package:quien_para/presentation/bloc/cleanable_bloc.dart';

/// BloC responsable de la gestión del estado de creación y edición de planes
///
/// Esta implementación simplificada usa exclusivamente Clean Architecture
/// con casos de uso bien definidos y sin mezcla de enfoques arquitectónicos.
class PlanBloc extends CleanableBloc<PlanEvent, PlanState> {
  final GetPlanByIdUseCase _getPlanByIdUseCase;
  final CreatePlanUseCase _createPlanUseCase;
  final UpdatePlanUseCase _updatePlanUseCase;
  final SavePlanUseCase _savePlanUseCase;
  //final GetOtherUserPlansUseCase _otherUsersPlansUseCase;

  PlanBloc({
    required GetPlanByIdUseCase getPlanByIdUseCase,
    required CreatePlanUseCase createPlanUseCase,
    required UpdatePlanUseCase updatePlanUseCase,
    required SavePlanUseCase savePlanUseCase,
    //required GetOtherUserPlansUseCase otherUsersPlansUseCase,
    required PlanRepository planRepository,
  })  : _getPlanByIdUseCase = getPlanByIdUseCase,
        _createPlanUseCase = createPlanUseCase,
        _updatePlanUseCase = updatePlanUseCase,
        _savePlanUseCase = savePlanUseCase,
        //_otherUsersPlansUseCase = otherUsersPlansUseCase,
        super(const PlanState.initial()) {
    on<PlanEvent>((event, emit) {
      event.when(
        create: (creatorId, planData) =>
            _onCreatePlan(creatorId, planData, emit),
        save: () => _onSavePlan(emit),
        update: () => _onUpdatePlan(emit),
        updateField: (field, value) => _onUpdateField(field, value, emit),
        updateSelectedOptions: (options) =>
            _onUpdateSelectedOptions(options, emit),
        updateSelectedThemes: (themes) => _onUpdateSelectedThemes(themes, emit),
        updateExtraConditions: (conditions) =>
            _onUpdateExtraConditions(conditions, emit),
        clear: (creatorId) => _onClearPlan(creatorId, emit),
        updateFromSuggestedPlan: (planData) =>
            _onUpdateFromSuggestedPlan(planData, emit),
        loadExistingPlan: (planData) => _onLoadExistingPlan(planData, emit),
        loadOtherUsersPlans: (currentUserId) =>
            _loadOtherUsersPlans(currentUserId, emit),
      );
    });
  }

  Future<void> _onCreatePlan(
    String creatorId,
    Map<String, dynamic> planData,
    Emitter<PlanState> emit,
  ) async {
    try {
      final newPlan = PlanEntity.empty().copyWith(
        creatorId: creatorId,
        title: planData['title'] as String? ?? '',
        description: planData['description'] as String? ?? '',
        location: planData['location'] as String? ?? '',
        category: planData['category'] as String? ?? '',
      );

      final result = await _createPlanUseCase.execute(newPlan);
      result.fold(
        (failure) => emit(PlanState.error(message: failure.message)),
        (createdPlan) => emit(PlanState.loaded(plan: createdPlan)),
      );
    } catch (e, stackTrace) {
      _handleError('crear plan', e, stackTrace);
      emit(PlanState.error(message: 'Error al crear plan: $e'));
    }
  }

  Future<void> _onSavePlan(Emitter<PlanState> emit) async {
    final state = this.state;
    if (state is! PlanLoaded) {
      emit(
        const PlanState.error(message: 'No hay un plan activo para guardar'),
      );
      return;
    }

    final currentPlan = state.plan;
    try {
      emit(PlanState.saving(plan: currentPlan));

      final result = await _savePlanUseCase.execute(currentPlan);
      result.fold(
        (failure) =>
            emit(PlanState.error(message: failure.message, plan: currentPlan)),
        (savedPlan) => emit(PlanState.saved(plan: savedPlan)),
      );
    } catch (e, stackTrace) {
      _handleError('guardar plan', e, stackTrace);
      emit(
        PlanState.error(
          message: 'Error al guardar plan: $e',
          plan: currentPlan,
        ),
      );
    }
  }

  Future<void> _onUpdateField(
    String field,
    dynamic value,
    Emitter<PlanState> emit,
  ) async {
    final state = this.state;
    if (state is! PlanLoaded) return;

    try {
      final currentPlan = state.plan;
      PlanEntity updatedPlan;

      switch (field) {
        case 'title':
          updatedPlan = currentPlan.copyWith(title: value as String);
          break;
        case 'description':
          updatedPlan = currentPlan.copyWith(description: value as String);
          break;
        case 'location':
          updatedPlan = currentPlan.copyWith(location: value as String);
          break;
        case 'category':
          updatedPlan = currentPlan.copyWith(category: value as String);
          break;
        case 'date':
          if (value is DateTime) {
            updatedPlan = currentPlan.copyWith(date: value);
          } else if (value is Timestamp) {
            updatedPlan = currentPlan.copyWith(date: value.toDate());
          } else {
            throw ArgumentError('Formato de fecha inválido');
          }
          break;
        case 'guestCount':
          updatedPlan = currentPlan.copyWith(
            guestCount: int.tryParse(value.toString()),
          );
          break;
        case 'payCondition':
          updatedPlan = currentPlan.copyWith(payCondition: value as String);
          break;
        default:
          emit(
            PlanState.error(
              message: 'Campo no reconocido: $field',
              plan: currentPlan,
            ),
          );
          return;
      }
      emit(PlanState.loaded(plan: updatedPlan));
    } catch (e, stackTrace) {
      _handleError('actualizar campo', e, stackTrace);
      emit(
        PlanState.error(
          message: 'Error al actualizar campo: $e',
          plan: state.plan,
        ),
      );
    }
  }

  Future<void> _onUpdateSelectedOptions(
    Map<String, String> options,
    Emitter<PlanState> emit,
  ) async {
    final state = this.state;
    if (state is! PlanLoaded) return;

    try {
      final updatedPlan = state.plan.copyWith(conditions: options);
      emit(PlanState.loaded(plan: updatedPlan));
    } catch (e, stackTrace) {
      _handleError('actualizar opciones seleccionadas', e, stackTrace);
      emit(
        PlanState.error(
          message: 'Error al actualizar opciones: $e',
          plan: state.plan,
        ),
      );
    }
  }

  Future<void> _onUpdateSelectedThemes(
    List<String> themes,
    Emitter<PlanState> emit,
  ) async {
    final state = this.state;
    if (state is! PlanLoaded) return;

    try {
      final updatedPlan = state.plan.copyWith(selectedThemes: themes);
      emit(PlanState.loaded(plan: updatedPlan));
    } catch (e, stackTrace) {
      _handleError('actualizar temas seleccionados', e, stackTrace);
      emit(
        PlanState.error(
          message: 'Error al actualizar temas: $e',
          plan: state.plan,
        ),
      );
    }
  }

  Future<void> _onUpdateExtraConditions(
    String conditions,
    Emitter<PlanState> emit,
  ) async {
    final state = this.state;
    if (state is! PlanLoaded) return;

    try {
      final updatedPlan = state.plan.copyWith(extraConditions: conditions);
      emit(PlanState.loaded(plan: updatedPlan));
    } catch (e, stackTrace) {
      _handleError('actualizar condiciones extra', e, stackTrace);
      emit(
        PlanState.error(
          message: 'Error al actualizar condiciones: $e',
          plan: state.plan,
        ),
      );
    }
  }

  Future<void> _onClearPlan(String creatorId, Emitter<PlanState> emit) async {
    try {
      final newPlan = PlanEntity.empty().copyWith(creatorId: creatorId);
      emit(PlanState.loaded(plan: newPlan));
    } catch (e, stackTrace) {
      _handleError('limpiar plan', e, stackTrace);
      emit(PlanState.error(message: 'Error al limpiar plan: $e'));
    }
  }

  Future<void> _onUpdateFromSuggestedPlan(
    Map<String, dynamic> planData,
    Emitter<PlanState> emit,
  ) async {
    final state = this.state;
    if (state is! PlanLoaded) return;

    try {
      final updatedPlan = state.plan.copyWith(
        title: planData['title'] as String? ?? state.plan.title,
        description:
            planData['description'] as String? ?? state.plan.description,
        location: planData['location'] as String? ?? state.plan.location,
        category: planData['category'] as String? ?? state.plan.category,
      );
      emit(PlanState.loaded(plan: updatedPlan));
    } catch (e, stackTrace) {
      _handleError('actualizar desde plan sugerido', e, stackTrace);
      emit(
        PlanState.error(
          message: 'Error al actualizar desde plan sugerido: $e',
          plan: state.plan,
        ),
      );
    }
  }

  Future<void> _onLoadExistingPlan(
    Map<String, dynamic> planData,
    Emitter<PlanState> emit,
  ) async {
    try {
      final planId = planData['id'] as String?;
      if (planId == null || planId.isEmpty) {
        emit(const PlanState.error(message: 'ID de plan no válido'));
        return;
      }

      final result = await _getPlanByIdUseCase.execute(planId);
      result.fold(
        (failure) => emit(PlanState.error(message: failure.message)),
        (plan) => plan != null
            ? emit(PlanState.loaded(plan: plan))
            : emit(const PlanState.error(message: 'Plan no encontrado')),
      );
    } catch (e, stackTrace) {
      _handleError('cargar plan existente', e, stackTrace);
      emit(PlanState.error(message: 'Error al cargar plan existente: $e'));
    }
  }

  Future<void> _onUpdatePlan(Emitter<PlanState> emit) async {
    final state = this.state;
    if (state is! PlanLoaded) {
      emit(
        const PlanState.error(message: 'No hay un plan activo para actualizar'),
      );
      return;
    }

    try {
      final currentPlan = state.plan;
      emit(PlanState.updating(plan: currentPlan));

      final result = await _updatePlanUseCase.execute(currentPlan);
      result.fold(
        (failure) =>
            emit(PlanState.error(message: failure.message, plan: currentPlan)),
        (updatedPlan) => emit(PlanState.saved(plan: updatedPlan)),
      );
    } catch (e, stackTrace) {
      _handleError('actualizar plan', e, stackTrace);
      emit(
        PlanState.error(
          message: 'Error al actualizar plan: $e',
          plan: state.plan,
        ),
      );
    }
  }

  Future<void> _loadOtherUsersPlans(
    String currentUserId,
    Emitter<PlanState> emit,
  ) async {
    try {
      emit(const PlanState.loading());

      // Obtener primero una actualización de los planes
      // await _otherUsersPlansUseCase.refreshPlans(currentUserId);

      // Configurar suscripción al stream de planes
      //final plansStream =_otherUsersPlansUseCase.execute(currentUserId: currentUserId);

      // Para simplificar la gestión del BLoC, tomamos solo el primer valor del stream
      //final firstResult = await plansStream.first;

      //firstResult.fold(
      // (failure) => emit(PlanState.error(message: failure.message)),
      // (plans) => emit(PlanState.plansLoaded(plans: plans)),
      // );

      // Opcional: si quieres continuar escuchando el stream
      // plansStream.listen(
      //   (result) => result.fold(
      //     (failure) => add(PlanEvent.error(failure.message)),
      //     (plans) => add(PlanEvent.plansLoaded(plans)),
      //   ),
      // );
    } catch (e, stackTrace) {
      _handleError('cargar planes de otros usuarios', e, stackTrace);
      emit(PlanState.error(message: 'Error al cargar planes: $e'));
    }
  }

  void _handleError(String operation, dynamic error, StackTrace stackTrace) {
    if (kDebugMode) {
      print('Error al $operation: $error');
      print('StackTrace: $stackTrace');
    }
  }
}
