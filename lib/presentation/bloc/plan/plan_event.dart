// libcore/blocs/plan/plan_event.dart
// ignore_for_file: always_specify_types

import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan_event.freezed.dart';

@freezed
class PlanEvent with _$PlanEvent {
  const PlanEvent._();

  const factory PlanEvent.create({
    @Default('') final String creatorId,
    @Default({}) final Map<String, dynamic> planData,
  }) = _Create;
  const factory PlanEvent.save() = _Save;
  const factory PlanEvent.update() = _Update;
  const factory PlanEvent.updateField({
    required final String field,
    required final dynamic value,
  }) = _UpdateField;

  const factory PlanEvent.updateSelectedOptions(
    final Map<String, String> options,
  ) = _UpdateSelectedOptions;

  const factory PlanEvent.updateSelectedThemes(
    final List<String> themes,
  ) = _UpdateSelectedThemes;

  const factory PlanEvent.updateExtraConditions(
    final String extraConditions,
  ) = _UpdateExtraConditions;

  const factory PlanEvent.clear({@Default('') final String creatorId}) = _Clear;

  const factory PlanEvent.updateFromSuggestedPlan(
    final Map<String, dynamic> planData,
  ) = _UpdateFromSuggestedPlan;

  const factory PlanEvent.loadExistingPlan({
    required final Map<String, dynamic> planData,
  }) = _LoadExistingPlan;

  const factory PlanEvent.loadOtherUsersPlans({
    required final String currentUserId,
  }) = _LoadOtherUsersPlans;
}
