// test/ui/mock_theme_provider.dart
import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';

/// MockThemeProvider para usar en pruebas
class MockThemeProvider extends ThemeProvider {
  final bool _isDarkMode;
  
  MockThemeProvider({bool isDarkMode = false}) : _isDarkMode = isDarkMode;

  @override
  bool get isDarkMode => _isDarkMode;

  @override
  Color get brandYellow => const Color(0xFFFFC107);

  @override
  Color get accentColor => const Color(0xFFE53E3E);

  @override
  bool get useCustomColors => false;
}
