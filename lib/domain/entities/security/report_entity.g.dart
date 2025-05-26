// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportEntityImpl _$$ReportEntityImplFromJson(Map<String, dynamic> json) =>
    _$ReportEntityImpl(
      id: json['id'] as String,
      reporterId: json['reporterId'] as String,
      reportedUserId: json['reportedUserId'] as String,
      reportedPlanId: json['reportedPlanId'] as String?,
      type: $enumDecode(_$ReportTypeEnumMap, json['type']),
      reason: $enumDecode(_$ReportReasonEnumMap, json['reason']),
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status:
          $enumDecodeNullable(_$ReportStatusEnumMap, json['status']) ??
          ReportStatus.pending,
      moderatorId: json['moderatorId'] as String?,
      moderatorNotes: json['moderatorNotes'] as String?,
      resolvedAt: json['resolvedAt'] == null
          ? null
          : DateTime.parse(json['resolvedAt'] as String),
      evidence: json['evidence'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ReportEntityImplToJson(_$ReportEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reporterId': instance.reporterId,
      'reportedUserId': instance.reportedUserId,
      'reportedPlanId': instance.reportedPlanId,
      'type': _$ReportTypeEnumMap[instance.type]!,
      'reason': _$ReportReasonEnumMap[instance.reason]!,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': _$ReportStatusEnumMap[instance.status]!,
      'moderatorId': instance.moderatorId,
      'moderatorNotes': instance.moderatorNotes,
      'resolvedAt': instance.resolvedAt?.toIso8601String(),
      'evidence': instance.evidence,
    };

const _$ReportTypeEnumMap = {
  ReportType.user: 'user',
  ReportType.plan: 'plan',
  ReportType.content: 'content',
};

const _$ReportReasonEnumMap = {
  ReportReason.inappropriateContent: 'inappropriateContent',
  ReportReason.harassment: 'harassment',
  ReportReason.spam: 'spam',
  ReportReason.fakeProfile: 'fakeProfile',
  ReportReason.dangerousActivity: 'dangerousActivity',
  ReportReason.copyrightViolation: 'copyrightViolation',
  ReportReason.other: 'other',
};

const _$ReportStatusEnumMap = {
  ReportStatus.pending: 'pending',
  ReportStatus.underReview: 'underReview',
  ReportStatus.resolved: 'resolved',
  ReportStatus.dismissed: 'dismissed',
};
