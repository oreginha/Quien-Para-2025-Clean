// lib/domain/usecases/maps/get_directions_usecase.dart

import 'package:quien_para/domain/entities/location_entity.dart';
import 'package:quien_para/domain/repositories/maps/maps_repository.dart';

/// Caso de uso para obtener direcciones entre dos ubicaciones
class GetDirectionsUseCase {
  /// Repositorio de mapas
  final MapsRepository _mapsRepository;

  /// Constructor
  GetDirectionsUseCase(this._mapsRepository);

  /// Ejecutar el caso de uso
  ///
  /// [origin] - Ubicación de origen
  /// [destination] - Ubicación de destino
  /// [mode] - Modo de transporte (driving, walking, bicycling, transit)
  Future<Map<String, dynamic>> execute(
    LocationEntity origin,
    LocationEntity destination, {
    String mode = 'driving',
  }) {
    return _mapsRepository.getDirections(origin, destination, mode: mode);
  }
}
