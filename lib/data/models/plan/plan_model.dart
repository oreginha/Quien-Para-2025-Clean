// lib/data/models/plan/plan_model.dart
// ignore_for_file: always_specify_types

import 'package:freezed_annotation/freezed_annotation.dart';
// Removemos la dependencia directa a la entidad para evitar dependencia circular

part 'plan_model.freezed.dart';
part 'plan_model.g.dart';

@freezed
class PlanModel with _$PlanModel {
  const PlanModel._();

  const factory PlanModel({
    required String id,
    required String title,
    required String description,
    @Default('') String imageUrl,
    required String creatorId,
    required DateTime date,
    @Default(0) int likes,
    @Default('') String category,
    @Default('') String location,
    @Default({}) Map<String, String> conditions,
    @Default([]) List<String> selectedThemes,
    String? createdAt,
    @Default(true) bool esVisible,
  }) = _PlanModel;

  factory PlanModel.fromJson(Map<String, dynamic> json) =>
      _$PlanModelFromJson(json);

  // La conversión PlanEntity -> PlanModel ahora se maneja en PlanMapper

  // La conversión PlanModel -> PlanEntity ahora se maneja en PlanMapper

  // La conversión a formato Firestore ahora se maneja en PlanMapper
}
