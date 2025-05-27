// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'dart:js_util' as js_util;
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio mejorado de autenticación web que utiliza JavaScript interoperability
/// para manejar la autenticación de Google en el entorno web, utilizando
/// Firebase Auth directamente para evitar problemas de StorageRelay URI
class WebAuthService {
  // Singleton pattern
  static final WebAuthService _instance = WebAuthService._internal();
  factory WebAuthService() => _instance;

  // Estado del servicio
  bool _isInitialized = false;
  bool _isCheckingRedirect = false;
  final _authChangeController =
      StreamController<Map<String, dynamic>>.broadcast();

  // Timer para verificar el estado de autenticación periódicamente
  Timer? _authCheckTimer;
  SharedPreferences? _prefs;

  /// Configurar listeners del ciclo de vida de la página
  void _setupAuthLifecycleListeners() {
    try {
      final dynamic window = html.window;

      // Manejar evento de visibilidad cambiada
      js_util.setProperty(
        window,
        'onpagehide',
        js_util.allowInterop((event) {
          if (kDebugMode) {
            print('🕜 WebAuthService: Evento onpagehide detectado');
          }
        }),
      );

      // Manejar evento de visibilidad restaurada
      js_util.setProperty(
        window,
        'onpageshow',
        js_util.allowInterop((event) {
          if (kDebugMode) {
            print('🕜 WebAuthService: Evento onpageshow detectado');
          }

          // Verificar si hay que volver a comprobar el resultado de redirección
          _checkRedirectResult();
        }),
      );

      // Manejar evento de foco restaurado
      js_util.setProperty(
        window,
        'onfocus',
        js_util.allowInterop((event) {
          if (kDebugMode) {
            print('🕜 WebAuthService: Evento onfocus detectado');
          }

          // Verificar si hay que volver a comprobar el resultado de redirección
          _checkRedirectResult();
        }),
      );

      if (kDebugMode) {
        print('✅ WebAuthService: Listeners de ciclo de vida configurados');
      }
    } catch (e) {
      if (kDebugMode) {
        print(
          '❌ WebAuthService: Error configurando listeners de ciclo de vida: $e',
        );
      }
    }
  }

  /// Verificar el resultado de redirección después de regresar de una autenticación
  Future<void> _checkRedirectResult() async {
    if (_isCheckingRedirect) return;

    _isCheckingRedirect = true;

    try {
      final result = await _getRedirectResult();
      if (result != null && result['status'] == 'success') {
        if (kDebugMode) {
          print('✅ Se detectó un inicio de sesión exitoso tras redirección');
        }

        // Guardar información del usuario autenticado
        await _saveUserData(result);

        // Notificar el cambio de estado
        _authChangeController.add({'authenticated': true, 'user': result});
      } else if (result != null && result['status'] == 'cancelled') {
        if (kDebugMode) {
          print('✖️ Autenticación cancelada tras redirección');
        }

        // Notificar el cambio de estado (cancelación)
        _authChangeController.add({
          'authenticated': false,
          'cancelled': true,
          'message': result['message'] ?? 'Autenticación cancelada',
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error verificando resultado de redirección: $e');
      }
    } finally {
      _isCheckingRedirect = false;
    }
  }

  /// Obtener el resultado de la redirección después de iniciar sesión
  Future<Map<String, dynamic>?> _getRedirectResult() async {
    if (!_isInitialized) await initialize();

    try {
      if (kDebugMode) {
        print('🔄 Verificando resultado de redirección de Google');
      }

      // Llamar a getRedirectResult en JavaScript
      return await _callAuthMethod('getRedirectResult');
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error en WebAuthService._getRedirectResult: $e');
      }
      rethrow;
    }
  }

  /// Guardar datos del usuario autenticado
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    try {
      await _prefs?.setString('web_auth_user', jsonEncode(userData));
    } catch (e) {
      if (kDebugMode) {
        print('Error guardando datos de usuario: $e');
      }
    }
  }

  // Constructor privado
  WebAuthService._internal();

  // Getter para el stream de cambios de autenticación
  Stream<Map<String, dynamic>> get authStateChanges =>
      _authChangeController.stream;

  /// Inicializar el servicio de autenticación web
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _prefs = await SharedPreferences.getInstance();

      // Configurar listeners del ciclo de vida
      _setupAuthLifecycleListeners();

      // Esperar a que la biblioteca de autenticación esté disponible en JS
      await _waitForAuthWeb();

      // Verificar el resultado de redirección (por si venimos de un proceso de login)
      if (!_isCheckingRedirect) {
        _isCheckingRedirect = true;

        try {
          // Primero intentar obtener el estado inicial (solución para mantener sesión en debug)
          final initialState = await _callAuthMethod('getInitialState');
          if (initialState != null &&
              initialState['status'] == 'authenticated') {
            if (kDebugMode) {
              print('✅ Se recuperó la sesión guardada en el localStorage');
            }
            // Guardar información del usuario autenticado
            await _saveUserData(initialState);

            // Notificar el cambio de estado
            _authChangeController.add({
              'authenticated': true,
              'user': initialState,
            });
          } else {
            // Si no hay estado inicial, verificar resultado de redirección
            final result = await _getRedirectResult();
            if (result != null && result['status'] == 'success') {
              if (kDebugMode) {
                print(
                  '✅ Se detectó un inicio de sesión exitoso tras redirección',
                );
              }
              // Guardar información del usuario autenticado
              await _saveUserData(result);

              // Notificar el cambio de estado
              _authChangeController.add({
                'authenticated': true,
                'user': result,
              });
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('❌ Error verificando resultado de redirección: $e');
          }
        } finally {
          _isCheckingRedirect = false;
        }
      }

      // Iniciar verificación periódica del estado de autenticación
      _startAuthCheck();

      _isInitialized = true;

      if (kDebugMode) {
        print('✅ WebAuthService inicializado correctamente');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error inicializando WebAuthService: $e');
      }
      rethrow;
    }
  }

  /// Iniciar verificación periódica del estado de autenticación
  void _startAuthCheck() {
    _authCheckTimer?.cancel();

    // Verificar estado inmediatamente
    _checkAuthState();

    // Configurar verificación periódica (cada 15 segundos)
    _authCheckTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      _checkAuthState();
    });
  }

  /// Verificar el estado actual de autenticación
  Future<void> _checkAuthState() async {
    try {
      final state = await _callAuthMethod('checkAuthState');
      final bool isAuthenticated =
          state != null && state['status'] == 'authenticated';

      if (isAuthenticated) {
        // Guardar información del usuario autenticado
        await _saveUserData(state);
      }

      // Notificar cambio de estado
      _authChangeController.add({
        'authenticated': isAuthenticated,
        'user': isAuthenticated ? state : null,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error en _checkAuthState: $e');
      }
    }
  }

  /// Guardar datos del usuario autenticado
  /*Future<void> _saveUserData(Map<String, dynamic> userData) async {
    try {
      await _prefs?.setString('web_auth_user', jsonEncode(userData));
    } catch (e) {
      if (kDebugMode) {
        print('Error guardando datos de usuario: $e');
      }
    }
  }
*/
  /// Obtener datos del usuario guardados
  Map<String, dynamic>? getSavedUserData() {
    try {
      final String? userJson = _prefs?.getString('web_auth_user');
      if (userJson != null) {
        return jsonDecode(userJson) as Map<String, dynamic>;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error obteniendo datos guardados de usuario: $e');
      }
    }
    return null;
  }

  /// Esperar a que el objeto authWeb esté disponible en el contexto de la ventana
  Future<void> _waitForAuthWeb() async {
    // Función para verificar si authWeb está disponible
    bool isAuthWebAvailable() {
      try {
        final dynamic window = html.window;
        final dynamic authWeb = js_util.getProperty(window, 'authWeb');
        return authWeb != null;
      } catch (e) {
        return false;
      }
    }

    // Si ya está disponible, retornar inmediatamente
    if (isAuthWebAvailable()) return;

    // Esperar hasta que esté disponible con un timeout
    final Completer<void> completer = Completer<void>();

    // Intentar hasta 20 veces con intervalos de 250ms
    int attempts = 0;
    const maxAttempts = 20;

    void checkAuthWeb() {
      if (isAuthWebAvailable()) {
        completer.complete();
        return;
      }

      attempts++;
      if (attempts >= maxAttempts) {
        completer.completeError(
          Exception(
            'authWeb no está disponible después de $maxAttempts intentos',
          ),
        );
        return;
      }

      Future.delayed(const Duration(milliseconds: 250), checkAuthWeb);
    }

    // Iniciar la verificación
    checkAuthWeb();

    return completer.future;
  }

  /// Llamar a un método JavaScript del objeto authWeb
  Future<Map<String, dynamic>?> _callAuthMethod(
    String methodName, [
    List<dynamic>? args,
  ]) async {
    if (!_isInitialized) await initialize();

    try {
      // Obtener referencia al objeto authWeb desde window
      final dynamic window = html.window;
      final dynamic authWeb = js_util.getProperty(window, 'authWeb');

      // Verificar si el método existe
      if (!js_util.hasProperty(authWeb, methodName)) {
        throw Exception('El método $methodName no existe en authWeb');
      }

      // Llamar al método JavaScript
      final dynamic result = await js_util.promiseToFuture(
        js_util.callMethod(authWeb, methodName, args ?? []),
      );

      // Convertir resultado a Map
      if (result == null) return null;

      return Map<String, dynamic>.from(js_util.dartify(result) as Map);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error en WebAuthService._callAuthMethod($methodName): $e');
      }
      rethrow;
    }
  }

  /// Iniciar sesión con Google utilizando la redirección
  Future<Map<String, dynamic>> signInWithGoogle() async {
    if (!_isInitialized) await initialize();

    try {
      if (kDebugMode) {
        print(
          '🔄 Iniciando sesión con Google usando WebAuthService (redirección)',
        );
      }

      // Llamar a signInWithGoogle en JavaScript
      final response = await _callAuthMethod('signInWithGoogle') ??
          {'status': 'error', 'error': 'No response'};

      // Si es una cancelación, manejarla adecuadamente
      if (response['status'] == 'cancelled') {
        if (kDebugMode) {
          print('✖️ Autenticación cancelada por el usuario');
        }
        return response;
      }

      if (response['status'] == 'redirect_initiated') {
        return {'status': 'redirect_initiated'};
      }

      if (response['status'] == 'success') {
        // Guardar información del usuario autenticado
        await _saveUserData(response);

        if (kDebugMode) {
          print(
            '✅ Autenticación web exitosa: ${response['name']} (${response['email']})',
          );
        }
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error en WebAuthService.signInWithGoogle: $e');
      }

      // Si el error es popup_closed, manejarlo adecuadamente
      final String errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('popup_closed') ||
          errorMessage.contains('popup closed') ||
          errorMessage.contains('cancelled')) {
        return {
          'status': 'cancelled',
          'message': 'Inicio de sesión cancelado',
          'code': 'popup_closed',
        };
      }

      return {'status': 'error', 'error': e.toString()};
    }
  }

  /// Obtener el resultado de la redirección después de iniciar sesión
  /*Future<Map<String, dynamic>?> _getRedirectResult() async {
    if (!_isInitialized) await initialize();

    try {
      if (kDebugMode) {
        print('🔄 Verificando resultado de redirección de Google');
      }

      // Llamar a getRedirectResult en JavaScript
      return await _callAuthMethod('getRedirectResult');
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error en WebAuthService._getRedirectResult: $e');
      }
      rethrow;
    }
  }
*/
  /// Cerrar sesión
  Future<void> signOut() async {
    if (!_isInitialized) await initialize();

    try {
      // Llamar a signOut en JavaScript
      await _callAuthMethod('signOut');

      // Eliminar datos guardados
      await _prefs?.remove('web_auth_user');

      // Notificar cambio de estado
      _authChangeController.add({'authenticated': false, 'user': null});

      if (kDebugMode) {
        print('✅ Cierre de sesión web exitoso');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error en WebAuthService.signOut: $e');
      }
      rethrow;
    }
  }

  /// Verificar si hay un usuario autenticado
  Future<bool> isAuthenticated() async {
    if (!_isInitialized) await initialize();

    try {
      final state = await _callAuthMethod('checkAuthState');
      return state != null && state['status'] == 'authenticated';
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error en WebAuthService.isAuthenticated: $e');
      }
      return false;
    }
  }

  /// Liberar recursos
  void dispose() {
    _authCheckTimer?.cancel();
    _authChangeController.close();
  }
}

// Instancia global para facilitar el acceso
final webAuthService = WebAuthService();
