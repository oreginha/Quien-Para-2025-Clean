import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/plan_repository.dart';

class CheckIfFavoriteUseCase {
  final PlanRepository repository;

  CheckIfFavoriteUseCase(this.repository);

  Future<Either<Failure, bool>> execute({
    required String userId,
    required String planId,
  }) async {
    try {
      return await repository.isFavorite(
        userId: userId,
        planId: planId,
      );
    } catch (e) {
      return Left(DatabaseFailure(message: 'Error checking favorite status: $e'));
    }
  }
}
