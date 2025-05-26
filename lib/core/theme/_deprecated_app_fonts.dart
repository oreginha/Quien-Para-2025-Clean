import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const String primaryFont = 'Playfair Display';

  static const TextStyle appBarTitle = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.yellow,
  );

  static const TextStyle heading1 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
  );

  // Estilo de texto para encabezados nivel 3
  static TextStyle heading3(bool isDarkMode) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: isDarkMode
          ? AppColors.darkTextPrimary
          : AppColors.lightTextPrimary,
    );
  }
}
