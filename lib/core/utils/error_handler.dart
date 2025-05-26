// lib/core/utils/error_handler.dart

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:quien_para/core/errors/exceptions.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:logger/logger.dart';

/// Clase utilitaria para manejo consistente de errores en toda la aplicación.
///
/// Proporciona métodos para:
/// - Manejar errores de manera uniforme
/// - Transformar excepciones en tipos de fallo específicos
/// - Registrar errores con niveles apropiados
/// - Ejecutar operaciones con manejo de errores incorporado
class ErrorHandler {
  final Logger _logger;

  /// Constructor que recibe un Logger para registro de errores
  ErrorHandler({required Logger logger}) : _logger = logger;

  /// Maneja un error y devuelve un AppFailure apropiado
  AppFailure handleError(
    String operation,
    dynamic error, [
    StackTrace? stackTrace,
  ]) {
    // Registrar el error
    _logError(operation, error, stackTrace);

    // Transformar errores específicos en tipos de fallo apropiados
    if (error is FirebaseException) {
      return _handleFirebaseException(operation, error);
    } else if (error is FirebaseAuthException) {
      return _handleFirebaseAuthException(operation, error);
    } else if (error is ArgumentError) {
      return AppFailure(
        message: 'Error de argumento: ${error.message}',
        code: 'INVALID_ARGUMENT',
      );
    } else if (error is TimeoutException) {
      return AppFailure(
        message: 'La operación agotó el tiempo de espera',
        code: 'TIMEOUT',
      );
    } else if (error is NetworkException) {
      return AppFailure(
        message: 'Error de red. Verifique su conexión a Internet',
        code: 'NETWORK_ERROR',
      );
    } else {
      // Error genérico para cualquier otra excepción
      return AppFailure(
        message: 'Error al $operation: ${error.toString()}',
        code: 'UNKNOWN_ERROR',
      );
    }
  }

  /// Maneja errores específicos de Firebase
  AppFailure _handleFirebaseException(
    String operation,
    FirebaseException error,
  ) {
    // Mapear códigos de error de Firebase a mensajes amigables
    switch (error.code) {
      case 'permission-denied':
        return AppFailure(
          message: 'No tienes permisos para realizar esta operación',
          code: 'PERMISSION_DENIED',
        );
      case 'not-found':
        return AppFailure(
          message: 'El recurso solicitado no fue encontrado',
          code: 'NOT_FOUND',
        );
      case 'already-exists':
        return AppFailure(
          message: 'El recurso ya existe',
          code: 'ALREADY_EXISTS',
        );
      case 'unavailable':
        return AppFailure(
          message: 'El servicio no está disponible actualmente',
          code: 'SERVICE_UNAVAILABLE',
        );
      default:
        return AppFailure(
          message: 'Error de Firebase al $operation: ${error.message}',
          code: error.code,
        );
    }
  }

  /// Maneja errores específicos de Firebase Auth
  AppFailure _handleFirebaseAuthException(
    String operation,
    FirebaseAuthException error,
  ) {
    // Mapear códigos de error de Firebase Auth a mensajes amigables
    switch (error.code) {
      case 'user-not-found':
        return AppFailure(
          message: 'No se encontró ninguna cuenta con este correo electrónico',
          code: 'USER_NOT_FOUND',
        );
      case 'wrong-password':
        return AppFailure(
          message: 'Contraseña incorrecta',
          code: 'WRONG_PASSWORD',
        );
      case 'email-already-in-use':
        return AppFailure(
          message:
              'Este correo electrónico ya está siendo utilizado por otra cuenta',
          code: 'EMAIL_ALREADY_IN_USE',
        );
      case 'weak-password':
        return AppFailure(
          message: 'La contraseña es demasiado débil',
          code: 'WEAK_PASSWORD',
        );
      case 'invalid-email':
        return AppFailure(
          message: 'El correo electrónico no es válido',
          code: 'INVALID_EMAIL',
        );
      case 'operation-not-allowed':
        return AppFailure(
          message: 'Operación no permitida',
          code: 'OPERATION_NOT_ALLOWED',
        );
      case 'user-disabled':
        return AppFailure(
          message: 'Esta cuenta ha sido deshabilitada',
          code: 'USER_DISABLED',
        );
      case 'invalid-verification-code':
        return AppFailure(
          message: 'Código de verificación inválido',
          code: 'INVALID_VERIFICATION_CODE',
        );
      default:
        return AppFailure(
          message: 'Error de autenticación al $operation: ${error.message}',
          code: error.code,
        );
    }
  }

  /// Registra el error con el nivel apropiado
  void _logError(String operation, dynamic error, [StackTrace? stackTrace]) {
    final errorMessage = 'Error al $operation: $error';

    // Usar diferentes niveles de log según el tipo de error
    if (error is ArgumentError) {
      _logger.w(errorMessage, error: error, stackTrace: stackTrace);
    } else if (error is FirebaseException &&
        (error.code == 'not-found' || error.code == 'permission-denied')) {
      _logger.w(errorMessage, error: error, stackTrace: stackTrace);
    } else {
      _logger.e(errorMessage, error: error, stackTrace: stackTrace);
    }

    // Log para desarrollo en la consola
    if (kDebugMode) {
      print(errorMessage);
      if (stackTrace != null) {
        print('StackTrace: $stackTrace');
      }
    }
  }

  /// Ejecuta una operación con manejo de errores incorporado
  ///
  /// Devuelve un Either con el resultado o un AppFailure en caso de error
  Future<Either<AppFailure, T>> executeWithTryCatch<T>(
    String operation,
    Future<T> Function() action,
  ) async {
    try {
      final result = await action();
      return right(result);
    } catch (e, stackTrace) {
      final failure = handleError(operation, e, stackTrace);
      return left(failure);
    }
  }

  /// Ejecuta una operación que ya devuelve un Either, manejando cualquier excepción adicional
  Future<Either<AppFailure, T>> executeSafe<T>(
    String operation,
    Future<Either<AppFailure, T>> Function() action,
  ) async {
    try {
      return await action();
    } catch (e, stackTrace) {
      final failure = handleError(operation, e, stackTrace);
      return left(failure);
    }
  }
}

/// Excepción para errores de red
class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Error de red']);

  @override
  String toString() => message;
}

/// Extension para proporcionar métodos de utilidad para manejo de errores
extension ErrorHandlingExtension<T> on Future<T> {
  /// Transforma este Future en un Either, manejando errores automáticamente
  Future<Either<AppFailure, T>> toEither(
    ErrorHandler errorHandler,
    String operation,
  ) async {
    try {
      final result = await this;
      return right(result);
    } catch (e, stackTrace) {
      final failure = errorHandler.handleError(operation, e, stackTrace);
      return left(failure);
    }
  }
}
