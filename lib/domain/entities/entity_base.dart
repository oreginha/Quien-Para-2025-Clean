// lib/domain/entities/entity_base.dart

import 'package:equatable/equatable.dart';

/// Clase base para todas las entidades del dominio
/// Proporciona propiedades y métodos comunes a todas las entidades
abstract class EntityBase extends Equatable {
  /// Identificador único de la entidad
  final String id;
  
  /// Constructor con parámetros requeridos
  const EntityBase({required this.id});
  
  /// Las entidades de dominio no deben preocuparse por la serialización
  /// Esto se delega a los Mappers.
  
  @override
  List<Object?> get props => [id];
  
  @override
  String toString() => '${runtimeType.toString()}{id: $id}';
  
  /// Método para comprobar si la entidad está vacía o es inválida
  /// Cada subclase debe implementar esta lógica según sus requisitos
  bool get isEmpty;
  
  /// Método para comprobar si la entidad tiene todos los campos requeridos
  /// Cada subclase debe implementar esta lógica según sus requisitos
  bool get isValid;
}
