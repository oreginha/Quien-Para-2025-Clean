// lib/domain/failures/failure_helper.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/presentation/widgets/errors/app_exceptions.dart';
// Ya no es necesario importar FormatFailure pues está en app_failures.dart

/// Helper para convertir excepciones en objetos AppFailure.
///
/// Proporciona métodos para mapear diferentes tipos de excepciones a fallos
/// de dominio específicos, facilitando el manejo de errores consistente.
class FailureHelper {
  /// Convierte una excepción genérica en un AppFailure.
  ///
  /// Identifica el tipo de excepción y devuelve un tipo apropiado de failure.
  static AppFailure fromException(dynamic exception, [StackTrace? stackTrace]) {
    if (exception is FirebaseAuthException) {
      return _mapAuthException(exception);
    } else if (exception is FirebaseException) {
      return _mapFirebaseException(exception);
    } else if (exception is NetworkException) {
      return NetworkFailure(message: exception.message, code: '');
    } else if (exception is FormatException) {
      return ValidationFailure(
        message: exception.message,
        code: 'format_error',
        field: '',
      );
    } else if (exception is AppFailure) {
      return exception;
    } else {
      return UnexpectedFailure(
        message: exception?.toString() ?? 'Unknown error',
        code: 'unknown_error',
        stackTrace: stackTrace,
        originalError: exception,
      );
    }
  }

  /// Mapea excepciones de Firebase Auth a fallos específicos.
  static AppFailure _mapAuthException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'user-not-found':
        return AuthFailure(
          code: 'user-not-found',
          message: 'No se encontró ningún usuario con este correo electrónico.',
        );
      case 'wrong-password':
        return AuthFailure(
          code: 'wrong-password',
          message: 'Contraseña incorrecta.',
        );
      case 'email-already-in-use':
        return AuthFailure(
          code: 'email-already-in-use',
          message: 'Este correo electrónico ya está en uso.',
        );
      case 'weak-password':
        return AuthFailure(
          code: 'weak-password',
          message: 'La contraseña es demasiado débil.',
        );
      case 'invalid-email':
        return AuthFailure(
          code: 'invalid-email',
          message: 'El formato del correo electrónico es inválido.',
        );
      case 'operation-not-allowed':
        return AuthFailure(
          code: 'operation-not-allowed',
          message: 'Esta operación no está permitida.',
        );
      case 'user-disabled':
        return AuthFailure(
          code: 'user-disabled',
          message: 'Esta cuenta ha sido deshabilitada.',
        );
      case 'too-many-requests':
        return AuthFailure(
          code: 'too-many-requests',
          message: 'Demasiados intentos fallidos. Intente más tarde.',
        );
      case 'network-request-failed':
        return NetworkFailure(
          message: 'Error de conexión. Verifique su conexión a internet.',
          code: 'network_error',
        );
      default:
        return AuthFailure(
          code: exception.code,
          message: exception.message ?? 'Error de autenticación',
        );
    }
  }

  /// Mapea excepciones de Firebase a fallos específicos.
  static AppFailure _mapFirebaseException(FirebaseException exception) {
    switch (exception.code) {
      case 'permission-denied':
        return PermissionFailure(
          message: 'No tienes permisos para realizar esta acción.',
          code: 'permission_denied',
        );
      case 'not-found':
        return NotFoundFailure(
          message: 'El recurso solicitado no existe.',
          code: 'not_found',
        );
      case 'already-exists':
        return DatabaseFailure(
          message: 'El recurso ya existe.',
          code: 'already-exists',
          originalError: exception,
        );
      case 'unavailable':
        return NetworkFailure(
          message: 'Servicio no disponible. Intente más tarde.',
          code: 'service_unavailable',
        );
      case 'resource-exhausted':
        return DatabaseFailure(
          message: 'Demasiadas solicitudes. Intente más tarde.',
          code: 'resource-exhausted',
          originalError: exception,
        );
      case 'cancelled':
        return DatabaseFailure(
          message: 'Operación cancelada.',
          code: 'cancelled',
          originalError: exception,
        );
      case 'deadline-exceeded':
        return DatabaseFailure(
          message: 'La operación tardó demasiado tiempo. Intente de nuevo.',
          code: 'deadline-exceeded',
          originalError: exception,
        );
      default:
        return DatabaseFailure(
          code: exception.code,
          message: exception.message ?? 'Error del servidor',
          originalError: exception,
        );
    }
  }

  /// Crea un fallo específico para problemas de conexión.
  static NetworkFailure networkFailure({String? message}) {
    return NetworkFailure(
      message:
          message ?? 'Error de conexión. Verifique su conexión a internet.',
      code: 'network_error',
    );
  }

  /// Crea un fallo específico para operaciones de caché.
  static CacheFailure cacheFailure({String? message}) {
    return CacheFailure(
      message: message ?? 'Error al acceder a la caché local.',
      code: 'cache_error',
    );
  }

  /// Crea un fallo específico para problemas de permisos.
  static PermissionFailure permissionFailure({String? message}) {
    return PermissionFailure(
      message: message ?? 'No tienes permisos para realizar esta acción.',
      code: 'permission_denied',
    );
  }

  /// Crea un fallo específico para recursos no encontrados.
  static NotFoundFailure notFoundFailure({String? message}) {
    return NotFoundFailure(
      message: message ?? 'El recurso solicitado no existe.',
      code: 'not_found',
    );
  }

  /// Crea un fallo específico para validación de datos.
  static ValidationFailure validationFailure({String? message, String? field}) {
    return ValidationFailure(
      message: message ?? 'Error de validación',
      code: 'validation_error',
      field: field ?? '',
    );
  }
}
