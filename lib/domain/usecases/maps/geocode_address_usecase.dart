// lib/domain/usecases/maps/geocode_address_usecase.dart

import 'package:quien_para/domain/entities/location_entity.dart';
import 'package:quien_para/domain/repositories/maps/maps_repository.dart';

/// Caso de uso para convertir una dirección en coordenadas
class GeocodeAddressUseCase {
  /// Repositorio de mapas
  final MapsRepository _mapsRepository;

  /// Constructor
  GeocodeAddressUseCase(this._mapsRepository);

  /// Ejecutar el caso de uso
  Future<LocationEntity?> execute(String address) {
    return _mapsRepository.geocodeAddress(address);
  }
}
