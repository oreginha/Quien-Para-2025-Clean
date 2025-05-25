// lib/domain/usecases/maps/get_current_location_usecase.dart

import 'package:quien_para/domain/entities/location_entity.dart';
import 'package:quien_para/domain/repositories/maps/maps_repository.dart';

/// Caso de uso para obtener la ubicación actual del usuario
class GetCurrentLocationUseCase {
  /// Repositorio de mapas
  final MapsRepository _mapsRepository;

  /// Constructor
  GetCurrentLocationUseCase(this._mapsRepository);

  /// Ejecutar el caso de uso
  Future<LocationEntity> execute() {
    return _mapsRepository.getCurrentLocation();
  }
}
