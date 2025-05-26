// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApplicationModelImpl _$$ApplicationModelImplFromJson(
  Map<String, dynamic> json,
) => _$ApplicationModelImpl(
  id: json['id'] as String,
  planId: json['planId'] as String,
  applicantId: json['applicantId'] as String,
  status: json['status'] as String,
  appliedAt: DateTime.parse(json['appliedAt'] as String),
  message: json['message'] as String?,
  processedAt: json['processedAt'] == null
      ? null
      : DateTime.parse(json['processedAt'] as String),
  planTitle: json['planTitle'] as String?,
  planImageUrl: json['planImageUrl'] as String?,
  applicantName: json['applicantName'] as String?,
  applicantPhotoUrl: json['applicantPhotoUrl'] as String?,
  responsibleMessage: json['responsibleMessage'] as String?,
);

Map<String, dynamic> _$$ApplicationModelImplToJson(
  _$ApplicationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'planId': instance.planId,
  'applicantId': instance.applicantId,
  'status': instance.status,
  'appliedAt': instance.appliedAt.toIso8601String(),
  'message': instance.message,
  'processedAt': instance.processedAt?.toIso8601String(),
  'planTitle': instance.planTitle,
  'planImageUrl': instance.planImageUrl,
  'applicantName': instance.applicantName,
  'applicantPhotoUrl': instance.applicantPhotoUrl,
  'responsibleMessage': instance.responsibleMessage,
};
