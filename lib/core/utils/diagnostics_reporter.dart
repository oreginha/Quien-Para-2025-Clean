// lib/core/utils/diagnostics_reporter.dart
import 'package:flutter/foundation.dart';
import '../logger/logger.dart';

/// Utilidad para generar logs de diagnóstico detallados
class DiagnosticsReporter {
  static final DiagnosticsReporter _instance = DiagnosticsReporter._internal();
  factory DiagnosticsReporter() => _instance;

  DiagnosticsReporter._internal();

  /// Prefijos para categorías de logs
  static const String _navigation = '🧭 [Navigation]';
  static const String _bloc = '🔄 [BlocState]';
  static const String _ui = '🎨 [UI]';
  static const String _data = '📊 [Data]';
  static const String _network = '📡 [Network]';
  static const String _error = '❌ [Error]';

  bool _isActive = true;

  // Activar/desactivar diagnósticos
  void setActive(bool active) {
    _isActive = active;
  }

  // Navegación
  void navigation(String message, {String? details}) {
    if (!_isActive) return;
    _log('$_navigation $message', details: details);
  }

  // Estado de los Blocs
  void blocState(String message, {String? details}) {
    if (!_isActive) return;
    _log('$_bloc $message', details: details);
  }

  // Interfaz de usuario
  void ui(String message, {String? details}) {
    if (!_isActive) return;
    _log('$_ui $message', details: details);
  }

  // Datos/Modelos
  void data(String message, {String? details}) {
    if (!_isActive) return;
    _log('$_data $message', details: details);
  }

  // Red/Peticiones
  void network(String message, {String? details}) {
    if (!_isActive) return;
    _log('$_network $message', details: details);
  }

  // Errores
  void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    String? details,
  }) {
    if (!_isActive) return;
    _log(
      '$_error $message',
      details: details,
      error: error,
      stackTrace: stackTrace,
    );
  }

  // Log principal
  void _log(
    String message, {
    String? details,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    String fullMessage = message;
    if (details != null) {
      fullMessage += '\n     Details: $details';
    }

    if (error != null) {
      logger.e(fullMessage, error: error, stackTrace: stackTrace);
    } else {
      logger.d(fullMessage);
    }

    // También imprimir directamente para asegurar visibilidad inmediata
    if (kDebugMode) {
      print(fullMessage);
      if (error != null) {
        print('Error: $error');
        if (stackTrace != null) {
          print('StackTrace: $stackTrace');
        }
      }
    }
  }
}

// Singleton para fácil acceso
final diagnostics = DiagnosticsReporter();
