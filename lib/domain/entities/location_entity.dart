// lib/domain/entities/location_entity.dart

import 'package:equatable/equatable.dart';

/// Entidad que representa una ubicación geográfica
class LocationEntity extends Equatable {
  /// Latitud de la ubicación
  final double latitude;

  /// Longitud de la ubicación
  final double longitude;

  /// Nombre de la ubicación (opcional)
  final String? name;

  /// Dirección completa (opcional)
  final String? address;

  /// Código postal (opcional)
  final String? postalCode;

  /// Ciudad (opcional)
  final String? city;

  /// País (opcional)
  final String? country;

  /// Constructor principal
  const LocationEntity({
    required this.latitude,
    required this.longitude,
    this.name,
    this.address,
    this.postalCode,
    this.city,
    this.country,
  });

  /// Constructor para crear una ubicación a partir de un mapa
  factory LocationEntity.fromJson(Map<String, dynamic> json) {
    return LocationEntity(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      name: json['name'] as String?,
      address: json['address'] as String?,
      postalCode: json['postalCode'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
    );
  }

  /// Convertir la entidad a un mapa
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (postalCode != null) 'postalCode': postalCode,
      if (city != null) 'city': city,
      if (country != null) 'country': country,
    };
  }

  /// Crear una copia con algunos valores modificados
  LocationEntity copyWith({
    double? latitude,
    double? longitude,
    String? name,
    String? address,
    String? postalCode,
    String? city,
    String? country,
  }) {
    return LocationEntity(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      name: name ?? this.name,
      address: address ?? this.address,
      postalCode: postalCode ?? this.postalCode,
      city: city ?? this.city,
      country: country ?? this.country,
    );
  }

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    name,
    address,
    postalCode,
    city,
    country,
  ];

  @override
  String toString() =>
      'LocationEntity(latitude: $latitude, longitude: $longitude, name: $name)';
}
