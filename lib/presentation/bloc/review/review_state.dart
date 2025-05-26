import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/review/review_entity.dart';
import '../../../domain/usecases/review/get_user_reviews_usecase.dart';
import '../../../domain/usecases/review/calculate_user_rating_usecase.dart';

part 'review_state.freezed.dart';

@freezed
class ReviewState with _$ReviewState {
  const factory ReviewState({
    // ==================== ESTADO GENERAL ====================
    @Default(ReviewStatus.initial) ReviewStatus status,
    String? error,
    bool? isLoading,

    // ==================== RESEÑAS ====================
    @Default([]) List<ReviewEntity> userReviews,
    @Default([]) List<ReviewEntity> planReviews,
    @Default([]) List<ReviewEntity> reviewsByUser,
    @Default([]) List<ReviewEntity> pendingReviews,

    // ==================== PAGINACIÓN ====================
    @Default(false) bool hasMoreUserReviews,
    @Default(false) bool hasMorePlanReviews,
    @Default(false) bool hasMoreReviewsByUser,
    @Default(false) bool hasMorePendingReviews,
    String? lastUserReviewDocumentId,
    String? lastPlanReviewDocumentId,
    String? lastReviewsByUserDocumentId,
    String? lastPendingReviewDocumentId,

    // ==================== RATING DE USUARIO ====================
    UserRatingEntity? currentUserRating,
    @Default([]) List<UserRatingEntity> topRatedUsers,
    UserRatingCalculationResult? lastCalculationResult,
    UserReviewsResult? lastUserReviewsResult,
    @Default([]) List<UserRatingComparison> userRatingComparisons,

    // ==================== ACCIONES ====================
    String? lastCreatedReviewId,
    String? lastUpdatedReviewId,
    String? lastDeletedReviewId,
    @Default([]) List<String> helpfulReviewIds,

    // ==================== MODERACIÓN ====================
    String? lastApprovedReviewId,
    String? lastRejectedReviewId,
    String? lastFlaggedReviewId,

    // ==================== ANALYTICS ====================
    Map<String, dynamic>? reviewMetrics,
    Map<int, int>? ratingDistribution,
    Map<String, dynamic>? reviewTrends,

    // ==================== PERMISOS ====================
    @Default({})
    Map<String, bool> canReviewPermissions, // planId + targetUserId -> bool
    // ==================== CACHE Y PERFORMANCE ====================
    DateTime? lastRefreshTime,
    @Default({}) Map<String, DateTime> lastDataFetchTimes,
    @Default(false) bool isRefreshing,
  }) = _ReviewState;
}

enum ReviewStatus {
  initial,
  loading,
  loadingMore,
  success,
  error,
  creating,
  created,
  updating,
  updated,
  deleting,
  deleted,
  moderating,
  moderated,
  calculating,
  calculated,
}

extension ReviewStateExtensions on ReviewState {
  // ==================== GETTERS DE CONVENIENCIA ====================

  bool get isInitial => status == ReviewStatus.initial;
  bool get isLoadingInitial => status == ReviewStatus.loading;
  bool get isLoadingMore => status == ReviewStatus.loadingMore;
  bool get isSuccess => status == ReviewStatus.success;
  bool get hasError => status == ReviewStatus.error && error != null;
  bool get isCreating => status == ReviewStatus.creating;
  bool get isUpdating => status == ReviewStatus.updating;
  bool get isDeleting => status == ReviewStatus.deleting;
  bool get isModerating => status == ReviewStatus.moderating;
  bool get isCalculating => status == ReviewStatus.calculating;

  // ==================== DATOS COMBINADOS ====================

  /// Todas las reseñas cargadas actualmente
  List<ReviewEntity> get allReviews => [
    ...userReviews,
    ...planReviews,
    ...reviewsByUser,
    ...pendingReviews,
  ];

  /// Reseñas agrupadas por rating
  Map<int, List<ReviewEntity>> get userReviewsByRating {
    final grouped = <int, List<ReviewEntity>>{};
    for (int i = 1; i <= 5; i++) {
      grouped[i] = userReviews.where((r) => r.rating.round() == i).toList();
    }
    return grouped;
  }

  /// Reseñas recientes del usuario
  List<ReviewEntity> get recentUserReviews =>
      userReviews.where((r) => r.isRecent).toList();

  /// Reseñas positivas del usuario
  List<ReviewEntity> get positiveUserReviews =>
      userReviews.where((r) => r.isPositive).toList();

  /// Reseñas negativas del usuario
  List<ReviewEntity> get negativeUserReviews =>
      userReviews.where((r) => r.isNegative).toList();

  // ==================== ESTADÍSTICAS ====================

  /// Rating promedio de las reseñas del usuario actual
  double get averageUserRating {
    if (userReviews.isEmpty) return 0.0;
    final sum = userReviews.fold<double>(0, (sum, r) => sum + r.rating);
    return sum / userReviews.length;
  }

  /// Distribución de ratings de las reseñas del usuario
  Map<int, int> get userReviewDistribution {
    final distribution = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final review in userReviews) {
      final rating = review.rating.round();
      distribution[rating] = (distribution[rating] ?? 0) + 1;
    }
    return distribution;
  }

  /// Total de reseñas útiles marcadas por el usuario actual
  int get totalHelpfulMarked => helpfulReviewIds.length;

  // ==================== VALIDACIONES ====================

  /// Verifica si se puede cargar más contenido
  bool canLoadMore(String type) {
    switch (type) {
      case 'userReviews':
        return hasMoreUserReviews && !isLoadingMore;
      case 'planReviews':
        return hasMorePlanReviews && !isLoadingMore;
      case 'reviewsByUser':
        return hasMoreReviewsByUser && !isLoadingMore;
      case 'pendingReviews':
        return hasMorePendingReviews && !isLoadingMore;
      default:
        return false;
    }
  }

  /// Verifica si los datos necesitan refresh
  bool needsRefresh([Duration? maxAge]) {
    final age = maxAge ?? const Duration(minutes: 5);
    if (lastRefreshTime == null) return true;
    return DateTime.now().difference(lastRefreshTime!) > age;
  }

  /// Verifica si el usuario puede revisar un plan específico
  bool canUserReviewPlan(String planId, String targetUserId) {
    final key = '${planId}_$targetUserId';
    return canReviewPermissions[key] ?? false;
  }

  // ==================== BÚSQUEDA Y FILTRADO ====================

  /// Filtra reseñas del usuario por tipo
  List<ReviewEntity> getUserReviewsByType(ReviewType type) {
    return userReviews.where((r) => r.type == type).toList();
  }

  /// Busca reseñas que contengan un texto específico
  List<ReviewEntity> searchReviews(String query) {
    final lowercaseQuery = query.toLowerCase();
    return allReviews
        .where((r) => r.comment.toLowerCase().contains(lowercaseQuery))
        .toList();
  }

  /// Obtiene reseñas por rango de fechas
  List<ReviewEntity> getReviewsByDateRange(DateTime start, DateTime end) {
    return allReviews
        .where((r) => r.createdAt.isAfter(start) && r.createdAt.isBefore(end))
        .toList();
  }

  // ==================== UTILIDADES DE UI ====================

  /// Mensaje de error formateado para mostrar en UI
  String get formattedError {
    if (error == null) return '';
    if (error!.contains('Ya has escrito')) {
      return 'Ya escribiste una reseña para este usuario en este plan';
    }
    if (error!.contains('calificación debe estar')) {
      return 'La calificación debe estar entre 1 y 5 estrellas';
    }
    if (error!.contains('comentario debe tener')) {
      return 'El comentario debe tener al menos 10 caracteres';
    }
    return error!;
  }

  /// Color sugerido basado en el rating promedio
  String get ratingColor {
    final rating = currentUserRating?.averageRating ?? averageUserRating;
    if (rating >= 4.5) return 'green';
    if (rating >= 4.0) return 'lightGreen';
    if (rating >= 3.5) return 'yellow';
    if (rating >= 3.0) return 'orange';
    return 'red';
  }

  /// Ícono sugerido basado en el estado
  String get statusIcon {
    switch (status) {
      case ReviewStatus.loading:
      case ReviewStatus.loadingMore:
        return 'loading';
      case ReviewStatus.success:
        return 'check';
      case ReviewStatus.error:
        return 'error';
      case ReviewStatus.created:
        return 'add_circle';
      case ReviewStatus.updated:
        return 'edit';
      case ReviewStatus.deleted:
        return 'delete';
      default:
        return 'star';
    }
  }
}
