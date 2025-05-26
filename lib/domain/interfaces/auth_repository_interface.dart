// lib/domain/repositories/auth_repository_interface.dart

import 'package:quien_para/domain/entities/user/user_entity.dart';

/// Repositorio unificado para autenticación
abstract class AuthRepositoryInterface {
  /// Stream del estado de autenticación
  Stream<bool> get authStateChanges;

  /// Obtiene el usuario autenticado actual
  Future<UserEntity?> getCurrentUser();

  /// Obtiene un usuario por ID
  Future<UserEntity?> getUserById(String userId);

  /// Obtiene el ID del usuario actual
  String? getCurrentUserId();

  /// Verifica si el usuario está autenticado
  bool isAuthenticated();

  /// Iniciar sesión con Google
  Future<UserEntity> signInWithGoogle();

  /// Iniciar sesión con email y contraseña
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);

  /// Registrarse con email y contraseña
  Future<UserEntity> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  );

  /// Cierra la sesión del usuario actual
  Future<void> signOut();

  /// Elimina la cuenta del usuario actual
  Future<void> deleteAccount();

  /// Obtiene los datos del usuario actual
  Future<Map<String, dynamic>?> getCurrentUserData();
}
