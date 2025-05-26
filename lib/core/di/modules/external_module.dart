// lib/core/di/modules/external_module.dart

import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:quien_para/core/di/modules/di_module.dart';

/// Módulo para registrar servicios externos y de terceros
///
/// Este módulo se encarga de registrar servicios que dependen de APIs externas
/// o servicios de terceros, como:
/// - Cualquier otro servicio externo
class ExternalModule implements DIModule {
  static final ExternalModule _instance = ExternalModule._internal();
  factory ExternalModule() => _instance;
  ExternalModule._internal();

  /// Registra todos los servicios externos en el contenedor DI
  @override
  Future<void> register(GetIt sl) async {
    if (kDebugMode) {
      print('🌐 Registrando módulo de Servicios Externos');
    }

    // Dio HTTP Client
    if (!sl.isRegistered<Dio>()) {
      sl.registerLazySingleton<Dio>(() => Dio());
    }
  }

  @override
  Future<void> dispose(GetIt container) async {
    if (kDebugMode) {
      print('🗑 Liberando recursos del módulo de Servicios Externos');
    }

    // Liberar Dio si es necesario
    if (container.isRegistered<Dio>()) {
      final dio = container<Dio>();
      dio.close();
    }

    if (kDebugMode) {
      print(
        '✅ Recursos del módulo de Servicios Externos liberados exitosamente',
      );
    }
  }

  @override
  Future<void> registerTestDependencies(GetIt container) async {
    if (kDebugMode) {
      print(
        '📣 Registrando dependencias de prueba para módulo de Servicios Externos',
      );
    }

    // Registrar Dio con interceptores para pruebas
    if (!container.isRegistered<Dio>()) {
      final dio = Dio();

      // Agregar interceptor para simular respuestas o monitorear solicitudes durante pruebas
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (kDebugMode) {
              print('Solicitud de prueba a: ${options.uri}');
            }
            handler.next(options);
          },
          onResponse: (response, handler) {
            if (kDebugMode) {
              print(
                'Respuesta de prueba recibida de: ${response.requestOptions.uri}',
              );
            }
            handler.next(response);
          },
          onError: (DioException error, handler) {
            if (kDebugMode) {
              print(
                'Error de prueba en solicitud a: ${error.requestOptions.uri}',
              );
            }
            handler.next(error);
          },
        ),
      );

      container.registerLazySingleton<Dio>(() => dio);
    }

    if (kDebugMode) {
      print(
        '✅ Dependencias de prueba para módulo de Servicios Externos registradas exitosamente',
      );
    }
  }
}
