// lib/data/repositories/user_repository_cached_impl.dart
// ignore_for_file: always_specify_types

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/core/utils/firebase_crud_helper.dart';
import 'package:quien_para/data/datasources/local/user_cache.dart';
import 'package:quien_para/data/mappers/user_mapper.dart';
import 'package:quien_para/domain/entities/user/user_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/user/user_repository_interface.dart';

/// Implementación del repositorio de usuarios que utiliza caché
class UserRepositoryImpl implements IUserRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;
  final UserCache _cache;
  final UserMapper _mapper;
  final Logger _logger;

  UserRepositoryImpl({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required FirebaseAuth auth,
    required UserCache cache,
    required UserMapper mapper,
    Logger? logger,
  })  : _firestore = firestore,
        _storage = storage,
        _auth = auth,
        _cache = cache,
        _mapper = mapper,
        _logger = logger ?? Logger();

  @override
  Either<AppFailure, String?> getCurrentUserId() {
    try {
      // Implementación mejorada para obtener el ID de usuario
      final User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        _logger.d('Usuario autenticado encontrado: ${currentUser.uid}');
        return Right(currentUser.uid);
      }

      // Intento adicional para plataforma web
      if (kIsWeb) {
        _logger.d('Intentando recuperar UID desde estado web...');
        // Esta información vendría del JS Bridge
        return const Right(null);
      }

      _logger.d('Usuario no autenticado');
      return const Right(null);
    } catch (e) {
      _logger.e('Error fatal al obtener el ID del usuario: $e');
      return Left(AuthFailure(
          message: 'Error al obtener el ID del usuario: $e',
          code: 'get-user-id-error'));
    }
  }

  @override
  Future<Either<AppFailure, List<String>>> uploadUserPhotos(
      final List<File> photos) async {
    if (photos.isEmpty) return const Right(<String>[]);

    // Obtener el ID del usuario
    String? userId;

    // Intentar obtener el ID varias veces si es necesario
    for (int i = 0; i < 3; i++) {
      final result = getCurrentUserId();
      userId = result.fold((failure) => null, (id) => id);
      if (userId != null) break;
      // Esperar un momento antes de reintentar
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }

    if (userId == null) {
      _logger.d('Error de autenticación - Estado actual:');
      _logger.d('Auth actual: ${_auth.currentUser}');
      _logger.d('Auth state: ${await _auth.authStateChanges().first}');
      return Left(AuthFailure(
          message: 'Usuario no autenticado después de varios intentos',
          code: 'auth-user-null'));
    }

    final List<String> photoUrls = <String>[];

    for (File photo in photos) {
      try {
        final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final Reference ref =
            _storage.ref().child('user_photos').child(userId).child(fileName);

        // Metadata con información adicional
        final SettableMetadata metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: <String, String>{
            'userId': userId,
            'timestamp': DateTime.now().toString(),
          },
        );

        // Subir el archivo con metadata
        final TaskSnapshot uploadTask = await ref.putFile(photo, metadata);

        // Verificar si la subida fue exitosa
        if (uploadTask.state == TaskState.success) {
          final String downloadUrl = await ref.getDownloadURL();
          photoUrls.add(downloadUrl);
          _logger.d('Foto subida exitosamente: $fileName');
        } else {
          _logger.d('Error en la subida - Estado: ${uploadTask.state}');
          throw Exception('Error al subir la foto: estado incorrecto');
        }
      } catch (e) {
        _logger.d('Error detallado al subir foto: $e');
        return Left(DatabaseFailure(
            message: 'Error al subir la foto: $e', code: 'upload-photo-error'));
      }
    }

    return Right(photoUrls);
  }

  @override
  Future<Either<AppFailure, UserEntity?>> getUserProfile() async {
    try {
      // Primero verificar en el caché
      if (_cache.isAvailable) {
        final cachedUser = await _cache.getCachedCurrentUser();
        if (cachedUser != null) {
          _logger.d('Obtenido perfil de usuario desde caché');
          return Right(cachedUser);
        }
      }

      // Si no está en caché o la caché no está disponible, obtenerlo de Firestore
      final Either<AppFailure, String?> idResult = getCurrentUserId();
      final String userId = idResult.fold((failure) => '', (id) => id ?? '');

      // Si no hay ID de usuario, no podemos continuar
      if (userId.isEmpty) {
        return Left(AuthFailure(
            message: 'No se pudo obtener el ID del usuario',
            code: 'user-id-null'));
      }

      // Obtener el documento del usuario de forma segura
      final docSnapshot = await FirebaseCrudHelper.getDocumentSafely(
        _firestore,
        'users',
        userId,
      );

      if (docSnapshot == null || !docSnapshot.exists) {
        return const Right(null);
      }

      final UserEntity userEntity = _mapper.fromFirestore(docSnapshot);

      // Guardar en caché
      if (_cache.isAvailable) {
        await _cache.cacheCurrentUser(userEntity);
      }

      return Right(userEntity);
    } catch (e, stackTrace) {
      _logger.e('Error obteniendo perfil de usuario: $e');
      return Left(FailureHelper.fromException(e, stackTrace));
    }
  }

  @override
  Future<Either<AppFailure, UserEntity?>> getUserProfileById(
      String userId) async {
    try {
      // Primero verificar en el caché
      if (_cache.isAvailable) {
        final cachedUser = await _cache.getCachedUser(userId);
        if (cachedUser != null) {
          _logger.d('Obtenido perfil de usuario por ID desde caché: $userId');
          return Right(cachedUser);
        }
      }

      // Obtener el documento del usuario de forma segura
      final docSnapshot = await FirebaseCrudHelper.getDocumentSafely(
        _firestore,
        'users',
        userId,
      );

      if (docSnapshot == null || !docSnapshot.exists) {
        return const Right(null);
      }

      final UserEntity userEntity = _mapper.fromFirestore(docSnapshot);

      // Guardar en caché
      if (_cache.isAvailable) {
        await _cache.cacheUser(userEntity);
      }

      return Right(userEntity);
    } catch (e, stackTrace) {
      _logger.e('Error obteniendo perfil de usuario por ID: $e');
      return Left(FailureHelper.fromException(e, stackTrace));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> saveUserProfile(UserEntity user) async {
    try {
      // Convertir la entidad a un formato adecuado para Firestore
      final Map<String, dynamic> userData = _mapper.toFirestore(user);

      // Obtener el ID del usuario actual o del usuario a guardar
      final String userId = user.id;
      if (userId.isEmpty) {
        final Either<AppFailure, String?> idResult = getCurrentUserId();
        final String? currentUserId =
            idResult.fold((failure) => null, (id) => id);

        if (currentUserId == null) {
          return Left(AuthFailure(
              message: 'Usuario no autenticado', code: 'auth-error'));
        }
      }

      // Guardar en Firestore usando el helper
      final success = await FirebaseCrudHelper.createDocumentSafely(
        _firestore,
        'users',
        userData,
        documentId: userId,
      );

      if (success == null) {
        return Left(DatabaseFailure(
            message: 'Error al guardar el perfil del usuario',
            code: 'save-profile-error'));
      }

      // Actualizar la caché
      if (_cache.isAvailable) {
        await _cache.cacheUser(user);

        // Si es el perfil del usuario actual, actualizar también esa caché
        final String? currentUserId = _auth.currentUser?.uid;
        if (currentUserId == userId) {
          await _cache.cacheCurrentUser(user);
        }
      }

      return const Right(unit);
    } catch (e, stackTrace) {
      _logger.e('Error al guardar perfil: $e');
      return Left(FailureHelper.fromException(e, stackTrace));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> updateUserInterests(
      String userId, List<String> interests) async {
    try {
      final success = await FirebaseCrudHelper.updateDocumentSafely(
        _firestore,
        'users',
        userId,
        {
          'interests': interests,
          'updatedAt': FieldValue.serverTimestamp(),
          'hasCompletedOnboarding': interests.isNotEmpty,
        },
      );

      if (!success) {
        return Left(DatabaseFailure(
            message: 'Error al actualizar intereses',
            code: 'update-interests-error'));
      }

      // Invalidar la caché para este usuario
      if (_cache.isAvailable) {
        await _cache.invalidateUserCache(userId);

        // Si es el usuario actual, invalidar esa caché también
        final String? currentUserId = _auth.currentUser?.uid;
        if (currentUserId == userId) {
          await _cache.invalidateCurrentUserCache();
        }
      }

      return const Right(unit);
    } catch (e, stackTrace) {
      _logger.e('Error actualizando intereses: $e');
      return Left(FailureHelper.fromException(e, stackTrace));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> updateUserLocation(
      String userId, String location) async {
    try {
      final success = await FirebaseCrudHelper.updateDocumentSafely(
        _firestore,
        'users',
        userId,
        {
          'location': location,
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );

      if (!success) {
        return Left(DatabaseFailure(
            message: 'Error al actualizar ubicación',
            code: 'update-location-error'));
      }

      // Invalidar la caché para este usuario
      if (_cache.isAvailable) {
        await _cache.invalidateUserCache(userId);

        // Si es el usuario actual, invalidar esa caché también
        final String? currentUserId = _auth.currentUser?.uid;
        if (currentUserId == userId) {
          await _cache.invalidateCurrentUserCache();
        }
      }

      return const Right(unit);
    } catch (e, stackTrace) {
      _logger.e('Error actualizando ubicación: $e');
      return Left(FailureHelper.fromException(e, stackTrace));
    }
  }

  @override
  Future<Either<AppFailure, bool>> hasCompletedOnboarding(String userId) async {
    try {
      // Intentar obtener de caché primero
      if (_cache.isAvailable) {
        final cachedUser = await _cache.getCachedUser(userId);
        if (cachedUser != null && cachedUser.interests != null) {
          return Right(cachedUser.interests!.isNotEmpty);
        }
      }

      final docSnapshot = await FirebaseCrudHelper.getDocumentSafely(
        _firestore,
        'users',
        userId,
      );

      if (docSnapshot == null || !docSnapshot.exists) {
        return const Right(false);
      }

      final data = docSnapshot.data();
      final bool hasCompleted = data?['hasCompletedOnboarding'] ?? false;

      return Right(hasCompleted);
    } catch (e, stackTrace) {
      _logger.e('Error verificando estado de onboarding: $e');
      return Left(FailureHelper.fromException(e, stackTrace));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> blockUser(
      {required String blockerId, required String blockedUserId}) {
    // TODO: implement blockUser
    throw UnimplementedError();
  }

  @override
  Future<Either<AppFailure, List<String>>> getBlockedUsers(String userId) {
    // TODO: implement getBlockedUsers
    throw UnimplementedError();
  }

  @override
  Future<Either<AppFailure, bool>> isUserBlocked(
      {required String userId, required String targetUserId}) {
    // TODO: implement isUserBlocked
    throw UnimplementedError();
  }
}
