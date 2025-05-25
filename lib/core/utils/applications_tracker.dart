// lib/core/utils/applications_tracker.dart
import 'package:flutter/foundation.dart';
import 'diagnostics_reporter.dart';

class ApplicationsTracker {
  /// Estado global del tracker
  static final Map<String, dynamic> _state = {
    'navigation_started': false,
    'screen_built': false,
    'bloc_initialized': false,
    'data_requested': false,
    'data_received': false,
    'plans_loading_started': false,
    'plans_loaded': false,
    'render_started': false,
    'render_completed': false,
    'errors': <String>[],
    'applications_count': 0,
    'plans_count': 0,
    'last_bloc_state': 'unknown',
    'navigation_timestamp': 0,
    'data_requested_timestamp': 0,
    'data_received_timestamp': 0,
    'render_completed_timestamp': 0,
  };

  /// Registrar la navegación a la pantalla
  static void navigationStarted(String userId) {
    _state['navigation_started'] = true;
    _state['navigation_timestamp'] = DateTime.now().millisecondsSinceEpoch;

    diagnostics.navigation('Navegación iniciada a MyApplicationsScreen',
        details: 'userId: $userId');
  }

  /// Registrar la construcción de la pantalla
  static void screenBuilt() {
    _state['screen_built'] = true;

    diagnostics.ui('MyApplicationsScreen construida');
  }

  /// Registrar la inicialización del bloc
  static void blocInitialized() {
    _state['bloc_initialized'] = true;

    diagnostics.blocState('MatchingBloc inicializado para aplicaciones');
  }

  /// Registrar la solicitud de datos
  static void dataRequested(String? userId) {
    _state['data_requested'] = true;
    _state['data_requested_timestamp'] = DateTime.now().millisecondsSinceEpoch;

    diagnostics.data('Solicitud de aplicaciones enviada',
        details: 'userId: ${userId ?? "current"}');
  }

  /// Registrar la recepción de datos
  static void dataReceived(int count) {
    _state['data_received'] = true;
    _state['applications_count'] = count;
    _state['data_received_timestamp'] = DateTime.now().millisecondsSinceEpoch;

    final int elapsed =
        _state['data_received_timestamp'] - _state['data_requested_timestamp'];

    diagnostics.data('Aplicaciones recibidas: $count',
        details: 'Tiempo: ${elapsed}ms');
  }

  /// Registrar el inicio de carga de planes
  static void plansLoadingStarted(int count) {
    _state['plans_loading_started'] = true;

    diagnostics.data('Iniciando carga de $count planes');
  }

  /// Registrar planes cargados
  static void plansLoaded(int count) {
    _state['plans_loaded'] = true;
    _state['plans_count'] = count;

    diagnostics.data('$count planes cargados con éxito');
  }

  /// Registrar inicio de renderizado
  static void renderStarted() {
    _state['render_started'] = true;

    diagnostics.ui('Iniciando renderizado de aplicaciones');
  }

  /// Registrar renderizado completado
  static void renderCompleted() {
    _state['render_completed'] = true;
    _state['render_completed_timestamp'] =
        DateTime.now().millisecondsSinceEpoch;

    final int totalElapsed =
        _state['render_completed_timestamp'] - _state['navigation_timestamp'];

    diagnostics.ui('Renderizado de aplicaciones completado',
        details: 'Tiempo total: ${totalElapsed}ms');
  }

  /// Registrar estado del bloc
  static void blocStateChanged(String state) {
    _state['last_bloc_state'] = state;

    diagnostics.blocState('Estado del bloc cambiado: $state');
  }

  /// Registrar error
  static void error(String message, [dynamic error]) {
    _state['errors'].add(message);

    diagnostics.error('Error en MyApplicationsScreen: $message', error: error);
  }

  /// Imprimir resumen del estado actual
  static void printSummary() {
    if (!kDebugMode) return;

    final StringBuffer buffer = StringBuffer();
    buffer.writeln('\n=== APPLICATIONS SCREEN DIAGNOSTICS ===');
    buffer.writeln('Navegación iniciada: ${_state['navigation_started']}');
    buffer.writeln('Pantalla construida: ${_state['screen_built']}');
    buffer.writeln('Bloc inicializado: ${_state['bloc_initialized']}');
    buffer.writeln('Datos solicitados: ${_state['data_requested']}');
    buffer.writeln('Datos recibidos: ${_state['data_received']}');
    buffer.writeln(
        'Carga de planes iniciada: ${_state['plans_loading_started']}');
    buffer.writeln('Planes cargados: ${_state['plans_loaded']}');
    buffer.writeln('Renderizado iniciado: ${_state['render_started']}');
    buffer.writeln('Renderizado completado: ${_state['render_completed']}');
    buffer.writeln('Último estado del bloc: ${_state['last_bloc_state']}');
    buffer.writeln('Número de aplicaciones: ${_state['applications_count']}');
    buffer.writeln('Número de planes: ${_state['plans_count']}');

    if (_state['errors'].isNotEmpty) {
      buffer.writeln('\nErrores detectados:');
      for (final error in _state['errors']) {
        buffer.writeln('- $error');
      }
    }

    if (_state['navigation_timestamp'] > 0 &&
        _state['render_completed_timestamp'] > 0) {
      buffer.writeln('\nTiempos:');
      buffer.writeln(
          'Tiempo de solicitud de datos: ${_state['data_received_timestamp'] - _state['data_requested_timestamp']}ms');
      buffer.writeln(
          'Tiempo total: ${_state['render_completed_timestamp'] - _state['navigation_timestamp']}ms');
    }

    buffer.writeln('=======================================');

    if (kDebugMode) {
      print(buffer.toString());
    }
  }

  /// Reiniciar el tracker
  static void reset() {
    _state['navigation_started'] = false;
    _state['screen_built'] = false;
    _state['bloc_initialized'] = false;
    _state['data_requested'] = false;
    _state['data_received'] = false;
    _state['plans_loading_started'] = false;
    _state['plans_loaded'] = false;
    _state['render_started'] = false;
    _state['render_completed'] = false;
    _state['errors'] = <String>[];
    _state['applications_count'] = 0;
    _state['plans_count'] = 0;
    _state['last_bloc_state'] = 'unknown';
    _state['navigation_timestamp'] = 0;
    _state['data_requested_timestamp'] = 0;
    _state['data_received_timestamp'] = 0;
    _state['render_completed_timestamp'] = 0;

    diagnostics.data('ApplicationsTracker reiniciado');
  }
}
