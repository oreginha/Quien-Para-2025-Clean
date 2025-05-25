import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';
// Se eliminó importación no utilizada: '../../../core/theme/app_theme.dart'

enum ButtonVariant {
  primary,
  secondary,
  outline,
  text,
}

class ThemeAwareButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final bool isFullWidth;
  final bool isLoading;
  final IconData? iconLeft;
  final IconData? iconRight;

  const ThemeAwareButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isFullWidth = false,
    this.isLoading = false,
    this.iconLeft,
    this.iconRight,
  });

  @override
  Widget build(BuildContext context) {
    // Se eliminó variable de tema no utilizada

    // Configuraciones según variante
    late final Color darkPrimaryBackground;
    late final Color textColor;
    late final Color borderColor;
    late final BorderRadius borderRadius;

    // Radio de bordes según especificaciones
    borderRadius = BorderRadius.circular(12);

    switch (variant) {
      case ButtonVariant.primary:
        darkPrimaryBackground = AppColors.brandYellow;
        textColor = const Color(
            0xFF1E293B); // Navy en botones amarillos para ambos temas
        borderColor = Colors.transparent;
        break;

      case ButtonVariant.secondary:
        darkPrimaryBackground = AppColors.brandYellow;
        textColor = Colors.white;
        borderColor = Colors.transparent;
        break;

      case ButtonVariant.outline:
        darkPrimaryBackground = Colors.transparent;
        textColor = AppColors.lightTextPrimary;
        borderColor = AppColors.brandYellow;
        break;

      case ButtonVariant.text:
        darkPrimaryBackground = Colors.transparent;
        textColor = AppColors.brandYellow;
        borderColor = Colors.transparent;
        break;
    }

    // Widget para el contenido del botón
    Widget buttonContent = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (iconLeft != null) ...[
          Icon(iconLeft, color: textColor, size: 20),
          const SizedBox(width: 8),
        ],
        if (isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(textColor),
            ),
          )
        else
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
        if (iconRight != null) ...[
          const SizedBox(width: 8),
          Icon(iconRight, color: textColor, size: 20),
        ],
      ],
    );

    // Construir el botón
    return Container(
      width: isFullWidth ? double.infinity : null,
      height: 48, // Altura estándar para botones
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: variant == ButtonVariant.outline
            ? Border.all(color: borderColor, width: 2)
            : null,
      ),
      child: Material(
        color: darkPrimaryBackground,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: isLoading ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: buttonContent,
          ),
        ),
      ),
    );
  }
}
