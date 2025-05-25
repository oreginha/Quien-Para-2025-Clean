import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Clase para definir toda la tipografía de la aplicación según el documento de diseño
/// Fuentes utilizadas:
/// - Playfair Display: Para headings y títulos
/// - Inter: Para body text y elementos secundarios
class AppTypography {
  // Fuentes principales
  static const String primaryFont = 'Playfair Display';
  static const String secondaryFont = 'Inter';

  // ===== HEADINGS (Playfair Display) =====

  /// Heading 1 - 32pt / lh 40pt
  static TextStyle heading1(bool isDarkMode) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: 32.0,
      height: 1.25, // 40/32 = 1.25
      fontWeight: FontWeight.bold,
      color:
          isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );
  }

  /// Heading 2 - 28pt
  static TextStyle heading2(bool isDarkMode) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: 28.0,
      height: 1.25,
      fontWeight: FontWeight.bold,
      color:
          isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );
  }

  /// Heading 3 - 24pt
  static TextStyle heading3(bool isDarkMode) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: 24.0,
      height: 1.25,
      fontWeight: FontWeight.bold,
      color:
          isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );
  }

  /// Heading 4 - 20pt
  static TextStyle heading4(bool isDarkMode) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: 20.0,
      height: 1.3,
      fontWeight: FontWeight.bold,
      color:
          isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );
  }

  /// Heading 5 - 18pt
  static TextStyle heading5(bool isDarkMode) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: 18.0,
      height: 1.3,
      fontWeight: FontWeight.w600,
      color:
          isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );
  }

  /// Heading 6 - 16pt
  static TextStyle heading6(bool isDarkMode) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: 16.0,
      height: 1.3,
      fontWeight: FontWeight.w600,
      color:
          isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );
  }

  // ===== BODY TEXT (Inter) =====

  /// Body Large - 16pt / lh 24pt
  static TextStyle bodyLarge(bool isDarkMode) {
    return TextStyle(
      fontFamily: secondaryFont,
      fontSize: 16.0,
      height: 1.5, // 24/16 = 1.5
      fontWeight: FontWeight.normal,
      color:
          isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );
  }

  /// Body Medium - 14pt / lh 21pt
  static TextStyle bodyMedium(bool isDarkMode) {
    return TextStyle(
      fontFamily: secondaryFont,
      fontSize: 14.0,
      height: 1.5,
      fontWeight: FontWeight.normal,
      color:
          isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );
  }

  /// Body Small - 12pt / lh 18pt
  static TextStyle bodySmall(bool isDarkMode) {
    return TextStyle(
      fontFamily: secondaryFont,
      fontSize: 12.0,
      height: 1.5,
      fontWeight: FontWeight.normal,
      color: isDarkMode
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary,
    );
  }

  // ===== LABELS AND CAPTIONS =====

  /// Label Large - 14pt
  static TextStyle labelLarge(bool isDarkMode) {
    return TextStyle(
      fontFamily: secondaryFont,
      fontSize: 14.0,
      height: 1.2,
      fontWeight: FontWeight.w500,
      color: isDarkMode
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary,
    );
  }

  /// Label Medium - 12pt
  static TextStyle labelMedium(bool isDarkMode) {
    return TextStyle(
      fontFamily: secondaryFont,
      fontSize: 12.0,
      height: 1.2,
      fontWeight: FontWeight.w500,
      color: isDarkMode
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary,
    );
  }

  /// Label Small - 11pt
  static TextStyle labelSmall(bool isDarkMode) {
    return TextStyle(
      fontFamily: secondaryFont,
      fontSize: 11.0,
      height: 1.2,
      fontWeight: FontWeight.w500,
      color: isDarkMode
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary,
    );
  }

  /// Caption - 12pt (más ligero que label)
  static TextStyle caption(bool isDarkMode) {
    return TextStyle(
      fontFamily: secondaryFont,
      fontSize: 12.0,
      height: 1.4,
      fontWeight: FontWeight.normal,
      color: isDarkMode
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary,
    );
  }

  // ===== BUTTON TEXT =====

  /// Button Large - 16pt
  static TextStyle buttonLarge(bool isDarkMode) {
    return TextStyle(
      fontFamily: secondaryFont,
      fontSize: 16.0,
      height: 1.2,
      fontWeight: FontWeight.w600,
      color:
          isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );
  }

  /// Button Medium - 14pt
  static TextStyle buttonMedium(bool isDarkMode) {
    return TextStyle(
      fontFamily: secondaryFont,
      fontSize: 14.0,
      height: 1.2,
      fontWeight: FontWeight.w600,
      color:
          isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );
  }

  /// Button Small - 12pt
  static TextStyle buttonSmall(bool isDarkMode) {
    return TextStyle(
      fontFamily: secondaryFont,
      fontSize: 12.0,
      height: 1.2,
      fontWeight: FontWeight.w600,
      color:
          isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );
  }

  // ===== SPECIAL STYLES =====

  /// AppBar Title - Playfair Display 24pt
  static TextStyle appBarTitle(bool isDarkMode) {
    return TextStyle(
      fontFamily: primaryFont,
      fontSize: 24.0,
      height: 1.2,
      fontWeight: FontWeight.bold,
      // Usar color azul en modo claro y amarillo en modo oscuro para mejor contraste
      color: isDarkMode ? AppColors.brandYellow : AppColors.lightTextPrimary,
    );
  }

  /// Subtitle - Inter 16pt Medium
  static TextStyle subtitle1(bool isDarkMode) {
    return TextStyle(
      fontFamily: secondaryFont,
      fontSize: 16.0,
      height: 1.4,
      fontWeight: FontWeight.w500,
      color:
          isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
    );
  }

  /// Subtitle Small - Inter 14pt Medium
  static TextStyle subtitle2(bool isDarkMode) {
    return TextStyle(
      fontFamily: secondaryFont,
      fontSize: 14.0,
      height: 1.4,
      fontWeight: FontWeight.w500,
      color: isDarkMode
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary,
    );
  }

  /// Overline - Inter 12pt Medium Uppercase
  static TextStyle overline(bool isDarkMode) {
    return TextStyle(
      fontFamily: secondaryFont,
      fontSize: 12.0,
      height: 1.5,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.5,
      color: isDarkMode
          ? AppColors.darkTextSecondary
          : AppColors.lightTextSecondary,
    );
  }

  // ===== MÉTODOS HELPER =====

  /// Obtiene un TextTheme completo para Flutter según el modo
  static TextTheme getTextTheme(bool isDarkMode) {
    return TextTheme(
      displayLarge: heading1(isDarkMode),
      displayMedium: heading2(isDarkMode),
      displaySmall: heading3(isDarkMode),
      headlineLarge: heading4(isDarkMode),
      headlineMedium: heading5(isDarkMode),
      headlineSmall: heading6(isDarkMode),
      titleLarge: subtitle1(isDarkMode),
      titleMedium: subtitle2(isDarkMode),
      titleSmall: labelLarge(isDarkMode),
      bodyLarge: bodyLarge(isDarkMode),
      bodyMedium: bodyMedium(isDarkMode),
      bodySmall: bodySmall(isDarkMode),
      labelLarge: buttonLarge(isDarkMode),
      labelMedium: labelMedium(isDarkMode),
      labelSmall: labelSmall(isDarkMode),
    );
  }
}
