// lib/core/bloc/bloc_use_case_executor.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../../core/errors/error_handler.dart';

/// Utilidad para estandarizar la ejecución de casos de uso desde los BLoCs
///
/// Proporciona un enfoque estructurado para la delegación de lógica de negocio
/// desde los BLoCs a los casos de uso, facilitando la separación de responsabilidades.
/// Incluye protecciones contra emisores cerrados y manejo avanzado de errores.
class BlocUseCaseExecutor {
  static final Logger _logger = Logger();

  /// Ejecuta un caso de uso que devuelve un Future y maneja los estados y errores consistentemente
  ///
  /// Parámetros:
  /// - [emit]: El emisor de estados del BLoC
  /// - [loadingState]: Estado a emitir durante la carga
  /// - [execute]: Función que ejecuta el caso de uso y devuelve un Future
  /// - [onSuccess]: Callback que recibe el resultado exitoso y retorna el estado correspondiente
  /// - [onError]: Callback opcional que maneja errores específicos (si no se proporciona, se usa un manejo por defecto)
  /// - [operation]: Nombre descriptivo de la operación para el logging
  /// - [useFirebaseErrorHandler]: Si se debe usar el manejador de errores de Firebase
  static Future<void> execute<T, State>({
    required Emitter<State> emit,
    required State loadingState,
    required Future<T> Function() execute,
    required State Function(T result) onSuccess,
    required State Function(dynamic error) onError,
    String operation = 'operación',
    bool useFirebaseErrorHandler = false,
  }) async {
    try {
      // Verificar si el emisor está disponible antes de emitir el estado de carga
      if (!emit.isDone) {
        if (kDebugMode) {
          print(
              '💡 BlocUseCaseExecutor - Emitiendo estado de carga para $operation');
        }
        emit(loadingState);
      } else {
        if (kDebugMode) {
          print(
              '⚠️ BlocUseCaseExecutor - Emisor cerrado, no se pudo emitir estado de carga para $operation');
        }
      }

      // Ejecutar el caso de uso
      final T result = await execute();

      if (kDebugMode) {
        print(
            '✅ BlocUseCaseExecutor - Operación $operation completada exitosamente');
      }

      // Verificar nuevamente si el emisor está disponible antes de emitir el estado de éxito
      if (!emit.isDone) {
        final State successState = onSuccess(result);
        if (kDebugMode) {
          print(
              '💡 BlocUseCaseExecutor - Emitiendo estado de éxito tipo ${successState.runtimeType} para $operation');
        }
        emit(successState);
      } else {
        if (kDebugMode) {
          print(
              '⚠️ BlocUseCaseExecutor - Emisor cerrado, no se pudo emitir estado de éxito para $operation');
        }
      }
    } catch (e, stackTrace) {
      // Convertir el error a un AppException para un manejo consistente
      final AppException exception = useFirebaseErrorHandler
          ? ErrorHandler.handleFirebaseError(e, stackTrace)
          : ErrorHandler.handleError(e, stackTrace);

      // Registrar el error
      if (kDebugMode) {
        _logger.e(
          'Error en $operation: ${exception.message}',
          error: exception.originalError,
          stackTrace: exception.stackTrace,
        );
        print(
            '⛔ BlocUseCaseExecutor - ERROR en $operation: ${exception.message}');
      }

      // Emitir estado de error solo si el emisor aún está disponible
      if (!emit.isDone) {
        final State errorState = onError(exception);
        if (kDebugMode) {
          print(
              '💡 BlocUseCaseExecutor - Emitiendo estado de error tipo ${errorState.runtimeType} para $operation');
        }
        emit(errorState);
      } else {
        if (kDebugMode) {
          print(
              '⚠️ BlocUseCaseExecutor - Emisor cerrado, no se pudo emitir estado de error para $operation');
        }
      }
    }
  }

  /// Ejecuta un caso de uso con referencia al BLoC para manejar situaciones donde el emisor se cierra
  ///
  /// Esta variante proporciona mayor robustez para casos donde el BLoC puede cerrarse durante
  /// la ejecución del caso de uso, permitiendo reintento mediante eventos si es necesario.
  ///
  /// Parámetros:
  /// - [bloc]: Referencia al BLoC para verificar si está cerrado y aplicar estados directamente
  /// - [emit]: El emisor de estados del BLoC
  /// - [loadingState]: Estado a emitir durante la carga
  /// - [execute]: Función que ejecuta el caso de uso y devuelve un Future
  /// - [onSuccess]: Callback que recibe el resultado exitoso y retorna el estado correspondiente
  /// - [onError]: Callback opcional que maneja errores específicos
  /// - [refreshEvent]: Evento para reintentar si es necesario
  /// - [operation]: Nombre descriptivo de la operación para el logging
  /// - [useFirebaseErrorHandler]: Si se debe usar el manejador de errores de Firebase
  static Future<void> executeWithBloc<Event, State, T>({
    required Bloc<Event, State> bloc,
    required Emitter<State> emit,
    required State loadingState,
    required Future<T> Function() execute,
    required State Function(T result) onSuccess,
    required State Function(dynamic error) onError,
    required Event refreshEvent,
    String operation = 'operación',
    bool useFirebaseErrorHandler = false,
  }) async {
    try {
      // Verificar si el BLoC o el emisor están cerrados antes de intentar emitir
      if (bloc.isClosed) {
        if (kDebugMode) {
          print(
              '⚠️ BlocUseCaseExecutor - BLoC ${bloc.runtimeType} cerrado, abortando operación $operation');
        }
        return; // Salir sin hacer nada si el bloc está cerrado
      }

      // Verificar si el emisor está disponible antes de emitir el estado de carga
      if (!emit.isDone) {
        if (kDebugMode) {
          print(
              '💡 BlocUseCaseExecutor - Emitiendo estado de carga para $operation');
        }

        // Intentar emitir con protección
        try {
          emit(loadingState);
        } catch (e) {
          if (kDebugMode) {
            print(
                '⚠️ BlocUseCaseExecutor - Error al emitir estado de carga: $e');
          }
          // No interrumpir, continuar con la operación
        }
      } else {
        if (kDebugMode) {
          print(
              '⚠️ BlocUseCaseExecutor - Emisor cerrado, no se pudo emitir estado de carga para $operation');
        }
      }

      // Ejecutar el caso de uso independientemente del estado del emisor
      final T result = await execute();

      if (kDebugMode) {
        print(
            '✅ BlocUseCaseExecutor - Operación $operation completada exitosamente');
      }

      // Preparar el estado de éxito antes de intentar emitirlo
      final State successState = onSuccess(result);

      // Verificar nuevamente si el bloc o el emisor están disponibles
      if (bloc.isClosed) {
        if (kDebugMode) {
          print(
              '⚠️ BlocUseCaseExecutor - BLoC cerrado después de completar operación $operation - no se emitirá estado');
        }
        return;
      }

      // Verificar si el emisor está disponible para emitir el estado de éxito
      if (!emit.isDone) {
        if (kDebugMode) {
          print(
              '💡 BlocUseCaseExecutor - Emitiendo estado de éxito tipo ${successState.runtimeType} para $operation');
        }

        try {
          emit(successState);
        } catch (e) {
          if (kDebugMode) {
            print(
                '⚠️ BlocUseCaseExecutor - Error al emitir estado de éxito: $e');
          }

          // Intentar añadir un evento de refresco como último recurso
          try {
            if (!bloc.isClosed) {
              if (kDebugMode) {
                print(
                    '🔄 BlocUseCaseExecutor - Intentando añadir evento de refresco');
              }
              bloc.add(refreshEvent);
            }
          } catch (e) {
            if (kDebugMode) {
              print(
                  '⚠️ BlocUseCaseExecutor - Error al añadir evento de refresco: $e');
            }
          }
        }
      } else {
        if (kDebugMode) {
          print(
              '⚠️ BlocUseCaseExecutor - Emisor cerrado, no se pudo emitir estado de éxito para $operation');
        }

        // Intentar añadir un evento de refresco como último recurso
        try {
          if (!bloc.isClosed) {
            if (kDebugMode) {
              print(
                  '🔄 BlocUseCaseExecutor - Emisor cerrado, intentando añadir evento de refresco');
            }
            bloc.add(refreshEvent);
          }
        } catch (e) {
          if (kDebugMode) {
            print(
                '⚠️ BlocUseCaseExecutor - Error al añadir evento de refresco: $e');
          }
        }
      }
    } catch (e, stackTrace) {
      // Convertir el error a un AppException para un manejo consistente
      final AppException exception = useFirebaseErrorHandler
          ? ErrorHandler.handleFirebaseError(e, stackTrace)
          : ErrorHandler.handleError(e, stackTrace);

      // Registrar el error
      if (kDebugMode) {
        _logger.e(
          'Error en $operation: ${exception.message}',
          error: exception.originalError,
          stackTrace: exception.stackTrace,
        );
        print(
            '⛔ BlocUseCaseExecutor - ERROR en $operation: ${exception.message}');
      }

      // Preparar el estado de error antes de intentar emitirlo
      final State errorState = onError(exception);

      // Verificar si el bloc está cerrado
      if (bloc.isClosed) {
        if (kDebugMode) {
          print(
              '⚠️ BlocUseCaseExecutor - BLoC cerrado después de error en operación $operation - no se emitirá estado');
        }
        return;
      }

      // Emitir estado de error solo si el emisor aún está disponible
      if (!emit.isDone) {
        if (kDebugMode) {
          print(
              '💡 BlocUseCaseExecutor - Emitiendo estado de error tipo ${errorState.runtimeType} para $operation');
        }

        try {
          emit(errorState);
        } catch (e) {
          if (kDebugMode) {
            print(
                '⚠️ BlocUseCaseExecutor - Error al emitir estado de error: $e');
          }
        }
      } else {
        if (kDebugMode) {
          print(
              '⚠️ BlocUseCaseExecutor - Emisor cerrado, no se pudo emitir estado de error para $operation');
        }
      }
    }
  }
}
