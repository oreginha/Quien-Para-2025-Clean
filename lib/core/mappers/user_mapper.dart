// lib/core/mappers/user_mapper.dart
// DEPRECATED: Este archivo está obsoleto y será eliminado en futuras versiones.
// Usar import 'package:quien_para/data/mappers/user_mapper.dart'; en su lugar.

import 'package:quien_para/data/mappers/user_mapper.dart' as data_mapper;
import '../../domain/entities/user/user_entity.dart';

/// Mapper para convertir entre diferentes representaciones de usuarios
/// @deprecated Use data/mappers/user_mapper.dart en su lugar
class UserMapper {
  const UserMapper();

  final data_mapper.UserMapper _actualMapper = const data_mapper.UserMapper();

  /// Convierte un mapa de datos a una entidad de usuario
  /// @deprecated Use UserMapper de data/mappers en su lugar
  UserEntity fromMap(Map<String, dynamic> map) {
    return _actualMapper.fromJson(map);
  }

  /// Convierte una entidad de usuario a un mapa de datos
  /// @deprecated Use UserMapper de data/mappers en su lugar
  Map<String, dynamic> toMap(UserEntity user) {
    return _actualMapper.toJson(user);
  }

  /// Convierte una lista de mapas a una lista de entidades
  /// @deprecated Use UserMapper de data/mappers en su lugar
  List<UserEntity> fromMapList(List<Map<String, dynamic>> list) {
    return list.map((map) => fromMap(map)).toList();
  }

  /// Convierte una lista de entidades a una lista de mapas
  /// @deprecated Use UserMapper de data/mappers en su lugar
  List<Map<String, dynamic>> toMapList(List<UserEntity> users) {
    return users.map((user) => toMap(user)).toList();
  }
}
