// lib/core/error/error_handler.dart
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Tipo de error para clasificación y manejo específico
enum ErrorType {
  /// Error de red (sin conexión, timeout, etc.)
  network,

  /// Error de autenticación (no autorizado, sesión expirada)
  auth,

  /// Error de permisos (acceso prohibido)
  permission,

  /// Error de validación (datos inválidos)
  validation,

  /// Error de servidor (error 500, etc.)
  server,

  /// Error de datos no encontrados (404)
  notFound,

  /// Error desconocido
  unknown,
}

/// Clase para manejar excepciones de forma estandarizada
class AppException implements Exception {
  final String message;
  final ErrorType type;
  final dynamic originalError;
  final StackTrace? stackTrace;

  AppException({
    required this.message,
    this.type = ErrorType.unknown,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => message;
}

/// Utilidad para manejar errores de forma consistente en toda la aplicación
class ErrorHandler {
  static final Logger _logger = Logger();

  /// Maneja una excepción y devuelve un AppException con información estructurada
  static AppException handleError(dynamic error, [StackTrace? stackTrace]) {
    // Si ya es un AppException, lo devolvemos directamente
    if (error is AppException) {
      return error;
    }

    String message;
    ErrorType type = ErrorType.unknown;

    // Manejar tipos específicos de error
    if (error.toString().contains('SocketException') ||
        error.toString().contains('TimeoutException')) {
      message = 'Error de conexión. Verifica tu conexión a Internet.';
      type = ErrorType.network;
    } else if (error.toString().contains('Unauthorized') ||
        error.toString().contains('Invalid token') ||
        error.toString().contains('Session expired')) {
      message =
          'Sesión expirada o no autorizada. Por favor, inicia sesión nuevamente.';
      type = ErrorType.auth;
    } else if (error.toString().contains('Permission') ||
        error.toString().contains('Forbidden')) {
      message = 'No tienes permisos para realizar esta acción.';
      type = ErrorType.permission;
    } else if (error.toString().contains('Not found') ||
        error.toString().contains('404')) {
      message = 'El recurso solicitado no fue encontrado.';
      type = ErrorType.notFound;
    } else if (error.toString().contains('Invalid') ||
        error.toString().contains('validation')) {
      message = 'Los datos proporcionados no son válidos.';
      type = ErrorType.validation;
    } else if (error.toString().contains('Server error') ||
        error.toString().contains('500')) {
      message = 'Error en el servidor. Intenta más tarde.';
      type = ErrorType.server;
    } else {
      // Para errores desconocidos, mostrar un mensaje más genérico en producción
      message = kDebugMode
          ? 'Error: ${error.toString()}'
          : 'Ha ocurrido un error inesperado.';
    }

    // Registrar el error para análisis
    _logger.e(message, error: error, stackTrace: stackTrace);

    return AppException(
      message: message,
      type: type,
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// Método para manejar errores específicos de Firebase
  static AppException handleFirebaseError(
    dynamic error, [
    StackTrace? stackTrace,
  ]) {
    String message;
    ErrorType type = ErrorType.unknown;

    final errorCode = _extractFirebaseErrorCode(error.toString());

    switch (errorCode) {
      case 'network-request-failed':
        message = 'Error de conexión. Verifica tu conexión a Internet.';
        type = ErrorType.network;
        break;
      case 'user-not-found':
      case 'wrong-password':
        message = 'Credenciales inválidas. Verifica tu correo y contraseña.';
        type = ErrorType.auth;
        break;
      case 'email-already-in-use':
        message = 'Este correo ya está en uso por otra cuenta.';
        type = ErrorType.validation;
        break;
      case 'weak-password':
        message = 'La contraseña es demasiado débil.';
        type = ErrorType.validation;
        break;
      case 'permission-denied':
        message = 'No tienes permisos para realizar esta acción.';
        type = ErrorType.permission;
        break;
      case 'not-found':
        message = 'El recurso solicitado no fue encontrado.';
        type = ErrorType.notFound;
        break;
      default:
        message = kDebugMode
            ? 'Error de Firebase: ${error.toString()}'
            : 'Ha ocurrido un error inesperado.';
        break;
    }

    // Registrar el error para análisis
    _logger.e(
      'Error de Firebase: $message',
      error: error,
      stackTrace: stackTrace,
    );

    return AppException(
      message: message,
      type: type,
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// Extrae el código de error de un mensaje de error de Firebase
  static String _extractFirebaseErrorCode(String errorMessage) {
    final RegExp regExp = RegExp(r'\[(.*?)\]');
    final match = regExp.firstMatch(errorMessage);

    if (match != null && match.groupCount >= 1) {
      return match.group(1) ?? 'unknown-error';
    }

    return 'unknown-error';
  }

  /// Muestra mensajes más descriptivos para errores comunes
  static String getReadableErrorMessage(AppException exception) {
    switch (exception.type) {
      case ErrorType.network:
        return 'No fue posible conectarse al servidor. Verifica tu conexión a Internet y vuelve a intentarlo.';
      case ErrorType.auth:
        return 'Tu sesión ha expirado o no tienes autorización. Por favor, inicia sesión nuevamente.';
      case ErrorType.permission:
        return 'No tienes los permisos necesarios para realizar esta acción.';
      case ErrorType.validation:
        return 'La información proporcionada no es válida. Por favor revisa los datos e intenta nuevamente.';
      case ErrorType.server:
        return 'Estamos experimentando problemas técnicos. Intenta nuevamente más tarde.';
      case ErrorType.notFound:
        return 'Lo que estás buscando no se encuentra disponible o ha sido eliminado.';
      case ErrorType.unknown:
        return kDebugMode
            ? 'Error: ${exception.message}'
            : 'Ha ocurrido un error inesperado. Intenta nuevamente más tarde.';
    }
  }
}
