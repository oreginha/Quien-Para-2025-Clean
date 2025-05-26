import 'package:dartz/dartz.dart';
import 'package:quien_para/presentation/widgets/errors/failures.dart';
import '../../entities/review/review_entity.dart';
import '../../repositories/review/review_repository.dart';

class GetUserReviewsUseCase {
  final IReviewRepository repository;

  GetUserReviewsUseCase(this.repository);

  Future<Either<Failure, UserReviewsResult>> call(
    GetUserReviewsParams params,
  ) async {
    // Validaciones
    if (params.userId.isEmpty) {
      return Left(ValidationFailure('ID de usuario requerido'));
    }

    if (params.limit <= 0 || params.limit > 100) {
      return Left(ValidationFailure('El límite debe estar entre 1 y 100'));
    }

    // Obtener reseñas del usuario
    final reviewsResult = await repository.getUserReviews(
      userId: params.userId,
      type: params.type,
      limit: params.limit,
      lastDocumentId: params.lastDocumentId,
    );

    if (reviewsResult.isLeft()) {
      return Left((reviewsResult as Left).value);
    }

    final reviews = (reviewsResult as Right).value;

    // Obtener rating del usuario
    final ratingResult = await repository.getUserRating(params.userId);
    UserRatingEntity? userRating;

    if (ratingResult.isRight()) {
      userRating = (ratingResult as Right).value;
    }

    // Obtener estadísticas adicionales
    final statsResult = await repository.getUserReviewStats(params.userId);
    Map<String, dynamic> stats = {};

    if (statsResult.isRight()) {
      stats = (statsResult as Right).value;
    }

    return Right(
      UserReviewsResult(
        reviews: reviews,
        userRating: userRating,
        stats: stats,
        hasMore: reviews.length == params.limit,
      ),
    );
  }
}

class GetUserReviewsParams {
  final String userId;
  final ReviewType? type;
  final int limit;
  final String? lastDocumentId;

  GetUserReviewsParams({
    required this.userId,
    this.type,
    this.limit = 20,
    this.lastDocumentId,
  });
}

class UserReviewsResult {
  final List<ReviewEntity> reviews;
  final UserRatingEntity? userRating;
  final Map<String, dynamic> stats;
  final bool hasMore;

  UserReviewsResult({
    required this.reviews,
    this.userRating,
    this.stats = const {},
    this.hasMore = false,
  });

  // Métodos de conveniencia para análisis
  List<ReviewEntity> get positiveReviews =>
      reviews.where((r) => r.isPositive).toList();

  List<ReviewEntity> get negativeReviews =>
      reviews.where((r) => r.isNegative).toList();

  List<ReviewEntity> get neutralReviews =>
      reviews.where((r) => r.isNeutral).toList();

  List<ReviewEntity> get recentReviews =>
      reviews.where((r) => r.isRecent).toList();

  double get averageRating {
    if (reviews.isEmpty) return 0.0;
    return reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        reviews.length;
  }

  Map<int, int> get ratingDistribution {
    final distribution = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final review in reviews) {
      distribution[review.rating.round()] =
          (distribution[review.rating.round()] ?? 0) + 1;
    }
    return distribution;
  }

  List<String> get topComments {
    final filtered = reviews.where((r) => r.helpfulCount > 0).toList();
    filtered.sort((a, b) => b.helpfulCount.compareTo(a.helpfulCount));
    return filtered.take(5).map((r) => r.comment).toList();
  }
}

// Validation Failure class (si no existe ya)
class ValidationFailure extends Failure {
  ValidationFailure(super.message);
}
