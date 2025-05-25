// lib/core/widgets/optimized/virtualized_list.dart
import 'package:flutter/material.dart';

/// Widget para manejar listas largas de manera eficiente
///
/// Solo renderiza los elementos visibles y un pequeño buffer,
/// reduciendo el uso de memoria y mejorando el rendimiento.
class VirtualizedListView<T> extends StatefulWidget {
  /// Lista de elementos
  final List<T> items;

  /// Builder para cada elemento
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Altura estimada para cada elemento
  final double estimatedItemHeight;

  /// Número de elementos a pre-cargar antes del área visible
  final int preloadItemCount;

  /// Estilo del desplazamiento
  final ScrollPhysics? physics;

  /// Padding de la lista
  final EdgeInsetsGeometry? padding;

  /// Separador entre elementos
  final Widget? separatorBuilder;

  /// Si se debe mostrar un indicador de carga al final
  final bool showLoading;

  /// Si hay más elementos para cargar
  final bool hasMoreItems;

  /// Función para cargar más elementos
  final Future<void> Function()? onLoadMore;

  /// Callback cuando el usuario hace scroll
  final Function(ScrollUpdateNotification)? onScroll;

  /// Controlador de scroll
  final ScrollController? scrollController;

  const VirtualizedListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.estimatedItemHeight = 100.0,
    this.preloadItemCount = 5,
    this.physics,
    this.padding,
    this.separatorBuilder,
    this.showLoading = false,
    this.hasMoreItems = false,
    this.onLoadMore,
    this.onScroll,
    this.scrollController,
  });

  @override
  State<VirtualizedListView<T>> createState() => _VirtualizedListViewState<T>();
}

class _VirtualizedListViewState<T> extends State<VirtualizedListView<T>> {
  /// Controlador de scroll interno
  late ScrollController _scrollController;

  /// El último índice visible
  int _lastVisibleIndex = 0;

  /// Si está cargando más elementos
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      // Solo disponer si creamos el controlador internamente
      _scrollController.dispose();
    } else {
      // Remover listener si usamos un controlador externo
      _scrollController.removeListener(_handleScroll);
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(VirtualizedListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Actualizar el controlador si cambió
    if (oldWidget.scrollController != widget.scrollController) {
      _scrollController.removeListener(_handleScroll);

      if (oldWidget.scrollController == null) {
        // Disponer el controlador antiguo si lo creamos internamente
        _scrollController.dispose();
      }

      _scrollController = widget.scrollController ?? ScrollController();
      _scrollController.addListener(_handleScroll);
    }
  }

  /// Maneja el evento de scroll
  void _handleScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 500 &&
        widget.hasMoreItems &&
        !_isLoadingMore &&
        widget.onLoadMore != null) {
      _loadMore();
    }
  }

  /// Carga más elementos
  Future<void> _loadMore() async {
    if (_isLoadingMore || !widget.hasMoreItems || widget.onLoadMore == null) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    try {
      await widget.onLoadMore!();
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        // Notificar el evento de scroll
        if (widget.onScroll != null) {
          widget.onScroll!(notification);
        }

        // Calcular el último índice visible
        final double itemExtent = widget.estimatedItemHeight;
        final int visibleIndex =
            (notification.metrics.pixels / itemExtent).floor();

        if (visibleIndex != _lastVisibleIndex) {
          _lastVisibleIndex = visibleIndex;
        }

        return false;
      },
      child: ListView.separated(
        controller: _scrollController,
        physics: widget.physics,
        padding: widget.padding,
        itemCount: widget.items.length + (widget.showLoading ? 1 : 0),
        separatorBuilder: (context, index) =>
            widget.separatorBuilder ?? const SizedBox(height: 0),
        itemBuilder: (context, index) {
          // Mostrar indicador de carga al final
          if (widget.showLoading && index == widget.items.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Renderizar solo si está cerca del área visible
          final item = widget.items[index];
          final isClose =
              (index - _lastVisibleIndex).abs() <= widget.preloadItemCount;

          if (!isClose) {
            // Placeholder con la altura correcta para mantener el scroll
            return SizedBox(
              height: widget.estimatedItemHeight,
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          return widget.itemBuilder(context, item, index);
        },
      ),
    );
  }
}
