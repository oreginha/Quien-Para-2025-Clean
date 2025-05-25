// lib/domain/repositories/user_repository_interface.dart

import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:quien_para/domain/entities/user/user_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';

/// Interfaz mejorada para el repositorio de usuarios
///
/// Implementa un manejo de errores consistente con Either, separa correctamente la
/// gestión de errores y centraliza la lógica de resolución de problemas.
abstract class IUserRepository {
  /// Obtiene el ID del usuario actual
  Either<AppFailure, String?> getCurrentUserId();

  /// Obtiene el perfil del usuario actual
  Future<Either<AppFailure, UserEntity?>> getUserProfile();

  /// Obtiene el perfil de un usuario por su ID
  Future<Either<AppFailure, UserEntity?>> getUserProfileById(String userId);

  /// Guarda el perfil de un usuario
  Future<Either<AppFailure, Unit>> saveUserProfile(UserEntity user);

  /// Sube fotos del usuario
  Future<Either<AppFailure, List<String>>> uploadUserPhotos(List<File> photos);

  /// Actualiza intereses del usuario
  Future<Either<AppFailure, Unit>> updateUserInterests(
      String userId, List<String> interests);

  /// Actualiza la ubicación del usuario
  Future<Either<AppFailure, Unit>> updateUserLocation(
      String userId, String location);

  /// Verifica si el usuario ha completado el onboarding
  Future<Either<AppFailure, bool>> hasCompletedOnboarding(String userId);

  /// Bloquea a un usuario
  Future<Either<AppFailure, Unit>> blockUser({
    required String blockerId,
    required String blockedUserId,
  });

  /// Obtiene la lista de usuarios bloqueados
  Future<Either<AppFailure, List<String>>> getBlockedUsers(String userId);

  /// Verifica si un usuario está bloqueado
  Future<Either<AppFailure, bool>> isUserBlocked({
    required String userId,
    required String targetUserId,
  });
}
