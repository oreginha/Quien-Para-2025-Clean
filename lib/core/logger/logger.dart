// lib/core/logger/logger.dart
import 'package:logger/logger.dart' as log_package;
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;
  AppLogger._internal();

  final log_package.Logger _logger = log_package.Logger(
    printer: log_package.PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: (final DateTime dateTime) =>
          DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime),
    ),
    level: kDebugMode ? log_package.Level.trace : log_package.Level.warning,
  );

  void v(final String message,
      {final String? tag, final dynamic error, final StackTrace? stackTrace}) {
    _log(log_package.Level.trace, message, tag, error, stackTrace);
  }

  void d(final String message,
      {final String? tag, final dynamic error, final StackTrace? stackTrace}) {
    _log(log_package.Level.debug, message, tag, error, stackTrace);
  }

  void i(final String message,
      {final String? tag, final dynamic error, final StackTrace? stackTrace}) {
    _log(log_package.Level.info, message, tag, error, stackTrace);
  }

  void w(final String message,
      {final String? tag, final dynamic error, final StackTrace? stackTrace}) {
    _log(log_package.Level.warning, message, tag, error, stackTrace);
  }

  void e(final String message,
      {final String? tag, final dynamic error, final StackTrace? stackTrace}) {
    _log(log_package.Level.error, message, tag, error, stackTrace);
  }

  void _log(final log_package.Level level, final String message,
      final String? tag, final dynamic error, final StackTrace? stackTrace) {
    final String logMessage = tag != null ? '[$tag] $message' : message;

    switch (level) {
      case log_package.Level.debug:
        _logger.d(logMessage, error: error, stackTrace: stackTrace);
        break;
      case log_package.Level.info:
        _logger.i(logMessage, error: error, stackTrace: stackTrace);
        break;
      case log_package.Level.warning:
        _logger.w(logMessage, error: error, stackTrace: stackTrace);
        break;
      case log_package.Level.error:
        _logger.e(logMessage, error: error, stackTrace: stackTrace);
        break;
      default:
        _logger.d(logMessage, error: error, stackTrace: stackTrace);
    }
  }
}

// Singleton para fácil acceso
final AppLogger logger = AppLogger();
