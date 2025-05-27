// lib/presentation/widgets/common/buttons/app_buttons.dart
import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/presentation/routes/app_router.dart';

/// Estilos predefinidos para los botones de la aplicación
enum AppButtonStyle {
  /// Botón principal, usado para acciones principales
  primary,

  /// Botón secundario, usado para acciones secundarias
  secondary,

  /// Botón de peligro, usado para acciones destructivas
  danger,

  /// Botón de texto sin fondo, usado para acciones sutiles
  text,

  /// Botón de acción, usado para acciones especiales (amarillo)
  action,
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

/// Clase auxiliar para almacenar los colores de un botón
class ButtonColors {
  final Color background;
  final Color foreground;
  final Color disabledBackground;
  final Color disabledForeground;

  ButtonColors({
    required this.background,
    required this.foreground,
    required this.disabledBackground,
    required this.disabledForeground,
  });
}

/// Clase auxiliar para almacenar las dimensiones de un botón
class ButtonSize {
  final EdgeInsets padding;
  final double fontSize;
  final double iconSize;

  ButtonSize({
    required this.padding,
    required this.fontSize,
    required this.iconSize,
  });
}

/// Widget reutilizable para botones con estilos consistentes en toda la aplicación
///
/// Ofrece diferentes variantes y opciones de personalización mientras mantiene
/// la consistencia visual con el tema de la aplicación.
class AppButton extends StatelessWidget {
  /// El texto a mostrar en el botón
  final String text;

  /// Ícono opcional para mostrar junto al texto
  final IconData? icon;

  /// Función a ejecutar cuando se presiona el botón
  final VoidCallback? onPressed;

  /// Si el botón debe ocupar todo el ancho disponible
  final bool fullWidth;

  /// Estilo del botón (primario, secundario, peligro, etc.)
  final AppButtonStyle style;

  /// Tamaño del botón (pequeño, normal, grande)
  final AppButtonSize size;

  /// Si el botón debe mostrarse como cargando
  final bool isLoading;

  /// Si el botón debe mostrarse deshabilitado
  final bool disabled;

  /// Si el ícono debe mostrarse después del texto (por defecto es antes)
  final bool iconAfterText;

  /// Padding personalizado
  final EdgeInsets? padding;

  /// Color de fondo personalizado (anula el estilo)
  final Color? backgroundColor;

  /// Color de texto personalizado (anula el estilo)
  final Color? textColor;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.fullWidth = false,
    this.style = AppButtonStyle.primary,
    this.size = AppButtonSize.normal,
    this.isLoading = false,
    this.disabled = false,
    this.iconAfterText = false,
    this.padding,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Determinar colores según el estilo
    final colors = _getButtonColors(style);

    // Determinar el tamaño del botón
    final buttonSize = _getButtonSize(size);

    // Crear el contenido del botón
    Widget content;
    if (isLoading) {
      content = SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(colors.foreground),
          strokeWidth: 2,
        ),
      );
    } else if (icon != null) {
      if (iconAfterText) {
        content = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: TextStyle(fontSize: buttonSize.fontSize)),
            const SizedBox(width: 8),
            Icon(icon, size: buttonSize.iconSize),
          ],
        );
      } else {
        content = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: buttonSize.iconSize),
            const SizedBox(width: 8),
            Text(text, style: TextStyle(fontSize: buttonSize.fontSize)),
          ],
        );
      }
    } else {
      content = Text(text, style: TextStyle(fontSize: buttonSize.fontSize));
    }

    // Crear el botón con el estilo apropiado
    final Widget buttonWidget = ElevatedButton(
      onPressed: (disabled || isLoading) ? null : onPressed,
      style: _buildButtonStyle(colors, buttonSize),
      child: content,
    );

    // Envolver en un SizedBox si es fullWidth
    return fullWidth
        ? SizedBox(width: double.infinity, child: buttonWidget)
        : buttonWidget;
  }

  /// Construye el estilo del botón según los colores y tamaños
  ButtonStyle _buildButtonStyle(ButtonColors colors, ButtonSize buttonSize) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? colors.background,
      foregroundColor: textColor ?? colors.foreground,
      disabledBackgroundColor: colors.disabledBackground,
      disabledForegroundColor: colors.disabledForeground,
      elevation: style == AppButtonStyle.text ? 0 : 2,
      padding: padding ?? buttonSize.padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.l),
        side: style == AppButtonStyle.secondary
            ? BorderSide(color: AppColors.lightTextPrimary)
            : BorderSide.none,
      ),
    );
  }

  /// Devuelve los colores para el estilo de botón especificado
  ButtonColors _getButtonColors(AppButtonStyle style) {
    switch (style) {
      case AppButtonStyle.primary:
        return ButtonColors(
          background: AppColors.lightTextPrimary,
          foreground: Colors.black,
          disabledBackground: AppColors.lightTextPrimary.withAlpha(
            (0.5 * 255).round(),
          ),
          disabledForeground: Colors.black54,
        );
      case AppButtonStyle.secondary:
        return ButtonColors(
          background: Colors.transparent,
          foreground: AppColors.lightTextPrimary,
          disabledBackground: Colors.transparent,
          disabledForeground: AppColors.lightTextPrimary.withAlpha(
            (0.5 * 255).round(),
          ),
        );
      case AppButtonStyle.danger:
        return ButtonColors(
          background: Colors.red.shade600,
          foreground: Colors.white,
          disabledBackground: Colors.red.shade300,
          disabledForeground: Colors.white70,
        );
      case AppButtonStyle.text:
        return ButtonColors(
          background: Colors.transparent,
          foreground: AppColors.lightTextPrimary,
          disabledBackground: Colors.transparent,
          disabledForeground: AppColors.lightTextPrimary.withAlpha(
            (0.5 * 255).round(),
          ),
        );
      case AppButtonStyle.action:
        return ButtonColors(
          background: Colors.amber,
          foreground: Colors.black87,
          disabledBackground: Colors.amber.shade200,
          disabledForeground: Colors.black38,
        );
    }
  }

  /// Devuelve las dimensiones para el tamaño de botón especificado
  ButtonSize _getButtonSize(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return ButtonSize(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          fontSize: 14,
          iconSize: 16,
        );
      case AppButtonSize.normal:
        return ButtonSize(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          fontSize: 16,
          iconSize: 20,
        );
      case AppButtonSize.large:
        return ButtonSize(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          fontSize: 18,
          iconSize: 24,
        );
    }
  }
}

/// Botón primario con fondo principal
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;
  final AppButtonSize size;
  final bool disabled;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = false,
    this.size = AppButtonSize.normal,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      fullWidth: fullWidth,
      style: AppButtonStyle.primary,
      size: size,
      disabled: disabled,
    );
  }
}

/// Botón secundario con borde y sin fondo
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;
  final AppButtonSize size;
  final bool disabled;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = false,
    this.size = AppButtonSize.normal,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      fullWidth: fullWidth,
      style: AppButtonStyle.secondary,
      size: size,
      disabled: disabled,
    );
  }
}

/// Botón de peligro con fondo rojo para acciones destructivas
class DangerButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;
  final AppButtonSize size;
  final bool disabled;

  const DangerButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = false,
    this.size = AppButtonSize.normal,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      fullWidth: fullWidth,
      style: AppButtonStyle.danger,
      size: size,
      disabled: disabled,
    );
  }
}

/// Componentes originales preservados para mantener compatibilidad
/// y características únicas

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool showConfirmDialog;

  const AppBackButton({
    super.key,
    this.onPressed,
    this.showConfirmDialog = true,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      color: Colors.white,
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          if (showConfirmDialog) {
            // Show confirmation dialog
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: const Text('¿Estás seguro?'),
                  content: const Text(
                    'Si vuelves atrás, perderás los cambios no guardados.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => dialogContext.closeScreen(),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        dialogContext.closeScreen();
                        context.goBack();
                      },
                      child: const Text('Volver'),
                    ),
                  ],
                );
              },
            );
          } else {
            context.goBack();
          }
        }
      },
    );
  }
}

class RoundedButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final Color? backgroundColor;

  const RoundedButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 40,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: FloatingActionButton(
        heroTag: null,
        onPressed: onPressed,
        backgroundColor: backgroundColor ?? AppColors.lightTextPrimary,
        elevation: 0,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

/// Botón de texto sin fondo ni borde
class TextButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool iconAfterText;
  final AppButtonSize size;
  final bool disabled;

  const TextButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.iconAfterText = false,
    this.size = AppButtonSize.normal,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      iconAfterText: iconAfterText,
      style: AppButtonStyle.text,
      size: size,
      disabled: disabled,
    );
  }
}

/// Botón de acción con fondo amarillo para acciones destacadas
class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;
  final AppButtonSize size;
  final bool disabled;

  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = false,
    this.size = AppButtonSize.normal,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      fullWidth: fullWidth,
      style: AppButtonStyle.action,
      size: size,
      disabled: disabled,
    );
  }
}

class BackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const BackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: onPressed ??
          () {
            Navigator.pop(context);
          },
      color: AppColors.lightTextPrimary,
      tooltip: 'Volver',
    );
  }
}

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? darkPrimaryBackground;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final String? tooltip;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.darkPrimaryBackground,
    this.iconColor,
    this.size = 40.0,
    this.iconSize = 20.0,
    this.tooltip,
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
          onTap: onPressed,
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
