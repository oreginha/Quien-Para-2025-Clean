// lib/core/bloc/base_bloc.dart
// ignore_for_file: use_super_parameters

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

/// Clase base abstracta para estandarizar la implementación de BLoCs en la aplicación
///
/// Define un comportamiento común para el manejo de errores y logging,
/// mientras se mantiene la flexibilidad para diferentes tipos de eventos y estados.
abstract class BaseBloc<Event, State> extends Bloc<Event, State> {
  final Logger logger = Logger();

  /// Constructor que inicializa el BLoC con su estado inicial
  BaseBloc(State initialState) : super(initialState) {
    if (kDebugMode) {
      logger.d('${runtimeType.toString()} inicializado');
    }
  }

  /// Método auxiliar para gestionar errores de manera consistente
  ///
  /// Registra el error y la pila de llamadas, facilitando la depuración.
  void handleError(String operation, dynamic error, StackTrace stackTrace) {
    if (kDebugMode) {
      logger.e(
        'Error en $runtimeType durante $operation',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> close() {
    if (kDebugMode) {
      logger.d('${runtimeType.toString()} cerrado');
    }
    return super.close();
  }
}
