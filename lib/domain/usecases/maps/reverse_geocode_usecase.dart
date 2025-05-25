// lib/domain/usecases/maps/reverse_geocode_usecase.dart

import 'package:quien_para/domain/entities/location_entity.dart';
import 'package:quien_para/domain/repositories/maps/maps_repository.dart';

/// Caso de uso para convertir coordenadas en una dirección
class ReverseGeocodeUseCase {
  /// Repositorio de mapas
  final MapsRepository _mapsRepository;

  /// Constructor
  ReverseGeocodeUseCase(this._mapsRepository);

  /// Ejecutar el caso de uso
  Future<LocationEntity?> execute(double latitude, double longitude) {
    return _mapsRepository.reverseGeocode(latitude, longitude);
  }
}
