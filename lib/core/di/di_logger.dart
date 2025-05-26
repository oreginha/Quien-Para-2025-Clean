// lib/core/di/di_logger.dart

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Sistema de logging especializado para el sistema de inyección de dependencias
///
/// Proporciona métodos de logging con prefijos estandarizados y niveles
/// para facilitar el seguimiento y depuración del sistema DI.
class DILogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
    ),
  );

  // Nivel de logging (0=silencio, 1=error, 2=warn, 3=info, 4=debug, 5=verbose)
  static int _logLevel = kDebugMode ? 5 : 3;

  // Lista de mensajes para diagnóstico
  static final List<String> _logHistory = [];
  static const int _maxHistorySize = 1000;

  // Nombres descriptivos para tipos de dependencias
  static final Map<String, String> _friendlyNames = {};

  // Banderas para config
  static bool _consoleOutput = true;
  static final bool _fileOutput = false;
  static bool _detailedOutput = kDebugMode;

  /// Establece el nivel de verbosidad del logging (0-5)
  static void setLogLevel(int level) {
    _logLevel = level.clamp(0, 5);
    debug('Nivel de log establecido a $_logLevel');
  }

  /// Establece el modo verbose (nivel máximo de logs)
  static void setVerbose(bool value) {
    _logLevel = value ? 5 : 3;
    debug('Modo verbose ${value ? 'activado' : 'desactivado'}');
  }

  /// Habilita o deshabilita la salida por consola
  static void setConsoleOutput(bool enabled) {
    _consoleOutput = enabled;
  }

  /// Habilita o deshabilita la salida detallada
  static void setDetailedOutput(bool detailed) {
    _detailedOutput = detailed;
  }

  /// Registra un nombre amigable para un tipo (para depuración)
  static void registerFriendlyName(String typeName, String friendlyName) {
    _friendlyNames[typeName] = friendlyName;
  }

  /// Log de información general
  static void info(String message) {
    if (_logLevel >= 3) {
      _logMessage('🔵 [DI] $message', LogLevel.info);
    }
  }

  /// Log de éxito (operación completada correctamente)
  static void success(String message) {
    if (_logLevel >= 3) {
      _logMessage('✅ [DI] $message', LogLevel.info);
    }
  }

  /// Log de advertencia (posible problema)
  static void warning(String message) {
    if (_logLevel >= 2) {
      _logMessage('⚠️ [DI] $message', LogLevel.warning);
    }
  }

  /// Log de error (problema que requiere atención)
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (_logLevel >= 1) {
      _logMessage('❌ [DI] $message', LogLevel.error, error, stackTrace);
    }
  }

  /// Log de debug (detalles para depuración)
  static void debug(String message) {
    if (_logLevel >= 4) {
      _logMessage('🔍 [DI] $message', LogLevel.debug);
    }
  }

  /// Log muy detallado (solo para diagnóstico profundo)
  static void verbose(String message) {
    if (_logLevel >= 5) {
      _logMessage('🔬 [DI] $message', LogLevel.verbose);
    }
  }

  /// Log de objeto completo (para inspección detallada)
  static void dump(String label, Object object) {
    if (_logLevel >= 4) {
      _logMessage('📦 [DI] $label: $object', LogLevel.debug);
    }
  }

  /// Log de inicio de un proceso importante
  static void startProcess(String processName) {
    if (_logLevel >= 3) {
      _logMessage('🚀 [DI] Iniciando: $processName', LogLevel.info);
    }
  }

  /// Log de finalización de un proceso importante
  static void endProcess(String processName, int timeMs) {
    if (_logLevel >= 3) {
      _logMessage(
        '🏁 [DI] Completado: $processName en ${timeMs}ms',
        LogLevel.info,
      );
    }
  }

  /// Log de registro de módulo
  static void moduleRegister(String moduleName) {
    if (_logLevel >= 3) {
      _logMessage('📦 [DI] Registrando módulo: $moduleName', LogLevel.info);
    }
  }

  /// Log de registro de dependencia
  static void registerDependency(String type, String implementation) {
    if (_logLevel >= 4) {
      final friendlyType = _friendlyNames[type] ?? type;
      final friendlyImpl = _friendlyNames[implementation] ?? implementation;

      _logMessage(
        '🔧 [DI] Registrando $friendlyType con $friendlyImpl',
        LogLevel.debug,
      );
    }
  }

  /// Obtiene un log histórico completo para diagnóstico
  static String getDiagnosticLog() {
    return _logHistory.join('\n');
  }

  /// Log formateado con metadata
  static void _logMessage(
    String message,
    LogLevel level, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    // Almacena el mensaje en la historia con timestamp
    final timestamp = DateTime.now().toString();
    final historyMessage = '[$timestamp] [$level] $message';

    _addToHistory(historyMessage);

    // Consola output
    if (_consoleOutput) {
      switch (level) {
        case LogLevel.error:
          _logger.e(message, error: error, stackTrace: stackTrace);
          debugPrint(message);
          if (error != null) {
            debugPrint('❌ [DI] Error: $error');
          }
          if (stackTrace != null && _detailedOutput) {
            debugPrint('❌ [DI] StackTrace: $stackTrace');
          }
          break;
        case LogLevel.warning:
          _logger.w(message);
          debugPrint(message);
          break;
        case LogLevel.info:
          _logger.i(message);
          debugPrint(message);
          break;
        case LogLevel.debug:
          _logger.d(message);
          if (_detailedOutput) {
            debugPrint(message);
          }
          break;
        case LogLevel.verbose:
          _logger.t(message);
          if (_detailedOutput) {
            debugPrint(message);
          }
          break;
      }
    }

    // File output
    if (_fileOutput) {
      // Implementación de la salida a archivo si se necesita
    }
  }

  /// Agrega un mensaje al historial con límite de tamaño
  static void _addToHistory(String message) {
    _logHistory.add(message);
    if (_logHistory.length > _maxHistorySize) {
      _logHistory.removeAt(0);
    }
  }

  /// Limpia el historial de logs
  static void clearHistory() {
    _logHistory.clear();
  }

  /// Devuelve todos los errores registrados para diagnóstico
  static List<String> getErrorLogs() {
    return _logHistory.where((log) => log.contains('[ERROR]')).toList();
  }
}

/// Niveles de logging para el sistema DI
enum LogLevel { error, warning, info, debug, verbose }
