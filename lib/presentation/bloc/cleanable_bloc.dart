// lib/core/bloc/cleanable_bloc.dart

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/core/utils/stream_manager.dart';

/// Clase base para bloques que necesitan gestionar recursos.
///
/// Proporciona métodos para la gestión de suscripciones a streams
/// y la limpieza automática de recursos cuando el bloc se cierra.
abstract class CleanableBloc<Event, State> extends Bloc<Event, State> {
  /// Gestor de suscripciones a streams
  final StreamSubscriptionManager _streamManager = StreamSubscriptionManager();

  CleanableBloc(super.initialState);

  /// Registra una suscripción a un stream con una etiqueta
  StreamSubscription<T> listenStream<T>(
    String tag,
    Stream<T> stream,
    void Function(T) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _streamManager.listen<T>(
      tag,
      stream,
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// Cancela una suscripción específica
  bool cancelSubscription(String tag) {
    return _streamManager.cancel(tag);
  }

  /// Cancela todas las suscripciones
  Future<void> cancelAllSubscriptions() async {
    await _streamManager.cancelAll();
  }

  @override
  Future<void> close() async {
    await cancelAllSubscriptions();
    await super.close();
  }
}

/// Versión mixin para usar con Cubit
mixin CleanableCubitMixin<State> on Cubit<State> {
  /// Gestor de suscripciones a streams
  final StreamSubscriptionManager _streamManager = StreamSubscriptionManager();

  /// Registra una suscripción a un stream con una etiqueta
  StreamSubscription<T> listenStream<T>(
    String tag,
    Stream<T> stream,
    void Function(T) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _streamManager.listen<T>(
      tag,
      stream,
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// Cancela una suscripción específica
  bool cancelSubscription(String tag) {
    return _streamManager.cancel(tag);
  }

  /// Cancela todas las suscripciones
  Future<void> cancelAllSubscriptions() async {
    await _streamManager.cancelAll();
  }

  @override
  Future<void> close() async {
    await cancelAllSubscriptions();
    return super.close();
  }
}

/// Mixin para cualquier clase que necesite gestionar recursos
mixin ResourceCleanupMixin {
  /// Gestor de suscripciones a streams
  final StreamSubscriptionManager streamManager = StreamSubscriptionManager();

  /// Recursos adicionales para limpiar
  final List<Future<void> Function()> _cleanupTasks = [];

  /// Registra una función de limpieza para ejecutarse durante dispose
  void registerCleanupTask(Future<void> Function() task) {
    _cleanupTasks.add(task);
  }

  /// Limpia todos los recursos
  Future<void> cleanupResources() async {
    // Limpiar suscripciones
    await streamManager.cancelAll();

    // Ejecutar tareas de limpieza personalizadas
    for (final task in _cleanupTasks) {
      await task();
    }

    _cleanupTasks.clear();
  }
}
