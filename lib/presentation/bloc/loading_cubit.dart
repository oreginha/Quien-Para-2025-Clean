// lib/core/bloc/loading_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

part 'loading_cubit.freezed.dart';

/// Estado genérico para manejar operaciones de carga, error y datos
///
/// Proporciona una estructura consistente para todos los estados de carga
/// en la aplicación, facilitando la reutilización y estandarización.
@freezed
class LoadingState<T> with _$LoadingState<T> {
  const LoadingState._();

  /// Estado inicial o de carga
  const factory LoadingState.loading() = _LoadingState;

  /// Estado cuando los datos se han cargado exitosamente
  const factory LoadingState.loaded(T data) = _LoadedState;

  /// Estado cuando ocurre un error durante la carga
  const factory LoadingState.error(String message) = _ErrorState;

  /// Estado cuando los datos están vacíos
  const factory LoadingState.empty() = _EmptyState;

  /// Comprueba si el estado actual es de carga
  bool get isLoading => maybeMap(
        loading: (_) => true,
        orElse: () => false,
      );

  /// Comprueba si el estado actual es de error
  bool get isError => maybeMap(
        error: (_) => true,
        orElse: () => false,
      );

  /// Comprueba si el estado actual es de datos cargados
  bool get isLoaded => maybeMap(
        loaded: (_) => true,
        orElse: () => false,
      );

  /// Comprueba si el estado actual es de datos vacíos
  bool get isEmpty => maybeMap(
        empty: (_) => true,
        orElse: () => false,
      );

  /// Obtiene los datos si están disponibles, o null en caso contrario
  T? get data => maybeMap(
        loaded: (state) => state.data,
        orElse: () => null,
      );

  /// Obtiene el mensaje de error si existe, o null en caso contrario
  String? get errorMessage => maybeMap(
        error: (state) => state.message,
        orElse: () => null,
      );
}

/// Cubit base para manejar operaciones de carga en toda la aplicación
///
/// Proporciona métodos comunes para actualizar el estado durante operaciones
/// asíncronas, manejo de errores y logging consistente.
class LoadingCubit<T> extends Cubit<LoadingState<T>> {
  final Logger logger = Logger();

  /// Constructor que inicializa el Cubit con estado de carga
  LoadingCubit() : super(const LoadingState.loading()) {
    if (kDebugMode) {
      logger.d('${runtimeType.toString()} inicializado');
    }
  }

  /// Actualiza el estado a cargando
  void setLoading() {
    emit(const LoadingState.loading());
  }

  /// Actualiza el estado con los datos cargados
  void setLoaded(T data) {
    emit(LoadingState.loaded(data));
  }

  /// Actualiza el estado con un error
  void setError(String message) {
    emit(LoadingState.error(message));
  }

  /// Actualiza el estado a vacío
  void setEmpty() {
    emit(const LoadingState.empty());
  }

  /// Ejecuta una operación asíncrona con manejo automático de estados
  ///
  /// Actualiza el estado a cargando, ejecuta la operación y actualiza
  /// el estado según el resultado (datos, error o vacío)
  Future<void> executeOperation(
    Future<T?> Function() operation, {
    bool showLoading = true,
    String operationName = 'operación',
  }) async {
    try {
      if (showLoading) {
        emit(const LoadingState.loading());
      }

      final result = await operation();

      if (result == null) {
        emit(const LoadingState.empty());
      } else if (result is List && (result as List).isEmpty) {
        emit(const LoadingState.empty());
      } else if (result is Map && (result as Map).isEmpty) {
        emit(const LoadingState.empty());
      } else {
        emit(LoadingState.loaded(result));
      }
    } catch (error, stackTrace) {
      handleError(operationName, error, stackTrace);
      emit(LoadingState.error(error.toString()));
    }
  }

  /// Método auxiliar para gestionar errores de manera consistente
  void handleError(String operation, dynamic error, StackTrace stackTrace) {
    if (kDebugMode) {
      logger.e('Error en $runtimeType durante $operation',
          error: error, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> close() {
    if (kDebugMode) {
      logger.d('${runtimeType.toString()} cerrado');
    }
    return super.close();
  }
}
