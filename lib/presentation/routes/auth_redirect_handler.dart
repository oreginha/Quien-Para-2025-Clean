// auth_redirect_handler.dart
// Este archivo maneja la lógica de redirección basada en autenticación

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';
import 'app_routes.dart';

/// Clase que maneja la lógica de redirección basada en autenticación
class AuthRedirectHandler {
  // Variables para prevención de bucles de redirección
  String? _lastRedirectPath;
  DateTime? _lastRedirectTime;

  // Referencia al AuthCubit
  AuthCubit? _authCubit;

  // Configurar el manejador con el AuthCubit
  void setAuthCubit(AuthCubit authCubit) {
    _authCubit = authCubit;
  }

  // Verificar si estamos en un posible bucle de redirección
  bool isRedirectLoop(String? currentPath) {
    if (currentPath == null) return false;
    final DateTime now = DateTime.now();

    // Si estamos intentando redirigir al mismo lugar en menos de 500ms, es probable que sea un bucle
    if (_lastRedirectPath == currentPath &&
        _lastRedirectTime != null &&
        now.difference(_lastRedirectTime!).inMilliseconds < 500) {
      if (kDebugMode) {
        print(
          '⚠️ [Router] Posible bucle de redirección detectado, cancelando redirección a $currentPath',
        );
      }
      return true;
    }
    return false;
  }

  // Obtener AuthCubit de la manera más segura posible
  AuthCubit? getAuthCubit(BuildContext context) {
    // Si ya tenemos un AuthCubit configurado, usarlo
    if (_authCubit != null) {
      if (kDebugMode) {
        print('🔒 [Router] Usando AuthCubit configurado');
      }
      return _authCubit;
    }

    // Si no, intentar obtenerlo del Provider
    try {
      if (context.mounted) {
        final AuthCubit authCubit = Provider.of<AuthCubit>(
          context,
          listen: false,
        );
        // Si lo obtenemos correctamente, guardarlo para futuras referencias
        _authCubit = authCubit;
        if (kDebugMode) {
          print('🔒 [Router] AuthCubit obtenido del Provider');
        }
        return authCubit;
      }
    } catch (e) {
      // Si hay un error al obtener el AuthCubit, registrarlo
      if (kDebugMode) {
        print('❌ [Router] Error al obtener AuthCubit: $e');
      }
    }

    // Si no se pudo obtener AuthCubit
    if (kDebugMode) {
      print('⚠️ [Router] No se pudo obtener AuthCubit, omitiendo redirección');
    }
    return null;
  }

  // Determinar la ruta de redirección basada en el estado de autenticación
  String? determineRedirectPath(AuthState authState, String currentPath) {
    // Si es la ruta inicial o la de login
    final bool isInitialOrLoginRoute =
        currentPath == AppRoutes.root || currentPath == AppRoutes.login;

    // Determinar la redirección según el estado
    switch (authState.status) {
      case AuthStatus.initial:
        return _handleInitialAuthStatus(authState, currentPath);

      case AuthStatus.loading:
        return _handleLoadingAuthStatus(currentPath);

      case AuthStatus.authenticated:
        return _handleAuthenticatedStatus(
          authState,
          currentPath,
          isInitialOrLoginRoute,
        );

      case AuthStatus.unauthenticated:
      case AuthStatus.error:
        return _handleUnauthenticatedStatus(isInitialOrLoginRoute);
    }
  }

  // Manejar estado inicial de autenticación
  String? _handleInitialAuthStatus(AuthState authState, String currentPath) {
    // En estado inicial, evitar redirecciones excesivas
    if (currentPath != AppRoutes.home && currentPath != AppRoutes.root) {
      // Verificar estado de autenticación sin forzar redirección inmediata
      Future.microtask(() => _authCubit?.checkAuthStatus());

      if (kDebugMode) {
        print('🔄 [Router] Verificando estado de autenticación');
      }
      return AppRoutes.home;
    } else if (currentPath == AppRoutes.home || currentPath == AppRoutes.root) {
      // Si ya estamos en home/root, verificar auth sin redireccionar
      Future.microtask(() => _authCubit?.checkAuthStatus());
      return null;
    }
    return null;
  }

  // Manejar estado de carga de autenticación
  String? _handleLoadingAuthStatus(String currentPath) {
    // En estado de carga, mantener al usuario donde está si es en home/root
    if (currentPath != AppRoutes.home && currentPath != AppRoutes.root) {
      if (kDebugMode) {
        print('📡 [Router] Redirigiendo a home (loading)');
      }
      return AppRoutes.home;
    }
    return null;
  }

  // Manejar estado autenticado
  String? _handleAuthenticatedStatus(
    AuthState authState,
    String currentPath,
    bool isInitialOrLoginRoute,
  ) {
    // Usuario autenticado - verificar si tiene perfil
    if (!authState.hasUserProfile) {
      if (currentPath != AppRoutes.userOnboarding) {
        if (kDebugMode) {
          print('📡 [Router] Redirigiendo a onboarding (sin perfil)');
        }
        return AppRoutes.userOnboarding;
      }
    } else {
      // Usuario con perfil completo
      if (isInitialOrLoginRoute || currentPath == AppRoutes.userOnboarding) {
        // Estamos en login/root o en onboarding (pero ya tenemos perfil) - ir a home
        if (kDebugMode) {
          print(
            '📡 [Router] Redirigiendo a home (usuario con perfil completo)',
          );
        }
        return AppRoutes
            .proposalsScreen; // Ir a proposalsScreen en lugar de home
      }
    }
    return null;
  }

  // Manejar estado no autenticado
  String? _handleUnauthenticatedStatus(bool isInitialOrLoginRoute) {
    // No autenticado - redirigir al login si no está ya ahí
    if (!isInitialOrLoginRoute) {
      if (kDebugMode) {
        print('📡 [Router] Redirigiendo a login (no autenticado)');
      }
      return AppRoutes.login;
    }
    return null;
  }

  // Actualizar el historial de redirecciones
  void updateRedirectHistory(String redirectPath) {
    _lastRedirectPath = redirectPath;
    _lastRedirectTime = DateTime.now();
  }
}
