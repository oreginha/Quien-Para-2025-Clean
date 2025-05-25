import 'package:quien_para/domain/entities/user/user_entity.dart';

/// Interface for authentication data operations
abstract class AuthDataSource {
  /// Get the current user
  Future<UserEntity?> getCurrentUser();

  /// Get user by ID
  Future<UserEntity?> getUserById(String userId);

  /// Sign in with email and password
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);

  /// Sign up with email and password
  Future<UserEntity> signUpWithEmailAndPassword(
      String email, String password, String name);

  /// Sign out the current user
  Future<void> signOut();

  /// Get current user ID
  String? getCurrentUserId();

  /// Check if user is authenticated
  bool isAuthenticated();

  /// Sign in with Google
  Future<UserEntity> signInWithGoogle();
}
