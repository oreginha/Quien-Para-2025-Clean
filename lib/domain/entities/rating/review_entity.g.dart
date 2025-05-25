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
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      helpfulVotes: (json['helpfulVotes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      reviewerName: json['reviewerName'] as String?,
      reviewerProfileImage: json['reviewerProfileImage'] as String?,
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
      'isAnonymous': instance.isAnonymous,
      'helpfulVotes': instance.helpfulVotes,
      'reviewerName': instance.reviewerName,
      'reviewerProfileImage': instance.reviewerProfileImage,
    };

_$UserRatingEntityImpl _$$UserRatingEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$UserRatingEntityImpl(
      userId: json['userId'] as String,
      averageRating: (json['averageRating'] as num).toDouble(),
      totalReviews: (json['totalReviews'] as num).toInt(),
      ratingDistribution:
          (json['ratingDistribution'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), (e as num).toInt()),
      ),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$UserRatingEntityImplToJson(
        _$UserRatingEntityImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'averageRating': instance.averageRating,
      'totalReviews': instance.totalReviews,
      'ratingDistribution':
          instance.ratingDistribution.map((k, e) => MapEntry(k.toString(), e)),
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };
