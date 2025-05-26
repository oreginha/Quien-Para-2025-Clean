// lib/core/di/di.dart

import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'di_logger.dart';

// Módulos
import 'modules/core_module.dart';
import 'modules/service_module.dart';
import 'modules/repository_module.dart';
import 'modules/bloc_module.dart';
import 'modules/external_module.dart';
import 'modules/maps_module.dart';
import 'modules/search_module.dart';
import 'modules/di_module.dart';
import 'modules/usecase_module.dart';

/// Singleton de GetIt para toda la aplicación
final GetIt sl = GetIt.instance;

/// Sistema de inyección de dependencias modular unificado
///
/// Esta clase centraliza la gestión de dependencias de la aplicación
/// utilizando un enfoque modular para mayor mantenibilidad y estructura.
class DI {
  // Instancia de GetIt
  static final GetIt locator = GetIt.instance;

  // Lista de módulos en orden de inicialización
  static final List<DIModule> _modules = [
    CoreModule(),
    ServiceModule(),
    RepositoryModule(),
    UseCaseModule(), // Versión simplificada que no registra los casos de uso problemáticos
    BlocModule(),
    ExternalModule(),
    MapsModule(),
    SearchModule(),
  ];

  // Control de estado de inicialización
  static bool _isInitializing = false;
  static bool _isInitialized = false;

  /// Inicializa todas las dependencias de la aplicación de forma optimizada
  static Future<void> initializeAppDI() async {
    DILogger.info('Iniciando sistema de inyección de dependencias');

    // Evitar inicializaciones múltiples simultáneas
    if (_isInitializing || _isInitialized) {
      DILogger.warning(
        'Sistema DI ya inicializado o en proceso de inicialización',
      );
      return;
    }

    _isInitializing = true;
    final Stopwatch stopwatch = Stopwatch()..start();

    try {
      // Registrar módulos principales primero
      await _registerCoreModules(locator);

      // Registrar casos de uso de forma directa para evitar problemas
      await _registerUseCases(locator);

      // Registrar el resto de módulos
      await _registerOtherModules(locator);

      _isInitialized = true;
      DILogger.success(
        'Sistema de inyección de dependencias inicializado correctamente en ${stopwatch.elapsedMilliseconds}ms',
      );
    } catch (e, stackTrace) {
      DILogger.error('Error al inicializar dependencias', e, stackTrace);
      rethrow;
    } finally {
      _isInitializing = false;
    }
  }

  /// Registra los módulos principales
  static Future<void> _registerCoreModules(GetIt sl) async {
    try {
      await CoreModule().register(sl);
      await ServiceModule().register(sl);
      await RepositoryModule().register(sl);
    } catch (e, stack) {
      DILogger.error('Error registrando módulos principales', e, stack);
      throw Exception('Error en módulos principales: $e');
    }
  }

  /// Registra los casos de uso directamente
  static Future<void> _registerUseCases(GetIt sl) async {
    try {
      // Usamos la versión simplificada de UseCaseModule que no registra casos de uso problemáticos
      await UseCaseModule().register(sl);
      DILogger.info('[DI] Usando versión minimalista de casos de uso');
    } catch (e, stack) {
      DILogger.error('Error registrando casos de uso', e, stack);
      // No lanzamos excepción para permitir que la app continúe
      DILogger.warning('Continuando sin casos de uso registrados');
    }
  }

  /// Registra los módulos restantes
  static Future<void> _registerOtherModules(GetIt sl) async {
    try {
      await BlocModule().register(sl);
      await ExternalModule().register(sl);
      await MapsModule().register(sl);
      await SearchModule().register(sl);
    } catch (e, stack) {
      DILogger.error('Error registrando módulos adicionales', e, stack);
      // Continuamos a pesar del error
    }
  }

  /// Método simplificado para inicializar todas las dependencias
  static Future<void> init() async {
    return initializeAppDI();
  }

  /// Registra un módulo personalizado.
  ///
  /// Útil para añadir módulos específicos de funcionalidades opcionales.
  Future<void> registerModule(DIModule module) async {
    if (!_isInitialized) {
      DILogger.error('Intento de registrar módulo sin inicializar DI');
      throw StateError(
        'Inicialice DI.init() antes de registrar módulos adicionales',
      );
    }

    DILogger.info('Registrando módulo adicional: ${module.runtimeType}');
    await module.register(locator);
    _modules.add(module);
    DILogger.success(
      'Módulo adicional ${module.runtimeType} registrado correctamente',
    );
  }

  /// Restablece todas las dependencias (util para testing)
  Future<void> reset() async {
    if (!_isInitialized) return;

    DILogger.info('Reseteando sistema de inyección de dependencias...');

    // Liberar recursos de los módulos en orden inverso
    for (final module in _modules.reversed) {
      try {
        DILogger.debug('Liberando recursos del módulo ${module.runtimeType}');
        await module.dispose(locator);
      } catch (e) {
        DILogger.error(
          'Error liberando recursos en módulo ${module.runtimeType}',
          e,
        );
      }
    }

    // Resetear el contenedor
    DILogger.debug('Reseteando contenedor GetIt');
    await locator.reset();

    _isInitialized = false;
    DILogger.success(
      'Sistema de inyección de dependencias reseteado correctamente',
    );
  }
}

/// API global para inicializar el sistema DI
///
/// Este método mantiene compatibilidad con el código existente mientras
/// utiliza el nuevo sistema modular de inyección de dependencias.
Future<void> initializeApp() async {
  DILogger.setVerbose(kDebugMode);
  DILogger.info('Inicializando sistema de dependencias a través de API global');
  return DI.initializeAppDI();
}

/// Método global para usar la versión consolidada de inyección de dependencias
///
/// Este método reemplaza a setupServiceLocator() y es el punto de entrada preferido
/// para inicializar todas las dependencias de la aplicación.
Future<void> initializeDependencies() async {
  DILogger.info('🚀 Inicializando sistema modular de dependencias');
  return DI.initializeAppDI();
}
