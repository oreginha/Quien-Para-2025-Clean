import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/review/review_entity.dart';

part 'review_event.freezed.dart';

@freezed
class ReviewEvent with _$ReviewEvent {
  // ==================== CREAR RESEÑA ====================

  const factory ReviewEvent.createReview({
    required String reviewerId,
    required String reviewedUserId,
    required String planId,
    required double rating,
    required String comment,
    required ReviewType type,
    String? planTitle,
    DateTime? planDate,
    String? reviewerRole,
  }) = CreateReviewEvent;

  // ==================== OBTENER RESEÑAS ====================

  const factory ReviewEvent.getUserReviews({
    required String userId,
    ReviewType? type,
    int? limit,
    bool? refresh,
  }) = GetUserReviewsEvent;

  const factory ReviewEvent.getPlanReviews({
    required String planId,
    int? limit,
    bool? refresh,
  }) = GetPlanReviewsEvent;

  const factory ReviewEvent.getReviewsByUser({
    required String reviewerId,
    int? limit,
    bool? refresh,
  }) = GetReviewsByUserEvent;

  const factory ReviewEvent.loadMoreUserReviews({
    required String userId,
    ReviewType? type,
  }) = LoadMoreUserReviewsEvent;

  const factory ReviewEvent.loadMorePlanReviews({required String planId}) =
      LoadMorePlanReviewsEvent;

  const factory ReviewEvent.loadMoreReviewsByUser({
    required String reviewerId,
  }) = LoadMoreReviewsByUserEvent;

  // ==================== ACCIONES DE RESEÑA ====================

  const factory ReviewEvent.updateReview({required ReviewEntity review}) =
      UpdateReviewEvent;

  const factory ReviewEvent.deleteReview({required String reviewId}) =
      DeleteReviewEvent;

  const factory ReviewEvent.markReviewAsHelpful({
    required String reviewId,
    required String userId,
  }) = MarkReviewAsHelpfulEvent;

  const factory ReviewEvent.unmarkReviewAsHelpful({
    required String reviewId,
    required String userId,
  }) = UnmarkReviewAsHelpfulEvent;

  // ==================== RATING DE USUARIO ====================

  const factory ReviewEvent.getUserRating({required String userId}) =
      GetUserRatingEvent;

  const factory ReviewEvent.calculateUserRating({
    required String userId,
    double? newRating,
    ReviewType? reviewType,
    bool? forceRecalculation,
  }) = CalculateUserRatingEvent;

  const factory ReviewEvent.getTopRatedUsers({ReviewType? type, int? limit}) =
      GetTopRatedUsersEvent;

  // ==================== MODERACIÓN ====================

  const factory ReviewEvent.getPendingReviews({int? limit, bool? refresh}) =
      GetPendingReviewsEvent;

  const factory ReviewEvent.approveReview({required String reviewId}) =
      ApproveReviewEvent;

  const factory ReviewEvent.rejectReview({
    required String reviewId,
    required String reason,
  }) = RejectReviewEvent;

  const factory ReviewEvent.flagReview({
    required String reviewId,
    required String reason,
  }) = FlagReviewEvent;

  // ==================== ANALYTICS ====================

  const factory ReviewEvent.getReviewMetrics() = GetReviewMetricsEvent;

  const factory ReviewEvent.getRatingDistribution() =
      GetRatingDistributionEvent;

  const factory ReviewEvent.getReviewTrends({
    required DateTime startDate,
    required DateTime endDate,
  }) = GetReviewTrendsEvent;

  // ==================== UTILIDADES ====================

  const factory ReviewEvent.checkCanUserReviewPlan({
    required String userId,
    required String planId,
    required String targetUserId,
  }) = CheckCanUserReviewPlanEvent;

  const factory ReviewEvent.compareUserRatings({
    required List<String> userIds,
  }) = CompareUserRatingsEvent;

  const factory ReviewEvent.resetState() = ResetStateEvent;

  const factory ReviewEvent.clearError() = ClearErrorEvent;
}
