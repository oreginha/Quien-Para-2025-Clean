// lib/core/repositories/base_repository.dart

// ignore_for_file: unintended_html_in_doc_comment

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/core/utils/error_handler.dart';
import 'package:quien_para/domain/failures/app_failures.dart';

/// Clase base para todos los repositorios de la aplicación.
///
/// Proporciona manejo de errores uniforme, logging y métodos comunes
/// que pueden ser utilizados por todos los repositorios derivados.
abstract class BaseRepository {
  final Logger _logger;
  final ErrorHandler _errorHandler;

  /// Constructor que recibe un logger para registro de errores
  BaseRepository({
    required Logger logger,
  })  : _logger = logger,
        _errorHandler = ErrorHandler(logger: logger);

  /// Ejecuta una operación con manejo de errores incorporado
  ///
  /// Devuelve un Either con el resultado o un AppFailure en caso de error
  Future<Either<AppFailure, T>> executeWithTryCatch<T>(
      String operation, Future<T> Function() action) async {
    return _errorHandler.executeWithTryCatch(operation, action);
  }

  /// Ejecuta una operación que ya devuelve un Either, manejando cualquier excepción adicional
  Future<Either<AppFailure, T>> executeSafe<T>(
      String operation, Future<Either<AppFailure, T>> Function() action) async {
    return _errorHandler.executeSafe(operation, action);
  }

  /// Maneja un error y devuelve un AppFailure apropiado
  AppFailure handleError(String operation, dynamic error,
      [StackTrace? stackTrace]) {
    return _errorHandler.handleError(operation, error, stackTrace);
  }

  /// Registra un evento o mensaje informativo
  void logInfo(String message) {
    _logger.i(message);
  }

  /// Registra una advertencia
  void logWarning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Registra un error
  void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Mapea un Future<T> a un Future<Either<AppFailure, T>>
  Future<Either<AppFailure, T>> mapToEither<T>(
      String operation, Future<T> future) async {
    try {
      final result = await future;
      return right(result);
    } catch (e, stackTrace) {
      final failure = handleError(operation, e, stackTrace);
      return left(failure);
    }
  }

  /// Convierte un valor a un Either, manejando el caso null como un error
  Either<AppFailure, T> valueToEither<T>(
      T? value, String errorMessage, String errorCode) {
    if (value == null) {
      return left(AppFailure(message: errorMessage, code: errorCode));
    }
    return right(value);
  }

  /// Crea un Either con un error específico
  Either<AppFailure, T> leftWithError<T>(String message, String code) {
    return left(AppFailure(message: message, code: code));
  }

  /// Método para limpiar recursos cuando ya no se necesita el repositorio
  Future<void> dispose() async {
    // Override en clases derivadas si es necesario
  }
}
