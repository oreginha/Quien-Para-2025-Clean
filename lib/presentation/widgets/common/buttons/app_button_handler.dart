// lib/presentation/widgets/common/app_button.dart
import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';

/// Tipos de botones en la aplicación
enum AppButtonType { primary, secondary, danger, success, outline, text }

/// Widget reutilizable para botones con estilos consistentes en toda la aplicación
class AppButtonHandler extends StatelessWidget {
  /// Texto del botón
  final String label;

  /// Acción al presionar el botón
  final VoidCallback? onPressed;

  /// Tipo de botón
  final AppButtonType type;

  /// Icono opcional a mostrar junto al texto
  final IconData? icon;

  /// Si el icono va antes o después del texto
  final bool iconLeading;

  /// Tamaño del botón
  final AppButtonSize size;

  /// Si el botón ocupa todo el ancho disponible
  final bool fullWidth;

  /// Padding personalizado
  final EdgeInsets? padding;

  /// Bordes personalizados
  final BorderRadius? borderRadius;

  /// Si se debe mostrar un indicador de carga
  final bool isLoading;

  const AppButtonHandler({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
    this.iconLeading = true,
    this.size = AppButtonSize.medium,
    this.fullWidth = false,
    this.padding,
    this.borderRadius,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Obtener el estilo según el tipo de botón
    final style = _getButtonStyle(context);

    // Calcular padding según el tamaño
    final buttonPadding = padding ?? _getPaddingBySize();

    // Calcular borderRadius
    final buttonBorderRadius = borderRadius ?? _getBorderRadiusBySize();

    // Construir el contenido del botón
    Widget buttonContent = _buildButtonContent();

    // Si está en estado de carga, mostrar indicador
    if (isLoading) {
      buttonContent = Stack(
        alignment: Alignment.center,
        children: [
          Opacity(opacity: 0.0, child: buttonContent),
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(_getLoadingColor()),
            ),
          ),
        ],
      );
    }

    // Determinar si debemos utilizar ElevatedButton u OutlinedButton
    Widget button;

    if (type == AppButtonType.outline || type == AppButtonType.text) {
      button = OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: buttonContent,
      );
    } else {
      button = ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: style.copyWith(
          padding: WidgetStateProperty.all(buttonPadding),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: buttonBorderRadius),
          ),
        ),
        child: buttonContent,
      );
    }

    // Si debe ocupar todo el ancho
    if (fullWidth) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  /// Construye el contenido del botón (texto + icono)
  Widget _buildButtonContent() {
    if (icon == null) {
      return Text(label);
    }

    // Crear los elementos (texto e icono)
    final textElement = Text(label);
    final iconElement = Icon(icon, size: _getIconSize());

    // Determinar el orden
    if (iconLeading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [iconElement, SizedBox(width: 8), textElement],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [textElement, SizedBox(width: 8), iconElement],
      );
    }
  }

  /// Obtiene el estilo del botón según el tipo
  ButtonStyle _getButtonStyle(BuildContext context) {
    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFC107), // brandYellow
          foregroundColor: const Color(0xFF1E293B), // darkTextPrimary
          elevation: 2,
        );
      case AppButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF242640),
          foregroundColor: Colors.white,
          elevation: 2,
        );
      case AppButtonType.danger:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          foregroundColor: Colors.white,
          elevation: 2,
        );
      case AppButtonType.success:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          elevation: 2,
        );
      case AppButtonType.outline:
        return OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFFFC107), // brandYellow
          side: BorderSide(color: const Color(0xFFFFC107)), // brandYellow
        );
      case AppButtonType.text:
        return OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFFFC107), // brandYellow
          side: BorderSide.none,
        );
    }
  }

  /// Obtiene el padding según el tamaño del botón
  EdgeInsets _getPaddingBySize() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    }
  }

  /// Obtiene el borderRadius según el tamaño del botón
  BorderRadius _getBorderRadiusBySize() {
    double radius;
    switch (size) {
      case AppButtonSize.small:
        radius = 8.0;
        break;
      case AppButtonSize.medium:
        radius = 12.0;
        break;
      case AppButtonSize.large:
        radius = 16.0;
        break;
    }
    return BorderRadius.circular(radius);
  }

  /// Obtiene el tamaño del icono según el tamaño del botón
  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16.0;
      case AppButtonSize.medium:
        return 20.0;
      case AppButtonSize.large:
        return 24.0;
    }
  }

  /// Obtiene el color del indicador de carga
  Color _getLoadingColor() {
    switch (type) {
      case AppButtonType.primary:
        return Colors.black;
      case AppButtonType.outline:
      case AppButtonType.text:
        return AppColors.lightTextPrimary;
      default:
        return Colors.white;
    }
  }
}

/// Tamaños de botones disponibles
enum AppButtonSize { small, medium, large }
