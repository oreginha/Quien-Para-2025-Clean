// lib/core/bloc/app_bloc_observer.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

/// BlocObserver personalizado para monitorear el comportamiento de todos los BLoCs en la aplicación
/// Proporciona registro coherente y monitoreo de errores en un único lugar
class AppBlocObserver extends BlocObserver {
  final Logger _logger = Logger();
  
  // Controla si se registran los eventos y transiciones (puede ser costoso en producción)
  final bool _verbose;
  
  AppBlocObserver({bool verbose = false}) : _verbose = verbose;

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    // Solo registramos la creación de blocs en modo de depuración
    if (kDebugMode) {
      _logger.d('${bloc.runtimeType} creado');
    }
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    // En modo verbose o depuración, registramos todos los eventos
    if (_verbose || kDebugMode) {
      _logger.d('${bloc.runtimeType} recibió evento: $event');
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // En modo verbose, registramos todos los cambios de estado
    if (_verbose && kDebugMode) {
      _logger.d('${bloc.runtimeType} cambió de ${change.currentState} a ${change.nextState}');
    }
    
    // Siempre mostrar cambios de estado en modo debug
    if (kDebugMode) {
      print('🔴 BLOC CAMBIO DE ESTADO: ${bloc.runtimeType} -> ${change.nextState.runtimeType}');
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // En modo verbose, registramos todas las transiciones
    if (_verbose && kDebugMode) {
      _logger.d(
        '${bloc.runtimeType} transición: ${transition.event} -> '
        'Estado actual: ${transition.currentState}, '
        'Próximo estado: ${transition.nextState}',
      );
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    // Siempre registramos errores
    _logger.e(
      'Error en ${bloc.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    // Solo registramos cierre de blocs en modo de depuración
    if (kDebugMode) {
      _logger.d('${bloc.runtimeType} cerrado');
    }
  }
}
