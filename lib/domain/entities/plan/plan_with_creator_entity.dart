// lib/domain/entities/plan_with_creator_entity.dart

import 'package:quien_para/domain/entities/plan/plan_entity.dart';

/// Entidad que combina plan con su creador para optimizar consultas
class PlanWithCreatorEntity {
  final PlanEntity plan;
  final Map<String, dynamic>? creatorData;

  PlanWithCreatorEntity({required this.plan, this.creatorData});

  /// Factory para crear una lista de planes con creador desde un mapa
  static List<PlanWithCreatorEntity> fromPlansAndCreators(
    List<PlanEntity> plans,
    Map<String, Map<String, dynamic>> creatorsMap,
  ) {
    return plans.map((plan) {
      final creatorData = creatorsMap[plan.creatorId];
      return PlanWithCreatorEntity(plan: plan, creatorData: creatorData);
    }).toList();
  }

  // Métodos de ayuda para acceder a datos comunes del creador
  String? get creatorName => creatorData?['name'] as String?;
  String? get creatorPhotoUrl => creatorData?['photoUrl'] as String?;
  String? get creatorUsername => creatorData?['username'] as String?;
}
