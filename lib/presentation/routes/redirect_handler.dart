// lib/presentation/routes/redirect_handler.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quien_para/presentation/bloc/auth/auth_cubit.dart';
import 'package:quien_para/presentation/bloc/auth/auth_state.dart';
import 'package:provider/provider.dart';

/// Clase para manejar la lógica de redirección de rutas
/// Extraída de AppRouter para reducir la complejidad ciclomática
class RedirectHandler {
  // Variables para prevenir bucles de redirección
  String? _lastRedirectPath;
  DateTime? _lastRedirectTime;
  static const _redirectCooldown = Duration(milliseconds: 500);

  // AuthCubit para manejar el estado de autenticación
  AuthCubit? _authCubit;

  // Constructor
  RedirectHandler({AuthCubit? authCubit}) : _authCubit = authCubit;

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
        final AuthCubit authCubit =
            Provider.of<AuthCubit>(context, listen: false);
        // Si lo obtenemos correctamente, guardarlo para futuras referencias
        if (authCubit != null) {
          _authCubit = authCubit;
          if (kDebugMode) {
            print('🔒 [Router] AuthCubit obtenido del Provider');
          }
          return authCubit;
        }
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
            '⚠️ [Router] Posible bucle de redirección detectado, cancelando redirección a $currentPath');
      }
      return true;
    }
    return false;
  }

  // Método principal que maneja la redirección basada en el estado actual
  String? handleRedirect(BuildContext context, String currentPath,
      {bool skipSpecialPaths = true}) {
    // No redirigir desde rutas especiales
    if (skipSpecialPaths && currentPath == '/theme-showcase') {
      return null;
    }

    // Verificar bucle de redirección
    if (isRedirectLoop(currentPath)) {
      return null;
    }

    // Obtener AuthCubit
    final AuthCubit? authCubit = getAuthCubit(context);
    if (authCubit == null) {
      return null;
    }

    // Obtener estado de autenticación
    final authState = authCubit.state;

    // Log del estado de autenticación
    if (kDebugMode) {
      print(
          '📡 [Router] Evaluando redirección - Ruta: $currentPath, Estado auth: ${authState.status}');
    }

    // Determinar redirección basada en el estado
    final String? redirectPath = determineRedirectPath(authState, currentPath);

    // Actualizar historial de redirecciones si hay una redirección
    if (redirectPath != null) {
      _lastRedirectPath = redirectPath;
      _lastRedirectTime = DateTime.now();
    }

    return redirectPath;
  }

  // Determinar la ruta de redirección basada en el estado de autenticación
  String? determineRedirectPath(AuthState authState, String currentPath) {
    // Rutas de entrada (login y root)
    final bool isInitialOrLoginRoute =
        currentPath == '/' || currentPath == '/login';

    // Resolver redirección según el estado
    switch (authState.status) {
      case AuthStatus.initial:
        return _handleInitialState(authState, currentPath);

      case AuthStatus.loading:
        return _handleLoadingState(currentPath);

      case AuthStatus.authenticated:
        return _handleAuthenticatedState(
            authState, currentPath, isInitialOrLoginRoute);

      case AuthStatus.unauthenticated:
      case AuthStatus.error:
        return _handleUnauthenticatedState(isInitialOrLoginRoute);
    }
  }

  // Handlers para cada estado de autenticación
  String? _handleInitialState(AuthState authState, String currentPath) {
    // En estado inicial, evitar redirecciones excesivas
    if (currentPath != '/home' && currentPath != '/') {
      // Verificar estado de autenticación sin forzar redirección inmediata
      Future.microtask(() => _authCubit?.checkAuthStatus());

      if (kDebugMode) {
        print('🔄 [Router] Verificando estado de autenticación');
      }
      return '/home';
    } else if (currentPath == '/home' || currentPath == '/') {
      // Si ya estamos en home/root, verificar auth sin redireccionar
      Future.microtask(() => _authCubit?.checkAuthStatus());
      return null;
    }
    return null;
  }

  String? _handleLoadingState(String currentPath) {
    // Durante la carga, mantener al usuario en home/root si ya está ahí
    if (currentPath != '/home' && currentPath != '/') {
      if (kDebugMode) {
        print('📡 [Router] Redirigiendo a home (loading)');
      }
      return '/home';
    }
    return null;
  }

  String? _handleAuthenticatedState(
      AuthState authState, String currentPath, bool isInitialOrLoginRoute) {
    // Verificar si el usuario tiene perfil completo
    if (!authState.hasUserProfile) {
      // Si no tiene perfil, enviar a onboarding
      if (currentPath != '/user-onboarding') {
        if (kDebugMode) {
          print('📡 [Router] Redirigiendo a onboarding (sin perfil)');
        }
        return '/user-onboarding';
      }
    } else {
      // Usuario con perfil completo
      if (isInitialOrLoginRoute || currentPath == '/user-onboarding') {
        // Redirigir a home desde login/root/onboarding
        if (kDebugMode) {
          print(
              '📡 [Router] Redirigiendo a propuestas (usuario con perfil completo)');
        }
        return '/proposalsScreen';
      }
    }
    return null;
  }

  String? _handleUnauthenticatedState(bool isInitialOrLoginRoute) {
    // Si no está autenticado y no está en login/root, enviar a login
    if (!isInitialOrLoginRoute) {
      if (kDebugMode) {
        print('📡 [Router] Redirigiendo a login (no autenticado)');
      }
      return '/login';
    }
    return null;
  }

  // Establecer AuthCubit
  void setAuthCubit(AuthCubit authCubit) {
    _authCubit = authCubit;
  }
}
