import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../errors/failures.dart';

class LocationService {
  static LocationService? _instance;
  static LocationService get instance => _instance ??= LocationService._();
  LocationService._();

  /// Obtiene la ubicación actual del usuario
  Future<Either<Failure, Position>> getCurrentLocation() async {
    try {
      // Verificar si el servicio de ubicación está habilitado
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Left(LocationFailure(
          message: 'Los servicios de ubicación están deshabilitados',
        ));
      }

      // Verificar permisos
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Left(LocationFailure(
            message: 'Permisos de ubicación denegados',
          ));
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Left(LocationFailure(
          message: 'Permisos de ubicación denegados permanentemente',
        ));
      }

      // Obtener ubicación
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return Right(position);
    } catch (e) {
      return Left(LocationFailure(message: 'Error obteniendo ubicación: $e'));
    }
  }

  /// Verifica si los permisos de ubicación están concedidos
  Future<bool> hasLocationPermission() async {
    try {
      final permission = await Geolocator.checkPermission();
      return permission == LocationPermission.always ||
             permission == LocationPermission.whileInUse;
    } catch (e) {
      return false;
    }
  }

  /// Solicita permisos de ubicación
  Future<Either<Failure, bool>> requestLocationPermission() async {
    try {
      final permission = await Geolocator.requestPermission();
      
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return Left(LocationFailure(
          message: 'Permisos de ubicación denegados',
        ));
      }

      return const Right(true);
    } catch (e) {
      return Left(LocationFailure(
        message: 'Error solicitando permisos: $e',
      ));
    }
  }

  /// Calcula la distancia entre dos puntos en kilómetros
  double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    ) / 1000; // Convertir metros a kilómetros
  }

  /// Abre la configuración de ubicación del dispositivo
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// Abre la configuración de la aplicación
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  /// Stream de cambios de ubicación
  Stream<Position> getLocationStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10, // metros
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
      ),
    );
  }

  /// Obtiene la última ubicación conocida
  Future<Either<Failure, Position?>> getLastKnownPosition() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      return Right(position);
    } catch (e) {
      return Left(LocationFailure(
        message: 'Error obteniendo última ubicación: $e',
      ));
    }
  }
}

/// Modelo para representar una ubicación
class LocationData {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final DateTime timestamp;
  final String? address;

  const LocationData({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    required this.timestamp,
    this.address,
  });

  factory LocationData.fromPosition(Position position, {String? address}) {
    return LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      timestamp: position.timestamp,
      address: address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'timestamp': timestamp.toIso8601String(),
      'address': address,
    };
  }

  factory LocationData.fromMap(Map<String, dynamic> map) {
    return LocationData(
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      accuracy: map['accuracy']?.toDouble(),
      timestamp: DateTime.parse(map['timestamp']),
      address: map['address'],
    );
  }
}

/// Fallo específico para errores de ubicación
class LocationFailure extends Failure {
  LocationFailure({required String message}) : super(message: message);
}
