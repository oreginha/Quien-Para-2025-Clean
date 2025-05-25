// lib/core/utils/stream_subscription_manager.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Clase para gestionar suscripciones a streams de manera segura
class StreamSubscriptionManager {
  /// Mapa de suscripciones activas, con una clave para identificarlas
  final Map<String, StreamSubscription> _subscriptions = {};

  /// Agrega una nueva suscripción con una clave única
  ///
  /// Cancela cualquier suscripción existente con la misma clave
  void add<T>(String key, Stream<T> stream,
      {void Function(T)? onData,
      Function? onError,
      void Function()? onDone,
      bool? cancelOnError}) {
    // Cancelar suscripción existente con la misma clave
    cancel(key);

    // Crear nueva suscripción
    _subscriptions[key] = stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );

    if (kDebugMode) {
      print('StreamSubscriptionManager: Agregada suscripción "$key"');
    }
  }

  /// Cancela una suscripción específica por su clave
  Future<void> cancel(String key) async {
    final subscription = _subscriptions[key];
    if (subscription != null) {
      await subscription.cancel();
      _subscriptions.remove(key);

      if (kDebugMode) {
        print('StreamSubscriptionManager: Cancelada suscripción "$key"');
      }
    }
  }

  /// Cancela todas las suscripciones
  Future<void> cancelAll() async {
    final keys = List<String>.from(_subscriptions.keys);

    for (final key in keys) {
      await cancel(key);
    }

    if (kDebugMode) {
      print('StreamSubscriptionManager: Todas las suscripciones canceladas');
    }
  }

  /// Pausa una suscripción específica
  void pause(String key) {
    final subscription = _subscriptions[key];
    if (subscription != null) {
      subscription.pause();

      if (kDebugMode) {
        print('StreamSubscriptionManager: Pausada suscripción "$key"');
      }
    }
  }

  /// Reanuda una suscripción específica
  void resume(String key) {
    final subscription = _subscriptions[key];
    if (subscription != null) {
      subscription.resume();

      if (kDebugMode) {
        print('StreamSubscriptionManager: Reanudada suscripción "$key"');
      }
    }
  }

  /// Verifica si existe una suscripción con la clave dada
  bool contains(String key) {
    return _subscriptions.containsKey(key);
  }

  /// Obtiene el número de suscripciones activas
  int get count => _subscriptions.length;

  /// Obtiene todas las claves de suscripciones activas
  List<String> get keys => _subscriptions.keys.toList();

  /// Limpia recursos al destruir
  void dispose() {
    cancelAll();
  }
}

/// Mixin para clases State que necesitan gestionar suscripciones a streams
mixin StreamSubscriptionManagerMixin<T extends StatefulWidget> on State<T> {
  /// Administrador de suscripciones
  final StreamSubscriptionManager subscriptionManager =
      StreamSubscriptionManager();

  @override
  void dispose() {
    // Asegurar que todas las suscripciones sean canceladas
    subscriptionManager.dispose();
    super.dispose();
  }
}
