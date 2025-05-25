// lib/core/di/di_emergency.dart

import 'package:get_it/get_it.dart';
import 'di_logger.dart';

// Módulos - Solo los ESENCIALES
import 'modules/core_module.dart';
import 'modules/service_module.dart';
import 'modules/repository_module.dart';
import 'modules/bloc_module.dart';
import 'modules/external_module.dart';
import 'modules/maps_module.dart';
import 'modules/search_module.dart';
import 'modules/di_module.dart';
// NO importamos usecase_module.dart en absoluto

/// Singleton de GetIt para toda la aplicación (modo emergencia sin casos de uso)
final GetIt sl = GetIt.instance;

/// Sistema de inyección de dependencias modular para EMERGENCIA
///
/// Esta versión elimina completamente las referencias a casos de uso
class DI {
  // Instancia de GetIt
  static final GetIt locator = GetIt.instance;

  // Lista de módulos esenciales - SIN CASOS DE USO
  static final List<DIModule> _modules = [
    CoreModule(),
    ServiceModule(),
    RepositoryModule(),
    BlocModule(),
    ExternalModule(),
    MapsModule(),
    SearchModule(),
  ];

  // Control de estado de inicialización
  static bool _isInitializing = false;
  static bool _isInitialized = false;

  /// Inicializa solo las dependencias esenciales
  static Future<void> initializeEmergencyDI() async {
    DILogger.info(
        '[EMERGENCIA] Iniciando sistema de inyección de dependencias sin casos de uso');

    // Evitar inicializaciones múltiples simultáneas
    if (_isInitializing || _isInitialized) {
      DILogger.warning(
          'Sistema DI ya inicializado o en proceso de inicialización');
      return;
    }

    _isInitializing = true;
    final Stopwatch stopwatch = Stopwatch()..start();

    try {
      // BLOQUE CRUCIAL: Prevenir inicialización de casos de uso
      // Esto debe hacerse ANTES de registrar cualquier módulo
      //preventUseCaseInitialization(locator);
      //DILogger.success('[EMERGENCIA] Prevención de casos de uso activada');

      // Registrar módulos principales primero
      await _registerCoreModules(locator);

      // NO registramos casos de uso en absoluto
      DILogger.info('[EMERGENCIA] Omitiendo completamente los casos de uso');

      // Registrar el resto de módulos
      await _registerOtherModules(locator);

      _isInitialized = true;
      DILogger.success(
          '[EMERGENCIA] Sistema DI inicializado correctamente en ${stopwatch.elapsedMilliseconds}ms (sin casos de uso)');
    } catch (e, stackTrace) {
      DILogger.error(
          '[EMERGENCIA] Error al inicializar dependencias', e, stackTrace);
      // No propagamos el error para permitir continuar
      DILogger.warning('[EMERGENCIA] Continuando a pesar del error');
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
      DILogger.success('[EMERGENCIA] Módulos core registrados correctamente');
    } catch (e, stack) {
      DILogger.error(
          '[EMERGENCIA] Error registrando módulos principales', e, stack);
      // No lanzamos excepción para permitir continuar
      DILogger.warning(
          '[EMERGENCIA] Continuando a pesar del error en módulos principales');
    }
  }

  /// Registra los módulos restantes
  static Future<void> _registerOtherModules(GetIt sl) async {
    // Envolvemos cada registro en un try-catch para ser resistentes a fallos

    try {
      await BlocModule().register(sl);
      DILogger.debug('[EMERGENCIA] BlocModule registrado');
    } catch (e, stack) {
      DILogger.error('[EMERGENCIA] Error registrando BlocModule', e, stack);
    }

    try {
      await ExternalModule().register(sl);
      DILogger.debug('[EMERGENCIA] ExternalModule registrado');
    } catch (e, stack) {
      DILogger.error('[EMERGENCIA] Error registrando ExternalModule', e, stack);
    }

    try {
      await MapsModule().register(sl);
      DILogger.debug('[EMERGENCIA] MapsModule registrado');
    } catch (e, stack) {
      DILogger.error('[EMERGENCIA] Error registrando MapsModule', e, stack);
    }

    try {
      await SearchModule().register(sl);
      DILogger.debug('[EMERGENCIA] SearchModule registrado');
    } catch (e, stack) {
      DILogger.error('[EMERGENCIA] Error registrando SearchModule', e, stack);
    }

    DILogger.success('[EMERGENCIA] Registro de módulos adicionales completado');
  }

  /// Método simplificado para inicializar las dependencias de emergencia
  static Future<void> init() async {
    return initializeEmergencyDI();
  }
}
