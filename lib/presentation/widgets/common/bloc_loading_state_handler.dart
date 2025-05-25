// lib/presentation/widgets/common/bloc_loading_state_handler.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/presentation/widgets/empty_state_widget.dart';

import '../../bloc/loading_cubit.dart' as app_loading;

/// Widget genérico para manejar estados de carga usando el patrón BLoC/Cubit
///
/// Proporciona una interfaz consistente para mostrar estados de carga, error,
/// vacío y datos cargados en toda la aplicación, integrado con el patrón BLoC.
class BlocLoadingStateHandler<T> extends StatelessWidget {
  /// El cubit o bloc que proporciona el estado de carga
  final app_loading.LoadingState<T> state;

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

  const BlocLoadingStateHandler({
    super.key,
    required this.state,
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
    return state.map(
      loading: (_) => _buildLoadingWidget(),
      loaded: (loadedState) => _buildLoadedWidget(loadedState.data),
      error: (errorState) => _buildErrorWidget(errorState.message),
      empty: (_) => _buildEmptyWidget(),
    );
  }

  /// Construye el widget para el estado de carga
  Widget _buildLoadingWidget() {
    Widget content = loadingWidget ??
        Center(
          child: CircularProgressIndicator(
            color: AppColors.lightTextPrimary,
          ),
        );

    return _applyContainer(content);
  }

  /// Construye el widget para el estado de datos cargados
  Widget _buildLoadedWidget(T data) {
    Widget content = builder(data);

    if (onRefresh != null) {
      content = RefreshIndicator(
        onRefresh: onRefresh!,
        color: AppColors.lightTextPrimary,
        child: content,
      );
    }

    return _applyContainer(content);
  }

  /// Construye el widget para el estado de error
  Widget _buildErrorWidget(String message) {
    Widget content = errorWidget ??
        Center(
          child: EmptyStateWidget(
            icon: Icons.error_outline,
            title: 'Error',
            description: 'Error: $message',
          ),
        );

    return _applyContainer(content);
  }

  /// Construye el widget para el estado vacío
  Widget _buildEmptyWidget() {
    Widget content = emptyWidget ??
        Center(
          child: EmptyStateWidget(
            icon: emptyIcon,
            title: 'Sin datos',
            description: emptyMessage,
          ),
        );

    return _applyContainer(content);
  }

  /// Aplica el contenedor con fondo si se especifica
  Widget _applyContainer(Widget child) {
    if (darkPrimaryBackground != null) {
      return Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 100),
        decoration: BoxDecoration(
          color: darkPrimaryBackground,
        ),
        child: child,
      );
    }
    return child;
  }
}

/// Extension para simplificar el uso del BlocLoadingStateHandler con cualquier Cubit/Bloc
extension LoadingCubitExtension<T> on app_loading.LoadingCubit<T> {
  /// Crea un BlocLoadingStateHandler a partir de este Cubit
  BlocLoadingStateHandler<T> buildHandler({
    required Widget Function(T data) builder,
    Widget? loadingWidget,
    Widget? errorWidget,
    Widget? emptyWidget,
    Color? darkPrimaryBackground,
    Future<void> Function()? onRefresh,
    String emptyMessage = 'No hay datos disponibles',
    IconData emptyIcon = Icons.inbox_outlined,
  }) {
    return BlocLoadingStateHandler<T>(
      state: state,
      builder: builder,
      loadingWidget: loadingWidget,
      errorWidget: errorWidget,
      emptyWidget: emptyWidget,
      darkPrimaryBackground: darkPrimaryBackground,
      onRefresh: onRefresh,
      emptyMessage: emptyMessage,
      emptyIcon: emptyIcon,
    );
  }
}

/// Widget que combina BlocBuilder con BlocLoadingStateHandler
///
/// Simplifica el uso del BlocLoadingStateHandler con un Cubit/Bloc
class BlocLoadingBuilder<C extends app_loading.LoadingCubit<T>, T>
    extends StatelessWidget {
  /// El cubit que proporciona el estado de carga
  final C cubit;

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

  const BlocLoadingBuilder({
    super.key,
    required this.cubit,
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
    return BlocBuilder<C, app_loading.LoadingState<T>>(
      bloc: cubit,
      builder: (context, state) {
        return BlocLoadingStateHandler<T>(
          state: state,
          builder: builder,
          loadingWidget: loadingWidget,
          errorWidget: errorWidget,
          emptyWidget: emptyWidget,
          darkPrimaryBackground: darkPrimaryBackground,
          onRefresh: onRefresh,
          emptyMessage: emptyMessage,
          emptyIcon: emptyIcon,
        );
      },
    );
  }
}
