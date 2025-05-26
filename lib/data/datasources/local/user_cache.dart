// lib/data/datasources/local/user_cache.dart
// ignore_for_file: always_specify_types

import 'dart:convert';
import 'dart:io';
import '../../../core/logger/logger.dart';
import '../../../domain/entities/user/user_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

/// Clase para manejar la caché de usuarios
class UserCache {
  static const String _usersCacheBox = 'users_cache';
  static const String _lastFetchKey = 'user_last_fetch_time';
  static const String _currentUserCacheKey = 'current_user';
  static const String _usersCachePrefix = 'user_';
  static const Duration _cacheDuration = Duration(minutes: 30);

  static bool _initialized = false;

  /// Inicializar Hive de forma segura
  Future<void> init() async {
    try {
      if (!_initialized) {
        try {
          // Inicializar Hive con un directorio de la aplicación
          final Directory appDir = await getApplicationDocumentsDirectory();
          await Hive.initFlutter(appDir.path);
        } catch (e) {
          // Si path_provider falla, inicializar Hive sin una ruta específica
          logger.w(
            'Path provider no disponible, usando inicialización básica de Hive',
          );
          await Hive.initFlutter();
        }

        // Abrir el box para los usuarios, con manejo de errores
        try {
          await Hive.openBox<dynamic>(_usersCacheBox);
          _initialized = true;
          logger.d('User cache initialized successfully');
        } catch (boxError) {
          logger.e('Error opening Hive box:', error: boxError);
          _initialized = false;
        }
      }
    } catch (e) {
      logger.e('Error initializing user cache:', error: e);
      // Podemos seguir funcionando sin caché
      _initialized = false;
    }
  }

  /// Método para verificar si el cache está disponible
  bool get isAvailable => _initialized;

  /// Guarda el perfil del usuario actual en la caché
  Future<void> cacheCurrentUser(UserEntity user) async {
    if (!isAvailable) {
      logger.w('Cache not available, skipping cacheCurrentUser');
      return;
    }

    try {
      final Box<dynamic> box = Hive.box(_usersCacheBox);

      // Convertir a JSON para almacenamiento
      final Map<String, dynamic> userJson = _userEntityToJson(user);

      await box.put(_currentUserCacheKey, jsonEncode(userJson));
      await box.put(_lastFetchKey, DateTime.now().millisecondsSinceEpoch);

      logger.d('Cached current user profile');
    } catch (e) {
      logger.e('Error caching current user:', error: e);
    }
  }

  /// Obtiene el perfil del usuario actual desde la caché
  Future<UserEntity?> getCachedCurrentUser() async {
    if (!isAvailable) {
      logger.w('Cache not available, returning null from getCachedCurrentUser');
      return null;
    }

    try {
      final Box<dynamic> box = Hive.box(_usersCacheBox);
      final int lastFetchTime = box.get(_lastFetchKey, defaultValue: 0) as int;

      // Verificar si la caché ha expirado
      final int now = DateTime.now().millisecondsSinceEpoch;
      if (now - lastFetchTime > _cacheDuration.inMilliseconds) {
        logger.d('Current user cache expired');
        return null;
      }

      final cachedData = box.get(_currentUserCacheKey);
      if (cachedData == null) {
        return null;
      }

      final Map<String, dynamic> userJson =
          jsonDecode(cachedData as String) as Map<String, dynamic>;
      final UserEntity user = _jsonToUserEntity(userJson);

      logger.d('Retrieved current user from cache');
      return user;
    } catch (e) {
      logger.e('Error retrieving cached current user:', error: e);
      return null;
    }
  }

  /// Guarda el perfil de un usuario específico en la caché
  Future<void> cacheUser(UserEntity user) async {
    if (!isAvailable) {
      logger.w('Cache not available or invalid user, skipping cacheUser');
      return;
    }

    try {
      final Box<dynamic> box = Hive.box(_usersCacheBox);
      final String key = _usersCachePrefix + user.id;

      // Convertir a JSON para almacenamiento
      final Map<String, dynamic> userJson = _userEntityToJson(user);

      await box.put(key, jsonEncode(userJson));
      await box.put('${key}_time', DateTime.now().millisecondsSinceEpoch);

      logger.d('Cached user profile for user ID: ${user.id}');
    } catch (e) {
      logger.e('Error caching user:', error: e);
    }
  }

  /// Obtiene el perfil de un usuario específico desde la caché
  Future<UserEntity?> getCachedUser(String userId) async {
    if (!isAvailable) {
      logger.w('Cache not available, returning null from getCachedUser');
      return null;
    }

    try {
      final Box<dynamic> box = Hive.box(_usersCacheBox);
      final String key = _usersCachePrefix + userId;

      final String? cachedData = box.get(key) as String?;
      final int? timestamp = box.get('${key}_time') as int?;

      if (cachedData == null || timestamp == null) {
        logger.d('No cached user found for user ID: $userId');
        return null;
      }

      // Verificar si los datos están expirados
      final DateTime cachedTime = DateTime.fromMillisecondsSinceEpoch(
        timestamp,
      );
      if (DateTime.now().difference(cachedTime) > _cacheDuration) {
        logger.d('Cached user expired for user ID: $userId');
        return null;
      }

      final Map<String, dynamic> userJson =
          jsonDecode(cachedData) as Map<String, dynamic>;
      final UserEntity user = _jsonToUserEntity(userJson);

      logger.d('Retrieved user from cache for user ID: $userId');
      return user;
    } catch (e) {
      logger.e('Error retrieving cached user:', error: e);
      return null;
    }
  }

  /// Almacena múltiples usuarios en la caché
  Future<void> cacheUsers(List<UserEntity> users) async {
    if (!isAvailable) {
      logger.w('Cache not available, skipping cacheUsers');
      return;
    }

    try {
      final Box<dynamic> box = Hive.box(_usersCacheBox);

      for (final UserEntity user in users) {
        final String key = _usersCachePrefix + user.id;

        // Convertir a JSON para almacenamiento
        final Map<String, dynamic> userJson = _userEntityToJson(user);

        await box.put(key, jsonEncode(userJson));
        await box.put('${key}_time', DateTime.now().millisecondsSinceEpoch);
      }

      logger.d('Cached ${users.length} users');
    } catch (e) {
      logger.e('Error caching users:', error: e);
    }
  }

  /// Invalidar la caché de un usuario específico
  Future<void> invalidateUserCache(String userId) async {
    if (!isAvailable) {
      logger.w('Cache not available, skipping invalidateUserCache');
      return;
    }

    try {
      final Box<dynamic> box = Hive.box(_usersCacheBox);
      final String key = _usersCachePrefix + userId;

      await box.delete(key);
      await box.delete('${key}_time');

      logger.d('Invalidated cache for user ID: $userId');
    } catch (e) {
      logger.e('Error invalidating user cache:', error: e);
    }
  }

  /// Invalidar la caché del usuario actual
  Future<void> invalidateCurrentUserCache() async {
    if (!isAvailable) {
      logger.w('Cache not available, skipping invalidateCurrentUserCache');
      return;
    }

    try {
      final Box<dynamic> box = Hive.box(_usersCacheBox);

      await box.delete(_currentUserCacheKey);
      await box.delete(_lastFetchKey);

      logger.d('Invalidated current user cache');
    } catch (e) {
      logger.e('Error invalidating current user cache:', error: e);
    }
  }

  /// Limpiar toda la caché de usuarios
  Future<void> clearCache() async {
    if (!isAvailable) {
      logger.w('Cache not available, skipping clearCache');
      return;
    }

    try {
      final Box<dynamic> box = Hive.box(_usersCacheBox);
      await box.clear();
      logger.d('User cache cleared successfully');
    } catch (e) {
      logger.e('Error clearing user cache:', error: e);
    }
  }

  /// Invalidar toda la caché o una clave específica
  Future<void> invalidateCache({String? key}) async {
    if (!isAvailable) {
      logger.w('Cache not available, skipping invalidateCache');
      return;
    }

    try {
      final Box<dynamic> box = Hive.box(_usersCacheBox);

      if (key != null) {
        // Invalidar solo la clave específica
        await box.delete(key);
        await box.delete('${key}_time');
        logger.d('Invalidated cache for key: $key');
      } else {
        // Invalidar toda la caché
        await clearCache();
      }
    } catch (e) {
      logger.e('Error invalidating cache:', error: e);
    }
  }

  /// Almacenar una lista de elementos en caché con una clave específica
  Future<void> cacheList(List<dynamic> items, String key) async {
    if (!isAvailable) {
      logger.w('Cache not available, skipping cacheList');
      return;
    }

    try {
      final Box<dynamic> box = Hive.box(_usersCacheBox);

      // Serializar la lista
      final List<Map<String, dynamic>> serializedItems = [];

      for (final item in items) {
        if (item is UserEntity) {
          serializedItems.add(_userEntityToJson(item));
        } else {
          // Si no es UserEntity, intentar convertir directamente
          serializedItems.add(item as Map<String, dynamic>);
        }
      }

      // Guardar en caché
      await box.put(key, jsonEncode(serializedItems));
      await box.put('${key}_time', DateTime.now().millisecondsSinceEpoch);

      logger.d('Cached list with ${items.length} items using key: $key');
    } catch (e) {
      logger.e('Error caching list:', error: e);
    }
  }

  /// Convertir UserEntity a Map para serialización
  Map<String, dynamic> _userEntityToJson(UserEntity user) {
    return {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'photoUrl': user.photoUrl,
      'age': user.age,
      'gender': user.gender,
      'location': user.location,
      'interests': user.interests,
      'photoUrls': user.photoUrls,
      'bio': user.bio,
      'orientation': user.orientation,
      'createdAt': user.createdAt?.toIso8601String(),
      'updatedAt': user.updatedAt?.toIso8601String(),
    };
  }

  /// Convertir Map a UserEntity
  UserEntity _jsonToUserEntity(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      location: json['location'] as String?,
      interests: _parseListString(json['interests']),
      photoUrls: _parseListString(json['photoUrls']),
      bio: json['bio'] as String?,
      orientation: json['orientation'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Convertir listas dinámicas a listas de strings
  List<String>? _parseListString(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    return null;
  }

  Future<List<String>> getAllCacheKeys() async {
    final box = await Hive.openBox<dynamic>('plans_cache');
    return box.keys.cast<String>().toList();
  }

  getCachedList(String key) {}
}
