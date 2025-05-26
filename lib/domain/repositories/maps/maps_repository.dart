// lib/domain/repositories/maps_repository.dart

import 'package:quien_para/domain/entities/location_entity.dart';

/// Interfaz para el repositorio de mapas
abstract class MapsRepository {
  /// Obtiene la ubicación actual del usuario
  Future<LocationEntity> getCurrentLocation();

  /// Convierte una dirección en coordenadas (geocoding)
  Future<LocationEntity?> geocodeAddress(String address);

  /// Convierte coordenadas en una dirección (reverse geocoding)
  Future<LocationEntity?> reverseGeocode(double latitude, double longitude);

  /// Calcula la distancia entre dos ubicaciones en kilómetros
  Future<double> calculateDistance(
    LocationEntity origin,
    LocationEntity destination,
  );

  /// Busca lugares cercanos según un término de búsqueda
  Future<List<LocationEntity>> searchNearbyPlaces(
    LocationEntity center,
    String query, {
    double radiusInKm = 5.0,
  });

  /// Obtiene direcciones/rutas entre dos puntos
  Future<Map<String, dynamic>> getDirections(
    LocationEntity origin,
    LocationEntity destination, {
    String mode = 'driving',
  });
}
