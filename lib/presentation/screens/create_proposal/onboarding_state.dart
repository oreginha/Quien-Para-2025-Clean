// lib/presentation/screens/create_proposal/onboarding_state.dart
// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';

class PlanOnboardingState {
  final List<String>? interests;
  final String? description;
  final String? location;
  final String? type;
  final DateTime? date;
  final TimeOfDay? time;
  final Map<String, String>? options;
  final String? extraConditions;
  final String? title;
  final String? imageUrl;
  final String? category;

  const PlanOnboardingState({
    this.interests,
    this.description,
    this.location,
    this.type,
    this.date,
    this.time,
    this.options,
    this.extraConditions,
    this.title,
    this.imageUrl,
    this.category,
  });

  PlanOnboardingState copyWith({
    List<String>? interests,
    String? description,
    String? location,
    String? type,
    DateTime? date,
    TimeOfDay? time,
    Map<String, String>? options,
    String? extraConditions,
    String? title,
    String? imageUrl,
    String? category,
  }) {
    return PlanOnboardingState(
      interests: interests ?? this.interests,
      description: description ?? this.description,
      location: location ?? this.location,
      type: type ?? this.type,
      date: date ?? this.date,
      time: time ?? this.time,
      options: options ?? this.options,
      extraConditions: extraConditions ?? this.extraConditions,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'interests': interests,
      'description': description,
      'location': location,
      'type': type,
      'date': date?.toIso8601String(),
      'time': time != null ? '${time!.hour}:${time!.minute}' : null,
      'options': options,
      'extraConditions': extraConditions,
      'title': title,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  factory PlanOnboardingState.fromJson(Map<String, dynamic> json) {
    return PlanOnboardingState(
      interests: json['interests'] != null
          ? List<String>.from(json['interests'] as List<dynamic>)
          : null,
      description: json['description'] as String,
      location: json['location'] as String,
      type: json['type'] as String,
      date:
          json['date'] != null ? DateTime.parse(json['date'] as String) : null,
      time: json['time'] != null
          ? TimeOfDay.fromDateTime(DateTime.parse('2024-01-01 ${json['time']}'))
          : null,
      options: json['options'] != null
          ? Map<String, String>.from(json['options'] as Map<dynamic, dynamic>)
          : null,
      extraConditions: json['extraConditions'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
    );
  }
}

class OnboardingState {
  final List<String> selectedThemes;
  final String description;
  final String location;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final Map<String, String>
      selectedOptions; // Nuevo campo para múltiples opciones
  final String extraConditions; // Nuevo campo para condiciones adicionales
  final String title;
  final List<PlanEntity> createdPlans;
  final String creatorId;
  final String? imageUrl; // Nuevo campo para la URL de la imagen

  OnboardingState({
    this.selectedThemes = const <String>[],
    this.description = '',
    this.location = '',
    this.selectedDate,
    this.selectedTime,
    this.selectedOptions = const <String, String>{}, // Inicializado
    this.extraConditions = '', // Inicializado
    this.title = '',
    this.createdPlans = const <PlanEntity>[],
    this.creatorId = '',
    this.imageUrl, // Inicializado
  });

  OnboardingState copyWith({
    final List<String>? selectedThemes,
    final String? description,
    final String? location,
    final DateTime? selectedDate,
    final TimeOfDay? selectedTime,
    final Map<String, String>? selectedOptions,
    final String? extraConditions,
    final String? title,
    final List<PlanEntity>? createdPlans,
    final String? creatorId,
    final String? imageUrl,
  }) {
    return OnboardingState(
      selectedThemes: selectedThemes ?? this.selectedThemes,
      description: description ?? this.description,
      location: location ?? this.location,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      extraConditions: extraConditions ?? this.extraConditions,
      title: title ?? this.title,
      createdPlans: createdPlans ?? this.createdPlans,
      creatorId: creatorId ?? this.creatorId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'selectedThemes': selectedThemes,
      'description': description,
      'location': location,
      'selectedDate': selectedDate?.toIso8601String(),
      'selectedTime': selectedTime != null
          ? '${selectedTime!.hour}:${selectedTime!.minute}'
          : null,
      'selectedOptions': selectedOptions,
      'extraConditions': extraConditions,
      'title': title,
      'createdPlans':
          createdPlans.map((final PlanEntity plan) => plan.toJson()).toList(),
      'creatorId': creatorId,
      'imageUrl': imageUrl,
    };
  }

  factory OnboardingState.fromJson(final Map<String, dynamic> json) {
    return OnboardingState(
      selectedThemes: List<String>.from(
          json['selectedThemes'] as List<dynamic>? ?? <String>[]),
      description: (json['description'] as String?) ?? '',
      location: (json['location'] as String?) ?? '',
      selectedDate: json['selectedDate'] != null
          ? DateTime.parse(json['selectedDate'] as String)
          : null,
      selectedTime: json['selectedTime'] != null
          ? TimeOfDay.fromDateTime(
              DateTime.parse('2024-01-01 ${json['selectedTime'] as String}'))
          : null,
      selectedOptions: Map<String, String>.from(
          json['selectedOptions'] as Map<String, dynamic>? ??
              <String, dynamic>{}),
      extraConditions: (json['extraConditions'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      createdPlans: ((json['createdPlans'] as List<dynamic>?) ?? <String>[])
          .map(
              (final plan) => PlanEntity.fromJson(plan as Map<String, dynamic>))
          .toList(),
      creatorId: (json['creatorId'] as String?) ?? '',
      imageUrl: json['imageUrl'] as String?,
    );
  }
  factory OnboardingState.fromJsonMap(final Map<String, dynamic> json) {
    return OnboardingState(
      selectedThemes: List<String>.from(
          json['selectedThemes'] as List<dynamic>? ?? <String>[]),
      description: (json['description'] as String?) ?? '',
      location: (json['location'] as String?) ?? '',
      selectedDate: json['selectedDate'] != null
          ? DateTime.parse(json['selectedDate'] as String)
          : null,
      selectedTime: json['selectedTime'] != null
          ? TimeOfDay.fromDateTime(
              DateTime.parse('2024-01-01 ${json['selectedTime'] as String}'))
          : null,
      selectedOptions: Map<String, String>.from(
          json['selectedOptions'] as Map<String, dynamic>? ??
              <String, dynamic>{}),
      extraConditions: (json['extraConditions'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      createdPlans: ((json['createdPlans'] as List<dynamic>?) ?? <String>[])
          .map(
              (final plan) => PlanEntity.fromJson(plan as Map<String, dynamic>))
          .toList(),
      creatorId: (json['creatorId'] as String?) ?? '',
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
