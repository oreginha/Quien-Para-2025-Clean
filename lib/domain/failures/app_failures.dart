// lib/domain/failures/app_failures.dart

import 'package:equatable/equatable.dart';

/// Clase base para todos los fallos de la aplicación
///
/// Proporciona un manejo consistente de errores a través de la aplicación.
class AppFailure extends Equatable {
  final String message;
  final String code;
  final StackTrace? stackTrace;
  final Object? originalError;

  const AppFailure({
    required this.message,
    required this.code,
    this.stackTrace,
    this.originalError,
  });

  @override
  List<Object?> get props => [message, code, originalError];

  @override
  String toString() => 'AppFailure: $message';
}

/// Fallo relacionado con operaciones de red
class NetworkFailure extends AppFailure {
  const NetworkFailure({
    required super.message,
    required super.code,
    super.stackTrace,
    super.originalError,
  });
}

/// Fallo relacionado con operaciones de base de datos
class DatabaseFailure extends AppFailure {
  const DatabaseFailure({
    required super.message,
    required super.code,
    super.stackTrace,
    super.originalError,
  });
}

/// Fallo específico cuando no se encuentra un recurso
class NotFoundFailure extends AppFailure {
  const NotFoundFailure({
    required super.message,
    required super.code,
    super.stackTrace,
    super.originalError,
  });
}

/// Fallo de validación de datos
class ValidationFailure extends AppFailure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    required super.message,
    required super.code,
    this.fieldErrors,
    super.stackTrace,
    super.originalError,
    required String field,
  });

  @override
  List<Object?> get props => [message, fieldErrors, originalError];
}

/// Fallo de caché
class CacheFailure extends AppFailure {
  const CacheFailure({
    required super.message,
    required super.code,
    super.stackTrace,
    super.originalError,
  });
}

/// Fallo de autenticación
class AuthFailure extends AppFailure {
  const AuthFailure({
    required super.message,
    required super.code,
    super.stackTrace,
    super.originalError,
  });
}

/// Fallo de permisos
class PermissionFailure extends AppFailure {
  const PermissionFailure({
    required super.message,
    required super.code,
    super.stackTrace,
    super.originalError,
  });
}

/// Fallo inesperado/genérico
class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure({
    required super.message,
    required super.code,
    super.stackTrace,
    super.originalError,
  });
}

/// Utilidad para convertir excepciones en fallos
class FailureHelper {
  /// Convierte una excepción en un objeto AppFailure apropiado
  static AppFailure fromException(Object error, [StackTrace? stackTrace]) {
    if (error is AppFailure) {
      return error;
    }

    // Determinar el tipo de error basado en la clase de excepción
    final String errorString = error.toString().toLowerCase();

    if (errorString.contains('network') ||
        errorString.contains('socket') ||
        errorString.contains('connection') ||
        errorString.contains('timeout')) {
      return NetworkFailure(
        message: 'Error de red: ${error.toString()}',
        stackTrace: stackTrace,
        originalError: error,
        code: '',
      );
    }

    if (errorString.contains('not found') ||
        errorString.contains('no encontrado') ||
        errorString.contains('404')) {
      return NotFoundFailure(
        message: 'Recurso no encontrado: ${error.toString()}',
        stackTrace: stackTrace,
        originalError: error,
        code: '',
      );
    }

    if (errorString.contains('database') ||
        errorString.contains('firestore') ||
        errorString.contains('firebase')) {
      return DatabaseFailure(
        message: 'Error de base de datos: ${error.toString()}',
        stackTrace: stackTrace,
        originalError: error,
        code: '',
      );
    }

    // Verificar autenticación antes que validación
    if (errorString.contains('auth') ||
        errorString.contains('unauthorized') ||
        errorString.contains('unauthenticated')) {
      return AuthFailure(
        message: 'Error de autenticación: ${error.toString()}',
        stackTrace: stackTrace,
        originalError: error,
        code: '',
      );
    }

    if (errorString.contains('validation') ||
        errorString.contains('invalid') ||
        errorString.contains('validación')) {
      return ValidationFailure(
        message: 'Error de validación: ${error.toString()}',
        stackTrace: stackTrace,
        originalError: error,
        code: '',
        field: '',
      );
    }

    if (errorString.contains('permission') ||
        errorString.contains('denied') ||
        errorString.contains('access')) {
      return PermissionFailure(
        message: 'Error de permisos: ${error.toString()}',
        stackTrace: stackTrace,
        originalError: error,
        code: '',
      );
    }

    if (errorString.contains('cache') || errorString.contains('caché')) {
      return CacheFailure(
        message: 'Error de caché: ${error.toString()}',
        stackTrace: stackTrace,
        originalError: error,
        code: '',
      );
    }

    // Si no podemos determinar el tipo específico, devolvemos un error inesperado
    return UnexpectedFailure(
      message: 'Error inesperado: ${error.toString()}',
      stackTrace: stackTrace,
      originalError: error,
      code: '',
    );
  }
}
