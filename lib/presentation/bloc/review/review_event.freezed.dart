// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ReviewEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewEventCopyWith<$Res> {
  factory $ReviewEventCopyWith(
    ReviewEvent value,
    $Res Function(ReviewEvent) then,
  ) = _$ReviewEventCopyWithImpl<$Res, ReviewEvent>;
}

/// @nodoc
class _$ReviewEventCopyWithImpl<$Res, $Val extends ReviewEvent>
    implements $ReviewEventCopyWith<$Res> {
  _$ReviewEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CreateReviewEventImplCopyWith<$Res> {
  factory _$$CreateReviewEventImplCopyWith(
    _$CreateReviewEventImpl value,
    $Res Function(_$CreateReviewEventImpl) then,
  ) = __$$CreateReviewEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String reviewerId,
    String reviewedUserId,
    String planId,
    double rating,
    String comment,
    ReviewType type,
    String? planTitle,
    DateTime? planDate,
    String? reviewerRole,
  });
}

/// @nodoc
class __$$CreateReviewEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$CreateReviewEventImpl>
    implements _$$CreateReviewEventImplCopyWith<$Res> {
  __$$CreateReviewEventImplCopyWithImpl(
    _$CreateReviewEventImpl _value,
    $Res Function(_$CreateReviewEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reviewerId = null,
    Object? reviewedUserId = null,
    Object? planId = null,
    Object? rating = null,
    Object? comment = null,
    Object? type = null,
    Object? planTitle = freezed,
    Object? planDate = freezed,
    Object? reviewerRole = freezed,
  }) {
    return _then(
      _$CreateReviewEventImpl(
        reviewerId: null == reviewerId
            ? _value.reviewerId
            : reviewerId // ignore: cast_nullable_to_non_nullable
                  as String,
        reviewedUserId: null == reviewedUserId
            ? _value.reviewedUserId
            : reviewedUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        planId: null == planId
            ? _value.planId
            : planId // ignore: cast_nullable_to_non_nullable
                  as String,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        comment: null == comment
            ? _value.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ReviewType,
        planTitle: freezed == planTitle
            ? _value.planTitle
            : planTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        planDate: freezed == planDate
            ? _value.planDate
            : planDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reviewerRole: freezed == reviewerRole
            ? _value.reviewerRole
            : reviewerRole // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CreateReviewEventImpl implements CreateReviewEvent {
  const _$CreateReviewEventImpl({
    required this.reviewerId,
    required this.reviewedUserId,
    required this.planId,
    required this.rating,
    required this.comment,
    required this.type,
    this.planTitle,
    this.planDate,
    this.reviewerRole,
  });

  @override
  final String reviewerId;
  @override
  final String reviewedUserId;
  @override
  final String planId;
  @override
  final double rating;
  @override
  final String comment;
  @override
  final ReviewType type;
  @override
  final String? planTitle;
  @override
  final DateTime? planDate;
  @override
  final String? reviewerRole;

  @override
  String toString() {
    return 'ReviewEvent.createReview(reviewerId: $reviewerId, reviewedUserId: $reviewedUserId, planId: $planId, rating: $rating, comment: $comment, type: $type, planTitle: $planTitle, planDate: $planDate, reviewerRole: $reviewerRole)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateReviewEventImpl &&
            (identical(other.reviewerId, reviewerId) ||
                other.reviewerId == reviewerId) &&
            (identical(other.reviewedUserId, reviewedUserId) ||
                other.reviewedUserId == reviewedUserId) &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.planTitle, planTitle) ||
                other.planTitle == planTitle) &&
            (identical(other.planDate, planDate) ||
                other.planDate == planDate) &&
            (identical(other.reviewerRole, reviewerRole) ||
                other.reviewerRole == reviewerRole));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    reviewerId,
    reviewedUserId,
    planId,
    rating,
    comment,
    type,
    planTitle,
    planDate,
    reviewerRole,
  );

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateReviewEventImplCopyWith<_$CreateReviewEventImpl> get copyWith =>
      __$$CreateReviewEventImplCopyWithImpl<_$CreateReviewEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return createReview(
      reviewerId,
      reviewedUserId,
      planId,
      rating,
      comment,
      type,
      planTitle,
      planDate,
      reviewerRole,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return createReview?.call(
      reviewerId,
      reviewedUserId,
      planId,
      rating,
      comment,
      type,
      planTitle,
      planDate,
      reviewerRole,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (createReview != null) {
      return createReview(
        reviewerId,
        reviewedUserId,
        planId,
        rating,
        comment,
        type,
        planTitle,
        planDate,
        reviewerRole,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return createReview(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return createReview?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (createReview != null) {
      return createReview(this);
    }
    return orElse();
  }
}

abstract class CreateReviewEvent implements ReviewEvent {
  const factory CreateReviewEvent({
    required final String reviewerId,
    required final String reviewedUserId,
    required final String planId,
    required final double rating,
    required final String comment,
    required final ReviewType type,
    final String? planTitle,
    final DateTime? planDate,
    final String? reviewerRole,
  }) = _$CreateReviewEventImpl;

  String get reviewerId;
  String get reviewedUserId;
  String get planId;
  double get rating;
  String get comment;
  ReviewType get type;
  String? get planTitle;
  DateTime? get planDate;
  String? get reviewerRole;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateReviewEventImplCopyWith<_$CreateReviewEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GetUserReviewsEventImplCopyWith<$Res> {
  factory _$$GetUserReviewsEventImplCopyWith(
    _$GetUserReviewsEventImpl value,
    $Res Function(_$GetUserReviewsEventImpl) then,
  ) = __$$GetUserReviewsEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId, ReviewType? type, int? limit, bool? refresh});
}

/// @nodoc
class __$$GetUserReviewsEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$GetUserReviewsEventImpl>
    implements _$$GetUserReviewsEventImplCopyWith<$Res> {
  __$$GetUserReviewsEventImplCopyWithImpl(
    _$GetUserReviewsEventImpl _value,
    $Res Function(_$GetUserReviewsEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? type = freezed,
    Object? limit = freezed,
    Object? refresh = freezed,
  }) {
    return _then(
      _$GetUserReviewsEventImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ReviewType?,
        limit: freezed == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        refresh: freezed == refresh
            ? _value.refresh
            : refresh // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc

class _$GetUserReviewsEventImpl implements GetUserReviewsEvent {
  const _$GetUserReviewsEventImpl({
    required this.userId,
    this.type,
    this.limit,
    this.refresh,
  });

  @override
  final String userId;
  @override
  final ReviewType? type;
  @override
  final int? limit;
  @override
  final bool? refresh;

  @override
  String toString() {
    return 'ReviewEvent.getUserReviews(userId: $userId, type: $type, limit: $limit, refresh: $refresh)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUserReviewsEventImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.refresh, refresh) || other.refresh == refresh));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, type, limit, refresh);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetUserReviewsEventImplCopyWith<_$GetUserReviewsEventImpl> get copyWith =>
      __$$GetUserReviewsEventImplCopyWithImpl<_$GetUserReviewsEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return getUserReviews(userId, type, limit, refresh);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return getUserReviews?.call(userId, type, limit, refresh);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (getUserReviews != null) {
      return getUserReviews(userId, type, limit, refresh);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return getUserReviews(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return getUserReviews?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (getUserReviews != null) {
      return getUserReviews(this);
    }
    return orElse();
  }
}

abstract class GetUserReviewsEvent implements ReviewEvent {
  const factory GetUserReviewsEvent({
    required final String userId,
    final ReviewType? type,
    final int? limit,
    final bool? refresh,
  }) = _$GetUserReviewsEventImpl;

  String get userId;
  ReviewType? get type;
  int? get limit;
  bool? get refresh;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetUserReviewsEventImplCopyWith<_$GetUserReviewsEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GetPlanReviewsEventImplCopyWith<$Res> {
  factory _$$GetPlanReviewsEventImplCopyWith(
    _$GetPlanReviewsEventImpl value,
    $Res Function(_$GetPlanReviewsEventImpl) then,
  ) = __$$GetPlanReviewsEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String planId, int? limit, bool? refresh});
}

/// @nodoc
class __$$GetPlanReviewsEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$GetPlanReviewsEventImpl>
    implements _$$GetPlanReviewsEventImplCopyWith<$Res> {
  __$$GetPlanReviewsEventImplCopyWithImpl(
    _$GetPlanReviewsEventImpl _value,
    $Res Function(_$GetPlanReviewsEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? planId = null,
    Object? limit = freezed,
    Object? refresh = freezed,
  }) {
    return _then(
      _$GetPlanReviewsEventImpl(
        planId: null == planId
            ? _value.planId
            : planId // ignore: cast_nullable_to_non_nullable
                  as String,
        limit: freezed == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        refresh: freezed == refresh
            ? _value.refresh
            : refresh // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc

class _$GetPlanReviewsEventImpl implements GetPlanReviewsEvent {
  const _$GetPlanReviewsEventImpl({
    required this.planId,
    this.limit,
    this.refresh,
  });

  @override
  final String planId;
  @override
  final int? limit;
  @override
  final bool? refresh;

  @override
  String toString() {
    return 'ReviewEvent.getPlanReviews(planId: $planId, limit: $limit, refresh: $refresh)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetPlanReviewsEventImpl &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.refresh, refresh) || other.refresh == refresh));
  }

  @override
  int get hashCode => Object.hash(runtimeType, planId, limit, refresh);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetPlanReviewsEventImplCopyWith<_$GetPlanReviewsEventImpl> get copyWith =>
      __$$GetPlanReviewsEventImplCopyWithImpl<_$GetPlanReviewsEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return getPlanReviews(planId, limit, refresh);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return getPlanReviews?.call(planId, limit, refresh);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (getPlanReviews != null) {
      return getPlanReviews(planId, limit, refresh);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return getPlanReviews(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return getPlanReviews?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (getPlanReviews != null) {
      return getPlanReviews(this);
    }
    return orElse();
  }
}

abstract class GetPlanReviewsEvent implements ReviewEvent {
  const factory GetPlanReviewsEvent({
    required final String planId,
    final int? limit,
    final bool? refresh,
  }) = _$GetPlanReviewsEventImpl;

  String get planId;
  int? get limit;
  bool? get refresh;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetPlanReviewsEventImplCopyWith<_$GetPlanReviewsEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GetReviewsByUserEventImplCopyWith<$Res> {
  factory _$$GetReviewsByUserEventImplCopyWith(
    _$GetReviewsByUserEventImpl value,
    $Res Function(_$GetReviewsByUserEventImpl) then,
  ) = __$$GetReviewsByUserEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String reviewerId, int? limit, bool? refresh});
}

/// @nodoc
class __$$GetReviewsByUserEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$GetReviewsByUserEventImpl>
    implements _$$GetReviewsByUserEventImplCopyWith<$Res> {
  __$$GetReviewsByUserEventImplCopyWithImpl(
    _$GetReviewsByUserEventImpl _value,
    $Res Function(_$GetReviewsByUserEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reviewerId = null,
    Object? limit = freezed,
    Object? refresh = freezed,
  }) {
    return _then(
      _$GetReviewsByUserEventImpl(
        reviewerId: null == reviewerId
            ? _value.reviewerId
            : reviewerId // ignore: cast_nullable_to_non_nullable
                  as String,
        limit: freezed == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        refresh: freezed == refresh
            ? _value.refresh
            : refresh // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc

class _$GetReviewsByUserEventImpl implements GetReviewsByUserEvent {
  const _$GetReviewsByUserEventImpl({
    required this.reviewerId,
    this.limit,
    this.refresh,
  });

  @override
  final String reviewerId;
  @override
  final int? limit;
  @override
  final bool? refresh;

  @override
  String toString() {
    return 'ReviewEvent.getReviewsByUser(reviewerId: $reviewerId, limit: $limit, refresh: $refresh)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetReviewsByUserEventImpl &&
            (identical(other.reviewerId, reviewerId) ||
                other.reviewerId == reviewerId) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.refresh, refresh) || other.refresh == refresh));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reviewerId, limit, refresh);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetReviewsByUserEventImplCopyWith<_$GetReviewsByUserEventImpl>
  get copyWith =>
      __$$GetReviewsByUserEventImplCopyWithImpl<_$GetReviewsByUserEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return getReviewsByUser(reviewerId, limit, refresh);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return getReviewsByUser?.call(reviewerId, limit, refresh);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (getReviewsByUser != null) {
      return getReviewsByUser(reviewerId, limit, refresh);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return getReviewsByUser(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return getReviewsByUser?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (getReviewsByUser != null) {
      return getReviewsByUser(this);
    }
    return orElse();
  }
}

abstract class GetReviewsByUserEvent implements ReviewEvent {
  const factory GetReviewsByUserEvent({
    required final String reviewerId,
    final int? limit,
    final bool? refresh,
  }) = _$GetReviewsByUserEventImpl;

  String get reviewerId;
  int? get limit;
  bool? get refresh;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetReviewsByUserEventImplCopyWith<_$GetReviewsByUserEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadMoreUserReviewsEventImplCopyWith<$Res> {
  factory _$$LoadMoreUserReviewsEventImplCopyWith(
    _$LoadMoreUserReviewsEventImpl value,
    $Res Function(_$LoadMoreUserReviewsEventImpl) then,
  ) = __$$LoadMoreUserReviewsEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId, ReviewType? type});
}

/// @nodoc
class __$$LoadMoreUserReviewsEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$LoadMoreUserReviewsEventImpl>
    implements _$$LoadMoreUserReviewsEventImplCopyWith<$Res> {
  __$$LoadMoreUserReviewsEventImplCopyWithImpl(
    _$LoadMoreUserReviewsEventImpl _value,
    $Res Function(_$LoadMoreUserReviewsEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userId = null, Object? type = freezed}) {
    return _then(
      _$LoadMoreUserReviewsEventImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ReviewType?,
      ),
    );
  }
}

/// @nodoc

class _$LoadMoreUserReviewsEventImpl implements LoadMoreUserReviewsEvent {
  const _$LoadMoreUserReviewsEventImpl({required this.userId, this.type});

  @override
  final String userId;
  @override
  final ReviewType? type;

  @override
  String toString() {
    return 'ReviewEvent.loadMoreUserReviews(userId: $userId, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadMoreUserReviewsEventImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, type);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadMoreUserReviewsEventImplCopyWith<_$LoadMoreUserReviewsEventImpl>
  get copyWith =>
      __$$LoadMoreUserReviewsEventImplCopyWithImpl<
        _$LoadMoreUserReviewsEventImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return loadMoreUserReviews(userId, type);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return loadMoreUserReviews?.call(userId, type);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (loadMoreUserReviews != null) {
      return loadMoreUserReviews(userId, type);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return loadMoreUserReviews(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return loadMoreUserReviews?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (loadMoreUserReviews != null) {
      return loadMoreUserReviews(this);
    }
    return orElse();
  }
}

abstract class LoadMoreUserReviewsEvent implements ReviewEvent {
  const factory LoadMoreUserReviewsEvent({
    required final String userId,
    final ReviewType? type,
  }) = _$LoadMoreUserReviewsEventImpl;

  String get userId;
  ReviewType? get type;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadMoreUserReviewsEventImplCopyWith<_$LoadMoreUserReviewsEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadMorePlanReviewsEventImplCopyWith<$Res> {
  factory _$$LoadMorePlanReviewsEventImplCopyWith(
    _$LoadMorePlanReviewsEventImpl value,
    $Res Function(_$LoadMorePlanReviewsEventImpl) then,
  ) = __$$LoadMorePlanReviewsEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String planId});
}

/// @nodoc
class __$$LoadMorePlanReviewsEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$LoadMorePlanReviewsEventImpl>
    implements _$$LoadMorePlanReviewsEventImplCopyWith<$Res> {
  __$$LoadMorePlanReviewsEventImplCopyWithImpl(
    _$LoadMorePlanReviewsEventImpl _value,
    $Res Function(_$LoadMorePlanReviewsEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? planId = null}) {
    return _then(
      _$LoadMorePlanReviewsEventImpl(
        planId: null == planId
            ? _value.planId
            : planId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$LoadMorePlanReviewsEventImpl implements LoadMorePlanReviewsEvent {
  const _$LoadMorePlanReviewsEventImpl({required this.planId});

  @override
  final String planId;

  @override
  String toString() {
    return 'ReviewEvent.loadMorePlanReviews(planId: $planId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadMorePlanReviewsEventImpl &&
            (identical(other.planId, planId) || other.planId == planId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, planId);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadMorePlanReviewsEventImplCopyWith<_$LoadMorePlanReviewsEventImpl>
  get copyWith =>
      __$$LoadMorePlanReviewsEventImplCopyWithImpl<
        _$LoadMorePlanReviewsEventImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return loadMorePlanReviews(planId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return loadMorePlanReviews?.call(planId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (loadMorePlanReviews != null) {
      return loadMorePlanReviews(planId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return loadMorePlanReviews(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return loadMorePlanReviews?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (loadMorePlanReviews != null) {
      return loadMorePlanReviews(this);
    }
    return orElse();
  }
}

abstract class LoadMorePlanReviewsEvent implements ReviewEvent {
  const factory LoadMorePlanReviewsEvent({required final String planId}) =
      _$LoadMorePlanReviewsEventImpl;

  String get planId;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadMorePlanReviewsEventImplCopyWith<_$LoadMorePlanReviewsEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadMoreReviewsByUserEventImplCopyWith<$Res> {
  factory _$$LoadMoreReviewsByUserEventImplCopyWith(
    _$LoadMoreReviewsByUserEventImpl value,
    $Res Function(_$LoadMoreReviewsByUserEventImpl) then,
  ) = __$$LoadMoreReviewsByUserEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String reviewerId});
}

/// @nodoc
class __$$LoadMoreReviewsByUserEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$LoadMoreReviewsByUserEventImpl>
    implements _$$LoadMoreReviewsByUserEventImplCopyWith<$Res> {
  __$$LoadMoreReviewsByUserEventImplCopyWithImpl(
    _$LoadMoreReviewsByUserEventImpl _value,
    $Res Function(_$LoadMoreReviewsByUserEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reviewerId = null}) {
    return _then(
      _$LoadMoreReviewsByUserEventImpl(
        reviewerId: null == reviewerId
            ? _value.reviewerId
            : reviewerId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$LoadMoreReviewsByUserEventImpl implements LoadMoreReviewsByUserEvent {
  const _$LoadMoreReviewsByUserEventImpl({required this.reviewerId});

  @override
  final String reviewerId;

  @override
  String toString() {
    return 'ReviewEvent.loadMoreReviewsByUser(reviewerId: $reviewerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadMoreReviewsByUserEventImpl &&
            (identical(other.reviewerId, reviewerId) ||
                other.reviewerId == reviewerId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reviewerId);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadMoreReviewsByUserEventImplCopyWith<_$LoadMoreReviewsByUserEventImpl>
  get copyWith =>
      __$$LoadMoreReviewsByUserEventImplCopyWithImpl<
        _$LoadMoreReviewsByUserEventImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return loadMoreReviewsByUser(reviewerId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return loadMoreReviewsByUser?.call(reviewerId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (loadMoreReviewsByUser != null) {
      return loadMoreReviewsByUser(reviewerId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return loadMoreReviewsByUser(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return loadMoreReviewsByUser?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (loadMoreReviewsByUser != null) {
      return loadMoreReviewsByUser(this);
    }
    return orElse();
  }
}

abstract class LoadMoreReviewsByUserEvent implements ReviewEvent {
  const factory LoadMoreReviewsByUserEvent({required final String reviewerId}) =
      _$LoadMoreReviewsByUserEventImpl;

  String get reviewerId;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadMoreReviewsByUserEventImplCopyWith<_$LoadMoreReviewsByUserEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateReviewEventImplCopyWith<$Res> {
  factory _$$UpdateReviewEventImplCopyWith(
    _$UpdateReviewEventImpl value,
    $Res Function(_$UpdateReviewEventImpl) then,
  ) = __$$UpdateReviewEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ReviewEntity review});

  $ReviewEntityCopyWith<$Res> get review;
}

/// @nodoc
class __$$UpdateReviewEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$UpdateReviewEventImpl>
    implements _$$UpdateReviewEventImplCopyWith<$Res> {
  __$$UpdateReviewEventImplCopyWithImpl(
    _$UpdateReviewEventImpl _value,
    $Res Function(_$UpdateReviewEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? review = null}) {
    return _then(
      _$UpdateReviewEventImpl(
        review: null == review
            ? _value.review
            : review // ignore: cast_nullable_to_non_nullable
                  as ReviewEntity,
      ),
    );
  }

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReviewEntityCopyWith<$Res> get review {
    return $ReviewEntityCopyWith<$Res>(_value.review, (value) {
      return _then(_value.copyWith(review: value));
    });
  }
}

/// @nodoc

class _$UpdateReviewEventImpl implements UpdateReviewEvent {
  const _$UpdateReviewEventImpl({required this.review});

  @override
  final ReviewEntity review;

  @override
  String toString() {
    return 'ReviewEvent.updateReview(review: $review)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateReviewEventImpl &&
            (identical(other.review, review) || other.review == review));
  }

  @override
  int get hashCode => Object.hash(runtimeType, review);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateReviewEventImplCopyWith<_$UpdateReviewEventImpl> get copyWith =>
      __$$UpdateReviewEventImplCopyWithImpl<_$UpdateReviewEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return updateReview(review);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return updateReview?.call(review);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (updateReview != null) {
      return updateReview(review);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return updateReview(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return updateReview?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (updateReview != null) {
      return updateReview(this);
    }
    return orElse();
  }
}

abstract class UpdateReviewEvent implements ReviewEvent {
  const factory UpdateReviewEvent({required final ReviewEntity review}) =
      _$UpdateReviewEventImpl;

  ReviewEntity get review;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateReviewEventImplCopyWith<_$UpdateReviewEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeleteReviewEventImplCopyWith<$Res> {
  factory _$$DeleteReviewEventImplCopyWith(
    _$DeleteReviewEventImpl value,
    $Res Function(_$DeleteReviewEventImpl) then,
  ) = __$$DeleteReviewEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String reviewId});
}

/// @nodoc
class __$$DeleteReviewEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$DeleteReviewEventImpl>
    implements _$$DeleteReviewEventImplCopyWith<$Res> {
  __$$DeleteReviewEventImplCopyWithImpl(
    _$DeleteReviewEventImpl _value,
    $Res Function(_$DeleteReviewEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reviewId = null}) {
    return _then(
      _$DeleteReviewEventImpl(
        reviewId: null == reviewId
            ? _value.reviewId
            : reviewId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$DeleteReviewEventImpl implements DeleteReviewEvent {
  const _$DeleteReviewEventImpl({required this.reviewId});

  @override
  final String reviewId;

  @override
  String toString() {
    return 'ReviewEvent.deleteReview(reviewId: $reviewId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteReviewEventImpl &&
            (identical(other.reviewId, reviewId) ||
                other.reviewId == reviewId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reviewId);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteReviewEventImplCopyWith<_$DeleteReviewEventImpl> get copyWith =>
      __$$DeleteReviewEventImplCopyWithImpl<_$DeleteReviewEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return deleteReview(reviewId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return deleteReview?.call(reviewId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (deleteReview != null) {
      return deleteReview(reviewId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return deleteReview(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return deleteReview?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (deleteReview != null) {
      return deleteReview(this);
    }
    return orElse();
  }
}

abstract class DeleteReviewEvent implements ReviewEvent {
  const factory DeleteReviewEvent({required final String reviewId}) =
      _$DeleteReviewEventImpl;

  String get reviewId;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteReviewEventImplCopyWith<_$DeleteReviewEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MarkReviewAsHelpfulEventImplCopyWith<$Res> {
  factory _$$MarkReviewAsHelpfulEventImplCopyWith(
    _$MarkReviewAsHelpfulEventImpl value,
    $Res Function(_$MarkReviewAsHelpfulEventImpl) then,
  ) = __$$MarkReviewAsHelpfulEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String reviewId, String userId});
}

/// @nodoc
class __$$MarkReviewAsHelpfulEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$MarkReviewAsHelpfulEventImpl>
    implements _$$MarkReviewAsHelpfulEventImplCopyWith<$Res> {
  __$$MarkReviewAsHelpfulEventImplCopyWithImpl(
    _$MarkReviewAsHelpfulEventImpl _value,
    $Res Function(_$MarkReviewAsHelpfulEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reviewId = null, Object? userId = null}) {
    return _then(
      _$MarkReviewAsHelpfulEventImpl(
        reviewId: null == reviewId
            ? _value.reviewId
            : reviewId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$MarkReviewAsHelpfulEventImpl implements MarkReviewAsHelpfulEvent {
  const _$MarkReviewAsHelpfulEventImpl({
    required this.reviewId,
    required this.userId,
  });

  @override
  final String reviewId;
  @override
  final String userId;

  @override
  String toString() {
    return 'ReviewEvent.markReviewAsHelpful(reviewId: $reviewId, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarkReviewAsHelpfulEventImpl &&
            (identical(other.reviewId, reviewId) ||
                other.reviewId == reviewId) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reviewId, userId);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarkReviewAsHelpfulEventImplCopyWith<_$MarkReviewAsHelpfulEventImpl>
  get copyWith =>
      __$$MarkReviewAsHelpfulEventImplCopyWithImpl<
        _$MarkReviewAsHelpfulEventImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return markReviewAsHelpful(reviewId, userId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return markReviewAsHelpful?.call(reviewId, userId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (markReviewAsHelpful != null) {
      return markReviewAsHelpful(reviewId, userId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return markReviewAsHelpful(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return markReviewAsHelpful?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (markReviewAsHelpful != null) {
      return markReviewAsHelpful(this);
    }
    return orElse();
  }
}

abstract class MarkReviewAsHelpfulEvent implements ReviewEvent {
  const factory MarkReviewAsHelpfulEvent({
    required final String reviewId,
    required final String userId,
  }) = _$MarkReviewAsHelpfulEventImpl;

  String get reviewId;
  String get userId;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarkReviewAsHelpfulEventImplCopyWith<_$MarkReviewAsHelpfulEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnmarkReviewAsHelpfulEventImplCopyWith<$Res> {
  factory _$$UnmarkReviewAsHelpfulEventImplCopyWith(
    _$UnmarkReviewAsHelpfulEventImpl value,
    $Res Function(_$UnmarkReviewAsHelpfulEventImpl) then,
  ) = __$$UnmarkReviewAsHelpfulEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String reviewId, String userId});
}

/// @nodoc
class __$$UnmarkReviewAsHelpfulEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$UnmarkReviewAsHelpfulEventImpl>
    implements _$$UnmarkReviewAsHelpfulEventImplCopyWith<$Res> {
  __$$UnmarkReviewAsHelpfulEventImplCopyWithImpl(
    _$UnmarkReviewAsHelpfulEventImpl _value,
    $Res Function(_$UnmarkReviewAsHelpfulEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reviewId = null, Object? userId = null}) {
    return _then(
      _$UnmarkReviewAsHelpfulEventImpl(
        reviewId: null == reviewId
            ? _value.reviewId
            : reviewId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UnmarkReviewAsHelpfulEventImpl implements UnmarkReviewAsHelpfulEvent {
  const _$UnmarkReviewAsHelpfulEventImpl({
    required this.reviewId,
    required this.userId,
  });

  @override
  final String reviewId;
  @override
  final String userId;

  @override
  String toString() {
    return 'ReviewEvent.unmarkReviewAsHelpful(reviewId: $reviewId, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnmarkReviewAsHelpfulEventImpl &&
            (identical(other.reviewId, reviewId) ||
                other.reviewId == reviewId) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reviewId, userId);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnmarkReviewAsHelpfulEventImplCopyWith<_$UnmarkReviewAsHelpfulEventImpl>
  get copyWith =>
      __$$UnmarkReviewAsHelpfulEventImplCopyWithImpl<
        _$UnmarkReviewAsHelpfulEventImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return unmarkReviewAsHelpful(reviewId, userId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return unmarkReviewAsHelpful?.call(reviewId, userId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (unmarkReviewAsHelpful != null) {
      return unmarkReviewAsHelpful(reviewId, userId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return unmarkReviewAsHelpful(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return unmarkReviewAsHelpful?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (unmarkReviewAsHelpful != null) {
      return unmarkReviewAsHelpful(this);
    }
    return orElse();
  }
}

abstract class UnmarkReviewAsHelpfulEvent implements ReviewEvent {
  const factory UnmarkReviewAsHelpfulEvent({
    required final String reviewId,
    required final String userId,
  }) = _$UnmarkReviewAsHelpfulEventImpl;

  String get reviewId;
  String get userId;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnmarkReviewAsHelpfulEventImplCopyWith<_$UnmarkReviewAsHelpfulEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GetUserRatingEventImplCopyWith<$Res> {
  factory _$$GetUserRatingEventImplCopyWith(
    _$GetUserRatingEventImpl value,
    $Res Function(_$GetUserRatingEventImpl) then,
  ) = __$$GetUserRatingEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId});
}

/// @nodoc
class __$$GetUserRatingEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$GetUserRatingEventImpl>
    implements _$$GetUserRatingEventImplCopyWith<$Res> {
  __$$GetUserRatingEventImplCopyWithImpl(
    _$GetUserRatingEventImpl _value,
    $Res Function(_$GetUserRatingEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userId = null}) {
    return _then(
      _$GetUserRatingEventImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$GetUserRatingEventImpl implements GetUserRatingEvent {
  const _$GetUserRatingEventImpl({required this.userId});

  @override
  final String userId;

  @override
  String toString() {
    return 'ReviewEvent.getUserRating(userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUserRatingEventImpl &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetUserRatingEventImplCopyWith<_$GetUserRatingEventImpl> get copyWith =>
      __$$GetUserRatingEventImplCopyWithImpl<_$GetUserRatingEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return getUserRating(userId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return getUserRating?.call(userId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (getUserRating != null) {
      return getUserRating(userId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return getUserRating(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return getUserRating?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (getUserRating != null) {
      return getUserRating(this);
    }
    return orElse();
  }
}

abstract class GetUserRatingEvent implements ReviewEvent {
  const factory GetUserRatingEvent({required final String userId}) =
      _$GetUserRatingEventImpl;

  String get userId;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetUserRatingEventImplCopyWith<_$GetUserRatingEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CalculateUserRatingEventImplCopyWith<$Res> {
  factory _$$CalculateUserRatingEventImplCopyWith(
    _$CalculateUserRatingEventImpl value,
    $Res Function(_$CalculateUserRatingEventImpl) then,
  ) = __$$CalculateUserRatingEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String userId,
    double? newRating,
    ReviewType? reviewType,
    bool? forceRecalculation,
  });
}

/// @nodoc
class __$$CalculateUserRatingEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$CalculateUserRatingEventImpl>
    implements _$$CalculateUserRatingEventImplCopyWith<$Res> {
  __$$CalculateUserRatingEventImplCopyWithImpl(
    _$CalculateUserRatingEventImpl _value,
    $Res Function(_$CalculateUserRatingEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? newRating = freezed,
    Object? reviewType = freezed,
    Object? forceRecalculation = freezed,
  }) {
    return _then(
      _$CalculateUserRatingEventImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        newRating: freezed == newRating
            ? _value.newRating
            : newRating // ignore: cast_nullable_to_non_nullable
                  as double?,
        reviewType: freezed == reviewType
            ? _value.reviewType
            : reviewType // ignore: cast_nullable_to_non_nullable
                  as ReviewType?,
        forceRecalculation: freezed == forceRecalculation
            ? _value.forceRecalculation
            : forceRecalculation // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc

class _$CalculateUserRatingEventImpl implements CalculateUserRatingEvent {
  const _$CalculateUserRatingEventImpl({
    required this.userId,
    this.newRating,
    this.reviewType,
    this.forceRecalculation,
  });

  @override
  final String userId;
  @override
  final double? newRating;
  @override
  final ReviewType? reviewType;
  @override
  final bool? forceRecalculation;

  @override
  String toString() {
    return 'ReviewEvent.calculateUserRating(userId: $userId, newRating: $newRating, reviewType: $reviewType, forceRecalculation: $forceRecalculation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalculateUserRatingEventImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.newRating, newRating) ||
                other.newRating == newRating) &&
            (identical(other.reviewType, reviewType) ||
                other.reviewType == reviewType) &&
            (identical(other.forceRecalculation, forceRecalculation) ||
                other.forceRecalculation == forceRecalculation));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    newRating,
    reviewType,
    forceRecalculation,
  );

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalculateUserRatingEventImplCopyWith<_$CalculateUserRatingEventImpl>
  get copyWith =>
      __$$CalculateUserRatingEventImplCopyWithImpl<
        _$CalculateUserRatingEventImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return calculateUserRating(
      userId,
      newRating,
      reviewType,
      forceRecalculation,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return calculateUserRating?.call(
      userId,
      newRating,
      reviewType,
      forceRecalculation,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (calculateUserRating != null) {
      return calculateUserRating(
        userId,
        newRating,
        reviewType,
        forceRecalculation,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return calculateUserRating(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return calculateUserRating?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (calculateUserRating != null) {
      return calculateUserRating(this);
    }
    return orElse();
  }
}

abstract class CalculateUserRatingEvent implements ReviewEvent {
  const factory CalculateUserRatingEvent({
    required final String userId,
    final double? newRating,
    final ReviewType? reviewType,
    final bool? forceRecalculation,
  }) = _$CalculateUserRatingEventImpl;

  String get userId;
  double? get newRating;
  ReviewType? get reviewType;
  bool? get forceRecalculation;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalculateUserRatingEventImplCopyWith<_$CalculateUserRatingEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GetTopRatedUsersEventImplCopyWith<$Res> {
  factory _$$GetTopRatedUsersEventImplCopyWith(
    _$GetTopRatedUsersEventImpl value,
    $Res Function(_$GetTopRatedUsersEventImpl) then,
  ) = __$$GetTopRatedUsersEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ReviewType? type, int? limit});
}

/// @nodoc
class __$$GetTopRatedUsersEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$GetTopRatedUsersEventImpl>
    implements _$$GetTopRatedUsersEventImplCopyWith<$Res> {
  __$$GetTopRatedUsersEventImplCopyWithImpl(
    _$GetTopRatedUsersEventImpl _value,
    $Res Function(_$GetTopRatedUsersEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = freezed, Object? limit = freezed}) {
    return _then(
      _$GetTopRatedUsersEventImpl(
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ReviewType?,
        limit: freezed == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$GetTopRatedUsersEventImpl implements GetTopRatedUsersEvent {
  const _$GetTopRatedUsersEventImpl({this.type, this.limit});

  @override
  final ReviewType? type;
  @override
  final int? limit;

  @override
  String toString() {
    return 'ReviewEvent.getTopRatedUsers(type: $type, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetTopRatedUsersEventImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, limit);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetTopRatedUsersEventImplCopyWith<_$GetTopRatedUsersEventImpl>
  get copyWith =>
      __$$GetTopRatedUsersEventImplCopyWithImpl<_$GetTopRatedUsersEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return getTopRatedUsers(type, limit);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return getTopRatedUsers?.call(type, limit);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (getTopRatedUsers != null) {
      return getTopRatedUsers(type, limit);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return getTopRatedUsers(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return getTopRatedUsers?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (getTopRatedUsers != null) {
      return getTopRatedUsers(this);
    }
    return orElse();
  }
}

abstract class GetTopRatedUsersEvent implements ReviewEvent {
  const factory GetTopRatedUsersEvent({
    final ReviewType? type,
    final int? limit,
  }) = _$GetTopRatedUsersEventImpl;

  ReviewType? get type;
  int? get limit;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetTopRatedUsersEventImplCopyWith<_$GetTopRatedUsersEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GetPendingReviewsEventImplCopyWith<$Res> {
  factory _$$GetPendingReviewsEventImplCopyWith(
    _$GetPendingReviewsEventImpl value,
    $Res Function(_$GetPendingReviewsEventImpl) then,
  ) = __$$GetPendingReviewsEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int? limit, bool? refresh});
}

/// @nodoc
class __$$GetPendingReviewsEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$GetPendingReviewsEventImpl>
    implements _$$GetPendingReviewsEventImplCopyWith<$Res> {
  __$$GetPendingReviewsEventImplCopyWithImpl(
    _$GetPendingReviewsEventImpl _value,
    $Res Function(_$GetPendingReviewsEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? limit = freezed, Object? refresh = freezed}) {
    return _then(
      _$GetPendingReviewsEventImpl(
        limit: freezed == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        refresh: freezed == refresh
            ? _value.refresh
            : refresh // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc

class _$GetPendingReviewsEventImpl implements GetPendingReviewsEvent {
  const _$GetPendingReviewsEventImpl({this.limit, this.refresh});

  @override
  final int? limit;
  @override
  final bool? refresh;

  @override
  String toString() {
    return 'ReviewEvent.getPendingReviews(limit: $limit, refresh: $refresh)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetPendingReviewsEventImpl &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.refresh, refresh) || other.refresh == refresh));
  }

  @override
  int get hashCode => Object.hash(runtimeType, limit, refresh);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetPendingReviewsEventImplCopyWith<_$GetPendingReviewsEventImpl>
  get copyWith =>
      __$$GetPendingReviewsEventImplCopyWithImpl<_$GetPendingReviewsEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return getPendingReviews(limit, refresh);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return getPendingReviews?.call(limit, refresh);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (getPendingReviews != null) {
      return getPendingReviews(limit, refresh);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return getPendingReviews(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return getPendingReviews?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (getPendingReviews != null) {
      return getPendingReviews(this);
    }
    return orElse();
  }
}

abstract class GetPendingReviewsEvent implements ReviewEvent {
  const factory GetPendingReviewsEvent({
    final int? limit,
    final bool? refresh,
  }) = _$GetPendingReviewsEventImpl;

  int? get limit;
  bool? get refresh;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetPendingReviewsEventImplCopyWith<_$GetPendingReviewsEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ApproveReviewEventImplCopyWith<$Res> {
  factory _$$ApproveReviewEventImplCopyWith(
    _$ApproveReviewEventImpl value,
    $Res Function(_$ApproveReviewEventImpl) then,
  ) = __$$ApproveReviewEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String reviewId});
}

/// @nodoc
class __$$ApproveReviewEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$ApproveReviewEventImpl>
    implements _$$ApproveReviewEventImplCopyWith<$Res> {
  __$$ApproveReviewEventImplCopyWithImpl(
    _$ApproveReviewEventImpl _value,
    $Res Function(_$ApproveReviewEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reviewId = null}) {
    return _then(
      _$ApproveReviewEventImpl(
        reviewId: null == reviewId
            ? _value.reviewId
            : reviewId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ApproveReviewEventImpl implements ApproveReviewEvent {
  const _$ApproveReviewEventImpl({required this.reviewId});

  @override
  final String reviewId;

  @override
  String toString() {
    return 'ReviewEvent.approveReview(reviewId: $reviewId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApproveReviewEventImpl &&
            (identical(other.reviewId, reviewId) ||
                other.reviewId == reviewId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reviewId);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApproveReviewEventImplCopyWith<_$ApproveReviewEventImpl> get copyWith =>
      __$$ApproveReviewEventImplCopyWithImpl<_$ApproveReviewEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return approveReview(reviewId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return approveReview?.call(reviewId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (approveReview != null) {
      return approveReview(reviewId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return approveReview(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return approveReview?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (approveReview != null) {
      return approveReview(this);
    }
    return orElse();
  }
}

abstract class ApproveReviewEvent implements ReviewEvent {
  const factory ApproveReviewEvent({required final String reviewId}) =
      _$ApproveReviewEventImpl;

  String get reviewId;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApproveReviewEventImplCopyWith<_$ApproveReviewEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RejectReviewEventImplCopyWith<$Res> {
  factory _$$RejectReviewEventImplCopyWith(
    _$RejectReviewEventImpl value,
    $Res Function(_$RejectReviewEventImpl) then,
  ) = __$$RejectReviewEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String reviewId, String reason});
}

/// @nodoc
class __$$RejectReviewEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$RejectReviewEventImpl>
    implements _$$RejectReviewEventImplCopyWith<$Res> {
  __$$RejectReviewEventImplCopyWithImpl(
    _$RejectReviewEventImpl _value,
    $Res Function(_$RejectReviewEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reviewId = null, Object? reason = null}) {
    return _then(
      _$RejectReviewEventImpl(
        reviewId: null == reviewId
            ? _value.reviewId
            : reviewId // ignore: cast_nullable_to_non_nullable
                  as String,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$RejectReviewEventImpl implements RejectReviewEvent {
  const _$RejectReviewEventImpl({required this.reviewId, required this.reason});

  @override
  final String reviewId;
  @override
  final String reason;

  @override
  String toString() {
    return 'ReviewEvent.rejectReview(reviewId: $reviewId, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RejectReviewEventImpl &&
            (identical(other.reviewId, reviewId) ||
                other.reviewId == reviewId) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reviewId, reason);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RejectReviewEventImplCopyWith<_$RejectReviewEventImpl> get copyWith =>
      __$$RejectReviewEventImplCopyWithImpl<_$RejectReviewEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return rejectReview(reviewId, reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return rejectReview?.call(reviewId, reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (rejectReview != null) {
      return rejectReview(reviewId, reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return rejectReview(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return rejectReview?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (rejectReview != null) {
      return rejectReview(this);
    }
    return orElse();
  }
}

abstract class RejectReviewEvent implements ReviewEvent {
  const factory RejectReviewEvent({
    required final String reviewId,
    required final String reason,
  }) = _$RejectReviewEventImpl;

  String get reviewId;
  String get reason;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RejectReviewEventImplCopyWith<_$RejectReviewEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FlagReviewEventImplCopyWith<$Res> {
  factory _$$FlagReviewEventImplCopyWith(
    _$FlagReviewEventImpl value,
    $Res Function(_$FlagReviewEventImpl) then,
  ) = __$$FlagReviewEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String reviewId, String reason});
}

/// @nodoc
class __$$FlagReviewEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$FlagReviewEventImpl>
    implements _$$FlagReviewEventImplCopyWith<$Res> {
  __$$FlagReviewEventImplCopyWithImpl(
    _$FlagReviewEventImpl _value,
    $Res Function(_$FlagReviewEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reviewId = null, Object? reason = null}) {
    return _then(
      _$FlagReviewEventImpl(
        reviewId: null == reviewId
            ? _value.reviewId
            : reviewId // ignore: cast_nullable_to_non_nullable
                  as String,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$FlagReviewEventImpl implements FlagReviewEvent {
  const _$FlagReviewEventImpl({required this.reviewId, required this.reason});

  @override
  final String reviewId;
  @override
  final String reason;

  @override
  String toString() {
    return 'ReviewEvent.flagReview(reviewId: $reviewId, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlagReviewEventImpl &&
            (identical(other.reviewId, reviewId) ||
                other.reviewId == reviewId) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reviewId, reason);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlagReviewEventImplCopyWith<_$FlagReviewEventImpl> get copyWith =>
      __$$FlagReviewEventImplCopyWithImpl<_$FlagReviewEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return flagReview(reviewId, reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return flagReview?.call(reviewId, reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (flagReview != null) {
      return flagReview(reviewId, reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return flagReview(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return flagReview?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (flagReview != null) {
      return flagReview(this);
    }
    return orElse();
  }
}

abstract class FlagReviewEvent implements ReviewEvent {
  const factory FlagReviewEvent({
    required final String reviewId,
    required final String reason,
  }) = _$FlagReviewEventImpl;

  String get reviewId;
  String get reason;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlagReviewEventImplCopyWith<_$FlagReviewEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GetReviewMetricsEventImplCopyWith<$Res> {
  factory _$$GetReviewMetricsEventImplCopyWith(
    _$GetReviewMetricsEventImpl value,
    $Res Function(_$GetReviewMetricsEventImpl) then,
  ) = __$$GetReviewMetricsEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GetReviewMetricsEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$GetReviewMetricsEventImpl>
    implements _$$GetReviewMetricsEventImplCopyWith<$Res> {
  __$$GetReviewMetricsEventImplCopyWithImpl(
    _$GetReviewMetricsEventImpl _value,
    $Res Function(_$GetReviewMetricsEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GetReviewMetricsEventImpl implements GetReviewMetricsEvent {
  const _$GetReviewMetricsEventImpl();

  @override
  String toString() {
    return 'ReviewEvent.getReviewMetrics()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetReviewMetricsEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return getReviewMetrics();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return getReviewMetrics?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (getReviewMetrics != null) {
      return getReviewMetrics();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return getReviewMetrics(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return getReviewMetrics?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (getReviewMetrics != null) {
      return getReviewMetrics(this);
    }
    return orElse();
  }
}

abstract class GetReviewMetricsEvent implements ReviewEvent {
  const factory GetReviewMetricsEvent() = _$GetReviewMetricsEventImpl;
}

/// @nodoc
abstract class _$$GetRatingDistributionEventImplCopyWith<$Res> {
  factory _$$GetRatingDistributionEventImplCopyWith(
    _$GetRatingDistributionEventImpl value,
    $Res Function(_$GetRatingDistributionEventImpl) then,
  ) = __$$GetRatingDistributionEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GetRatingDistributionEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$GetRatingDistributionEventImpl>
    implements _$$GetRatingDistributionEventImplCopyWith<$Res> {
  __$$GetRatingDistributionEventImplCopyWithImpl(
    _$GetRatingDistributionEventImpl _value,
    $Res Function(_$GetRatingDistributionEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GetRatingDistributionEventImpl implements GetRatingDistributionEvent {
  const _$GetRatingDistributionEventImpl();

  @override
  String toString() {
    return 'ReviewEvent.getRatingDistribution()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetRatingDistributionEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return getRatingDistribution();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return getRatingDistribution?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (getRatingDistribution != null) {
      return getRatingDistribution();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return getRatingDistribution(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return getRatingDistribution?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (getRatingDistribution != null) {
      return getRatingDistribution(this);
    }
    return orElse();
  }
}

abstract class GetRatingDistributionEvent implements ReviewEvent {
  const factory GetRatingDistributionEvent() = _$GetRatingDistributionEventImpl;
}

/// @nodoc
abstract class _$$GetReviewTrendsEventImplCopyWith<$Res> {
  factory _$$GetReviewTrendsEventImplCopyWith(
    _$GetReviewTrendsEventImpl value,
    $Res Function(_$GetReviewTrendsEventImpl) then,
  ) = __$$GetReviewTrendsEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DateTime startDate, DateTime endDate});
}

/// @nodoc
class __$$GetReviewTrendsEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$GetReviewTrendsEventImpl>
    implements _$$GetReviewTrendsEventImplCopyWith<$Res> {
  __$$GetReviewTrendsEventImplCopyWithImpl(
    _$GetReviewTrendsEventImpl _value,
    $Res Function(_$GetReviewTrendsEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? startDate = null, Object? endDate = null}) {
    return _then(
      _$GetReviewTrendsEventImpl(
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$GetReviewTrendsEventImpl implements GetReviewTrendsEvent {
  const _$GetReviewTrendsEventImpl({
    required this.startDate,
    required this.endDate,
  });

  @override
  final DateTime startDate;
  @override
  final DateTime endDate;

  @override
  String toString() {
    return 'ReviewEvent.getReviewTrends(startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetReviewTrendsEventImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, startDate, endDate);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GetReviewTrendsEventImplCopyWith<_$GetReviewTrendsEventImpl>
  get copyWith =>
      __$$GetReviewTrendsEventImplCopyWithImpl<_$GetReviewTrendsEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return getReviewTrends(startDate, endDate);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return getReviewTrends?.call(startDate, endDate);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (getReviewTrends != null) {
      return getReviewTrends(startDate, endDate);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return getReviewTrends(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return getReviewTrends?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (getReviewTrends != null) {
      return getReviewTrends(this);
    }
    return orElse();
  }
}

abstract class GetReviewTrendsEvent implements ReviewEvent {
  const factory GetReviewTrendsEvent({
    required final DateTime startDate,
    required final DateTime endDate,
  }) = _$GetReviewTrendsEventImpl;

  DateTime get startDate;
  DateTime get endDate;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GetReviewTrendsEventImplCopyWith<_$GetReviewTrendsEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CheckCanUserReviewPlanEventImplCopyWith<$Res> {
  factory _$$CheckCanUserReviewPlanEventImplCopyWith(
    _$CheckCanUserReviewPlanEventImpl value,
    $Res Function(_$CheckCanUserReviewPlanEventImpl) then,
  ) = __$$CheckCanUserReviewPlanEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId, String planId, String targetUserId});
}

/// @nodoc
class __$$CheckCanUserReviewPlanEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$CheckCanUserReviewPlanEventImpl>
    implements _$$CheckCanUserReviewPlanEventImplCopyWith<$Res> {
  __$$CheckCanUserReviewPlanEventImplCopyWithImpl(
    _$CheckCanUserReviewPlanEventImpl _value,
    $Res Function(_$CheckCanUserReviewPlanEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? planId = null,
    Object? targetUserId = null,
  }) {
    return _then(
      _$CheckCanUserReviewPlanEventImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        planId: null == planId
            ? _value.planId
            : planId // ignore: cast_nullable_to_non_nullable
                  as String,
        targetUserId: null == targetUserId
            ? _value.targetUserId
            : targetUserId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$CheckCanUserReviewPlanEventImpl implements CheckCanUserReviewPlanEvent {
  const _$CheckCanUserReviewPlanEventImpl({
    required this.userId,
    required this.planId,
    required this.targetUserId,
  });

  @override
  final String userId;
  @override
  final String planId;
  @override
  final String targetUserId;

  @override
  String toString() {
    return 'ReviewEvent.checkCanUserReviewPlan(userId: $userId, planId: $planId, targetUserId: $targetUserId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckCanUserReviewPlanEventImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.targetUserId, targetUserId) ||
                other.targetUserId == targetUserId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, planId, targetUserId);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckCanUserReviewPlanEventImplCopyWith<_$CheckCanUserReviewPlanEventImpl>
  get copyWith =>
      __$$CheckCanUserReviewPlanEventImplCopyWithImpl<
        _$CheckCanUserReviewPlanEventImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return checkCanUserReviewPlan(userId, planId, targetUserId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return checkCanUserReviewPlan?.call(userId, planId, targetUserId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (checkCanUserReviewPlan != null) {
      return checkCanUserReviewPlan(userId, planId, targetUserId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return checkCanUserReviewPlan(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return checkCanUserReviewPlan?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (checkCanUserReviewPlan != null) {
      return checkCanUserReviewPlan(this);
    }
    return orElse();
  }
}

abstract class CheckCanUserReviewPlanEvent implements ReviewEvent {
  const factory CheckCanUserReviewPlanEvent({
    required final String userId,
    required final String planId,
    required final String targetUserId,
  }) = _$CheckCanUserReviewPlanEventImpl;

  String get userId;
  String get planId;
  String get targetUserId;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckCanUserReviewPlanEventImplCopyWith<_$CheckCanUserReviewPlanEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CompareUserRatingsEventImplCopyWith<$Res> {
  factory _$$CompareUserRatingsEventImplCopyWith(
    _$CompareUserRatingsEventImpl value,
    $Res Function(_$CompareUserRatingsEventImpl) then,
  ) = __$$CompareUserRatingsEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<String> userIds});
}

/// @nodoc
class __$$CompareUserRatingsEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$CompareUserRatingsEventImpl>
    implements _$$CompareUserRatingsEventImplCopyWith<$Res> {
  __$$CompareUserRatingsEventImplCopyWithImpl(
    _$CompareUserRatingsEventImpl _value,
    $Res Function(_$CompareUserRatingsEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userIds = null}) {
    return _then(
      _$CompareUserRatingsEventImpl(
        userIds: null == userIds
            ? _value._userIds
            : userIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc

class _$CompareUserRatingsEventImpl implements CompareUserRatingsEvent {
  const _$CompareUserRatingsEventImpl({required final List<String> userIds})
    : _userIds = userIds;

  final List<String> _userIds;
  @override
  List<String> get userIds {
    if (_userIds is EqualUnmodifiableListView) return _userIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userIds);
  }

  @override
  String toString() {
    return 'ReviewEvent.compareUserRatings(userIds: $userIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompareUserRatingsEventImpl &&
            const DeepCollectionEquality().equals(other._userIds, _userIds));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_userIds));

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompareUserRatingsEventImplCopyWith<_$CompareUserRatingsEventImpl>
  get copyWith =>
      __$$CompareUserRatingsEventImplCopyWithImpl<
        _$CompareUserRatingsEventImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return compareUserRatings(userIds);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return compareUserRatings?.call(userIds);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (compareUserRatings != null) {
      return compareUserRatings(userIds);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return compareUserRatings(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return compareUserRatings?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (compareUserRatings != null) {
      return compareUserRatings(this);
    }
    return orElse();
  }
}

abstract class CompareUserRatingsEvent implements ReviewEvent {
  const factory CompareUserRatingsEvent({required final List<String> userIds}) =
      _$CompareUserRatingsEventImpl;

  List<String> get userIds;

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompareUserRatingsEventImplCopyWith<_$CompareUserRatingsEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ResetStateEventImplCopyWith<$Res> {
  factory _$$ResetStateEventImplCopyWith(
    _$ResetStateEventImpl value,
    $Res Function(_$ResetStateEventImpl) then,
  ) = __$$ResetStateEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ResetStateEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$ResetStateEventImpl>
    implements _$$ResetStateEventImplCopyWith<$Res> {
  __$$ResetStateEventImplCopyWithImpl(
    _$ResetStateEventImpl _value,
    $Res Function(_$ResetStateEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ResetStateEventImpl implements ResetStateEvent {
  const _$ResetStateEventImpl();

  @override
  String toString() {
    return 'ReviewEvent.resetState()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ResetStateEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return resetState();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return resetState?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (resetState != null) {
      return resetState();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return resetState(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return resetState?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (resetState != null) {
      return resetState(this);
    }
    return orElse();
  }
}

abstract class ResetStateEvent implements ReviewEvent {
  const factory ResetStateEvent() = _$ResetStateEventImpl;
}

/// @nodoc
abstract class _$$ClearErrorEventImplCopyWith<$Res> {
  factory _$$ClearErrorEventImplCopyWith(
    _$ClearErrorEventImpl value,
    $Res Function(_$ClearErrorEventImpl) then,
  ) = __$$ClearErrorEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearErrorEventImplCopyWithImpl<$Res>
    extends _$ReviewEventCopyWithImpl<$Res, _$ClearErrorEventImpl>
    implements _$$ClearErrorEventImplCopyWith<$Res> {
  __$$ClearErrorEventImplCopyWithImpl(
    _$ClearErrorEventImpl _value,
    $Res Function(_$ClearErrorEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ClearErrorEventImpl implements ClearErrorEvent {
  const _$ClearErrorEventImpl();

  @override
  String toString() {
    return 'ReviewEvent.clearError()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClearErrorEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )
    createReview,
    required TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )
    getUserReviews,
    required TResult Function(String planId, int? limit, bool? refresh)
    getPlanReviews,
    required TResult Function(String reviewerId, int? limit, bool? refresh)
    getReviewsByUser,
    required TResult Function(String userId, ReviewType? type)
    loadMoreUserReviews,
    required TResult Function(String planId) loadMorePlanReviews,
    required TResult Function(String reviewerId) loadMoreReviewsByUser,
    required TResult Function(ReviewEntity review) updateReview,
    required TResult Function(String reviewId) deleteReview,
    required TResult Function(String reviewId, String userId)
    markReviewAsHelpful,
    required TResult Function(String reviewId, String userId)
    unmarkReviewAsHelpful,
    required TResult Function(String userId) getUserRating,
    required TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )
    calculateUserRating,
    required TResult Function(ReviewType? type, int? limit) getTopRatedUsers,
    required TResult Function(int? limit, bool? refresh) getPendingReviews,
    required TResult Function(String reviewId) approveReview,
    required TResult Function(String reviewId, String reason) rejectReview,
    required TResult Function(String reviewId, String reason) flagReview,
    required TResult Function() getReviewMetrics,
    required TResult Function() getRatingDistribution,
    required TResult Function(DateTime startDate, DateTime endDate)
    getReviewTrends,
    required TResult Function(String userId, String planId, String targetUserId)
    checkCanUserReviewPlan,
    required TResult Function(List<String> userIds) compareUserRatings,
    required TResult Function() resetState,
    required TResult Function() clearError,
  }) {
    return clearError();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult? Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult? Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult? Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult? Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult? Function(String planId)? loadMorePlanReviews,
    TResult? Function(String reviewerId)? loadMoreReviewsByUser,
    TResult? Function(ReviewEntity review)? updateReview,
    TResult? Function(String reviewId)? deleteReview,
    TResult? Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult? Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult? Function(String userId)? getUserRating,
    TResult? Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult? Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult? Function(int? limit, bool? refresh)? getPendingReviews,
    TResult? Function(String reviewId)? approveReview,
    TResult? Function(String reviewId, String reason)? rejectReview,
    TResult? Function(String reviewId, String reason)? flagReview,
    TResult? Function()? getReviewMetrics,
    TResult? Function()? getRatingDistribution,
    TResult? Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult? Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult? Function(List<String> userIds)? compareUserRatings,
    TResult? Function()? resetState,
    TResult? Function()? clearError,
  }) {
    return clearError?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      ReviewType type,
      String? planTitle,
      DateTime? planDate,
      String? reviewerRole,
    )?
    createReview,
    TResult Function(
      String userId,
      ReviewType? type,
      int? limit,
      bool? refresh,
    )?
    getUserReviews,
    TResult Function(String planId, int? limit, bool? refresh)? getPlanReviews,
    TResult Function(String reviewerId, int? limit, bool? refresh)?
    getReviewsByUser,
    TResult Function(String userId, ReviewType? type)? loadMoreUserReviews,
    TResult Function(String planId)? loadMorePlanReviews,
    TResult Function(String reviewerId)? loadMoreReviewsByUser,
    TResult Function(ReviewEntity review)? updateReview,
    TResult Function(String reviewId)? deleteReview,
    TResult Function(String reviewId, String userId)? markReviewAsHelpful,
    TResult Function(String reviewId, String userId)? unmarkReviewAsHelpful,
    TResult Function(String userId)? getUserRating,
    TResult Function(
      String userId,
      double? newRating,
      ReviewType? reviewType,
      bool? forceRecalculation,
    )?
    calculateUserRating,
    TResult Function(ReviewType? type, int? limit)? getTopRatedUsers,
    TResult Function(int? limit, bool? refresh)? getPendingReviews,
    TResult Function(String reviewId)? approveReview,
    TResult Function(String reviewId, String reason)? rejectReview,
    TResult Function(String reviewId, String reason)? flagReview,
    TResult Function()? getReviewMetrics,
    TResult Function()? getRatingDistribution,
    TResult Function(DateTime startDate, DateTime endDate)? getReviewTrends,
    TResult Function(String userId, String planId, String targetUserId)?
    checkCanUserReviewPlan,
    TResult Function(List<String> userIds)? compareUserRatings,
    TResult Function()? resetState,
    TResult Function()? clearError,
    required TResult orElse(),
  }) {
    if (clearError != null) {
      return clearError();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReviewEvent value) createReview,
    required TResult Function(GetUserReviewsEvent value) getUserReviews,
    required TResult Function(GetPlanReviewsEvent value) getPlanReviews,
    required TResult Function(GetReviewsByUserEvent value) getReviewsByUser,
    required TResult Function(LoadMoreUserReviewsEvent value)
    loadMoreUserReviews,
    required TResult Function(LoadMorePlanReviewsEvent value)
    loadMorePlanReviews,
    required TResult Function(LoadMoreReviewsByUserEvent value)
    loadMoreReviewsByUser,
    required TResult Function(UpdateReviewEvent value) updateReview,
    required TResult Function(DeleteReviewEvent value) deleteReview,
    required TResult Function(MarkReviewAsHelpfulEvent value)
    markReviewAsHelpful,
    required TResult Function(UnmarkReviewAsHelpfulEvent value)
    unmarkReviewAsHelpful,
    required TResult Function(GetUserRatingEvent value) getUserRating,
    required TResult Function(CalculateUserRatingEvent value)
    calculateUserRating,
    required TResult Function(GetTopRatedUsersEvent value) getTopRatedUsers,
    required TResult Function(GetPendingReviewsEvent value) getPendingReviews,
    required TResult Function(ApproveReviewEvent value) approveReview,
    required TResult Function(RejectReviewEvent value) rejectReview,
    required TResult Function(FlagReviewEvent value) flagReview,
    required TResult Function(GetReviewMetricsEvent value) getReviewMetrics,
    required TResult Function(GetRatingDistributionEvent value)
    getRatingDistribution,
    required TResult Function(GetReviewTrendsEvent value) getReviewTrends,
    required TResult Function(CheckCanUserReviewPlanEvent value)
    checkCanUserReviewPlan,
    required TResult Function(CompareUserRatingsEvent value) compareUserRatings,
    required TResult Function(ResetStateEvent value) resetState,
    required TResult Function(ClearErrorEvent value) clearError,
  }) {
    return clearError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReviewEvent value)? createReview,
    TResult? Function(GetUserReviewsEvent value)? getUserReviews,
    TResult? Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult? Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult? Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult? Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult? Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult? Function(UpdateReviewEvent value)? updateReview,
    TResult? Function(DeleteReviewEvent value)? deleteReview,
    TResult? Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult? Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult? Function(GetUserRatingEvent value)? getUserRating,
    TResult? Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult? Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult? Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult? Function(ApproveReviewEvent value)? approveReview,
    TResult? Function(RejectReviewEvent value)? rejectReview,
    TResult? Function(FlagReviewEvent value)? flagReview,
    TResult? Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult? Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult? Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult? Function(CheckCanUserReviewPlanEvent value)?
    checkCanUserReviewPlan,
    TResult? Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult? Function(ResetStateEvent value)? resetState,
    TResult? Function(ClearErrorEvent value)? clearError,
  }) {
    return clearError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReviewEvent value)? createReview,
    TResult Function(GetUserReviewsEvent value)? getUserReviews,
    TResult Function(GetPlanReviewsEvent value)? getPlanReviews,
    TResult Function(GetReviewsByUserEvent value)? getReviewsByUser,
    TResult Function(LoadMoreUserReviewsEvent value)? loadMoreUserReviews,
    TResult Function(LoadMorePlanReviewsEvent value)? loadMorePlanReviews,
    TResult Function(LoadMoreReviewsByUserEvent value)? loadMoreReviewsByUser,
    TResult Function(UpdateReviewEvent value)? updateReview,
    TResult Function(DeleteReviewEvent value)? deleteReview,
    TResult Function(MarkReviewAsHelpfulEvent value)? markReviewAsHelpful,
    TResult Function(UnmarkReviewAsHelpfulEvent value)? unmarkReviewAsHelpful,
    TResult Function(GetUserRatingEvent value)? getUserRating,
    TResult Function(CalculateUserRatingEvent value)? calculateUserRating,
    TResult Function(GetTopRatedUsersEvent value)? getTopRatedUsers,
    TResult Function(GetPendingReviewsEvent value)? getPendingReviews,
    TResult Function(ApproveReviewEvent value)? approveReview,
    TResult Function(RejectReviewEvent value)? rejectReview,
    TResult Function(FlagReviewEvent value)? flagReview,
    TResult Function(GetReviewMetricsEvent value)? getReviewMetrics,
    TResult Function(GetRatingDistributionEvent value)? getRatingDistribution,
    TResult Function(GetReviewTrendsEvent value)? getReviewTrends,
    TResult Function(CheckCanUserReviewPlanEvent value)? checkCanUserReviewPlan,
    TResult Function(CompareUserRatingsEvent value)? compareUserRatings,
    TResult Function(ResetStateEvent value)? resetState,
    TResult Function(ClearErrorEvent value)? clearError,
    required TResult orElse(),
  }) {
    if (clearError != null) {
      return clearError(this);
    }
    return orElse();
  }
}

abstract class ClearErrorEvent implements ReviewEvent {
  const factory ClearErrorEvent() = _$ClearErrorEventImpl;
}
