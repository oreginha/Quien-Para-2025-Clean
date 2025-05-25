// lib/presentation/bloc/plan/plan_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:quien_para/domain/entities/plan/plan_entity.dart';
// Update the path as necessary

part 'plan_state.freezed.dart';

@freezed
class PlanState with _$PlanState {
  const PlanState._();

  const factory PlanState.initial() = PlanInitial;

  // Estado de carga
  const factory PlanState.loading() = _Loading;

  const factory PlanState.loaded({
    required final PlanEntity plan,
  }) = PlanLoaded;

  const factory PlanState.saving({
    final PlanEntity? plan,
  }) = PlanSaving;

  const factory PlanState.updating({
    final PlanEntity? plan,
  }) = PlanUpdating;

  const factory PlanState.plansLoaded({
    required final List<PlanEntity> plans,
  }) = PlansLoaded;

  const factory PlanState.saved({
    required final PlanEntity plan,
  }) = PlanSaved;

  const factory PlanState.error({
    required final String message,
    final PlanEntity? plan,
  }) = PlanError;
}
