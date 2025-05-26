// lib/presentation/widgets/cards/plan_card.dart
import 'package:flutter/material.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/presentation/widgets/common/cards/plan_card_types/my_application_card.dart';
import 'package:quien_para/presentation/widgets/common/cards/plan_card_types/my_plan_card.dart';
import 'package:quien_para/presentation/widgets/common/cards/plan_card_types/other_user_plan_card.dart';
import 'package:quien_para/presentation/widgets/common/cards/plan_card_types/plan_card_utils.dart';

enum PlanCardType {
  /// Para mostrar planes creados por otros usuarios
  otherUserPlan,

  /// Para mostrar planes creados por el usuario actual
  myPlan,

  /// Para mostrar planes a los que el usuario se ha postulado
  myApplication,
}

/// Widget reutilizable para mostrar tarjetas de planes
///
/// Se adapta según el tipo de tarjeta que se requiera mostrar.
class PlanCard extends StatelessWidget {
  /// Datos del plan a mostrar
  final dynamic planData;

  /// ID del plan
  final String planId;

  /// Tipo de tarjeta
  final PlanCardType cardType;

  /// Callback para cuando se presiona el botón de cancelar aplicación
  final Function(String)? onCancelApplication;

  /// ID de aplicación (solo si es una tarjeta de tipo aplicación)
  final String? applicationId;

  /// Status de la aplicación (solo si es una tarjeta de tipo aplicación)
  final String? applicationStatus;

  /// Mensaje de la aplicación (solo si es una tarjeta de tipo aplicación)
  final String? applicationMessage;

  /// Fecha de aplicación (solo si es una tarjeta de tipo aplicación)
  final DateTime? appliedAt;

  /// Callback para cuando se presiona el botón de eliminar plan (solo para planes propios)
  final Function(String, String)? onDeletePlan;

  /// Datos del usuario creador del plan (cuando ya se tienen)
  final Map<String, dynamic>? creatorData;

  const PlanCard({
    super.key,
    required this.planData,
    required this.planId,
    required this.cardType,
    this.onCancelApplication,
    this.applicationId,
    this.applicationStatus,
    this.applicationMessage,
    this.appliedAt,
    this.onDeletePlan,
    this.creatorData,
  });

  @override
  Widget build(BuildContext context) {
    // Determinar si estamos trabajando con un PlanEntity o un Map<String, dynamic>
    final bool isEntityType = planData is PlanEntity;

    // Extraer datos comunes
    final String title = isEntityType
        ? (planData as PlanEntity).title
        : (planData['title'] as String? ?? 'Sin título');

    final String description = isEntityType
        ? (planData as PlanEntity).description
        : (planData['description'] as String? ?? 'Sin descripción');

    final String location = isEntityType
        ? (planData as PlanEntity).location
        : (planData['location'] as String? ?? 'Ubicación no especificada');

    final String category = isEntityType
        ? (planData as PlanEntity).category
        : (planData['category'] as String? ?? '');

    final String imageUrl = isEntityType
        ? (planData as PlanEntity).imageUrl
        : (planData['imageUrl'] as String? ?? '');

    final String creatorId = isEntityType
        ? (planData as PlanEntity).creatorId
        : (planData['creatorId'] as String? ?? '');

    final DateTime? date = isEntityType
        ? (planData as PlanEntity).date
        : PlanCardUtils.parseDate(planData['date']);

    // Construir la tarjeta según el tipo
    switch (cardType) {
      case PlanCardType.myApplication:
        return MyApplicationCard(
          title: title,
          description: description,
          location: location,
          imageUrl: imageUrl,
          category: category,
          date: date,
          planId: planId,
          applicationId: applicationId,
          applicationStatus: applicationStatus,
          applicationMessage: applicationMessage,
          appliedAt: appliedAt,
          onCancelApplication: onCancelApplication,
        );
      case PlanCardType.myPlan:
        return MyPlanCard(
          title: title,
          description: description,
          imageUrl: imageUrl,
          date: date,
          planId: planId,
          onDeletePlan: onDeletePlan,
        );
      case PlanCardType.otherUserPlan:
        return OtherUserPlanCard(
          title: title,
          description: description,
          location: location,
          imageUrl: imageUrl,
          date: date,
          planId: planId,
          creatorId: creatorId,
          creatorData: creatorData,
        );
    }
  }
}
