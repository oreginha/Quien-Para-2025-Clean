// Archivo base para estados de BLoC
// Define la estructura común para todos los estados de la aplicación

/// Clase base para estados en los BLoCs
/// Proporciona una estructura común para:
/// - Estados de carga (isLoading)
/// - Estados de error (errorMessage)
/// - Estados con datos (data)
abstract class BaseState<T> {
  final bool isLoading;
  final String? errorMessage;
  final T? data;
  
  const BaseState({
    this.isLoading = false,
    this.errorMessage,
    this.data,
  });
  
  bool get hasError => errorMessage != null;
  bool get hasData => data != null;
  
  @override
  String toString() {
    return 'BaseState{isLoading: $isLoading, hasError: $hasError, hasData: $hasData}';
  }
}
