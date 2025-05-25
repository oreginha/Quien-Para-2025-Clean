// lib/domain/usecases/plan/load_suggested_plan_usecase.dart

// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:quien_para/data/repositories/plan/plan_repository_impl.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';

/// Caso de uso para cargar un plan sugerido desde datos externos
class LoadSuggestedPlanUseCase {
  final PlanRepositoryImpl _planRepository;

  LoadSuggestedPlanUseCase(this._planRepository);

  /// Ejecuta el caso de uso: crea un objeto PlanEntity a partir de datos sugeridos
  ///
  /// Parámetros:
  /// - creatorId: ID del usuario que creará el plan
  /// - suggestedData: Datos sugeridos para el plan
  Future<PlanEntity> execute({
    required String creatorId,
    required Map<String, dynamic> suggestedData,
  }) async {
    try {
      if (kDebugMode) {
        print(
            'LoadSuggestedPlanUseCase: Cargando plan sugerido para usuario: $creatorId');
      }

      // Crear un PlanEntity con los datos sugeridos
      final PlanEntity suggestedPlan = PlanEntity(
        id: suggestedData['id'] as String? ??
            '', // Puede ser vacío para un plan nuevo
        creatorId: creatorId,
        title: suggestedData['title'] as String? ?? '',
        description: suggestedData['description'] as String? ?? '',
        location: suggestedData['location'] as String? ?? '',
        date: suggestedData['date'] != null
            ? (suggestedData['date'] is Timestamp
                ? (suggestedData['date'] as Timestamp).toDate()
                : suggestedData['date'] as DateTime)
            : null,
        category: suggestedData['category'] as String? ?? '',
        imageUrl: suggestedData['imageUrl'] as String? ?? '',
        conditions: suggestedData['conditions'] != null
            ? Map<String, String>.from(
                suggestedData['conditions'] as Map<dynamic, dynamic>)
            : <String, String>{},
        selectedThemes: suggestedData['selectedThemes'] != null
            ? List<String>.from(
                suggestedData['selectedThemes'] as List<dynamic>)
            : <String>[],
        tags: [], likes: 0, extraConditions: '',
      );

      if (kDebugMode) {
        print(
            'LoadSuggestedPlanUseCase: Plan sugerido cargado: ${suggestedPlan.title}');
      }

      return suggestedPlan;
    } catch (e) {
      if (kDebugMode) {
        print('LoadSuggestedPlanUseCase: Error al cargar plan sugerido: $e');
      }
      throw Exception('Error al cargar plan sugerido: $e');
    }
  }
}
