// lib/presentation/widgets/common/loading_state_handler.dart
import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/presentation/widgets/empty_state_widget.dart';

/// Widget genérico para manejar estados de carga, error y vacío de manera consistente
/// Reduce la duplicación de código en múltiples pantallas al manejar estos estados comunes
class LoadingStateHandler<T> extends StatelessWidget {
  /// Determina si los datos están cargando
  final bool isLoading;

  /// Mensaje de error si existe
  final String? errorMessage;

  /// Los datos a mostrar
  final T? data;

  /// Función para verificar si los datos están vacíos
  final bool Function(T data)? isDataEmpty;

  /// Widget a mostrar cuando los datos están cargados y no vacíos
  final Widget Function(T data) builder;

  /// Widget personalizado para mostrar en estado de carga
  final Widget? loadingWidget;

  /// Widget personalizado para mostrar en estado de error
  final Widget? errorWidget;

  /// Widget personalizado para mostrar cuando los datos están vacíos
  final Widget? emptyWidget;

  /// Color de fondo del contenedor
  final Color? darkPrimaryBackground;

  /// Si se debe mostrar un indicador de "pull to refresh"
  final Future<void> Function()? onRefresh;

  /// Mensaje personalizado cuando los datos están vacíos
  final String emptyMessage;

  /// Icono personalizado cuando los datos están vacíos
  final IconData emptyIcon;

  const LoadingStateHandler({
    super.key,
    required this.isLoading,
    this.errorMessage,
    required this.data,
    this.isDataEmpty,
    required this.builder,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.darkPrimaryBackground,
    this.onRefresh,
    this.emptyMessage = 'No hay datos disponibles',
    this.emptyIcon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;

    // Verificar datos vacíos si existe el validador
    bool isEmpty = false;
    if (data != null && isDataEmpty != null) {
      isEmpty = isDataEmpty!(data as T);
    } else if (data == null) {
      isEmpty = true;
    } else if (data is List) {
      isEmpty = (data as List).isEmpty;
    } else if (data is Map) {
      isEmpty = (data as Map).isEmpty;
    }

    // Determinar qué widget mostrar según el estado
    if (isLoading && (data == null || isEmpty)) {
      // Estado de carga
      content =
          loadingWidget ??
          Center(
            child: CircularProgressIndicator(color: AppColors.lightTextPrimary),
          );
    } else if (errorMessage != null && (data == null || isEmpty)) {
      // Estado de error
      content =
          errorWidget ??
          Center(
            child: EmptyStateWidget(
              icon: Icons.error_outline,
              title: 'Error',
              description: 'Error: $errorMessage',
            ),
          );
    } else if (isEmpty) {
      // Estado vacío
      content =
          emptyWidget ??
          Center(
            child: EmptyStateWidget(
              icon: emptyIcon,
              title: 'Sin datos',
              description: emptyMessage,
            ),
          );
    } else {
      // Datos disponibles
      content = builder(data as T);
    }

    // Si se proporciona onRefresh, envolver en RefreshIndicator
    if (onRefresh != null) {
      content = RefreshIndicator(
        onRefresh: onRefresh!,
        color: AppColors.lightTextPrimary,
        child: content,
      );
    }

    // Aplicar fondo si se especifica
    if (darkPrimaryBackground != null) {
      content = Container(
        width: double.infinity,
        // Eliminar height: double.infinity para evitar constraints infinitos
        // y usar constraints que se adapten al contenido
        constraints: const BoxConstraints(minHeight: 100),
        decoration: BoxDecoration(color: darkPrimaryBackground),
        child: content,
      );
    }

    return content;
  }
}
