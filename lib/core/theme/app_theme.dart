import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'theme_constants.dart';
import 'provider/theme_provider.dart';

/// Clase principal de tema de la aplicación
///
/// AppTheme es responsable de proporcionar los temas completos (claro y oscuro)
/// para toda la aplicación, siguiendo las especificaciones de diseño del documento.
class AppTheme {
  final bool isDarkMode;

  const AppTheme({this.isDarkMode = false});

  /// Obtiene el tema completo basado en el modo (claro/oscuro)
  ThemeData getTheme() {
    return isDarkMode ? _darkTheme : _lightTheme;
  }

  /// Obtiene la instancia de AppTheme desde el contexto
  static AppTheme of(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return AppTheme(isDarkMode: themeProvider.isDarkMode);
  }

  /// Define el tema claro (light mode) según las especificaciones de diseño
  ThemeData get _lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.brandYellow,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.brandYellow,
        secondary: AppColors.accentRed,
        surface: AppColors.lightSecondaryBackground,
        // Previously used 'background: AppColors.lightBackground'
        // In Material 3, we use surfaceContainerHighest for the highest elevation surface
        surfaceContainerHighest: AppColors.lightBackground,
        error: AppColors.accentRed,
        onPrimary: AppColors.lightTextPrimary,
        onSecondary: Colors.white,
        onSurface: AppColors.lightTextPrimary,
        // Previously used 'onBackground: AppColors.lightTextPrimary'
        // In Material 3, text colors are handled through onSurface and variants
        onError: Colors.white,
      ),
      textTheme: AppTypography.getTextTheme(false),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightTextPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.appBarTitle(false),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandYellow,
          foregroundColor: AppColors.lightTextPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m,
            vertical: AppSpacing.s,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          elevation: AppElevation.button,
          textStyle: AppTypography.buttonLarge(false),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightTextPrimary,
          side: const BorderSide(color: AppColors.lightTextPrimary, width: 2),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m,
            vertical: AppSpacing.s,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: AppTypography.buttonLarge(false),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightBottomNavBackground,
        selectedItemColor: AppColors.brandYellow,
        unselectedItemColor: AppColors.lightTextSecondary,
        elevation: AppElevation.bottomNav,
        type: BottomNavigationBarType.fixed,
      ),
      cardTheme: CardTheme(
        color: AppColors.lightCardBackground,
        elevation: AppElevation.card,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        shadowColor: AppColors.lightShadow,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
        space: AppSpacing.s,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSecondaryBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputField),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputField),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputField),
          borderSide: const BorderSide(color: AppColors.brandYellow, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputField),
          borderSide: const BorderSide(color: AppColors.accentRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputField),
          borderSide: const BorderSide(color: AppColors.accentRed, width: 2),
        ),
        labelStyle: AppTypography.labelMedium(false),
        hintStyle: AppTypography.bodyMedium(false),
      ),
    );
  }

  /// Define el tema oscuro (dark mode) según las especificaciones de diseño
  ThemeData get _darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.brandYellow,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.brandYellow,
        secondary: AppColors.accentRed,
        surface: AppColors.darkSecondaryBackground,
        surfaceContainerHighest: AppColors.darkBackground,
        error: AppColors.accentRed,
        onPrimary: AppColors.lightTextPrimary,
        onSecondary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
        // onBackground: AppColors.darkTextPrimary,
        onError: Colors.white,
      ),
      textTheme: AppTypography.getTextTheme(true),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.appBarTitle(true),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandYellow,
          foregroundColor: AppColors.lightTextPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m,
            vertical: AppSpacing.s,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          elevation: AppElevation.button,
          textStyle: AppTypography.buttonLarge(true),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkTextPrimary,
          side: const BorderSide(color: AppColors.darkTextPrimary, width: 2),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m,
            vertical: AppSpacing.s,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: AppTypography.buttonLarge(true),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkBottomNavBackground,
        selectedItemColor: AppColors.brandYellow,
        unselectedItemColor: AppColors.darkTextSecondary,
        elevation: AppElevation.bottomNav,
        type: BottomNavigationBarType.fixed,
      ),
      cardTheme: CardTheme(
        color: AppColors.darkCardBackground,
        elevation: AppElevation.card,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        shadowColor: AppColors.darkShadow,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
        space: AppSpacing.s,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSecondaryBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputField),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputField),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputField),
          borderSide: const BorderSide(color: AppColors.brandYellow, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputField),
          borderSide: const BorderSide(color: AppColors.accentRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.inputField),
          borderSide: const BorderSide(color: AppColors.accentRed, width: 2),
        ),
        labelStyle: AppTypography.labelMedium(true),
        hintStyle: AppTypography.bodyMedium(true),
      ),
    );
  }

  // Getters de conveniencia para acceso rápido a colores según el tema
  Color get background => AppColors.getBackground(isDarkMode);
  Color get cardBackground => AppColors.getCardBackground(isDarkMode);
  Color get textPrimary => AppColors.getTextPrimary(isDarkMode);
  Color get textSecondary => AppColors.getTextSecondary(isDarkMode);
  Color get border => AppColors.getBorder(isDarkMode);
  Color get bottomNavBackground => AppColors.getBottomNavBackground(isDarkMode);

  // Getters para colores de marca
  Color get primary => AppColors.brandYellow;
  Color get primaryColor => AppColors.brandYellow;
  Color get accent => AppColors.accentRed;
  Color get successColor => Colors.green;

  // Constantes de opacidad
  double get mediumEmphasisOpacity => 0.87;

  // Gradiente de fondo
  LinearGradient get backgroundGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      isDarkMode
          ? AppColors.darkSecondaryBackground
          : AppColors.lightSecondaryBackground,
    ],
  );

  // Método para obtener color con alpha
  Color getColorWithAlpha(Color color, double opacity) {
    // Convertir valor de opacidad (0.0-1.0) a alpha (0-255)
    final int alpha = (opacity * 255).round();
    return color.withAlpha(alpha);
  }

  // Getters para estilos de texto más usados
  TextStyle get bodyMedium => AppTypography.bodyMedium(isDarkMode);
  TextStyle get bodyLarge => AppTypography.bodyLarge(isDarkMode);
  TextStyle get headingMedium => AppTypography.heading5(isDarkMode);
  TextStyle get headingLarge => AppTypography.heading3(isDarkMode);
  TextStyle get buttonText => AppTypography.buttonLarge(isDarkMode);

  // Método helper para obtener InputDecoration consistente
  InputDecoration getInputDecoration({
    String? hintText,
    String? labelText,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: isDarkMode
          ? AppColors.darkSecondaryBackground
          : AppColors.lightSecondaryBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.inputField),
        borderSide: BorderSide(
          color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.inputField),
        borderSide: BorderSide(
          color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.inputField),
        borderSide: const BorderSide(color: AppColors.brandYellow, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.inputField),
        borderSide: const BorderSide(color: AppColors.accentRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.inputField),
        borderSide: const BorderSide(color: AppColors.accentRed, width: 2),
      ),
      labelStyle: AppTypography.labelMedium(isDarkMode),
      hintStyle: AppTypography.bodyMedium(isDarkMode),
    );
  }
}
