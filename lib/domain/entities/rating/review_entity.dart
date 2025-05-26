import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_entity.freezed.dart';
part 'review_entity.g.dart';

@freezed
class ReviewEntity with _$ReviewEntity {
  const factory ReviewEntity({
    required String id,
    required String reviewerId,
    required String reviewedUserId,
    required String planId,
    required double rating, // 1.0 - 5.0
    required String comment,
    required DateTime createdAt,
    @Default(false) bool isAnonymous,
    @Default([]) List<String> helpfulVotes,
    String? reviewerName,
    String? reviewerProfileImage,
  }) = _ReviewEntity;

  factory ReviewEntity.fromJson(Map<String, dynamic> json) =>
      _$ReviewEntityFromJson(json);

  factory ReviewEntity.empty() => ReviewEntity(
    id: '',
    reviewerId: '',
    reviewedUserId: '',
    planId: '',
    rating: 0.0,
    comment: '',
    createdAt: DateTime.now(),
  );
}

@freezed
class UserRatingEntity with _$UserRatingEntity {
  const factory UserRatingEntity({
    required String userId,
    required double averageRating,
    required int totalReviews,
    required Map<int, int> ratingDistribution, // star -> count
    required DateTime lastUpdated,
  }) = _UserRatingEntity;

  factory UserRatingEntity.fromJson(Map<String, dynamic> json) =>
      _$UserRatingEntityFromJson(json);

  factory UserRatingEntity.empty() => UserRatingEntity(
    userId: '',
    averageRating: 0.0,
    totalReviews: 0,
    ratingDistribution: const {},
    lastUpdated: DateTime.fromMillisecondsSinceEpoch(0),
  );
}
