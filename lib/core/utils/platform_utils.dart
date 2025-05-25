// lib/core/utils/platform_utils.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Utilidades para detectar y adaptarse a diferentes plataformas
class PlatformUtils {
  PlatformUtils._(); // Constructor privado para prevenir instanciación

  /// Determina si la aplicación se está ejecutando en la web
  static bool get isWeb => kIsWeb;

  /// Determina si la aplicación se está ejecutando en un dispositivo móvil
  static bool get isMobile => !kIsWeb;

  /// Determina si la aplicación se está ejecutando en un dispositivo iOS
  static bool get isIOS => false; //

  /// Determina si la aplicación se está ejecutando en un dispositivo Android
  static bool get isAndroid => false; //

  /// Determina si la pantalla es considerada pequeña basada en el ancho
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  /// Determina si la pantalla es considerada mediana basada en el ancho
  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  /// Determina si la pantalla es considerada grande basada en el ancho
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  /// Obtiene el factor de escala adecuado para el texto según la plataforma
  static double getTextScaleFactor(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return 0.8;
    if (width < 600) return 1.0;
    if (width < 900) return 1.1;
    return 1.2;
  }
}

/// Extensión para BuildContext que proporciona métodos de utilidad para detección de plataforma
extension PlatformUtilsExtension on BuildContext {
  /// Determina si la aplicación se está ejecutando en la web
  bool get isWeb => PlatformUtils.isWeb;

  /// Determina si la aplicación se está ejecutando en un dispositivo móvil
  bool get isMobile => PlatformUtils.isMobile;

  /// Determina si la pantalla es considerada pequeña
  bool get isSmallScreen => PlatformUtils.isSmallScreen(this);

  /// Determina si la pantalla es considerada mediana
  bool get isMediumScreen => PlatformUtils.isMediumScreen(this);

  /// Determina si la pantalla es considerada grande
  bool get isLargeScreen => PlatformUtils.isLargeScreen(this);
}
