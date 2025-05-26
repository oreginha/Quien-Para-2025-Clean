import 'package:dartz/dartz.dart';
import '../../../presentation/widgets/errors/failures.dart';
import '../../entities/review/review_entity.dart';

abstract class IReviewRepository {
  // ==================== REVIEWS ====================

  /// Crear una nueva reseña
  Future<Either<Failure, String>> createReview(ReviewEntity review);

  /// Obtener reseñas de un usuario específico
  Future<Either<Failure, List<ReviewEntity>>> getUserReviews({
    required String userId,
    ReviewType? type,
    int limit = 20,
    String? lastDocumentId,
  });

  /// Obtener reseñas de un plan específico
  Future<Either<Failure, List<ReviewEntity>>> getPlanReviews({
    required String planId,
    int limit = 20,
    String? lastDocumentId,
  });

  /// Obtener reseñas escritas por un usuario
  Future<Either<Failure, List<ReviewEntity>>> getReviewsByUser({
    required String reviewerId,
    int limit = 20,
    String? lastDocumentId,
  });

  /// Actualizar una reseña existente
  Future<Either<Failure, void>> updateReview(ReviewEntity review);

  /// Eliminar una reseña
  Future<Either<Failure, void>> deleteReview(String reviewId);

  /// Marcar reseña como útil
  Future<Either<Failure, void>> markReviewAsHelpful({
    required String reviewId,
    required String userId,
  });

  /// Desmarcar reseña como útil
  Future<Either<Failure, void>> unmarkReviewAsHelpful({
    required String reviewId,
    required String userId,
  });

  /// Verificar si el usuario puede escribir una reseña para este plan
  Future<Either<Failure, bool>> canUserReviewPlan({
    required String userId,
    required String planId,
    required String targetUserId,
  });

  // ==================== USER RATINGS ====================

  /// Obtener rating completo de un usuario
  Future<Either<Failure, UserRatingEntity>> getUserRating(String userId);

  /// Actualizar rating de usuario (llamado automáticamente tras nueva reseña)
  Future<Either<Failure, void>> updateUserRating({
    required String userId,
    required double newRating,
    required ReviewType reviewType,
  });

  /// Recalcular rating completo de un usuario
  Future<Either<Failure, UserRatingEntity>> recalculateUserRating(
    String userId,
  );

  /// Obtener estadísticas de reviews de un usuario
  Future<Either<Failure, Map<String, dynamic>>> getUserReviewStats(
    String userId,
  );

  /// Obtener usuarios mejor calificados
  Future<Either<Failure, List<UserRatingEntity>>> getTopRatedUsers({
    ReviewType? type,
    int limit = 10,
  });

  // ==================== MODERACIÓN ====================

  /// Obtener reseñas pendientes de moderación
  Future<Either<Failure, List<ReviewEntity>>> getPendingReviews({
    int limit = 20,
    String? lastDocumentId,
  });

  /// Aprobar una reseña
  Future<Either<Failure, void>> approveReview(String reviewId);

  /// Rechazar una reseña
  Future<Either<Failure, void>> rejectReview({
    required String reviewId,
    required String reason,
  });

  /// Marcar reseña para revisión adicional
  Future<Either<Failure, void>> flagReview({
    required String reviewId,
    required String reason,
  });

  // ==================== ANALYTICS ====================

  /// Obtener métricas de reseñas
  Future<Either<Failure, Map<String, dynamic>>> getReviewMetrics();

  /// Obtener distribución de ratings
  Future<Either<Failure, Map<int, int>>> getRatingDistribution();

  /// Obtener tendencias de reviews
  Future<Either<Failure, Map<String, dynamic>>> getReviewTrends({
    required DateTime startDate,
    required DateTime endDate,
  });
}
