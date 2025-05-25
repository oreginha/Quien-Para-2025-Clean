// lib/core/utils/stream_manager.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:quien_para/core/logger/logger.dart';

/// Clase para facilitar la gestión y limpieza de suscripciones a streams.
///
/// Simplifica el seguimiento de múltiples suscripciones y garantiza
/// su correcta cancelación cuando ya no se necesitan.
class StreamSubscriptionManager {
  // Mapa de suscripciones por etiqueta
  final Map<String, StreamSubscription<dynamic>> _subscriptions = {};

  /// Registra una suscripción con una etiqueta para su posterior limpieza.
  ///
  /// Si ya existe una suscripción con la misma etiqueta, la cancela primero.
  void register<T>(String tag, StreamSubscription<T> subscription) {
    cancel(tag); // Cancelar la suscripción anterior si existe
    _subscriptions[tag] = subscription;
  }

  /// Agrega una suscripción a un stream con una etiqueta.
  ///
  /// Crea y registra automáticamente la suscripción.
  StreamSubscription<T> listen<T>(
    String tag,
    Stream<T> stream,
    void Function(T) onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    final subscription = stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );

    register<T>(tag, subscription);
    return subscription;
  }

  /// Cancela una suscripción específica identificada por su etiqueta.
  ///
  /// Devuelve true si se encontró y canceló exitosamente la suscripción.
  bool cancel(String tag) {
    final subscription = _subscriptions.remove(tag);
    if (subscription != null) {
      try {
        subscription.cancel();
        return true;
      } catch (e) {
        logger.e('Error al cancelar suscripción $tag', error: e);
        return false;
      }
    }
    return false;
  }

  /// Cancela todas las suscripciones registradas.
  ///
  /// Útil cuando un componente se destruye o se elimina de la memoria.
  Future<void> cancelAll() async {
    final tags = _subscriptions.keys.toList();

    for (final tag in tags) {
      cancel(tag);
    }

    _subscriptions.clear();
  }

  /// Devuelve true si hay una suscripción registrada con esta etiqueta.
  bool has(String tag) => _subscriptions.containsKey(tag);

  /// Devuelve el número actual de suscripciones activas.
  int get count => _subscriptions.length;

  /// Devuelve una lista de todas las etiquetas activas.
  List<String> get activeTags => _subscriptions.keys.toList();

  /// Imprime las suscripciones activas (útil para depuración).
  void debugPrint() {
    if (kDebugMode) {
      print('===== Suscripciones activas (${_subscriptions.length}) =====');
      for (final tag in _subscriptions.keys) {
        print('- $tag');
      }
      print('=================================================');
    }
  }
}

/// Extensión para facilitar el uso con StatefulWidget.
extension StreamSubscriptionManagerStatefulExtension on State {
  /// Crea un administrador de suscripciones.
  ///
  /// Uso recomendado en initState:
  /// ```dart
  /// late final subscriptionManager = createStreamManager();
  ///
  /// @override
  /// void dispose() {
  ///   subscriptionManager.cancelAll();
  ///   super.dispose();
  /// }
  /// ```
  StreamSubscriptionManager createStreamManager() {
    return StreamSubscriptionManager();
  }

  /// Registra una función para ejecutarse después del primer frame.
  void addPostFrameCallback(void Function() callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) => callback());
  }
}

/// Extensión para facilitar el uso con Bloc/Cubit.
mixin BlocStreamManagerMixin {
  final StreamSubscriptionManager streamManager = StreamSubscriptionManager();

  /// Debe llamarse en el método close() del Bloc o Cubit.
  Future<void> cancelAllSubscriptions() async {
    await streamManager.cancelAll();
  }
}
