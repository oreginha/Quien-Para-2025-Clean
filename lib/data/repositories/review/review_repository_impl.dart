// ignore_for_file: avoid_types_as_parameter_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/entities/review/review_entity.dart';
import '../../../domain/repositories/review/review_repository.dart';
import '../../../presentation/widgets/errors/failures.dart';

class ReviewRepositoryImpl implements IReviewRepository {
  final FirebaseFirestore firestore;

  ReviewRepositoryImpl({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  static const String reviewsCollection = 'reviews';
  static const String userRatingsCollection = 'user_ratings';
  static const String reviewStatsCollection = 'review_stats';

  // ==================== REVIEWS ====================

  @override
  Future<Either<Failure, String>> createReview(ReviewEntity review) async {
    try {
      // Verificar si ya existe una reseña del mismo usuario para el mismo plan
      final existingQuery = await firestore
          .collection(reviewsCollection)
          .where('reviewerId', isEqualTo: review.reviewerId)
          .where('planId', isEqualTo: review.planId)
          .where('reviewedUserId', isEqualTo: review.reviewedUserId)
          .limit(1)
          .get();

      if (existingQuery.docs.isNotEmpty) {
        return Left(ValidationFailure(
            'Ya has escrito una reseña para este usuario en este plan'));
      }

      // Crear la reseña
      final docRef = firestore.collection(reviewsCollection).doc();
      final reviewWithId = review.copyWith(id: docRef.id);

      await docRef.set(reviewWithId.toJson());

      // Actualizar contadores y estadísticas
      await _updateReviewStats(reviewWithId);

      return Right(docRef.id);
    } catch (e) {
      return Left(ServerFailure('Error al crear reseña: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getUserReviews({
    required String userId,
    ReviewType? type,
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      var query = firestore
          .collection(reviewsCollection)
          .where('reviewedUserId', isEqualTo: userId)
          .where('status',
              isEqualTo: ReviewStatus.approved.toString().split('.').last)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (type != null) {
        query = query.where('type', isEqualTo: type.toString().split('.').last);
      }

      if (lastDocumentId != null) {
        final lastDoc = await firestore
            .collection(reviewsCollection)
            .doc(lastDocumentId)
            .get();
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      final snapshot = await query.get();
      final reviews = snapshot.docs
          .map((doc) => ReviewEntity.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      return Right(reviews);
    } catch (e) {
      return Left(ServerFailure('Error al obtener reseñas: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getPlanReviews({
    required String planId,
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      var query = firestore
          .collection(reviewsCollection)
          .where('planId', isEqualTo: planId)
          .where('status',
              isEqualTo: ReviewStatus.approved.toString().split('.').last)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocumentId != null) {
        final lastDoc = await firestore
            .collection(reviewsCollection)
            .doc(lastDocumentId)
            .get();
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      final snapshot = await query.get();
      final reviews = snapshot.docs
          .map((doc) => ReviewEntity.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      return Right(reviews);
    } catch (e) {
      return Left(
          ServerFailure('Error al obtener reseñas del plan: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getReviewsByUser({
    required String reviewerId,
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      var query = firestore
          .collection(reviewsCollection)
          .where('reviewerId', isEqualTo: reviewerId)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocumentId != null) {
        final lastDoc = await firestore
            .collection(reviewsCollection)
            .doc(lastDocumentId)
            .get();
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      final snapshot = await query.get();
      final reviews = snapshot.docs
          .map((doc) => ReviewEntity.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      return Right(reviews);
    } catch (e) {
      return Left(ServerFailure(
          'Error al obtener reseñas del usuario: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateReview(ReviewEntity review) async {
    try {
      await firestore
          .collection(reviewsCollection)
          .doc(review.id)
          .update(review.toJson());

      return Right(null);
    } catch (e) {
      return Left(ServerFailure('Error al actualizar reseña: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReview(String reviewId) async {
    try {
      // Obtener la reseña antes de eliminarla para actualizar estadísticas
      final reviewDoc =
          await firestore.collection(reviewsCollection).doc(reviewId).get();

      if (!reviewDoc.exists) {
        return Left(NotFoundFailure('Reseña no encontrada'));
      }

      final review =
          ReviewEntity.fromJson({...reviewDoc.data()!, 'id': reviewDoc.id});

      // Eliminar la reseña
      await firestore.collection(reviewsCollection).doc(reviewId).delete();

      // Actualizar estadísticas
      await _removeReviewFromStats(review);

      return Right(null);
    } catch (e) {
      return Left(ServerFailure('Error al eliminar reseña: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> markReviewAsHelpful({
    required String reviewId,
    required String userId,
  }) async {
    try {
      await firestore.collection(reviewsCollection).doc(reviewId).update({
        'helpfulVotes': FieldValue.arrayUnion([userId]),
        'helpfulCount': FieldValue.increment(1),
      });

      return Right(null);
    } catch (e) {
      return Left(
          ServerFailure('Error al marcar reseña como útil: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> unmarkReviewAsHelpful({
    required String reviewId,
    required String userId,
  }) async {
    try {
      await firestore.collection(reviewsCollection).doc(reviewId).update({
        'helpfulVotes': FieldValue.arrayRemove([userId]),
        'helpfulCount': FieldValue.increment(-1),
      });

      return Right(null);
    } catch (e) {
      return Left(ServerFailure(
          'Error al desmarcar reseña como útil: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> canUserReviewPlan({
    required String userId,
    required String planId,
    required String targetUserId,
  }) async {
    try {
      // TODO: Implementar lógica real basada en participación en el plan
      // Por ahora, permitir si no ha escrito reseña previamente

      final existingQuery = await firestore
          .collection(reviewsCollection)
          .where('reviewerId', isEqualTo: userId)
          .where('planId', isEqualTo: planId)
          .where('reviewedUserId', isEqualTo: targetUserId)
          .limit(1)
          .get();

      return Right(existingQuery.docs.isEmpty);
    } catch (e) {
      return Left(
          ServerFailure('Error al verificar permisos: ${e.toString()}'));
    }
  }

  // ==================== USER RATINGS ====================

  @override
  Future<Either<Failure, UserRatingEntity>> getUserRating(String userId) async {
    try {
      final doc =
          await firestore.collection(userRatingsCollection).doc(userId).get();

      if (!doc.exists) {
        // Crear rating inicial si no existe
        final initialRating = UserRatingEntity(
          userId: userId,
          averageRating: 0.0,
          totalReviews: 0,
          lastUpdated: DateTime.now(),
          ratingDistribution: {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0},
        );

        await firestore
            .collection(userRatingsCollection)
            .doc(userId)
            .set(initialRating.toJson());

        return Right(initialRating);
      }

      final rating =
          UserRatingEntity.fromJson({...doc.data()!, 'userId': doc.id});
      return Right(rating);
    } catch (e) {
      return Left(ServerFailure('Error al obtener rating: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserRating({
    required String userId,
    required double newRating,
    required ReviewType reviewType,
  }) async {
    try {
      // Esta es una implementación simplificada
      // En producción, usarías Cloud Functions para cálculos más complejos

      final doc =
          await firestore.collection(userRatingsCollection).doc(userId).get();

      UserRatingEntity currentRating;

      if (doc.exists) {
        currentRating =
            UserRatingEntity.fromJson({...doc.data()!, 'userId': doc.id});
      } else {
        currentRating = UserRatingEntity(
          userId: userId,
          averageRating: 0.0,
          totalReviews: 0,
          lastUpdated: DateTime.now(),
          ratingDistribution: {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0},
        );
      }

      // Calcular nuevo promedio
      final totalRating =
          (currentRating.averageRating * currentRating.totalReviews) +
              newRating;
      final newTotalReviews = currentRating.totalReviews + 1;
      final newAverageRating = totalRating / newTotalReviews;

      // Actualizar distribución
      final newDistribution =
          Map<String, int>.from(currentRating.ratingDistribution ?? {});
      final ratingKey = newRating.round().toString();
      newDistribution[ratingKey] = (newDistribution[ratingKey] ?? 0) + 1;

      final updatedRating = currentRating.copyWith(
        averageRating: newAverageRating,
        totalReviews: newTotalReviews,
        lastUpdated: DateTime.now(),
        ratingDistribution: newDistribution,
      );

      await firestore
          .collection(userRatingsCollection)
          .doc(userId)
          .set(updatedRating.toJson());

      return Right(null);
    } catch (e) {
      return Left(ServerFailure('Error al actualizar rating: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserRatingEntity>> recalculateUserRating(
      String userId) async {
    try {
      // Obtener todas las reseñas aprobadas del usuario
      final reviewsQuery = await firestore
          .collection(reviewsCollection)
          .where('reviewedUserId', isEqualTo: userId)
          .where('status',
              isEqualTo: ReviewStatus.approved.toString().split('.').last)
          .get();

      if (reviewsQuery.docs.isEmpty) {
        final emptyRating = UserRatingEntity(
          userId: userId,
          averageRating: 0.0,
          totalReviews: 0,
          lastUpdated: DateTime.now(),
          ratingDistribution: {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0},
        );

        await firestore
            .collection(userRatingsCollection)
            .doc(userId)
            .set(emptyRating.toJson());

        return Right(emptyRating);
      }

      final reviews = reviewsQuery.docs
          .map((doc) => ReviewEntity.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Calcular estadísticas
      final totalRating =
          // ignore: avoid_types_as_parameter_names
          reviews.fold<double>(0, (sum, review) => sum + review.rating);
      final averageRating = totalRating / reviews.length;

      final distribution = <String, int>{
        '1': 0,
        '2': 0,
        '3': 0,
        '4': 0,
        '5': 0
      };
      for (final review in reviews) {
        final key = review.rating.round().toString();
        distribution[key] = (distribution[key] ?? 0) + 1;
      }

      // Calcular reliability score basado en variaciones de rating
      final variance = reviews.fold<double>(
              0,
              (sum, review) =>
                  sum +
                  ((review.rating - averageRating) *
                      (review.rating - averageRating))) /
          reviews.length;
      final reliabilityScore = (100 - (variance * 20)).clamp(0, 100).round();

      final updatedRating = UserRatingEntity(
        userId: userId,
        averageRating: averageRating,
        totalReviews: reviews.length,
        lastUpdated: DateTime.now(),
        reliabilityScore: reliabilityScore,
        ratingDistribution: distribution,
      );

      await firestore
          .collection(userRatingsCollection)
          .doc(userId)
          .set(updatedRating.toJson());

      return Right(updatedRating);
    } catch (e) {
      return Left(ServerFailure('Error al recalcular rating: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUserReviewStats(
      String userId) async {
    try {
      final doc =
          await firestore.collection(reviewStatsCollection).doc(userId).get();

      if (!doc.exists) {
        return Right(<String, dynamic>{});
      }

      return Right(doc.data()!);
    } catch (e) {
      return Left(
          ServerFailure('Error al obtener estadísticas: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<UserRatingEntity>>> getTopRatedUsers({
    ReviewType? type,
    int limit = 10,
  }) async {
    try {
      var query = firestore
          .collection(userRatingsCollection)
          .where('totalReviews', isGreaterThanOrEqualTo: 3) // Mínimo 3 reseñas
          .orderBy('averageRating', descending: true)
          .limit(limit);

      final snapshot = await query.get();
      final ratings = snapshot.docs
          .map((doc) =>
              UserRatingEntity.fromJson({...doc.data(), 'userId': doc.id}))
          .toList();

      return Right(ratings);
    } catch (e) {
      return Left(
          ServerFailure('Error al obtener top usuarios: ${e.toString()}'));
    }
  }

  // ==================== MODERACIÓN ====================

  @override
  Future<Either<Failure, List<ReviewEntity>>> getPendingReviews({
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      var query = firestore
          .collection(reviewsCollection)
          .where('status',
              isEqualTo: ReviewStatus.pending.toString().split('.').last)
          .orderBy('createdAt', descending: false) // Más antiguos primero
          .limit(limit);

      if (lastDocumentId != null) {
        final lastDoc = await firestore
            .collection(reviewsCollection)
            .doc(lastDocumentId)
            .get();
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      final snapshot = await query.get();
      final reviews = snapshot.docs
          .map((doc) => ReviewEntity.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      return Right(reviews);
    } catch (e) {
      return Left(ServerFailure(
          'Error al obtener reseñas pendientes: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> approveReview(String reviewId) async {
    try {
      await firestore.collection(reviewsCollection).doc(reviewId).update({
        'status': ReviewStatus.approved.toString().split('.').last,
      });

      return Right(null);
    } catch (e) {
      return Left(ServerFailure('Error al aprobar reseña: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> rejectReview({
    required String reviewId,
    required String reason,
  }) async {
    try {
      await firestore.collection(reviewsCollection).doc(reviewId).update({
        'status': ReviewStatus.rejected.toString().split('.').last,
        'rejectionReason': reason,
        'rejectedAt': DateTime.now().toIso8601String(),
      });

      return Right(null);
    } catch (e) {
      return Left(ServerFailure('Error al rechazar reseña: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> flagReview({
    required String reviewId,
    required String reason,
  }) async {
    try {
      await firestore.collection(reviewsCollection).doc(reviewId).update({
        'status': ReviewStatus.flagged.toString().split('.').last,
        'flagReason': reason,
        'flaggedAt': DateTime.now().toIso8601String(),
      });

      return Right(null);
    } catch (e) {
      return Left(ServerFailure('Error al marcar reseña: ${e.toString()}'));
    }
  }

  // ==================== ANALYTICS ====================

  @override
  Future<Either<Failure, Map<String, dynamic>>> getReviewMetrics() async {
    try {
      final metricsDoc =
          await firestore.collection('analytics').doc('review_metrics').get();

      if (!metricsDoc.exists) {
        return Right(<String, dynamic>{});
      }

      return Right(metricsDoc.data()!);
    } catch (e) {
      return Left(ServerFailure('Error al obtener métricas: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<int, int>>> getRatingDistribution() async {
    try {
      final distributionDoc = await firestore
          .collection('analytics')
          .doc('rating_distribution')
          .get();

      if (!distributionDoc.exists) {
        return Right(<int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0});
      }

      final data = distributionDoc.data()!;
      final distribution = <int, int>{};

      for (int i = 1; i <= 5; i++) {
        distribution[i] = data[i.toString()] ?? 0;
      }

      return Right(distribution);
    } catch (e) {
      return Left(
          ServerFailure('Error al obtener distribución: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getReviewTrends({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final trendsQuery = await firestore
          .collection(reviewsCollection)
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      final reviews = trendsQuery.docs
          .map((doc) => ReviewEntity.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Calcular tendencias
      final totalReviews = reviews.length;
      final averageRating = reviews.isEmpty
          ? 0.0
          : reviews.fold<double>(0, (sum, r) => sum + r.rating) /
              reviews.length;

      final dailyReviews = <String, int>{};
      final dailyAverages = <String, double>{};

      for (final review in reviews) {
        final dateKey = review.createdAt.toIso8601String().split('T')[0];
        dailyReviews[dateKey] = (dailyReviews[dateKey] ?? 0) + 1;

        final currentAvg = dailyAverages[dateKey] ?? 0.0;
        final currentCount = dailyReviews[dateKey]!;
        dailyAverages[dateKey] =
            ((currentAvg * (currentCount - 1)) + review.rating) / currentCount;
      }

      return Right({
        'totalReviews': totalReviews,
        'averageRating': averageRating,
        'dailyReviews': dailyReviews,
        'dailyAverages': dailyAverages,
        'period': {
          'start': startDate.toIso8601String(),
          'end': endDate.toIso8601String(),
        },
      });
    } catch (e) {
      return Left(
          ServerFailure('Error al obtener tendencias: ${e.toString()}'));
    }
  }

  // ==================== MÉTODOS PRIVADOS ====================

  Future<void> _updateReviewStats(ReviewEntity review) async {
    try {
      // Actualizar estadísticas del usuario revisado
      await firestore
          .collection(reviewStatsCollection)
          .doc(review.reviewedUserId)
          .set({
        'totalReviews': FieldValue.increment(1),
        'lastReviewDate': review.createdAt.toIso8601String(),
        'ratingSum': FieldValue.increment(review.rating),
      }, SetOptions(merge: true));

      // Actualizar métricas globales
      await firestore.collection('analytics').doc('review_metrics').set({
        'totalReviews': FieldValue.increment(1),
        'lastUpdated': DateTime.now().toIso8601String(),
        'ratingSum': FieldValue.increment(review.rating),
      }, SetOptions(merge: true));

      // Actualizar distribución de ratings
      await firestore.collection('analytics').doc('rating_distribution').set({
        review.rating.round().toString(): FieldValue.increment(1),
      }, SetOptions(merge: true));
    } catch (e) {
      // Log error but don't fail the main operation
      if (kDebugMode) {
        print('Error updating review stats: $e');
      }
    }
  }

  Future<void> _removeReviewFromStats(ReviewEntity review) async {
    try {
      // Restar de estadísticas del usuario
      await firestore
          .collection(reviewStatsCollection)
          .doc(review.reviewedUserId)
          .update({
        'totalReviews': FieldValue.increment(-1),
        'ratingSum': FieldValue.increment(-review.rating),
      });

      // Restar de métricas globales
      await firestore.collection('analytics').doc('review_metrics').update({
        'totalReviews': FieldValue.increment(-1),
        'ratingSum': FieldValue.increment(-review.rating),
        'lastUpdated': DateTime.now().toIso8601String(),
      });

      // Restar de distribución de ratings
      await firestore
          .collection('analytics')
          .doc('rating_distribution')
          .update({
        review.rating.round().toString(): FieldValue.increment(-1),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error removing review from stats: $e');
      }
    }
  }
}

// Custom exception classes
class ValidationFailure extends Failure {
  ValidationFailure(super.message);
}

class NotFoundFailure extends Failure {
  NotFoundFailure(super.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}
