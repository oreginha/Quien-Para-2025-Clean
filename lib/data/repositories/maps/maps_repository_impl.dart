// lib/data/repositories/maps_repository_impl.dart

// ignore_for_file: unused_field

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' as location_pkg;
import 'package:http/http.dart' as http;
import 'package:quien_para/domain/entities/location_entity.dart';
import 'package:quien_para/domain/repositories/maps/maps_repository.dart';

// Clase auxiliar para LatLng cuando se usa sin Google Maps Flutter
class CustomLatLng {
  final double latitude;
  final double longitude;

  CustomLatLng(this.latitude, this.longitude);
}

/// Implementación concreta del repositorio de mapas
class MapsRepositoryImpl implements MapsRepository {
  /// API Key de Google Maps
  final String apiKey;

  /// Servicio de ubicación
  final location_pkg.Location _locationService = location_pkg.Location();

  /// Cliente HTTP para solicitudes a APIs
  final http.Client _httpClient = http.Client();

  /// Constructor
  MapsRepositoryImpl({required this.apiKey});

  @override
  Future<LocationEntity> getCurrentLocation() async {
    try {
      // Verificar si el servicio de ubicación está habilitado
      final bool serviceEnabled = await _locationService.serviceEnabled();
      if (!serviceEnabled) {
        final bool serviceRequest = await _locationService.requestService();
        if (!serviceRequest) {
          throw Exception('El servicio de ubicación está deshabilitado');
        }
      }

      // Verificar permisos de ubicación
      location_pkg.PermissionStatus permissionStatus = await _locationService
          .hasPermission();
      if (permissionStatus == location_pkg.PermissionStatus.denied) {
        permissionStatus = await _locationService.requestPermission();
        if (permissionStatus != location_pkg.PermissionStatus.granted) {
          throw Exception('Permiso de ubicación denegado');
        }
      }

      // Obtener la ubicación actual
      final location_pkg.LocationData locationData = await _locationService
          .getLocation();

      // Convertir a nuestra entidad
      return LocationEntity(
        latitude: locationData.latitude ?? 0.0,
        longitude: locationData.longitude ?? 0.0,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener la ubicación: $e');
      }
      // Devolver una ubicación predeterminada (Madrid)
      return const LocationEntity(
        latitude: 40.4168,
        longitude: -3.7038,
        name: 'Madrid',
      );
    }
  }

  @override
  Future<LocationEntity?> geocodeAddress(String address) async {
    try {
      final List<geocoding.Location> locations = await geocoding
          .locationFromAddress(address);

      if (locations.isNotEmpty) {
        final location = locations.first;

        // Intentar obtener detalles del lugar
        final List<geocoding.Placemark> placemarks = await geocoding
            .placemarkFromCoordinates(location.latitude, location.longitude);

        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          return LocationEntity(
            latitude: location.latitude,
            longitude: location.longitude,
            name: address,
            address: '${placemark.street}',
            city: placemark.locality,
            postalCode: placemark.postalCode,
            country: placemark.country,
          );
        }

        return LocationEntity(
          latitude: location.latitude,
          longitude: location.longitude,
          name: address,
        );
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error en geocoding: $e');
      }
      return null;
    }
  }

  @override
  Future<LocationEntity?> reverseGeocode(
    double latitude,
    double longitude,
  ) async {
    try {
      final List<geocoding.Placemark> placemarks = await geocoding
          .placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final String name = placemark.name?.isNotEmpty == true
            ? placemark.name!
            : placemark.street?.isNotEmpty == true
            ? placemark.street!
            : 'Ubicación seleccionada';

        return LocationEntity(
          latitude: latitude,
          longitude: longitude,
          name: name,
          address: '${placemark.street}',
          city: placemark.locality,
          postalCode: placemark.postalCode,
          country: placemark.country,
        );
      }
      return LocationEntity(
        latitude: latitude,
        longitude: longitude,
        name: 'Ubicación seleccionada',
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error en reverse geocoding: $e');
      }
      return LocationEntity(
        latitude: latitude,
        longitude: longitude,
        name: 'Ubicación seleccionada',
      );
    }
  }

  @override
  Future<double> calculateDistance(
    LocationEntity origin,
    LocationEntity destination,
  ) async {
    // Implementación simple con la fórmula de Haversine
    const double earthRadius = 6371.0; // Radio de la Tierra en km
    final double lat1 = _toRadians(origin.latitude);
    final double lon1 = _toRadians(origin.longitude);
    final double lat2 = _toRadians(destination.latitude);
    final double lon2 = _toRadians(destination.longitude);

    final double dlon = lon2 - lon1;
    final double dlat = lat2 - lat1;

    final double a =
        math.pow(math.sin(dlat / 2), 2) +
        math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dlon / 2), 2);
    final double c = 2 * math.asin(math.sqrt(a));

    return earthRadius * c; // Distancia en km
  }

  /// Convierte grados a radianes
  double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  @override
  Future<List<LocationEntity>> searchNearbyPlaces(
    LocationEntity center,
    String query, {
    double radiusInKm = 5.0,
  }) async {
    try {
      // NOTA: En una implementación real, esta función usaría la API de Places
      // A continuación se muestra una implementación simulada

      // Simulación de lugares cercanos para propósitos de demostración
      await Future.delayed(const Duration(milliseconds: 500));

      final List<LocationEntity> mockPlaces = [
        LocationEntity(
          latitude: center.latitude + 0.01,
          longitude: center.longitude + 0.01,
          name: 'Café $query',
          address: 'Calle Principal 123',
          city: 'Madrid',
        ),
        LocationEntity(
          latitude: center.latitude - 0.01,
          longitude: center.longitude - 0.01,
          name: 'Restaurante $query',
          address: 'Avenida Central 456',
          city: 'Madrid',
        ),
        LocationEntity(
          latitude: center.latitude + 0.02,
          longitude: center.longitude - 0.02,
          name: 'Tienda $query',
          address: 'Plaza Mayor 789',
          city: 'Madrid',
        ),
      ];

      return mockPlaces;
    } catch (e) {
      if (kDebugMode) {
        print('Error al buscar lugares cercanos: $e');
      }
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getDirections(
    LocationEntity origin,
    LocationEntity destination, {
    String mode = 'driving',
  }) async {
    try {
      // NOTA: En una implementación real, esta función usaría la API de Directions
      // A continuación se muestra una implementación simulada

      await Future.delayed(const Duration(milliseconds: 800));

      // Simular datos de ruta
      final double distanceInKm = await calculateDistance(origin, destination);
      final int durationInMinutes = (distanceInKm * 3)
          .round(); // Estimación simple

      // Generar puntos de la polilinea
      final List<CustomLatLng> points = _generateFakeRoute(
        CustomLatLng(origin.latitude, origin.longitude),
        CustomLatLng(destination.latitude, destination.longitude),
      );

      return {
        'distance': {
          'text': '${distanceInKm.toStringAsFixed(1)} km',
          'value': distanceInKm * 1000, // En metros
        },
        'duration': {
          'text': '$durationInMinutes min',
          'value': durationInMinutes * 60, // En segundos
        },
        'points': points
            .map((p) => {'lat': p.latitude, 'lng': p.longitude})
            .toList(),
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener direcciones: $e');
      }
      return {'error': 'No se pudo calcular la ruta'};
    }
  }

  /// Genera una ruta simulada entre dos puntos
  List<CustomLatLng> _generateFakeRoute(CustomLatLng start, CustomLatLng end) {
    final List<CustomLatLng> points = [start];

    // Generar puntos intermedios
    final int steps = 10;
    for (int i = 1; i < steps; i++) {
      final double fraction = i / steps;

      // Agregar algo de variación a la ruta directa
      final double randomLat = (math.Random().nextDouble() - 0.5) * 0.005;
      final double randomLng = (math.Random().nextDouble() - 0.5) * 0.005;

      final double lat =
          start.latitude +
          (end.latitude - start.latitude) * fraction +
          randomLat;
      final double lng =
          start.longitude +
          (end.longitude - start.longitude) * fraction +
          randomLng;

      points.add(CustomLatLng(lat, lng));
    }

    points.add(end);
    return points;
  }
}
