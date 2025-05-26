// lib/core/widgets/optimized/selective_builder.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Un widget que solo reconstruye cuando cambian propiedades específicas del estado
///
/// Similar a BlocSelector pero con más flexibilidad para comparaciones personalizadas
class SelectiveBuilder<B extends StateStreamable<S>, S, T>
    extends StatefulWidget {
  /// La función para extraer datos específicos del estado
  final T Function(S state) selector;

  /// La función que construye el widget
  final Widget Function(BuildContext context, T value) builder;

  /// Función para comparar valores extraídos
  final bool Function(T previous, T current)? comparator;

  const SelectiveBuilder({
    super.key,
    required this.selector,
    required this.builder,
    this.comparator,
  });

  @override
  State<SelectiveBuilder<B, S, T>> createState() =>
      _SelectiveBuilderState<B, S, T>();
}

class _SelectiveBuilderState<B extends StateStreamable<S>, S, T>
    extends State<SelectiveBuilder<B, S, T>> {
  /// El BloC que proporciona el estado
  late B _bloc;

  /// El valor extraído del estado
  late T _selectedValue;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<B>();
    _selectedValue = widget.selector(_bloc.state);
  }

  @override
  void didUpdateWidget(SelectiveBuilder<B, S, T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bloc = context.read<B>();
    if (_bloc != bloc) {
      _bloc = bloc;
      _selectedValue = widget.selector(_bloc.state);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bloc = context.read<B>();
    if (_bloc != bloc) {
      _bloc = bloc;
      _selectedValue = widget.selector(_bloc.state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listenWhen: (previous, current) {
        final previousValue = widget.selector(previous);
        final currentValue = widget.selector(current);

        // Usar el comparador personalizado o la igualdad predeterminada
        final comparator =
            widget.comparator ?? (T previous, T current) => previous == current;
        final areEqual = comparator(previousValue, currentValue);

        if (!areEqual) {
          _selectedValue = currentValue;
        }

        return !areEqual;
      },
      listener: (context, state) {
        // Solo escuchamos para actualizar _selectedValue,
        // la reconstrucción ocurre con el setState en el listener
        setState(
          () {},
        ); // Forzar la reconstrucción cuando cambie el valor seleccionado
      },
      child: Builder(
        builder: (context) => widget.builder(context, _selectedValue),
      ),
    );
  }
}

/// Un builder que se actualiza selectivamente basado en una propiedad del estado
///
/// Este es un widget de conveniencia para usar con BLoCs y extractores de propiedad
class PropertyBuilder<B extends StateStreamable<S>, S> extends StatelessWidget {
  /// Función para extraer una propiedad del estado
  final dynamic Function(S state) property;

  /// Función para construir el widget
  final Widget Function(BuildContext context, S state) builder;

  const PropertyBuilder({
    super.key,
    required this.property,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      buildWhen: (previous, current) {
        return property(previous) != property(current);
      },
      builder: builder,
    );
  }
}
