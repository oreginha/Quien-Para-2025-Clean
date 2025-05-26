// lib/core/di/modules/usecase_module.dart
// VERSIÓN MÍNIMA Y SIMPLIFICADA

import 'package:get_it/get_it.dart';
import '../di_logger.dart';
import 'di_module.dart';

/// Módulo minimalista para registro de casos de uso - VERSIÓN DE EMERGENCIA
///
/// Esta versión simplificada no registra ninguno de los casos de uso problemáticos
/// y está diseñada para permitir que la aplicación inicie sin errores.
class UseCaseModule implements DIModule {
  @override
  Future<void> register(GetIt sl) async {
    try {
      DILogger.info('🔄 Iniciando registro de UseCaseModule (versión mínima)');

      // No registramos ningún caso de uso para evitar problemas
      // Los casos de uso se deberán implementar manualmente donde sea necesario

      DILogger.success(
        '✅ UseCaseModule (versión mínima) registrado correctamente',
      );
    } catch (e) {
      DILogger.error('❌ Error en registro de UseCaseModule mínimo: $e');
    }
  }

  @override
  Future<void> dispose(GetIt sl) async {
    // No hay nada que limpiar
  }

  @override
  Future<void> registerTestDependencies(GetIt sl) async {
    await register(sl);
  }
}
