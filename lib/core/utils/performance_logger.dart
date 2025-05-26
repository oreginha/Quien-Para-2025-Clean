// ignore_for_file: inference_failure_on_function_return_type

import 'package:flutter/foundation.dart';

class PerformanceLogger {
  // Mapa para almacenar los cronómetros activos
  static final Map<String, Stopwatch> _activeStopwatches =
      <String, Stopwatch>{};

  // Inicia la medición de rendimiento para una operación
  static void startMeasure(String tag) {
    if (kDebugMode) {
      if (_activeStopwatches.containsKey(tag)) {
        print(
          '⚠️ [Performance] Advertencia: Ya existe una medición activa para $tag',
        );
        _activeStopwatches[tag]?.reset();
      } else {
        _activeStopwatches[tag] = Stopwatch()..start();
      }
    }
  }

  // Finaliza la medición de rendimiento y muestra el resultado
  static void endMeasure(String tag) {
    if (kDebugMode) {
      final Stopwatch? stopwatch = _activeStopwatches.remove(tag);
      if (stopwatch != null) {
        stopwatch.stop();
        print(
          '[Performance] $tag ejecutado en ${stopwatch.elapsedMilliseconds}ms',
        );
        if (stopwatch.elapsedMilliseconds > 16) {
          print(
            '⚠️ [Performance] ADVERTENCIA: $tag está tomando más de 16ms (${stopwatch.elapsedMilliseconds}ms)',
          );
        }
      } else {
        print(
          '⚠️ [Performance] Error: No se encontró medición activa para $tag',
        );
      }
    }
  }

  static void logOperation(final String tag, final Function() operation) {
    final Stopwatch stopwatch = Stopwatch()..start();
    operation();
    stopwatch.stop();
    if (kDebugMode) {
      print(
        '[Performance] $tag ejecutado en ${stopwatch.elapsedMilliseconds}ms',
      );
      if (stopwatch.elapsedMilliseconds > 16) {
        print(
          '⚠️ [Performance] ADVERTENCIA: $tag está tomando más de 16ms (${stopwatch.elapsedMilliseconds}ms)',
        );
      }
    }
  }

  static Future<T> logAsyncOperation<T>(
    final String tag,
    final Future<T> Function() operation,
  ) async {
    final Stopwatch stopwatch = Stopwatch()..start();
    try {
      final T result = await operation();
      stopwatch.stop();
      if (kDebugMode) {
        print(
          '[Performance] $tag ejecutado en ${stopwatch.elapsedMilliseconds}ms',
        );
        if (stopwatch.elapsedMilliseconds > 100) {
          print(
            '⚠️ [Performance] ADVERTENCIA: Operación asíncrona $tag está tomando demasiado tiempo (${stopwatch.elapsedMilliseconds}ms)',
          );
        }
      }
      return result;
    } catch (e) {
      stopwatch.stop();
      if (kDebugMode) {
        print(
          '❌ [Performance] ERROR en $tag: $e (${stopwatch.elapsedMilliseconds}ms)',
        );
      }
      rethrow;
    }
  }

  static void logInit(final String className) {
    if (kDebugMode) {
      print('🔄 [Lifecycle] Inicializando $className');
    }
  }

  static void logDispose(final String className) {
    if (kDebugMode) {
      print('🗑️ [Lifecycle] Eliminando $className');
    }
  }
}
