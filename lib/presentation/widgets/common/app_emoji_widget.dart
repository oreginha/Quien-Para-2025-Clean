// lib/presentation/widgets/app_icon_widget.dart

import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import '../../../core/constants/app_icons.dart';

enum IconDisplayMode {
  materialIcon, // Mostrar solo el ícono de Material Design
  emoji, // Mostrar solo el emoji
  both, // Mostrar ambos (ícono y emoji)
  adaptive // Adaptar según la plataforma (Android: Material, iOS: Emoji)
}

/// Widget para mostrar íconos de la aplicación de manera consistente.
///
/// Este widget permite mostrar íconos utilizando emojis, íconos de Material Design, o ambos,
/// manteniendo una apariencia uniforme en toda la aplicación.
class AppEmojiWidget extends StatelessWidget {
  /// El tipo de ícono a mostrar, desde la clase AppIcons.
  final IconData icon;

  /// Emoji alternativo o complementario al ícono.
  final String emoji;

  /// Tamaño del ícono.
  final double size;

  /// Color del ícono. Si es null, usará el color  darkTextPrimary.
  final Color? color;

  /// Modo de visualización del ícono.
  final IconDisplayMode displayMode;

  /// Espacio entre el ícono y el emoji cuando displayMode es both.
  final double spacing;

  /// Construye un AppEmojiWidget con un emoji específico, obteniendo automáticamente el ícono correspondiente.
  ///
  /// Ejemplo: AppEmojiWidget.fromEmoji(emoji: '📌', size: 24)
  factory AppEmojiWidget.fromEmoji({
    required final String emoji,
    final double size = 24,
    final Color? color,
    final IconDisplayMode displayMode = IconDisplayMode.adaptive,
    final double spacing = 4,
  }) {
    return AppEmojiWidget(
      icon: AppIcons.getIconFromEmoji(emoji),
      emoji: emoji,
      size: size,
      color: color,
      displayMode: displayMode,
      spacing: spacing,
    );
  }

  /// Construye un AppEmojiWidget con un ícono y emoji específicos.
  ///
  /// Ejemplo: AppEmojiWidget(icon: AppIcons.pin, emoji: '📌', size: 24)
  const AppEmojiWidget({
    super.key,
    required this.icon,
    required this.emoji,
    this.size = 24,
    this.color,
    this.displayMode = IconDisplayMode.adaptive,
    this.spacing = 4,
  });

  @override
  Widget build(final BuildContext context) {
    // Determinar el modo de visualización
    IconDisplayMode effectiveMode = displayMode;
    if (displayMode == IconDisplayMode.adaptive) {
      // En iOS se prefieren los emojis, en Android los íconos de Material
      effectiveMode = Theme.of(context).platform == TargetPlatform.iOS
          ? IconDisplayMode.emoji
          : IconDisplayMode.materialIcon;
    }

    // Color predeterminado si no se proporciona uno
    final Color effectiveColor = color ?? AppColors.lightTextPrimary;

    switch (effectiveMode) {
      case IconDisplayMode.materialIcon:
        return Icon(
          icon,
          size: size,
          color: effectiveColor,
        );

      case IconDisplayMode.emoji:
        return Text(
          emoji,
          style: TextStyle(
            fontSize: size,
          ),
        );

      case IconDisplayMode.both:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: size,
              color: effectiveColor,
            ),
            SizedBox(width: spacing),
            Text(
              emoji,
              style: TextStyle(
                fontSize: size,
              ),
            ),
          ],
        );

      default:
        return Icon(
          icon,
          size: size,
          color: effectiveColor,
        );
    }
  }
}
