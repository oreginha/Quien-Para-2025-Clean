// lib/core/widgets/loading/loading_state.dart

/// Estado de carga genérico que puede ser reutilizado para diferentes características
class LoadingState<T> {
  final bool isLoading;
  final T? data;
  final String? errorMessage;
  final bool isEmpty;

  const LoadingState._({
    this.isLoading = false,
    this.data,
    this.errorMessage,
    this.isEmpty = false,
  });

  /// Constructor para el estado de carga
  factory LoadingState.loading() => LoadingState._(isLoading: true);

  /// Constructor para el estado cargado con datos
  factory LoadingState.loaded(T data) => LoadingState._(data: data);

  /// Constructor para el estado de error
  factory LoadingState.error(String message) =>
      LoadingState._(errorMessage: message);

  /// Constructor para el estado vacío
  factory LoadingState.empty() => LoadingState._(isEmpty: true);

  /// Utilidad para acceder a los datos o null si no están disponibles
  T? get dataOrNull => data;

  /// Utilidad para patrones de coincidencia de tipos
  R when<R>({
    required R Function() loading,
    required R Function(T) loaded,
    required R Function(String) error,
    required R Function() empty,
  }) {
    if (isLoading) return loading();
    if (errorMessage != null) return error(errorMessage!);
    if (isEmpty) return empty();
    if (data != null) return loaded(data as T);

    // Estado desconocido, usar loading como fallback
    return loading();
  }
}
