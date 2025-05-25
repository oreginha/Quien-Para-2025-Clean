import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quien_para/core/theme/app_colors.dart';

/// Clase que guarda la configuración personalizada de temas
class CustomThemeConfig {
  static const String _brandYellowKey = 'custom_primary_color';
  static const String _accentColorKey = 'custom_accent_color';
  static const String _useCustomColorsKey = 'use_custom_colors';

  // Colores por defecto - usando valores directos para evitar dependencia circular
  Color _brandYellow = const Color(0xFFFFC107); // Mismo valor que AppColors._defaultBrandYellow
  Color _accentColor = const Color(0xFFE53E3E); // Mismo valor que AppColors._defaultAccentRed
  bool _useCustomColors = false;

  // Singleton
  static final CustomThemeConfig _instance = CustomThemeConfig._internal();
  factory CustomThemeConfig() => _instance;
  CustomThemeConfig._internal();

  /// Inicializa la configuración cargando los valores guardados
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Cargar uso de colores personalizados
      _useCustomColors = prefs.getBool(_useCustomColorsKey) ?? false;

      // Cargar colores guardados o usar los predeterminados
      final savedPrimaryColor = prefs.getInt(_brandYellowKey);
      if (savedPrimaryColor != null) {
        _brandYellow = Color(savedPrimaryColor);
      }

      final savedAccentColor = prefs.getInt(_accentColorKey);
      if (savedAccentColor != null) {
        _accentColor = Color(savedAccentColor);
      }
    } catch (e) {
      debugPrint('Error cargando configuración de tema: $e');
    }
  }

  /// Obtener el color primario actual (personalizado o predeterminado)
  Color get brandYellow =>
      _useCustomColors ? _brandYellow : AppColors.brandYellow;

  /// Obtener el color de acento actual (personalizado o predeterminado)
  Color get accentColor =>
      _useCustomColors ? _accentColor : AppColors.accentRed;

  /// Saber si se están usando colores personalizados
  bool get useCustomColors => _useCustomColors;

  /// Establecer un nuevo color primario personalizado
  Future<void> setPrimaryColor(Color color) async {
    _brandYellow = color;
    await _saveColorPreference(
        _brandYellowKey,
        Color.fromARGB(
          color.a.round(),
          color.r.round(),
          color.g.round(),
          color.b.round(),
        ));
  }

  /// Establecer un nuevo color de acento personalizado
  Future<void> setAccentColor(Color color) async {
    _accentColor = color;
    await _saveColorPreference(
        _accentColorKey,
        Color.fromARGB(
          color.a.round(),
          color.r.round(),
          color.g.round(),
          color.b.round(),
        ));
  }

  /// Activar o desactivar el uso de colores personalizados
  Future<void> setUseCustomColors(bool value) async {
    _useCustomColors = value;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_useCustomColorsKey, value);
    } catch (e) {
      debugPrint('Error guardando uso de colores personalizados: $e');
    }
  }

  /// Guardar preferencia de color en SharedPreferences
  Future<void> _saveColorPreference(String key, Color color) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
          key,
          (color.a.round() << 24) |
              (color.r.round() << 16) |
              (color.g.round() << 8) |
              color.b.round());
    } catch (e) {
      debugPrint('Error guardando preferencia de color: $e');
    }
  }

  /// Resetear a los colores predeterminados
  Future<void> resetToDefaults() async {
    _brandYellow = AppColors.brandYellow;
    _accentColor = AppColors.accentRed;
    _useCustomColors = false;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_brandYellowKey);
      await prefs.remove(_accentColorKey);
      await prefs.remove(_useCustomColorsKey);
    } catch (e) {
      debugPrint('Error reseteando preferencias de tema: $e');
    }
  }
}
