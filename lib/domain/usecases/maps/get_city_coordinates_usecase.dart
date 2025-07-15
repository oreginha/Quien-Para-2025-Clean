import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/plan/plan_repository.dart';

class GetCityCoordinatesUseCase {
  final PlanRepository repository;

  GetCityCoordinatesUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> execute(String cityName) async {
    try {
      if (cityName.trim().isEmpty) {
        return Left(ValidationFailure(message: 'City name cannot be empty'));
      }

      return await repository.getCityCoordinates(cityName.trim());
    } catch (e) {
      return Left(DatabaseFailure(message: 'Error getting city coordinates: $e'));
    }
  }
}
