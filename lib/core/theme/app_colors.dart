import 'package:flutter/material.dart';

/// Clase de colores para ambos temas (claro y oscuro)
/// según las especificaciones del diseño UI
class AppColors {
  // Colores de marca compartidos (valores constantes según el diseño)
  static const Color brandYellow = Color(
    0xFFFFC107,
  ); // Color principal de marca
  static const Color accentRed = Color(
    0xFFE53E3E,
  ); // Color de alerta/secundario

  // ===== MODO OSCURO (DARK THEME) =====
  // Colores base para el modo oscuro
  static const Color darkBackground = Color(0xFF1E293B); // Fondo principal
  static const Color darkSecondaryBackground = Color(
    0xFF16202A,
  ); // Fondo secundario (panels, dropdowns)
  static const Color darkCardBackground = Color(0xFF1E293B); // Cards de feed
  static const Color darkBottomNavBackground = Color(
    0xFF161F2E,
  ); // Bottom nav bar

  // Textos en modo oscuro
  static const Color darkTextPrimary = Color(0xFFF7FAFC); // Titulares, body
  static const Color darkTextSecondary = Color(0xFFA0AEC0); // Captions, labels

  // Bordes y divisores en modo oscuro
  static const Color darkBorder = Color(
    0xFF2D3748,
  ); // Líneas divisorias, outlines

  // Overlay para imágenes en modo oscuro
  static const Color darkImageOverlay = Color(
    0x66000000,
  ); // rgba(0,0,0,0.4) overlay

  // ===== MODO CLARO (LIGHT THEME) =====
  // Colores base para el modo claro
  static const Color lightBackground = Color(0xFFF7FAFC); // Fondo principal
  static const Color lightSecondaryBackground = Color(
    0xFFFFFFFF,
  ); // Fondo secundario (panels)
  static const Color lightCardBackground = Color(0xFFFFFFFF); // Cards de feed
  static const Color lightBottomNavBackground = Color(
    0xFFFFFFFF,
  ); // Bottom nav bar

  // Textos en modo claro
  static const Color lightTextPrimary = Color(0xFF1E293B); // Titulares, body
  static const Color lightTextSecondary = Color(0xFF4A5568); // Captions, labels

  // Bordes y divisores en modo claro
  static const Color lightBorder = Color(
    0xFFCBD5E1,
  ); // Líneas divisorias, outlines

  // Overlay para imágenes en modo claro
  static const Color lightImageOverlay = Color(
    0x0A000000,
  ); // Overlay muy sutil o nulo

  // ===== ESTADOS Y FEEDBACK =====
  // Colores de estado compartidos por ambos temas
  static const Color success = Color(0xFF38A169);
  static const Color warning = Color(0xFFECC94B);
  static const Color info = Color(0xFF4299E1);

  // Sombras adaptativas según el tema
  static const Color darkShadow = Color(
    0x40000000,
  ); // Sombra más fuerte para modo oscuro
  static const Color lightShadow = Color(
    0x0D000000,
  ); // rgba(0,0,0,0.05) para modo claro

  // ===== HELPERS =====
  // Métodos para obtener colores basados en el modo actual
  static Color getBackground(bool isDarkMode) {
    return isDarkMode ? darkBackground : lightBackground;
  }

  static Color getSecondaryBackground(bool isDarkMode) {
    return isDarkMode ? darkSecondaryBackground : lightSecondaryBackground;
  }

  static Color getCardBackground(bool isDarkMode) {
    return isDarkMode ? darkCardBackground : lightCardBackground;
  }

  static Color getTextPrimary(bool isDarkMode) {
    return isDarkMode ? darkTextPrimary : lightTextPrimary;
  }

  static Color getTextSecondary(bool isDarkMode) {
    return isDarkMode ? darkTextSecondary : lightTextSecondary;
  }

  static Color getBorder(bool isDarkMode) {
    return isDarkMode ? darkBorder : lightBorder;
  }

  static Color getBottomNavBackground(bool isDarkMode) {
    return isDarkMode ? darkBottomNavBackground : lightBottomNavBackground;
  }

  static Color getImageOverlay(bool isDarkMode) {
    return isDarkMode ? darkImageOverlay : lightImageOverlay;
  }

  static Color getShadowColor(bool isDarkMode) {
    return isDarkMode ? darkShadow : lightShadow;
  }

  // Helpers para trabajar con opacidades
  static Color withAlpha(Color color, double opacity) {
    return color.withAlpha((opacity * 255).round());
  }

  // Determinar si una tarjeta o superficie necesita texto claro u oscuro
  static Color getContrastColor(Color darkPrimaryBackground) {
    return darkPrimaryBackground.computeLuminance() > 0.5
        ? const Color(0xFF1E293B) // Texto oscuro para fondos claros
        : const Color(0xFFF7FAFC); // Texto claro para fondos oscuros
  }

  // Lista de colores predefinidos para selección
  static List<Color> get predefinedColors => [
        brandYellow, // Amarillo de marca
        accentRed, // Rojo de alerta/acento
        const Color(0xFF3182CE), // Azul
        const Color(0xFF38A169), // Verde
        const Color(0xFF805AD5), // Púrpura
        const Color(0xFFDD6B20), // Naranja
        const Color(0xFFD53F8C), // Rosa
        const Color(0xFF718096), // Gris
      ];
}
