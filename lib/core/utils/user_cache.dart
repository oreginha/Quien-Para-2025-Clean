// lib/core/utils/user_cache.dart

import '../../domain/entities/user/user_entity.dart';

/// Cache para almacenar información de usuarios
class UserCache {
  final Map<String, UserEntity> _cache = {};

  /// Guarda un usuario en el cache
  void put(String id, UserEntity user) {
    _cache[id] = user;
  }

  /// Obtiene un usuario del cache
  UserEntity? get(String id) {
    return _cache[id];
  }

  /// Elimina un usuario del cache
  void remove(String id) {
    _cache.remove(id);
  }

  /// Limpia todo el cache
  void clear() {
    _cache.clear();
  }

  /// Verifica si un usuario está en el cache
  bool contains(String id) {
    return _cache.containsKey(id);
  }

  /// Obtiene todos los usuarios del cache
  List<UserEntity> getAll() {
    return _cache.values.toList();
  }

  /// Actualiza o agrega múltiples usuarios al cache
  void putAll(Map<String, UserEntity> users) {
    _cache.addAll(users);
  }
}
