// lib/presentation/bloc/auth/mock_auth_cubit.dart
// Versión simulada del AuthCubit para el modo de emergencia

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/presentation/bloc/auth/auth_state.dart';

/// Versión simulada del AuthCubit para modo de emergencia
///
/// Esta versión no realiza ninguna operación real y siempre devuelve un estado
/// predeterminado para que la UI no se rompa
class MockAuthCubit extends Cubit<AuthState> {
  MockAuthCubit() : super(const AuthState(status: AuthStatus.unauthenticated)) {
    if (kDebugMode) {
      print('🔴 [EMERGENCIA] MockAuthCubit inicializado');
    }
  }

  // Métodos simulados que no hacen nada
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

  Future<void> signInWithGoogle() async {
    if (kDebugMode) {
      print('🔴 [EMERGENCIA] Intento de login con Google simulado');
    }
    emit(const AuthState(status: AuthStatus.loading));
    await Future.delayed(const Duration(seconds: 1));
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> logout() async {
    if (kDebugMode) {
      print('🔴 [EMERGENCIA] Logout simulado');
    }
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> completeOnboarding() async {
    if (kDebugMode) {
      print('🔴 [EMERGENCIA] completeOnboarding simulado');
    }
  }

  Future<void> deleteAccount() async {
    if (kDebugMode) {
      print('🔴 [EMERGENCIA] deleteAccount simulado');
    }
  }

  Future<void> checkAuthStatus() async {
    if (kDebugMode) {
      print('🔴 [EMERGENCIA] checkAuthStatus simulado');
    }
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
