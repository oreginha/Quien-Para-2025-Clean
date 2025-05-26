import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

class ThemeAwareCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Color? color;
  final double? width;
  final double? height;
  final String? heroTag;
  final VoidCallback? onTap;
  final String? imageUrl;
  final bool hasOverlay;

  const ThemeAwareCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
    this.color,
    this.width,
    this.height,
    this.heroTag,
    this.onTap,
    this.imageUrl,
    this.hasOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    // Obtener el tema actual
    final theme = AppTheme.of(context);

    // Configuración de sombra según tema
    final BoxShadow shadow = theme.isDarkMode
        ? BoxShadow(
            color: Colors.black.withValues(
              red: 0,
              green: 0,
              blue: 0,
              alpha: 77,
            ),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        : BoxShadow(
            color: Colors.black.withValues(
              red: 0,
              green: 0,
              blue: 0,
              alpha: 13,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          );

    // Se eliminó la variable cardBackground no utilizada

    // Contenido de la tarjeta
    Widget cardContent = child;

    // Agregar imagen de fondo si se proporciona
    if (imageUrl != null) {
      cardContent = Stack(
        children: [
          // Imagen de fondo
          ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
            child: Image.network(
              imageUrl!,
              width: double.infinity,
              height: height,
              fit: BoxFit.cover,
            ),
          ),

          // Overlay para el modo oscuro o claro
          if (hasOverlay)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius ?? BorderRadius.circular(12),
                  color: theme.isDarkMode
                      ? Colors.black.withValues(
                          red: 0,
                          green: 0,
                          blue: 0,
                          alpha: 102,
                        ) // Overlay más oscuro para modo oscuro
                      : Colors.black.withValues(
                          red: 0,
                          green: 0,
                          blue: 0,
                          alpha: 26,
                        ), // Overlay muy sutil para modo claro
                ),
              ),
            ),

          // Contenido
          Positioned.fill(
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ],
      );
    } else {
      // Sin imagen de fondo
      cardContent = Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      );
    }

    // Aplicar Hero animation si se proporciona heroTag
    if (heroTag != null) {
      cardContent = Hero(tag: heroTag!, child: cardContent);
    }

    // Construir la tarjeta
    return Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.brandYellow,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        boxShadow: [shadow],
      ),
      child: Material(
        color: imageUrl != null ? Colors.transparent : AppColors.brandYellow,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          child: cardContent,
        ),
      ),
    );
  }
}
