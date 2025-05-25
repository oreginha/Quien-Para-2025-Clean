import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../custom_theme_config.dart';

enum ThemeMode {
  light,
  dark,
  system,
}

class ThemeProvider extends ChangeNotifier {
  static const String _themePreferenceKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.system;
  bool _isInitialized = false;

  // Suscripción para detectar cambios en el tema del sistema
  WidgetsBindingObserver? _observer;

  // Configuración de temas personalizados
  final CustomThemeConfig _customConfig = CustomThemeConfig();

  ThemeProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    // Inicializar configuración de temas personalizados
    await _customConfig.initialize();

    // Cargar las preferencias guardadas
    await _loadThemePreference();

    // Configurar el observer para detectar cambios en el tema del sistema
    _observer = _ThemeModeObserver(this);
    WidgetsBinding.instance.addObserver(_observer!);

    _isInitialized = true;
    // Notificar para asegurar que la UI se actualice después de la inicialización
    notifyListeners();
  }

  @override
  void dispose() {
    // Eliminar el observer cuando se destruya el provider
    if (_observer != null) {
      WidgetsBinding.instance.removeObserver(_observer!);
      _observer = null;
    }
    super.dispose();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (!_isInitialized) {
      return PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    }

    if (_themeMode == ThemeMode.system) {
      return PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  // Obtener el color primario actual (personalizado o predeterminado)
  Color get brandYellow => _customConfig.brandYellow;

  // Obtener el color de acento actual (personalizado o predeterminado)
  Color get accentColor => _customConfig.accentColor;

  // Saber si se están usando colores personalizados
  bool get useCustomColors => _customConfig.useCustomColors;

  // Métodos para personalizar colores

  /// Establecer un nuevo color primario personalizado
  Future<void> setPrimaryColor(Color color) async {
    await _customConfig.setPrimaryColor(color);
    notifyListeners();
  }

  /// Establecer un nuevo color de acento personalizado
  Future<void> setAccentColor(Color color) async {
    await _customConfig.setAccentColor(color);
    notifyListeners();
  }

  /// Activar o desactivar el uso de colores personalizados
  Future<void> setUseCustomColors(bool value) async {
    await _customConfig.setUseCustomColors(value);
    notifyListeners();
  }

  /// Resetear a los colores predeterminados
  Future<void> resetToDefaultColors() async {
    await _customConfig.resetToDefaults();
    notifyListeners();
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeMode = prefs.getString(_themePreferenceKey);

      if (savedThemeMode != null) {
        _themeMode = _getThemeModeFromString(savedThemeMode);
      }
    } catch (e) {
      debugPrint('Error cargando preferencias de tema: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return; // No hacer nada si es el mismo modo

    _themeMode = mode;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themePreferenceKey, mode.toString());
    } catch (e) {
      debugPrint('Error guardando preferencias de tema: $e');
    }

    notifyListeners();
  }

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else if (_themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      // Si está en modo sistema, cambiamos según el tema actual del sistema
      final isDark =
          PlatformDispatcher.instance.platformBrightness == Brightness.dark;
      await setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
    }
  }

  ThemeMode _getThemeModeFromString(String themeMode) {
    switch (themeMode) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.system':
      default:
        return ThemeMode.system;
    }
  }

  // Método para actualizar el tema cuando cambia la configuración del sistema
  void updateWithSystemTheme() {
    if (_themeMode == ThemeMode.system) {
      // Solo notificar si estamos en modo sistema
      notifyListeners();
    }
  }
}

// Observer personalizado para detectar cambios en el brillo de la plataforma
class _ThemeModeObserver extends WidgetsBindingObserver {
  final ThemeProvider provider;

  _ThemeModeObserver(this.provider);

  @override
  void didChangePlatformBrightness() {
    provider.updateWithSystemTheme();
    super.didChangePlatformBrightness();
  }
}
