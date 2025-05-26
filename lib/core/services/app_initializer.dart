// lib/core/services/app_initializer.dart - VERSIÓN DE EMERGENCIA
// ESTA VERSIÓN ELIMINA COMPLETAMENTE LA VERIFICACIÓN DE CASOS DE USO

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:quien_para/core/utils/resource_manager.dart';
import 'package:quien_para/core/logger/logger.dart';
import 'package:quien_para/core/di/di_emergency.dart'; // Usar versión de emergencia
import 'package:quien_para/core/di/di_logger.dart';
import 'package:quien_para/core/config/firebase_options.dart';

/// Clase responsable de la inicialización de la aplicación - MODO EMERGENCIA
///
/// Versión de emergencia que elimina completamente los casos de uso
class AppInitializer {
  // Instancia singleton
  static final AppInitializer _instance = AppInitializer._internal();

  // Fábrica para acceder a la instancia singleton
  factory AppInitializer() => _instance;

  // Constructor interno privado para el singleton
  AppInitializer._internal();

  // Indica si la inicialización se ha completado
  bool _initialized = false;

  /// Estado de inicialización
  bool get isInitialized => _initialized;

  /// Inicializa todos los componentes esenciales para la aplicación - MODO EMERGENCIA
  Future<void> initialize() async {
    if (_initialized) {
      logger.d(
        '[EMERGENCIA] AppInitializer ya está inicializado, omitiendo...',
      );
      return;
    }

    try {
      logger.d(
        '[EMERGENCIA] Iniciando inicialización mínima de la aplicación...',
      );
      DILogger.startProcess(
        '[EMERGENCIA] Inicialización mínima de la aplicación',
      );
      final initStopwatch = Stopwatch()..start();

      // 1. Inicializar Firebase (debe ser lo primero)
      await _initializeFirebase();
      logger.d('[EMERGENCIA] Firebase inicializado correctamente');

      // 2. Inicializar gestor de recursos
      await ResourceManager().initialize();
      logger.d('[EMERGENCIA] ResourceManager inicializado correctamente');

      // 3. Inicializar versión de emergencia de la inyección de dependencias
      // NOTA: La versión de emergencia NO inicializa casos de uso
      await DI.init();
      logger.d('[EMERGENCIA] Inyección de dependencias básica inicializada');

      // IMPORTANTE: NO verificamos casos de uso en el modo de emergencia
      logger.d('[EMERGENCIA] Omitiendo verificación de casos de uso');

      // 5. Inicialización completada
      _initialized = true;
      initStopwatch.stop();
      DILogger.endProcess(
        '[EMERGENCIA] Inicialización de la aplicación',
        initStopwatch.elapsedMilliseconds,
      );
      logger.d(
        '[EMERGENCIA] Inicialización mínima completada en ${initStopwatch.elapsedMilliseconds}ms',
      );
    } catch (e, stackTrace) {
      logger.e(
        '[EMERGENCIA] Error durante la inicialización',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow; // Propagar el error para que la app pueda mostrar un mensaje adecuado
    }
  }

  /// Inicializa Firebase
  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e, stackTrace) {
      logger.e(
        '[EMERGENCIA] Error inicializando Firebase',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Libera los recursos de la aplicación.
  Future<void> dispose() async {
    if (!_initialized) return;

    try {
      // Liberar recursos básicos
      await ResourceManager().dispose();
      logger.d('[EMERGENCIA] ResourceManager liberado correctamente');

      _initialized = false;
      logger.d('[EMERGENCIA] Recursos liberados correctamente');
    } catch (e, stackTrace) {
      logger.e(
        '[EMERGENCIA] Error liberando recursos',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Maneja una excepción durante la inicialización.
  void handleInitializationError(Object error, StackTrace stackTrace) {
    logger.e(
      '[EMERGENCIA] Error durante la inicialización',
      error: error,
      stackTrace: stackTrace,
    );

    // Intentar liberar los recursos que se hayan inicializado
    dispose();

    // En una aplicación real, aquí se podría mostrar un diálogo o pantalla de error
    if (kDebugMode) {
      print('[EMERGENCIA] ERROR DE INICIALIZACIÓN: $error');
      print(stackTrace);
    }
  }
}
