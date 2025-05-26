// lib/domain/usecases/search/filter_plans_by_location_usecase.dart

import 'package:dartz/dartz.dart';
import '../../entities/failure.dart';
import '../../entities/plan/plan_with_creator_entity.dart';
import '../../repositories/plan/plan_repository.dart';

/// Caso de uso para filtrar planes por ubicación geográfica
///
/// Permite filtrar planes dentro de un radio específico
/// desde una ubicación determinada
class FilterPlansByLocationUseCase {
  final PlanRepository repository;

  const FilterPlansByLocationUseCase(this.repository);

  /// Filtra planes por ubicación
  ///
  /// [latitude] - Latitud del punto central
  /// [longitude] - Longitud del punto central
  /// [radiusKm] - Radio de búsqueda en kilómetros
  /// [limit] - Límite de resultados (por defecto 20)
  /// [lastDocumentId] - Para paginación (opcional)
  ///
  /// Retorna planes dentro del radio especificado
  Future<Either<Failure, List<PlanWithCreatorEntity>>> execute({
    required double latitude,
    required double longitude,
    required double radiusKm,
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      // Validar parámetros
      if (latitude < -90 || latitude > 90) {
        return const Left(
          ValidationFailure('Latitud inválida: debe estar entre -90 y 90'),
        );
      }

      if (longitude < -180 || longitude > 180) {
        return const Left(
          ValidationFailure('Longitud inválida: debe estar entre -180 y 180'),
        );
      }

      if (radiusKm <= 0 || radiusKm > 1000) {
        return const Left(
          ValidationFailure('Radio inválido: debe estar entre 0 y 1000 km'),
        );
      }

      // Ejecutar filtro por ubicación
      final result = await repository.filterPlansByLocation(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
        limit: limit,
        lastDocumentId: lastDocumentId,
      );

      return result;
    } catch (e) {
      return Left(
        ServerFailure(null, 'Error al filtrar por ubicación: ${e.toString()}'),
      );
    }
  }

  /// Obtiene planes cercanos a una ciudad específica
  ///
  /// [cityName] - Nombre de la ciudad
  /// [radiusKm] - Radio de búsqueda en kilómetros
  /// [limit] - Límite de resultados
  Future<Either<Failure, List<PlanWithCreatorEntity>>> executeByCity({
    required String cityName,
    required double radiusKm,
    int limit = 20,
    String? lastDocumentId,
  }) async {
    try {
      if (cityName.trim().isEmpty) {
        return const Left(
          ValidationFailure('El nombre de la ciudad no puede estar vacío'),
        );
      }

      // Obtener coordenadas de la ciudad usando el repositorio
      final coordinatesResult = await repository.getCityCoordinates(
        cityName.trim(),
      );

      return coordinatesResult.fold(
        (failure) => Left(failure),
        (coordinates) => execute(
          latitude: coordinates['latitude'] as double,
          longitude: coordinates['longitude'] as double,
          radiusKm: radiusKm,
          limit: limit,
          lastDocumentId: lastDocumentId,
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(null, 'Error al buscar por ciudad: ${e.toString()}'),
      );
    }
  }
}
