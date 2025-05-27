// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Clase para manejar y verificar la conectividad de la red
class NetworkHelper {
  // Singleton
  static final NetworkHelper _instance = NetworkHelper._internal();
  factory NetworkHelper() => _instance;
  NetworkHelper._internal();

  // Instancia del paquete connectivity
  final Connectivity _connectivity = Connectivity();

  // Stream para escuchar cambios en la conectividad
  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;

  /// Verifica si hay conexión a internet
  Future<bool> isConnected() async {
    try {
      final List<ConnectivityResult> result =
          await _connectivity.checkConnectivity();
      return result.isNotEmpty && !result.contains(ConnectivityResult.none);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error verificando conectividad: $e');
      }
      return false;
    }
  }

  /// Espera hasta que haya conexión a internet, con timeout opcional
  Future<bool> waitForConnection({int timeoutSeconds = 30}) async {
    if (await isConnected()) return true;

    // Crear un completer para esperar la conexión
    final Completer<bool> completer = Completer<bool>();

    // Timeout para no esperar indefinidamente
    Timer(Duration(seconds: timeoutSeconds), () {
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    });

    // Escuchar cambios en la conectividad
    final StreamSubscription<List<ConnectivityResult>> subscription =
        connectivityStream.listen((List<ConnectivityResult> result) {
      if (result.isNotEmpty &&
          !result.contains(ConnectivityResult.none) &&
          !completer.isCompleted) {
        completer.complete(true);
      }
    });

    // Esperar a que se resuelva el completer
    final bool result = await completer.future;

    // Cancelar la suscripción
    await subscription.cancel();

    return result;
  }

  /// Ejecuta una operación con reintentos en caso de error de red
  Future<T> executeWithRetry<T>({
    required Future<T> Function() operation,
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
  }) async {
    int attempts = 0;

    while (true) {
      try {
        return await operation();
      } catch (e) {
        attempts++;

        // Si es error de red y no hemos superado el máximo de reintentos
        final bool isNetworkError = e.toString().contains('SocketException') ||
            e.toString().contains('Connection') ||
            e.toString().contains('network');

        if (isNetworkError && attempts <= maxRetries) {
          // Verificar si hay conexión
          final bool connected = await isConnected();

          if (kDebugMode) {
            print('🔄 Reintento $attempts/$maxRetries - Conexión: $connected');
          }

          if (!connected) {
            // Esperar a que haya conexión (máximo 5 segundos por reintento)
            final bool reconnected = await waitForConnection(timeoutSeconds: 5);
            if (!reconnected && attempts == maxRetries) {
              throw Exception('No hay conexión a internet');
            }
          }

          // Esperar antes de reintentar
          await Future.delayed(retryDelay * attempts);
          continue;
        }

        // Si no es error de red o ya superamos los reintentos, propagar el error
        rethrow;
      }
    }
  }
}
