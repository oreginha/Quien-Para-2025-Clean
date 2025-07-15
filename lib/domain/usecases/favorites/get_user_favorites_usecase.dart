import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/plan_entity.dart';
import '../../repositories/plan_repository.dart';

class GetUserFavoritesUseCase {
  final PlanRepository repository;

  GetUserFavoritesUseCase(this.repository);

  Future<Either<Failure, List<PlanWithCreatorEntity>>> execute({
    required String userId,
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      return await repository.getUserFavorites(
        userId: userId,
        limit: limit,
        lastDocumentId: lastDocumentId,
      );
    } catch (e) {
      return Left(DatabaseFailure(message: 'Error getting user favorites: $e'));
    }
  }
}
