// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewEntityImpl _$$ReviewEntityImplFromJson(Map<String, dynamic> json) =>
    _$ReviewEntityImpl(
      id: json['id'] as String,
      reviewerId: json['reviewerId'] as String,
      reviewedUserId: json['reviewedUserId'] as String,
      planId: json['planId'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      type: $enumDecode(_$ReviewTypeEnumMap, json['type']),
      status: $enumDecode(_$ReviewStatusEnumMap, json['status']),
      response: json['response'] as String?,
      responseDate: json['responseDate'] == null
          ? null
          : DateTime.parse(json['responseDate'] as String),
      helpfulCount: (json['helpfulCount'] as num?)?.toInt() ?? 0,
      helpfulVotes: (json['helpfulVotes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isVerified: json['isVerified'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ReviewEntityImplToJson(_$ReviewEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reviewerId': instance.reviewerId,
      'reviewedUserId': instance.reviewedUserId,
      'planId': instance.planId,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
      'type': _$ReviewTypeEnumMap[instance.type]!,
      'status': _$ReviewStatusEnumMap[instance.status]!,
      'response': instance.response,
      'responseDate': instance.responseDate?.toIso8601String(),
      'helpfulCount': instance.helpfulCount,
      'helpfulVotes': instance.helpfulVotes,
      'isVerified': instance.isVerified,
      'metadata': instance.metadata,
    };

const _$ReviewTypeEnumMap = {
  ReviewType.organizer: 'organizer',
  ReviewType.attendee: 'attendee',
  ReviewType.general: 'general',
};

const _$ReviewStatusEnumMap = {
  ReviewStatus.pending: 'pending',
  ReviewStatus.approved: 'approved',
  ReviewStatus.rejected: 'rejected',
  ReviewStatus.flagged: 'flagged',
};

_$UserRatingEntityImpl _$$UserRatingEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$UserRatingEntityImpl(
      userId: json['userId'] as String,
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: (json['totalReviews'] as num).toInt(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      totalPlansOrganized: (json['totalPlansOrganized'] as num?)?.toInt() ?? 0,
      totalPlansAttended: (json['totalPlansAttended'] as num?)?.toInt() ?? 0,
      reliabilityScore: (json['reliabilityScore'] as num?)?.toInt() ?? 0,
      ratingDistribution:
          (json['ratingDistribution'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      categoryRatings: (json['categoryRatings'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      topPositiveComments: (json['topPositiveComments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      commonConcerns: (json['commonConcerns'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$UserRatingEntityImplToJson(
        _$UserRatingEntityImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'averageRating': instance.averageRating,
      'totalReviews': instance.totalReviews,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'totalPlansOrganized': instance.totalPlansOrganized,
      'totalPlansAttended': instance.totalPlansAttended,
      'reliabilityScore': instance.reliabilityScore,
      'ratingDistribution': instance.ratingDistribution,
      'categoryRatings': instance.categoryRatings,
      'topPositiveComments': instance.topPositiveComments,
      'commonConcerns': instance.commonConcerns,
    };
