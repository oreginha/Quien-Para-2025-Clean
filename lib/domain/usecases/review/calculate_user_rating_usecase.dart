import 'package:dartz/dartz.dart';
import 'package:quien_para/presentation/widgets/errors/failures.dart';
import '../../entities/review/review_entity.dart';
import '../../repositories/review/review_repository.dart';

class CalculateUserRatingUseCase {
  final IReviewRepository repository;

  CalculateUserRatingUseCase(this.repository);

  Future<Either<Failure, UserRatingCalculationResult>> call(
    CalculateUserRatingParams params,
  ) async {
    // Validaciones
    if (params.userId.isEmpty) {
      return Left(ValidationFailure('ID de usuario requerido'));
    }

    try {
      // Obtener rating actual del usuario
      final currentRatingResult = await repository.getUserRating(params.userId);
      UserRatingEntity? currentRating;

      if (currentRatingResult.isRight()) {
        currentRating = (currentRatingResult as Right).value;
      }

      // Si se solicita recálculo completo, hacerlo
      if (params.forceRecalculation) {
        final recalculatedResult = await repository.recalculateUserRating(
          params.userId,
        );

        if (recalculatedResult.isLeft()) {
          return Left((recalculatedResult as Left).value);
        }

        final newRating = (recalculatedResult as Right).value;

        return Right(
          UserRatingCalculationResult(
            previousRating: currentRating,
            newRating: newRating,
            changeInRating: currentRating != null
                ? newRating.averageRating - currentRating.averageRating
                : newRating.averageRating,
            isImprovement: currentRating != null
                ? newRating.averageRating > currentRating.averageRating
                : true,
            recalculated: true,
          ),
        );
      }

      // Si hay nueva calificación, actualizar incrementalmente
      if (params.newRating != null) {
        await repository.updateUserRating(
          userId: params.userId,
          newRating: params.newRating!,
          reviewType: params.reviewType ?? ReviewType.general,
        );

        // Obtener el rating actualizado
        final updatedRatingResult = await repository.getUserRating(
          params.userId,
        );

        if (updatedRatingResult.isLeft()) {
          return Left((updatedRatingResult as Left).value);
        }

        final updatedRating = (updatedRatingResult as Right).value;

        return Right(
          UserRatingCalculationResult(
            previousRating: currentRating,
            newRating: updatedRating,
            changeInRating: currentRating != null
                ? updatedRating.averageRating - currentRating.averageRating
                : updatedRating.averageRating,
            isImprovement: currentRating != null
                ? updatedRating.averageRating > currentRating.averageRating
                : true,
            recalculated: false,
          ),
        );
      }

      // Solo devolver rating actual sin cambios
      if (currentRating != null) {
        return Right(
          UserRatingCalculationResult(
            previousRating: null,
            newRating: currentRating,
            changeInRating: 0.0,
            isImprovement: false,
            recalculated: false,
          ),
        );
      }

      return Left(NotFoundFailure('Rating de usuario no encontrado'));
    } catch (e) {
      return Left(ServerFailure('Error al calcular rating: ${e.toString()}'));
    }
  }

  /// Método de conveniencia para obtener solo el rating actual
  Future<Either<Failure, UserRatingEntity>> getCurrentRating(
    String userId,
  ) async {
    if (userId.isEmpty) {
      return Left(ValidationFailure('ID de usuario requerido'));
    }

    return await repository.getUserRating(userId);
  }

  /// Método para comparar ratings de múltiples usuarios
  Future<Either<Failure, List<UserRatingComparison>>> compareUsers(
    List<String> userIds,
  ) async {
    if (userIds.isEmpty) {
      return Left(ValidationFailure('Lista de usuarios requerida'));
    }

    if (userIds.length > 20) {
      return Left(ValidationFailure('Máximo 20 usuarios para comparar'));
    }

    try {
      final comparisons = <UserRatingComparison>[];

      for (final userId in userIds) {
        final ratingResult = await repository.getUserRating(userId);

        if (ratingResult.isRight()) {
          final rating = (ratingResult as Right).value;
          comparisons.add(
            UserRatingComparison(
              userId: userId,
              rating: rating,
              rank: 0, // Se calculará después
            ),
          );
        }
      }

      // Ordenar por rating y asignar ranks
      comparisons.sort(
        (a, b) => b.rating.averageRating.compareTo(a.rating.averageRating),
      );

      for (int i = 0; i < comparisons.length; i++) {
        comparisons[i] = comparisons[i].copyWith(rank: i + 1);
      }

      return Right(comparisons);
    } catch (e) {
      return Left(ServerFailure('Error al comparar ratings: ${e.toString()}'));
    }
  }
}

class CalculateUserRatingParams {
  final String userId;
  final double? newRating;
  final ReviewType? reviewType;
  final bool forceRecalculation;

  CalculateUserRatingParams({
    required this.userId,
    this.newRating,
    this.reviewType,
    this.forceRecalculation = false,
  });
}

class UserRatingCalculationResult {
  final UserRatingEntity? previousRating;
  final UserRatingEntity newRating;
  final double changeInRating;
  final bool isImprovement;
  final bool recalculated;

  UserRatingCalculationResult({
    this.previousRating,
    required this.newRating,
    required this.changeInRating,
    required this.isImprovement,
    required this.recalculated,
  });

  // Métodos de conveniencia
  bool get hasSignificantChange => changeInRating.abs() >= 0.1;

  String get changeDescription {
    if (changeInRating == 0) return 'Sin cambios';
    if (changeInRating > 0) {
      return 'Mejoró ${changeInRating.toStringAsFixed(1)} puntos';
    }
    return 'Bajó ${changeInRating.abs().toStringAsFixed(1)} puntos';
  }

  String get performanceLevel {
    return newRating.ratingLevel;
  }
}

class UserRatingComparison {
  final String userId;
  final UserRatingEntity rating;
  final int rank;

  UserRatingComparison({
    required this.userId,
    required this.rating,
    required this.rank,
  });

  UserRatingComparison copyWith({
    String? userId,
    UserRatingEntity? rating,
    int? rank,
  }) {
    return UserRatingComparison(
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      rank: rank ?? this.rank,
    );
  }

  bool get isTopRated => rank <= 3;
  bool get isHighPerformer => rating.averageRating >= 4.0;
}

// Exception classes
class ValidationFailure extends Failure {
  ValidationFailure(super.message);
}

class NotFoundFailure extends Failure {
  NotFoundFailure(super.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}
