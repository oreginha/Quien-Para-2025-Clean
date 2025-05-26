import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/domain/repositories/review/review_repository.dart';
import '../../../domain/usecases/review/create_review_usecase.dart';
import '../../../domain/usecases/review/get_user_reviews_usecase.dart';
import '../../../domain/usecases/review/calculate_user_rating_usecase.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final CreateReviewUseCase createReviewUseCase;
  final GetUserReviewsUseCase getUserReviewsUseCase;
  final CalculateUserRatingUseCase calculateUserRatingUseCase;
  final IReviewRepository repository;

  ReviewBloc({
    required this.createReviewUseCase,
    required this.getUserReviewsUseCase,
    required this.calculateUserRatingUseCase,
    required this.repository,
  }) : super(const ReviewState()) {
    // ==================== CREAR RESEÑA ====================
    on<CreateReviewEvent>(_onCreateReview);

    // ==================== OBTENER RESEÑAS ====================
    on<GetUserReviewsEvent>(_onGetUserReviews);
    on<GetPlanReviewsEvent>(_onGetPlanReviews);
    on<GetReviewsByUserEvent>(_onGetReviewsByUser);
    on<LoadMoreUserReviewsEvent>(_onLoadMoreUserReviews);
    on<LoadMorePlanReviewsEvent>(_onLoadMorePlanReviews);
    on<LoadMoreReviewsByUserEvent>(_onLoadMoreReviewsByUser);

    // ==================== ACCIONES DE RESEÑA ====================
    on<UpdateReviewEvent>(_onUpdateReview);
    on<DeleteReviewEvent>(_onDeleteReview);
    on<MarkReviewAsHelpfulEvent>(_onMarkReviewAsHelpful);
    on<UnmarkReviewAsHelpfulEvent>(_onUnmarkReviewAsHelpful);

    // ==================== RATING DE USUARIO ====================
    on<GetUserRatingEvent>(_onGetUserRating);
    on<CalculateUserRatingEvent>(_onCalculateUserRating);
    on<GetTopRatedUsersEvent>(_onGetTopRatedUsers);

    // ==================== MODERACIÓN ====================
    on<GetPendingReviewsEvent>(_onGetPendingReviews);
    on<ApproveReviewEvent>(_onApproveReview);
    on<RejectReviewEvent>(_onRejectReview);
    on<FlagReviewEvent>(_onFlagReview);

    // ==================== ANALYTICS ====================
    on<GetReviewMetricsEvent>(_onGetReviewMetrics);
    on<GetRatingDistributionEvent>(_onGetRatingDistribution);
    on<GetReviewTrendsEvent>(_onGetReviewTrends);

    // ==================== UTILIDADES ====================
    on<CheckCanUserReviewPlanEvent>(_onCheckCanUserReviewPlan);
    on<CompareUserRatingsEvent>(_onCompareUserRatings);
    on<ResetStateEvent>(_onResetState);
    on<ClearErrorEvent>(_onClearError);
  }

  // ==================== CREAR RESEÑA ====================

  Future<void> _onCreateReview(
    CreateReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(state.copyWith(status: ReviewStatus.creating));

    final params = CreateReviewParams(
      reviewerId: event.reviewerId,
      reviewedUserId: event.reviewedUserId,
      planId: event.planId,
      rating: event.rating,
      comment: event.comment,
      type: event.type,
      planTitle: event.planTitle,
      planDate: event.planDate,
      reviewerRole: event.reviewerRole,
    );

    final result = await createReviewUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (reviewId) => emit(
        state.copyWith(
          status: ReviewStatus.created,
          lastCreatedReviewId: reviewId,
          lastRefreshTime: DateTime.now(),
        ),
      ),
    );
  }

  // ==================== OBTENER RESEÑAS ====================

  Future<void> _onGetUserReviews(
    GetUserReviewsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    if (event.refresh == true) {
      emit(
        state.copyWith(
          status: ReviewStatus.loading,
          userReviews: [],
          hasMoreUserReviews: false,
          lastUserReviewDocumentId: null,
        ),
      );
    } else if (state.userReviews.isEmpty) {
      emit(state.copyWith(status: ReviewStatus.loading));
    }

    final params = GetUserReviewsParams(
      userId: event.userId,
      type: event.type,
      limit: event.limit ?? 20,
    );

    final result = await getUserReviewsUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (reviewsResult) => emit(
        state.copyWith(
          status: ReviewStatus.success,
          userReviews: reviewsResult.reviews,
          currentUserRating: reviewsResult.userRating,
          hasMoreUserReviews: reviewsResult.hasMore,
          lastUserReviewDocumentId: reviewsResult.reviews.isNotEmpty
              ? reviewsResult.reviews.last.id
              : null,
          lastUserReviewsResult: reviewsResult,
          lastRefreshTime: DateTime.now(),
        ),
      ),
    );
  }

  Future<void> _onGetPlanReviews(
    GetPlanReviewsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    if (event.refresh == true) {
      emit(
        state.copyWith(
          status: ReviewStatus.loading,
          planReviews: [],
          hasMorePlanReviews: false,
          lastPlanReviewDocumentId: null,
        ),
      );
    } else if (state.planReviews.isEmpty) {
      emit(state.copyWith(status: ReviewStatus.loading));
    }

    final result = await repository.getPlanReviews(
      planId: event.planId,
      limit: event.limit ?? 20,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (reviews) => emit(
        state.copyWith(
          status: ReviewStatus.success,
          planReviews: reviews,
          hasMorePlanReviews: reviews.length == (event.limit ?? 20),
          lastPlanReviewDocumentId: reviews.isNotEmpty ? reviews.last.id : null,
          lastRefreshTime: DateTime.now(),
        ),
      ),
    );
  }

  Future<void> _onGetReviewsByUser(
    GetReviewsByUserEvent event,
    Emitter<ReviewState> emit,
  ) async {
    if (event.refresh == true) {
      emit(
        state.copyWith(
          status: ReviewStatus.loading,
          reviewsByUser: [],
          hasMoreReviewsByUser: false,
          lastReviewsByUserDocumentId: null,
        ),
      );
    } else if (state.reviewsByUser.isEmpty) {
      emit(state.copyWith(status: ReviewStatus.loading));
    }

    final result = await repository.getReviewsByUser(
      reviewerId: event.reviewerId,
      limit: event.limit ?? 20,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (reviews) => emit(
        state.copyWith(
          status: ReviewStatus.success,
          reviewsByUser: reviews,
          hasMoreReviewsByUser: reviews.length == (event.limit ?? 20),
          lastReviewsByUserDocumentId: reviews.isNotEmpty
              ? reviews.last.id
              : null,
          lastRefreshTime: DateTime.now(),
        ),
      ),
    );
  }

  // ==================== CARGAR MÁS RESEÑAS ====================

  Future<void> _onLoadMoreUserReviews(
    LoadMoreUserReviewsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    if (!state.hasMoreUserReviews || state.isLoadingMore) return;

    emit(state.copyWith(status: ReviewStatus.loadingMore));

    final params = GetUserReviewsParams(
      userId: event.userId,
      type: event.type,
      limit: 20,
      lastDocumentId: state.lastUserReviewDocumentId,
    );

    final result = await getUserReviewsUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (reviewsResult) => emit(
        state.copyWith(
          status: ReviewStatus.success,
          userReviews: [...state.userReviews, ...reviewsResult.reviews],
          hasMoreUserReviews: reviewsResult.hasMore,
          lastUserReviewDocumentId: reviewsResult.reviews.isNotEmpty
              ? reviewsResult.reviews.last.id
              : state.lastUserReviewDocumentId,
        ),
      ),
    );
  }

  Future<void> _onLoadMorePlanReviews(
    LoadMorePlanReviewsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    if (!state.hasMorePlanReviews || state.isLoadingMore) return;

    emit(state.copyWith(status: ReviewStatus.loadingMore));

    final result = await repository.getPlanReviews(
      planId: event.planId,
      limit: 20,
      lastDocumentId: state.lastPlanReviewDocumentId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (reviews) => emit(
        state.copyWith(
          status: ReviewStatus.success,
          planReviews: [...state.planReviews, ...reviews],
          hasMorePlanReviews: reviews.length == 20,
          lastPlanReviewDocumentId: reviews.isNotEmpty
              ? reviews.last.id
              : state.lastPlanReviewDocumentId,
        ),
      ),
    );
  }

  Future<void> _onLoadMoreReviewsByUser(
    LoadMoreReviewsByUserEvent event,
    Emitter<ReviewState> emit,
  ) async {
    if (!state.hasMoreReviewsByUser || state.isLoadingMore) return;

    emit(state.copyWith(status: ReviewStatus.loadingMore));

    final result = await repository.getReviewsByUser(
      reviewerId: event.reviewerId,
      limit: 20,
      lastDocumentId: state.lastReviewsByUserDocumentId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (reviews) => emit(
        state.copyWith(
          status: ReviewStatus.success,
          reviewsByUser: [...state.reviewsByUser, ...reviews],
          hasMoreReviewsByUser: reviews.length == 20,
          lastReviewsByUserDocumentId: reviews.isNotEmpty
              ? reviews.last.id
              : state.lastReviewsByUserDocumentId,
        ),
      ),
    );
  }

  // ==================== ACCIONES DE RESEÑA ====================

  Future<void> _onUpdateReview(
    UpdateReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(state.copyWith(status: ReviewStatus.updating));

    final result = await repository.updateReview(event.review);

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (_) {
        // Actualizar la reseña en las listas locales
        final updatedUserReviews = state.userReviews
            .map((r) => r.id == event.review.id ? event.review : r)
            .toList();

        final updatedPlanReviews = state.planReviews
            .map((r) => r.id == event.review.id ? event.review : r)
            .toList();

        final updatedReviewsByUser = state.reviewsByUser
            .map((r) => r.id == event.review.id ? event.review : r)
            .toList();

        emit(
          state.copyWith(
            status: ReviewStatus.updated,
            userReviews: updatedUserReviews,
            planReviews: updatedPlanReviews,
            reviewsByUser: updatedReviewsByUser,
            lastUpdatedReviewId: event.review.id,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteReview(
    DeleteReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(state.copyWith(status: ReviewStatus.deleting));

    final result = await repository.deleteReview(event.reviewId);

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (_) {
        // Remover la reseña de las listas locales
        final updatedUserReviews = state.userReviews
            .where((r) => r.id != event.reviewId)
            .toList();

        final updatedPlanReviews = state.planReviews
            .where((r) => r.id != event.reviewId)
            .toList();

        final updatedReviewsByUser = state.reviewsByUser
            .where((r) => r.id != event.reviewId)
            .toList();

        emit(
          state.copyWith(
            status: ReviewStatus.deleted,
            userReviews: updatedUserReviews,
            planReviews: updatedPlanReviews,
            reviewsByUser: updatedReviewsByUser,
            lastDeletedReviewId: event.reviewId,
          ),
        );
      },
    );
  }

  Future<void> _onMarkReviewAsHelpful(
    MarkReviewAsHelpfulEvent event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await repository.markReviewAsHelpful(
      reviewId: event.reviewId,
      userId: event.userId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (_) {
        final updatedHelpfulIds = [...state.helpfulReviewIds];
        if (!updatedHelpfulIds.contains(event.reviewId)) {
          updatedHelpfulIds.add(event.reviewId);
        }

        emit(state.copyWith(helpfulReviewIds: updatedHelpfulIds));
      },
    );
  }

  Future<void> _onUnmarkReviewAsHelpful(
    UnmarkReviewAsHelpfulEvent event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await repository.unmarkReviewAsHelpful(
      reviewId: event.reviewId,
      userId: event.userId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (_) {
        final updatedHelpfulIds = state.helpfulReviewIds
            .where((id) => id != event.reviewId)
            .toList();

        emit(state.copyWith(helpfulReviewIds: updatedHelpfulIds));
      },
    );
  }

  // ==================== RATING DE USUARIO ====================

  Future<void> _onGetUserRating(
    GetUserRatingEvent event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await repository.getUserRating(event.userId);

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (rating) => emit(state.copyWith(currentUserRating: rating)),
    );
  }

  Future<void> _onCalculateUserRating(
    CalculateUserRatingEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(state.copyWith(status: ReviewStatus.calculating));

    final params = CalculateUserRatingParams(
      userId: event.userId,
      newRating: event.newRating,
      reviewType: event.reviewType,
      forceRecalculation: event.forceRecalculation ?? false,
    );

    final result = await calculateUserRatingUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (calculationResult) => emit(
        state.copyWith(
          status: ReviewStatus.calculated,
          currentUserRating: calculationResult.newRating,
          lastCalculationResult: calculationResult,
        ),
      ),
    );
  }

  Future<void> _onGetTopRatedUsers(
    GetTopRatedUsersEvent event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await repository.getTopRatedUsers(
      type: event.type,
      limit: event.limit ?? 10,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (topUsers) => emit(state.copyWith(topRatedUsers: topUsers)),
    );
  }

  // ==================== MODERACIÓN ====================

  Future<void> _onGetPendingReviews(
    GetPendingReviewsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    if (event.refresh == true) {
      emit(
        state.copyWith(
          status: ReviewStatus.loading,
          pendingReviews: [],
          hasMorePendingReviews: false,
          lastPendingReviewDocumentId: null,
        ),
      );
    } else if (state.pendingReviews.isEmpty) {
      emit(state.copyWith(status: ReviewStatus.loading));
    }

    final result = await repository.getPendingReviews(limit: event.limit ?? 20);

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (reviews) => emit(
        state.copyWith(
          status: ReviewStatus.success,
          pendingReviews: reviews,
          hasMorePendingReviews: reviews.length == (event.limit ?? 20),
          lastPendingReviewDocumentId: reviews.isNotEmpty
              ? reviews.last.id
              : null,
        ),
      ),
    );
  }

  Future<void> _onApproveReview(
    ApproveReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(state.copyWith(status: ReviewStatus.moderating));

    final result = await repository.approveReview(event.reviewId);

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (_) {
        final updatedPendingReviews = state.pendingReviews
            .where((r) => r.id != event.reviewId)
            .toList();

        emit(
          state.copyWith(
            status: ReviewStatus.moderated,
            pendingReviews: updatedPendingReviews,
            lastApprovedReviewId: event.reviewId,
          ),
        );
      },
    );
  }

  Future<void> _onRejectReview(
    RejectReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(state.copyWith(status: ReviewStatus.moderating));

    final result = await repository.rejectReview(
      reviewId: event.reviewId,
      reason: event.reason,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (_) {
        final updatedPendingReviews = state.pendingReviews
            .where((r) => r.id != event.reviewId)
            .toList();

        emit(
          state.copyWith(
            status: ReviewStatus.moderated,
            pendingReviews: updatedPendingReviews,
            lastRejectedReviewId: event.reviewId,
          ),
        );
      },
    );
  }

  Future<void> _onFlagReview(
    FlagReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(state.copyWith(status: ReviewStatus.moderating));

    final result = await repository.flagReview(
      reviewId: event.reviewId,
      reason: event.reason,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (_) => emit(
        state.copyWith(
          status: ReviewStatus.moderated,
          lastFlaggedReviewId: event.reviewId,
        ),
      ),
    );
  }

  // ==================== ANALYTICS ====================

  Future<void> _onGetReviewMetrics(
    GetReviewMetricsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await repository.getReviewMetrics();

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (metrics) => emit(state.copyWith(reviewMetrics: metrics)),
    );
  }

  Future<void> _onGetRatingDistribution(
    GetRatingDistributionEvent event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await repository.getRatingDistribution();

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (distribution) => emit(state.copyWith(ratingDistribution: distribution)),
    );
  }

  Future<void> _onGetReviewTrends(
    GetReviewTrendsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await repository.getReviewTrends(
      startDate: event.startDate,
      endDate: event.endDate,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (trends) => emit(state.copyWith(reviewTrends: trends)),
    );
  }

  // ==================== UTILIDADES ====================

  Future<void> _onCheckCanUserReviewPlan(
    CheckCanUserReviewPlanEvent event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await repository.canUserReviewPlan(
      userId: event.userId,
      planId: event.planId,
      targetUserId: event.targetUserId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (canReview) {
        final key = '${event.planId}_${event.targetUserId}';
        final updatedPermissions = Map<String, bool>.from(
          state.canReviewPermissions,
        );
        updatedPermissions[key] = canReview;

        emit(state.copyWith(canReviewPermissions: updatedPermissions));
      },
    );
  }

  Future<void> _onCompareUserRatings(
    CompareUserRatingsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await calculateUserRatingUseCase.compareUsers(event.userIds);

    result.fold(
      (failure) => emit(
        state.copyWith(status: ReviewStatus.error, error: failure.message),
      ),
      (comparisons) => emit(state.copyWith(userRatingComparisons: comparisons)),
    );
  }

  Future<void> _onResetState(
    ResetStateEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(const ReviewState());
  }

  Future<void> _onClearError(
    ClearErrorEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(state.copyWith(error: null));
  }
}
