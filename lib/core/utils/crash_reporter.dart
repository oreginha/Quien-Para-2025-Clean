// crash_reporter.dart
// Utilitario para manejo y reporte de errores en la aplicación

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

/// Clase para registrar y reportar errores de la aplicación
/// Útil para diagnosticar problemas en producción cuando los usuarios
/// reportan fallos en la aplicación.
class CrashReporter {
  // Singleton
  static final CrashReporter _instance = CrashReporter._internal();
  factory CrashReporter() => _instance;
  CrashReporter._internal();

  // Ruta al archivo de registro de errores
  String? _logFilePath;

  // Bandera para indicar si el reporte está habilitado
  bool _enabled = false;

  // Inicializar el reportero de errores
  Future<void> initialize() async {
    if (kDebugMode) {
      print('🚨 [CrashReporter] Inicializando sistema de reporte de errores');
    }

    try {
      // Obtener directorio para almacenar logs
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      _logFilePath = '${appDocDir.path}/crash_logs.txt';
      _enabled = true;

      if (kDebugMode) {
        print('📝 [CrashReporter] Archivo de logs: $_logFilePath');
      }

      // Limpiar logs antiguos (mantener solo los últimos 30 días)
      await _cleanOldLogs();
    } catch (e) {
      if (kDebugMode) {
        print('❌ [CrashReporter] Error al inicializar: $e');
      }
      _enabled = false;
    }
  }

  // Limpiar logs antiguos
  Future<void> _cleanOldLogs() async {
    if (!_enabled || _logFilePath == null) return;

    try {
      final File logFile = File(_logFilePath!);
      if (await logFile.exists()) {
        final String content = await logFile.readAsString();
        final List<String> logs = content.split('\n\n===== ERROR LOG =====\n');

        // Si hay menos de 50 registros, no hacer nada
        if (logs.length < 50) return;

        // Conservar solo los últimos 50 registros
        final String newContent =
            logs.sublist(logs.length - 50).join('\n\n===== ERROR LOG =====\n');
        await logFile.writeAsString(newContent);

        if (kDebugMode) {
          print('🧹 [CrashReporter] Logs antiguos eliminados');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ [CrashReporter] Error al limpiar logs: $e');
      }
    }
  }

  // Registrar un error con su stack trace
  Future<void> logError(dynamic error, StackTrace? stackTrace) async {
    if (!_enabled || _logFilePath == null) return;

    try {
      final String timestamp = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(DateTime.now());
      final String errorString = error.toString();
      final String stackString =
          stackTrace?.toString() ?? 'No stack trace disponible';

      // Formato del log
      final String logEntry = '\n===== ERROR LOG =====\n'
          'FECHA: $timestamp\n'
          'ERROR: $errorString\n'
          'STACK TRACE:\n$stackString\n';

      // Escribir al archivo
      final File logFile = File(_logFilePath!);
      await logFile.writeAsString(logEntry, mode: FileMode.append);

      if (kDebugMode) {
        print('📝 [CrashReporter] Error registrado en log');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ [CrashReporter] Error al guardar log: $e');
      }
    }
  }

  // Obtener todos los logs para enviar a soporte
  Future<String?> getErrorLogs() async {
    if (!_enabled || _logFilePath == null) return null;

    try {
      final File logFile = File(_logFilePath!);
      if (await logFile.exists()) {
        return await logFile.readAsString();
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ [CrashReporter] Error al leer logs: $e');
      }
    }

    return null;
  }

  // Borrar todos los logs
  Future<void> clearLogs() async {
    if (!_enabled || _logFilePath == null) return;

    try {
      final File logFile = File(_logFilePath!);
      if (await logFile.exists()) {
        await logFile.writeAsString('');
        if (kDebugMode) {
          print('🧹 [CrashReporter] Logs eliminados');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ [CrashReporter] Error al limpiar logs: $e');
      }
    }
  }
}
