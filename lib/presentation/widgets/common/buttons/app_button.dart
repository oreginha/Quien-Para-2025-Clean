import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/presentation/routes/app_router.dart';

/// Estilos predefinidos para los botones de la aplicación
enum AppButtonStyle {
  /// Botón principal, usado para acciones primarias (amarillo)
  primary,

  /// Botón secundario, usado para acciones secundarias (borde)
  secondary,

  /// Botón de acción, usado para acciones destacadas (azul)
  action,

  /// Botón de peligro, usado para acciones destructivas (rojo)
  danger,

  /// Botón de texto sin fondo, usado para acciones sutiles
  text,
}

/// Tamaños predefinidos para los botones de la aplicación
enum AppButtonSize {
  /// Botón pequeño
  small,

  /// Botón de tamaño normal
  normal,

  /// Botón grande
  large,
}

/// Widget reutilizable para botones con estilos consistentes en toda la aplicación
///
/// Ofrece diferentes variantes y opciones de personalización mientras mantiene
/// la consistencia visual con el tema de la aplicación.
class AppButton extends StatelessWidget {
  /// El texto a mostrar en el botón
  final String text;

  /// Función a ejecutar cuando se presiona el botón
  final VoidCallback? onPressed;

  /// Ícono opcional para mostrar junto al texto
  final IconData? icon;

  /// Si el botón debe ocupar todo el ancho disponible
  final bool fullWidth;

  /// Si el botón está en estado de carga
  final bool isLoading;

  /// Si el botón debe mostrarse deshabilitado
  final bool isEnabled;

  /// Estilo del botón
  final AppButtonStyle style;

  /// Tamaño del botón
  final AppButtonSize size;

  /// Color de fondo personalizado (anula el estilo)
  final Color? darkPrimaryBackground;

  /// Color del texto personalizado (anula el estilo)
  final Color? textColor;

  /// Si el ícono debe mostrarse después del texto
  final bool iconAfterText;

  /// Padding personalizado
  final EdgeInsets? padding;

  /// Ancho personalizado
  final double? width;

  /// Borde personalizado
  final BorderRadius? borderRadius;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.fullWidth = false,
    this.isLoading = false,
    this.isEnabled = true,
    this.style = AppButtonStyle.primary,
    this.size = AppButtonSize.normal,
    this.darkPrimaryBackground,
    this.textColor,
    this.iconAfterText = false,
    this.padding,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // Obtener colores según estilo
    final colors = _getButtonColors();

    // Obtener dimensiones según tamaño
    final dimensions = _getButtonDimensions();

    // Construir el contenido del botón
    Widget buttonContent;

    // Mostrar indicador de carga si está cargando
    if (isLoading) {
      buttonContent = SizedBox(
        width: dimensions.iconSize,
        height: dimensions.iconSize,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(colors.textColor),
          strokeWidth: 2,
        ),
      );
    }
    // Mostrar texto con ícono si está disponible
    else if (icon != null) {
      if (iconAfterText) {
        buttonContent = Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: dimensions.fontSize,
                fontWeight: FontWeight.bold,
                color: colors.textColor,
              ),
            ),
            SizedBox(width: 8),
            Icon(icon, size: dimensions.iconSize, color: colors.textColor),
          ],
        );
      } else {
        buttonContent = Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: dimensions.iconSize, color: colors.textColor),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: dimensions.fontSize,
                fontWeight: FontWeight.bold,
                color: colors.textColor,
              ),
            ),
          ],
        );
      }
    }
    // Mostrar solo texto
    else {
      buttonContent = Text(
        text,
        style: TextStyle(
          fontSize: dimensions.fontSize,
          fontWeight: FontWeight.bold,
          color: colors.textColor,
        ),
      );
    }

    // Crear el botón base
    final Widget button = ElevatedButton(
      onPressed: (isEnabled && !isLoading) ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.darkPrimaryBackground,
        foregroundColor: colors.textColor,
        disabledBackgroundColor: colors.disabledBackgroundColor,
        disabledForegroundColor: colors.disabledTextColor,
        elevation: style == AppButtonStyle.text ? 0 : 2,
        padding: padding ?? dimensions.padding,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(AppRadius.l),
          side: style == AppButtonStyle.secondary
              ? BorderSide(color: const Color(0xFFFFC107)) // brandYellow
              : BorderSide.none,
        ),
      ),
      child: buttonContent,
    );

    // Aplicar ancho personalizado o completo si se especifica
    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    } else if (width != null) {
      return SizedBox(width: width, child: button);
    }

    return button;
  }

  /// Obtiene los colores según el estilo del botón
  ButtonColors _getButtonColors() {
    Color bg, text, disabledBg, disabledText;

    // Usar colores personalizados si se especifican
    if (darkPrimaryBackground != null || textColor != null) {
      bg = darkPrimaryBackground ?? AppColors.lightTextPrimary;
      text = textColor ??
          (style == AppButtonStyle.primary ? Colors.black : Colors.white);
      disabledBg = bg.withAlpha(128);
      disabledText = text.withAlpha(128);
      return ButtonColors(
        darkPrimaryBackground: bg,
        textColor: text,
        disabledBackgroundColor: disabledBg,
        disabledTextColor: disabledText,
      );
    }

    // De lo contrario, usar colores según el estilo
    switch (style) {
      case AppButtonStyle.primary:
        return ButtonColors(
          darkPrimaryBackground: const Color(0xFFFFC107), // brandYellow
          textColor: const Color(0xFF1E293B), // darkTextPrimary
          disabledBackgroundColor: AppColors.lightTextPrimary.withAlpha(
            (255 * 0.4).round(),
          ),
          disabledTextColor: AppColors.lightTextPrimary.withAlpha(
            (255 * 0.6).round(),
          ),
        );
      case AppButtonStyle.secondary:
        return ButtonColors(
          darkPrimaryBackground: Colors.transparent,
          textColor: const Color(0xFFFFC107), // brandYellow
          disabledBackgroundColor: Colors.transparent,
          disabledTextColor: AppColors.brandYellow.withAlpha(
            (255 * 0.4).round(),
          ),
        );
      case AppButtonStyle.action:
        return ButtonColors(
          darkPrimaryBackground: const Color(0xFFFFC107), // brandYellow
          textColor: Colors.white,
          disabledBackgroundColor: AppColors.brandYellow.withAlpha(
            (255 * 0.4).round(),
          ),
          disabledTextColor: Colors.white.withAlpha(153),
        );
      case AppButtonStyle.danger:
        return ButtonColors(
          darkPrimaryBackground: AppColors.success,
          textColor: Colors.white,
          disabledBackgroundColor: AppColors.brandYellow.withAlpha(
            (255 * 0.4).round(),
          ),
          disabledTextColor: Colors.white.withAlpha(153),
        );
      case AppButtonStyle.text:
        return ButtonColors(
          darkPrimaryBackground: Colors.transparent,
          textColor: const Color(0xFFFFC107), // brandYellow
          disabledBackgroundColor: Colors.transparent,
          disabledTextColor: AppColors.brandYellow.withAlpha(
            (255 * 0.4).round(),
          ),
        );
    }
  }

  /// Obtiene dimensiones según el tamaño del botón
  ButtonDimensions _getButtonDimensions() {
    switch (size) {
      case AppButtonSize.small:
        return ButtonDimensions(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          fontSize: 14,
          iconSize: 18,
        );
      case AppButtonSize.normal:
        return ButtonDimensions(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          fontSize: 16,
          iconSize: 20,
        );
      case AppButtonSize.large:
        return ButtonDimensions(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          fontSize: 18,
          iconSize: 24,
        );
    }
  }
}

/// Botón primario (amarillo)
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;
  final bool isLoading;
  final bool isEnabled;
  final AppButtonSize size;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.fullWidth = false,
    this.isLoading = false,
    this.isEnabled = true,
    this.size = AppButtonSize.normal,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      fullWidth: fullWidth,
      isLoading: isLoading,
      isEnabled: isEnabled,
      style: AppButtonStyle.primary,
      size: size,
    );
  }
}

/// Clase interna para almacenar dimensiones del botón
class ButtonDimensions {
  final EdgeInsets padding;
  final double fontSize;
  final double iconSize;

  ButtonDimensions({
    required this.padding,
    required this.fontSize,
    required this.iconSize,
  });
}

/// Botón secundario (con borde)
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;
  final bool isLoading;
  final bool isEnabled;
  final AppButtonSize size;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.fullWidth = false,
    this.isLoading = false,
    this.isEnabled = true,
    this.size = AppButtonSize.normal,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      fullWidth: fullWidth,
      isLoading: isLoading,
      isEnabled: isEnabled,
      style: AppButtonStyle.secondary,
      size: size,
    );
  }
}

/// Botón de acción (azul)
class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;
  final bool isLoading;
  final bool isEnabled;
  final AppButtonSize size;

  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.fullWidth = false,
    this.isLoading = false,
    this.isEnabled = true,
    this.size = AppButtonSize.normal,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      fullWidth: fullWidth,
      isLoading: isLoading,
      isEnabled: isEnabled,
      style: AppButtonStyle.action,
      size: size,
    );
  }
}

/// Botón de peligro (rojo)
class DangerButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;
  final bool isLoading;
  final bool isEnabled;
  final AppButtonSize size;

  const DangerButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.fullWidth = false,
    this.isLoading = false,
    this.isEnabled = true,
    this.size = AppButtonSize.normal,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      fullWidth: fullWidth,
      isLoading: isLoading,
      isEnabled: isEnabled,
      style: AppButtonStyle.danger,
      size: size,
    );
  }
}

/// Botón de texto plano
class TextButtonCustom extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isEnabled;
  final AppButtonSize size;

  const TextButtonCustom({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isEnabled = true,
    this.size = AppButtonSize.normal,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      isEnabled: isEnabled,
      style: AppButtonStyle.text,
      size: size,
    );
  }
}

/// Botón circular con ícono
class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? darkPrimaryBackground;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final String? tooltip;
  final bool isEnabled;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.darkPrimaryBackground,
    this.iconColor,
    this.size = 40.0,
    this.iconSize = 20.0,
    this.tooltip,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        shape: const CircleBorder(),
        color: darkPrimaryBackground ?? AppColors.lightTextPrimary,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: isEnabled ? onPressed : null,
          child: Center(
            child: Tooltip(
              message: tooltip ?? '',
              child: Icon(
                icon,
                size: iconSize,
                color: iconColor ?? Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonColors {
  final Color darkPrimaryBackground;
  final Color textColor;
  final Color disabledBackgroundColor;
  final Color disabledTextColor;

  ButtonColors({
    required this.darkPrimaryBackground,
    required this.textColor,
    required this.disabledBackgroundColor,
    required this.disabledTextColor,
  });
}

/// Botón de retroceso personalizado con confirmación opcional
class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool showConfirmDialog;
  final Color? color;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.showConfirmDialog = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      color: color ?? Colors.white,
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          if (showConfirmDialog) {
            _showConfirmationDialog(context);
          } else {
            context.goBack();
          }
        }
      },
    );
  }

  /// Muestra un diálogo de confirmación antes de retroceder
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('¿Estás seguro?'),
          content: const Text(
            'Si vuelves atrás, perderás los cambios no guardados.',
          ),
          actions: [
            TextButtonCustom(
              text: 'Cancelar',
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButtonCustom(
              text: 'Volver',
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.goBack();
              },
            ),
          ],
        );
      },
    );
  }
}
