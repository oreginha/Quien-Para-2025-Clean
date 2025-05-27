// lib/presentation/bloc/auth/mock_auth_with_inheritance.dart
// Versión simulada del AuthCubit que extiende de AuthCubit para el modo de emergencia

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quien_para/domain/repositories/auth/auth_repository.dart';
import 'package:quien_para/domain/entities/user/user_entity.dart';
import 'auth_cubit.dart';
import 'auth_state.dart';

/// Implementación mínima de AuthRepository para usar con MockAuthCubitImpl
class MockAuthRepository implements AuthRepository {
  late final SharedPreferences _prefs;

  MockAuthRepository() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Stream<bool> get authStateChanges => Stream.value(false);

  @override
  Future<void> deleteAccount() async {}

  @override
  String? getCurrentUserId() => null;

  @override
  Future<Map<String, dynamic>?> getCurrentUserData() async => null;

  @override
  Future<UserEntity?> getCurrentUser() async => UserEntity.empty();

  @override
  Future<UserEntity?> getUserById(String userId) async => UserEntity.empty();

  @override
  Future<bool> isAuthenticated() async => false;

  @override
  Future<UserEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return UserEntity.empty();
  }

  @override
  Future<Map<String, dynamic>> signInWithGoogle() async {
    return {'status': 'cancelled'};
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<UserEntity> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    return UserEntity.empty();
  }

  @override
  Future<void> updateUser(UserEntity user) async {}

  @override
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {}
}

/// Versión simulada del AuthCubit que extiende realmente de AuthCubit
/// para ser compatible con el sistema real
class MockAuthCubitImpl extends AuthCubit {
  // Guardar la instancia de SharedPreferences
  static late SharedPreferences _sharedPrefs;

  // Método estático para inicializar prefs antes de crear la instancia
  static Future<void> initialize() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  MockAuthCubitImpl._()
      : super(
          // Pasar el repositorio mock
          MockAuthRepository(),
          // Pasar la instancia ya inicializada de SharedPreferences
          _sharedPrefs,
        ) {
    if (kDebugMode) {
      print('🔴 [EMERGENCIA] MockAuthCubitImpl inicializado');
    }

    // Establecer el estado inicial
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  // Método de fábrica para crear instancias de forma segura
  static Future<MockAuthCubitImpl> create() async {
    // Asegurarnos de que SharedPreferences esté inicializado
    await initialize();
    return MockAuthCubitImpl._();
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (kDebugMode) {
      print('🔴 [EMERGENCIA] Intento de login simulado');
    }
    emit(const AuthState(status: AuthStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  @override
  Future<void> signInWithGoogle() async {
    if (kDebugMode) {
      print('🔴 [EMERGENCIA] Intento de login con Google simulado');
    }
    emit(const AuthState(status: AuthStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  @override
  Future<void> logout() async {
    if (kDebugMode) {
      print('🔴 [EMERGENCIA] Logout simulado');
    }
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  @override
  Future<void> completeOnboarding() async {
    if (kDebugMode) {
      print('🔴 [EMERGENCIA] completeOnboarding simulado');
    }
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  @override
  Future<void> deleteAccount() async {
    if (kDebugMode) {
      print('🔴 [EMERGENCIA] deleteAccount simulado');
    }
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  @override
  Future<void> checkAuthStatus() async {
    if (kDebugMode) {
      print('🔴 [EMERGENCIA] checkAuthStatus simulado');
    }
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
