import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/plan_entity.dart';
import '../../repositories/plan_repository.dart';

class ToggleFavoriteUseCase {
  final PlanRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<Either<Failure, bool>> execute({
    required String userId,
    required String planId,
  }) async {
    try {
      // Get current favorite status
      final favoriteStatusResult = await repository.isFavorite(
        userId: userId,
        planId: planId,
      );

      return favoriteStatusResult.fold(
        (failure) => Left(failure),
        (isFavorite) async {
          if (isFavorite) {
            // Remove from favorites
            final removeResult = await repository.removeFavorite(
              userId: userId,
              planId: planId,
            );
            return removeResult.fold(
              (failure) => Left(failure),
              (_) => const Right(false), // Not favorite anymore
            );
          } else {
            // Add to favorites
            final addResult = await repository.addFavorite(
              userId: userId,
              planId: planId,
            );
            return addResult.fold(
              (failure) => Left(failure),
              (_) => const Right(true), // Now favorite
            );
          }
        },
      );
    } catch (e) {
      return Left(DatabaseFailure(message: 'Error toggling favorite: $e'));
    }
  }
}
