// lib/error_diagnostic.dart
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

/// Clase para ayudar en el diagnóstico de errores de inicialización
///
/// Esta clase proporciona métodos para probar los casos de uso uno por uno
/// y registrar los resultados
class ErrorDiagnostic {
  static final GetIt sl = GetIt.instance;

  /// Verifica un caso de uso específico y registra el resultado
  static bool checkUseCase(String name, Function testFunction) {
    try {
      if (kDebugMode) {
        print('🔍 Probando caso de uso: $name');
      }

      // Intentar ejecutar la función de prueba
      testFunction();

      if (kDebugMode) {
        print('✅ Caso de uso $name verificado correctamente');
      }
      return true;
    } catch (e, stack) {
      if (kDebugMode) {
        print('❌ Error en caso de uso $name: $e');
        print('Stack trace: $stack');
      }
      return false;
    }
  }

  /// Verifica si un caso de uso está registrado correctamente
  static bool isUseCaseRegistered(String name, Type type) {
    try {
      if (kDebugMode) {
        print('🔍 Verificando registro de caso de uso: $name');
      }

      final bool isRegistered = sl.isRegistered<Object>(instanceName: name) ||
          sl.isRegistered<Type>();

      if (kDebugMode) {
        if (isRegistered) {
          print('✅ Caso de uso $name está registrado');
        } else {
          print('❌ Caso de uso $name NO está registrado');
        }
      }

      return isRegistered;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error verificando registro de $name: $e');
      }
      return false;
    }
  }

  /// Intenta registrar un caso de uso de manera segura
  static bool safeRegisterUseCase(String name, dynamic instance) {
    try {
      if (kDebugMode) {
        print('🔄 Intentando registrar caso de uso: $name');
      }

      // Verificar si ya está registrado
      if (sl.isRegistered<Object>(instanceName: name)) {
        if (kDebugMode) {
          print('⚠️ Caso de uso $name ya está registrado, omitiendo');
        }
        return true;
      }

      // Registrar con nombre (más seguro)
      sl.registerSingleton<Object>(instance, instanceName: name);

      if (kDebugMode) {
        print('✅ Caso de uso $name registrado correctamente');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error registrando caso de uso $name: $e');
      }
      return false;
    }
  }

  /// Ejecuta una serie de pruebas para verificar dependencias básicas
  static Map<String, bool> runDependencyTests() {
    final Map<String, bool> results = {};

    // Verificar servicios básicos
    results['FirebaseServices'] = checkUseCase('Firebase Services', () {
      try {
        GetIt.instance.get(instanceName: 'FirebaseFirestore');
        GetIt.instance.get(instanceName: 'FirebaseAuth');
        GetIt.instance.get(instanceName: 'FirebaseStorage');
      } catch (e) {
        if (kDebugMode) {
          print(
              '⚠️ Firebase services no registrados por nombre, verificando por tipo...');
        }
        // Verificar si están registrados por tipo en su lugar
        GetIt.instance.get<Object>(instanceName: 'FirebaseFirestore');
        GetIt.instance.get<Object>(instanceName: 'FirebaseAuth');
        GetIt.instance.get<Object>(instanceName: 'FirebaseStorage');
      }
    });

    // Agregar más pruebas para otras dependencias básicas

    return results;
  }
}
