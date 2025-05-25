// test/helpers/di_test_helper.dart
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper para configurar el sistema de inyección de dependencias en pruebas
///
/// Este helper proporciona métodos para:
/// - Inicializar el sistema DI para pruebas
/// - Limpiar/resetear el contenedor DI entre pruebas
/// - Registrar mocks específicos para pruebas
class DITestHelper {
  /// Instancia compartida de GetIt
  static final GetIt sl = GetIt.instance;

  /// Bandera para evitar inicializaciones múltiples
  static bool _initialized = false;

  /// Inicializa una versión mínima del contenedor DI para pruebas
  ///
  /// Este método configura solo las dependencias esenciales para las pruebas,
  /// evitando configuraciones pesadas como Firebase.
  static Future<void> initializeDIForTesting() async {
    if (_initialized) return;

    TestWidgetsFlutterBinding.ensureInitialized();

    try {
      // Resetear el contenedor para asegurar un estado limpio
      await resetDI();

      // Usar el nuevo sistema modular (pero solo registrar lo mínimo necesario)
      // Esto evita la inicialización completa que podría requerir Firebase, etc.
      _initialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('Error al inicializar DI para pruebas: $e');
      }
      rethrow;
    }
  }

  /// Registra un mock para un tipo específico en el contenedor
  ///
  /// Ejemplo:
  /// ```dart
  /// final mockRepository = MockPlanRepository();
  /// DITestHelper.registerMock<PlanRepository>(mockRepository);
  /// ```
  static void registerMock<T extends Object>(T mockInstance) {
    // Verificar si ya está registrado y eliminarlo primero
    if (sl.isRegistered<T>()) {
      sl.unregister<T>();
    }

    // Registrar el mock
    sl.registerSingleton<T>(mockInstance);
  }

  /// Resetea completamente el contenedor DI
  ///
  /// Este método debe llamarse en el tearDown de las pruebas para
  /// evitar interferencias entre diferentes pruebas.
  static Future<void> resetDI() async {
    try {
      await sl.reset();
      _initialized = false;
    } catch (e) {
      if (kDebugMode) {
        print('Error al resetear DI: $e');
      }
    }
  }
}
