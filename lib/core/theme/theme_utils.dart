import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_colors.dart';
import 'app_theme.dart';
import 'provider/theme_provider.dart';

/// Utilidad para acceder a los temas y colores de manera estática
///
/// ThemeUtils proporciona acceso estático a colores y propiedades de tema
/// sin necesidad de crear instancias. Su propósito principal es resolver los
/// problemas de acceso estático a miembros de instancia y facilitar el acceso
/// a colores específicos en toda la aplicación.
///
/// Para acceder a temas completos de Material Design, utiliza AppTheme en su lugar.
///
/// Ejemplos de uso:
///
/// 1. Para acceder a colores estáticos:
/// ```dart
/// Container(
///   color: ThemeUtils.background,
///   child: Text('Ejemplo', style: TextStyle(color: ThemeUtils.textPrimary)),
/// )
/// ```
///
/// 2. Para obtener colores basados en el modo actual:
/// ```dart
/// final isDarkMode = Theme.of(context).brightness == Brightness.dark;
/// Container(
///   color: ThemeUtils.getBackground(isDarkMode),
///   child: Text('Ejemplo', style: TextStyle(color: ThemeUtils.getTextPrimary(isDarkMode))),
/// )
/// ```
class ThemeUtils {
  /// Obtener el tema según el contexto actual
  static AppTheme getTheme(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return AppTheme(isDarkMode: themeProvider.isDarkMode);
  }

  /// Colores comunes para acceso estático
  static Color get cardBackground => AppColors.lightCardBackground;
  static Color get cardBackgroundDark => AppColors.darkCardBackground;
  static Color get background => AppColors.lightBackground;
  static Color get backgroundDark => AppColors.darkBackground;
  static Color get textPrimary => AppColors.lightTextPrimary;
  static Color get textPrimaryDark => AppColors.darkTextPrimary;
  static Color get textSecondary => AppColors.lightTextSecondary;
  static Color get textSecondaryDark => AppColors.darkTextSecondary;
  static Color get lightBorder => AppColors.lightBorder;
  static Color get darkBorder => AppColors.darkBorder;
  static Color get brandYellow => AppColors.brandYellow;
  static Color get accentRed => AppColors.accentRed;
  static Color get darkSecondaryBackground => AppColors.darkSecondaryBackground;
  static Color get lightSecondaryBackground =>
      AppColors.lightSecondaryBackground;
  static Color get lightPrimaryBackground => AppColors.lightBackground;

  /// Acceso estático a colors (para corregir error «Instance member 'colors' can't be accessed using static access»)
  static Color get colors => AppColors.brandYellow;

  /// Color primario para botones
  static Color get buttonPrimaryColor => AppColors.brandYellow;

  /// Color secundario para botones
  static Color get buttonSecondaryColor => AppColors.accentRed;

  /// Acceso a estilos de texto
  static TextStyle get bodyMedium => const TextStyle(
    fontSize: 14,
    height: 1.5,
    color: AppColors.lightTextPrimary,
  );

  /// Acceso a originalBlueColor para corregir el error en interests_step.dart
  static Color get originalBlueColor => const Color(0xFF3B82F6);

  /// Obtener el color de fondo según el modo oscuro o claro
  static Color getBackground(bool isDarkMode) {
    return isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;
  }

  /// Obtener el color de tarjeta según el modo oscuro o claro
  static Color getCardBackground(bool isDarkMode) {
    return isDarkMode
        ? AppColors.darkCardBackground
        : AppColors.lightCardBackground;
  }

  /// Obtener el color de texto principal según el modo oscuro o claro
  static Color getTextPrimary(bool isDarkMode) {
    return isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
  }

  /// Obtener el color de texto secundario según el modo oscuro o claro
  static Color getTextSecondary(bool isDarkMode) {
    return isDarkMode
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
  }

  /// Obtener el color de borde según el modo oscuro o claro
  static Color getBorder(bool isDarkMode) {
    return isDarkMode ? AppColors.darkBorder : AppColors.lightBorder;
  }

  /// Obtener el color de fondo secundario según el modo oscuro o claro
  static Color getSecondaryBackground(bool isDarkMode) {
    return isDarkMode
        ? AppColors.darkSecondaryBackground
        : AppColors.lightSecondaryBackground;
  }
}
