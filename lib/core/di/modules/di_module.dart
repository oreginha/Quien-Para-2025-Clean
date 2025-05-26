// lib/core/di/modules/di_module.dart

import 'package:get_it/get_it.dart';

/// Interfaz base para módulos de inyección de dependencias.
///
/// Cada módulo encapsula un conjunto lógico de dependencias relacionadas
/// (ejemplo: RepositoriesModule, UseCasesModule, etc.).
abstract class DIModule {
  /// Registra las dependencias del módulo en el contenedor GetIt.
  ///
  /// Las implementaciones deberían registrar todas sus dependencias aquí.
  Future<void> register(GetIt container);

  /// Registra dependencias de prueba (mocks) para uso en tests unitarios.
  ///
  /// Por defecto es un método vacío, pero los módulos pueden sobrescribirlo
  /// para proporcionar dependencias de prueba.
  Future<void> registerTestDependencies(GetIt container) async {
    // Por defecto no hace nada
  }

  /// Limpia los recursos del módulo.
  ///
  /// Las implementaciones pueden sobrescribir este método para realizar
  /// limpieza específica al módulo cuando se resetea el contenedor.
  Future<void> dispose(GetIt container) async {
    // Por defecto no hace nada
  }
}
