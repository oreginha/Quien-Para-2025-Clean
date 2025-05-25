// lib/core/widgets/loading/loading_state_handler.dart
import 'package:flutter/material.dart';
import 'package:quien_para/presentation/widgets/loading/loading_state.dart';

/// Un widget genérico para manejar diferentes estados de carga
///
/// Simplifica la lógica repetitiva de mostrar diferentes widgets
/// según el estado de carga (cargando, error, vacío, cargado)
class LoadingStateHandler<T> extends StatelessWidget {
  /// Estado actual de carga
  final LoadingState<T> state;

  /// Widget a mostrar cuando se está cargando
  final Widget loadingWidget;

  /// Widget a mostrar cuando hay un error
  final Widget Function(String message) errorWidget;

  /// Widget a mostrar cuando no hay datos
  final Widget emptyWidget;

  /// Widget a mostrar cuando los datos están cargados
  final Widget Function(T data) loadedWidget;

  /// Si es verdadero, el widget loadingWidget ocupará todo el espacio disponible
  final bool fullscreenLoading;

  /// Si es verdadero, se puede interactuar con el widget mientras carga
  final bool isOverlay;

  const LoadingStateHandler({
    // Removed const
    super.key,
    required this.state,
    required this.loadedWidget,
    Widget? loadingWidget,
    Widget Function(String)? errorWidget,
    Widget? emptyWidget,
    this.fullscreenLoading = false,
    this.isOverlay = false,
  })  : loadingWidget =
            loadingWidget ?? const Center(child: CircularProgressIndicator()),
        errorWidget = errorWidget ?? _defaultErrorWidget,
        emptyWidget = emptyWidget ??
            const Center(child: Text('No hay datos disponibles'));

  static Widget _defaultErrorWidget(String message) =>
      Center(child: Text("Error: $message"));

  @override
  Widget build(BuildContext context) {
    return state.when(
      loading: () => _buildLoadingWidget(),
      loaded: (data) => loadedWidget(data),
      error: (message) => errorWidget(message),
      empty: () => emptyWidget,
    );
  }

  Widget _buildLoadingWidget() {
    if (isOverlay) {
      // Solo mostramos el overlay si hay datos disponibles
      final hasData = state.dataOrNull != null;

      if (hasData) {
        // Usar método seguro que verifica nullability primero
        return Stack(
          children: [
            _buildDataLayerSafely(),
            Positioned.fill(
              child: ColoredBox(
                color: const Color.fromRGBO(
                    0, 0, 0, 0.3), // Valor constante para la opacidad
                child: loadingWidget,
              ),
            ),
          ],
        );
      }
      // Si no hay datos, mostramos solo el indicador de carga
      return loadingWidget;
    } else if (fullscreenLoading) {
      return SizedBox.expand(child: loadingWidget);
    } else {
      return loadingWidget;
    }
  }

  // Método auxiliar para construir la capa de datos de manera segura
  Widget _buildDataLayerSafely() {
    final dataValue = state.dataOrNull;
    if (dataValue != null) {
      return loadedWidget(dataValue as T);
    } else {
      return const SizedBox(); // Widget vacío como fallback
    }
  }
}



  // Método auxiliar para construir la capa de datos de manera segura

