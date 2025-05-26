// lib/core/services/google_sign_in_fix.dart

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Clase para gestionar la inicialización de Google Sign In
/// Evita el problema de "Future already completed" en entorno web
class GoogleSignInService {
  // Singleton pattern
  static final GoogleSignInService _instance = GoogleSignInService._internal();
  factory GoogleSignInService() => _instance;

  // Controladores de estado para evitar múltiples inicializaciones
  bool _isInitializing = false;
  bool _isInitialized = false;

  // Instancia de GoogleSignIn
  late GoogleSignIn _googleSignIn;

  // Constructor privado
  GoogleSignInService._internal();

  // Getter para la instancia de GoogleSignIn
  GoogleSignIn get googleSignIn {
    if (!_isInitialized) {
      if (kDebugMode) {
        print(
          '⚠️ Advertencia: GoogleSignIn no está inicializado. Inicializando ahora...',
        );
      }
      initialize();
    }
    return _googleSignIn;
  }

  /// Método para inicializar GoogleSignIn de forma segura
  /// Evita inicializaciones múltiples
  void initialize() {
    // Evitar inicializaciones múltiples
    if (_isInitializing || _isInitialized) {
      return;
    }

    _isInitializing = true;

    try {
      if (kDebugMode) {
        print('🔄 Inicializando GoogleSignIn');
      }

      // Configuración específica para web
      if (kIsWeb) {
        _googleSignIn = GoogleSignIn(
          clientId:
              '308528139700-3eu684ijs5jaokegped7aennqqfulh3q.apps.googleusercontent.com',
          scopes: ['email', 'profile'],
          signInOption: SignInOption.standard,
        );
      } else {
        // Configuración para plataformas móviles
        _googleSignIn = GoogleSignIn(
          scopes: ['email', 'profile'],
          // En Android, no especificamos el clientId ya que se toma del google-services.json
          serverClientId:
              '308528139700-3eu684ijs5jaokegped7aennqqfulh3q.apps.googleusercontent.com',
        );
      }

      _isInitialized = true;

      if (kDebugMode) {
        print('✅ GoogleSignIn inicializado correctamente');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error inicializando GoogleSignIn: $e');
      }
    } finally {
      _isInitializing = false;
    }
  }

  /// Método para realizar el inicio de sesión de forma segura
  Future<GoogleSignInAccount?> signIn() async {
    if (!_isInitialized) {
      initialize();
    }

    try {
      return await _googleSignIn.signIn();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error en GoogleSignIn.signIn(): $e');
      }
      rethrow;
    }
  }

  /// Método para cerrar sesión
  Future<void> signOut() async {
    if (!_isInitialized) {
      return;
    }

    try {
      await _googleSignIn.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error en GoogleSignIn.signOut(): $e');
      }
      rethrow;
    }
  }
}

// Instancia global para facilitar el acceso
final googleSignInService = GoogleSignInService();
