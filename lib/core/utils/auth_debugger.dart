// lib/core/utils/auth_debugger.dart
import 'package:flutter/foundation.dart';

class AuthDebugger {
  static const String _tag = '🔐 AuthFlow';
  static bool _isEnabled = true;

  // Activar o desactivar el debugger
  static void enable(bool isEnabled) {
    _isEnabled = isEnabled;
  }

  // Log para eventos de navegación del flujo de autenticación
  static void logNavigation(String source, String destination, {String? reason}) {
    if (!_isEnabled || !kDebugMode) return;
    
    final String reasonText = reason != null ? ' - Razón: $reason' : '';
    if (kDebugMode) {
      print('$_tag - Navegación: $source → $destination$reasonText');
    }
  }

  // Log para cambios de estado de autenticación
  static void logStateChange(String component, String previousState, String newState) {
    if (!_isEnabled || !kDebugMode) return;
    
    if (kDebugMode) {
      print('$_tag - Estado cambiado en $component: $previousState → $newState');
    }
  }

  // Log para errores en el flujo de autenticación
  static void logError(String component, String error, {StackTrace? stackTrace}) {
    if (!kDebugMode) return; // Los errores siempre deben registrarse en modo debug
    
    if (kDebugMode) {
      print('$_tag - ERROR en $component: $error');
    }
    if (stackTrace != null) {
      if (kDebugMode) {
        print('$_tag - StackTrace: $stackTrace');
      }
    }
  }

  // Log para eventos generales
  static void log(String message) {
    if (!_isEnabled || !kDebugMode) return;
    
    if (kDebugMode) {
      print('$_tag - $message');
    }
  }
}
