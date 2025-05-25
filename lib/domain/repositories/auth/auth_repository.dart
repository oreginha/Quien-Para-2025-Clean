import 'dart:async';
import 'package:quien_para/domain/entities/user/user_entity.dart';

/// Interface consolidada para el repositorio de autenticación
/// Combina AuthRepository y AuthRepository para Clean Architecture
abstract class AuthRepository {
  // Métodos fundamentales de autenticación
  Stream<bool> get authStateChanges;
  Future<bool> isAuthenticated();
  String? getCurrentUserId();

  // Métodos para gestión de sesión
  Future<UserEntity?> getCurrentUser();
  Future<UserEntity?> getUserById(String userId);
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);
  Future<UserEntity> signUpWithEmailAndPassword(
      String email, String password, String name);
  Future<Map<String, dynamic>> signInWithGoogle();
  Future<void> signOut();
  Future<void> deleteAccount();

  // Método para obtener datos del usuario actual
  Future<Map<String, dynamic>?> getCurrentUserData();

  // Actualización de datos de usuario
  Future<void> updateUser(UserEntity user);

  // Actualización de campos específicos de usuario
  Future<void> updateUserData(String userId, Map<String, dynamic> data);
}
