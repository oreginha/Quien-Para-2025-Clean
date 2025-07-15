import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/plan/plan_with_creator_entity.dart';
import '../../repositories/plan/plan_repository.dart';

class GetNearbyPlansUseCase {
  final PlanRepository repository;

  GetNearbyPlansUseCase(this.repository);

  Future<Either<Failure, List<PlanWithCreatorEntity>>> execute({
    required double latitude,
    required double longitude,
    required double radiusKm,
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      // Validar coordenadas
      if (latitude < -90 || latitude > 90) {
        return Left(ValidationFailure(message: 'Invalid latitude: $latitude'));
      }
      
      if (longitude < -180 || longitude > 180) {
        return Left(ValidationFailure(message: 'Invalid longitude: $longitude'));
      }
      
      if (radiusKm <= 0) {
        return Left(ValidationFailure(message: 'Radius must be greater than 0'));
      }

      // Usar el método del repositorio para filtros geográficos
      return await repository.filterPlansByLocation(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
        limit: limit,
        lastDocumentId: lastDocumentId,
      );
    } catch (e) {
      return Left(DatabaseFailure(message: 'Error getting nearby plans: $e'));
    }
  }

  /// Método de conveniencia para obtener planes en un radio específico desde una ciudad
  Future<Either<Failure, List<PlanWithCreatorEntity>>> executeFromCity({
    required String cityName,
    required double radiusKm,
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      // Primero obtener las coordenadas de la ciudad
      final coordinatesResult = await repository.getCityCoordinates(cityName);
      
      return coordinatesResult.fold(
        (failure) => Left(failure),
        (coordinates) async {
          final latitude = coordinates['latitude'] as double;
          final longitude = coordinates['longitude'] as double;
          
          return await execute(
            latitude: latitude,
            longitude: longitude,
            radiusKm: radiusKm,
            limit: limit,
            lastDocumentId: lastDocumentId,
          );
        },
      );
    } catch (e) {
      return Left(DatabaseFailure(message: 'Error getting plans from city: $e'));
    }
  }
}
