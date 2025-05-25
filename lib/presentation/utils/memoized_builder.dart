// lib/core/widgets/optimized/memoized_builder.dart
import 'package:flutter/material.dart';

/// Un widget que memoriza su contenido para evitar reconstrucciones innecesarias
///
/// Solo reconstruye su contenido cuando los valores proporcionados cambian
class MemoizedBuilder<T> extends StatefulWidget {
  /// El objeto que determina si se debe reconstruir el widget
  final T value;

  /// Función que construye el widget
  final Widget Function(BuildContext, T) builder;

  /// Función para determinar si dos valores son iguales
  final bool Function(T previous, T current)? areEqual;

  const MemoizedBuilder({
    super.key,
    required this.value,
    required this.builder,
    this.areEqual,
  });

  @override
  State<MemoizedBuilder<T>> createState() => _MemoizedBuilderState<T>();
}

class _MemoizedBuilderState<T> extends State<MemoizedBuilder<T>> {
  /// El valor anterior para comparación
  late T _previousValue;

  /// El widget memorizado
  late Widget _cachedWidget;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
    _cachedWidget = widget.builder(context, widget.value);
  }

  @override
  void didUpdateWidget(MemoizedBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Determinar si necesitamos reconstruir
    final areEqual = widget.areEqual ?? _defaultEquals;

    if (!areEqual(_previousValue, widget.value)) {
      _previousValue = widget.value;
      _cachedWidget = widget.builder(context, widget.value);
    }
  }

  /// Comparación predeterminada para los valores
  bool _defaultEquals(T previous, T current) {
    return previous == current;
  }

  @override
  Widget build(BuildContext context) {
    return _cachedWidget;
  }
}

/// Una versión de MemoizedBuilder para listas, que compara elementos individuales
class MemoizedListBuilder<T> extends StatelessWidget {
  /// La lista de elementos
  final List<T> items;

  /// Función que construye cada elemento
  final Widget Function(BuildContext, T, int) itemBuilder;

  /// Función para determinar si dos elementos son iguales
  final bool Function(T, T)? areItemsEqual;

  /// Generador de claves para los elementos
  final Key Function(T, int)? keyBuilder;

  const MemoizedListBuilder({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.areItemsEqual,
    this.keyBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos un ListView.builder para eficiencia
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        // Usamos MemoizedBuilder para cada elemento
        return MemoizedBuilder<T>(
          key: keyBuilder?.call(item, index) ?? ValueKey<int>(index),
          value: item,
          areEqual: areItemsEqual,
          builder: (context, value) => itemBuilder(context, value, index),
        );
      },
    );
  }
}
