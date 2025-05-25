import 'package:dartz/dartz.dart';
import 'package:quien_para/presentation/widgets/errors/failures.dart';
import '../../entities/review/review_entity.dart';
import '../../repositories/review/review_repository.dart';

class CreateReviewUseCase {
  final IReviewRepository repository;

  CreateReviewUseCase(this.repository);

  Future<Either<Failure, String>> call(CreateReviewParams params) async {
    // Validaciones
    if (params.rating < 1.0 || params.rating > 5.0) {
      return Left(ValidationFailure('La calificación debe estar entre 1 y 5'));
    }

    if (params.comment.trim().length < 10) {
      return Left(
          ValidationFailure('El comentario debe tener al menos 10 caracteres'));
    }

    if (params.comment.trim().length > 500) {
      return Left(
          ValidationFailure('El comentario no puede exceder 500 caracteres'));
    }

    if (params.reviewerId == params.reviewedUserId) {
      return Left(
          ValidationFailure('No puedes escribir una reseña de ti mismo'));
    }

    // Verificar si el usuario puede escribir esta reseña
    final canReview = await repository.canUserReviewPlan(
      userId: params.reviewerId,
      planId: params.planId,
      targetUserId: params.reviewedUserId,
    );

    if (canReview.isLeft()) {
      return Left((canReview as Left).value);
    }

    if (!(canReview as Right).value) {
      return Left(ValidationFailure(
          'No puedes escribir una reseña para este usuario/plan'));
    }

    // Crear la entidad de reseña
    final review = ReviewEntity(
      id: '', // Se generará en el repositorio
      reviewerId: params.reviewerId,
      reviewedUserId: params.reviewedUserId,
      planId: params.planId,
      rating: params.rating,
      comment: params.comment.trim(),
      createdAt: DateTime.now(),
      type: params.type,
      status: ReviewStatus.pending, // Todas las reseñas inician como pendientes
      metadata: {
        'planTitle': params.planTitle,
        'planDate': params.planDate?.toIso8601String(),
        'reviewerRole': params.reviewerRole,
      },
    );

    // Crear la reseña
    final result = await repository.createReview(review);

    if (result.isRight()) {
      // Actualizar el rating del usuario automáticamente
      await repository.updateUserRating(
        userId: params.reviewedUserId,
        newRating: params.rating,
        reviewType: params.type,
      );
    }

    return result;
  }
}

class CreateReviewParams {
  final String reviewerId;
  final String reviewedUserId;
  final String planId;
  final double rating;
  final String comment;
  final ReviewType type;
  final String? planTitle;
  final DateTime? planDate;
  final String? reviewerRole; // 'organizer' | 'attendee'

  CreateReviewParams({
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
}

// Validation Failure class específica para reviews
class ValidationFailure extends Failure {
  ValidationFailure(super.message);
}
