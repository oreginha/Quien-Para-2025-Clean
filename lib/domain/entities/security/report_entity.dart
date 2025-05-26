// lib/domain/entities/security/report_entity.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_entity.freezed.dart';
part 'report_entity.g.dart';

@freezed
class ReportEntity with _$ReportEntity {
  const factory ReportEntity({
    required String id,
    required String reporterId,
    required String reportedUserId,
    String? reportedPlanId,
    required ReportType type,
    required ReportReason reason,
    required String description,
    required DateTime createdAt,
    @Default(ReportStatus.pending) ReportStatus status,
    String? moderatorId,
    String? moderatorNotes,
    DateTime? resolvedAt,
    Map<String, dynamic>? evidence,
  }) = _ReportEntity;

  factory ReportEntity.fromJson(Map<String, dynamic> json) =>
      _$ReportEntityFromJson(json);

  /// Convierte la entidad a JSON
  // La función toJson es generada automáticamente por Freezed/JsonSerializable.
}

enum ReportType { user, plan, content }

enum ReportReason {
  inappropriateContent,
  harassment,
  spam,
  fakeProfile,
  dangerousActivity,
  copyrightViolation,
  other,
}

enum ReportStatus { pending, underReview, resolved, dismissed }

extension ReportReasonExtension on ReportReason {
  String get displayName {
    switch (this) {
      case ReportReason.inappropriateContent:
        return 'Contenido inapropiado';
      case ReportReason.harassment:
        return 'Acoso o intimidación';
      case ReportReason.spam:
        return 'Spam o contenido no deseado';
      case ReportReason.fakeProfile:
        return 'Perfil falso';
      case ReportReason.dangerousActivity:
        return 'Actividad peligrosa';
      case ReportReason.copyrightViolation:
        return 'Violación de derechos de autor';
      case ReportReason.other:
        return 'Otro motivo';
    }
  }

  String get priority {
    switch (this) {
      case ReportReason.dangerousActivity:
      case ReportReason.harassment:
        return 'high';
      case ReportReason.inappropriateContent:
      case ReportReason.fakeProfile:
        return 'medium';
      default:
        return 'low';
    }
  }
}
