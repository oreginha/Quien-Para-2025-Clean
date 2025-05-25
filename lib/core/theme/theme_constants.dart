/// Archivo para definiciones de constantes de diseño
/// Incluye espaciados, radios y elevaciones según grid de 8pt
library;

import 'package:flutter/material.dart';

/// Definiciones de espaciados consistentes basados en grid de 8pt
class AppSpacing {
  // Espaciados básicos (multiplicadores de 8)
  static const double xxs = 2;   // Para micro espacios
  static const double xs = 4;    // Espacios muy pequeños
  static const double s = 8;     // 1 unidad del grid
  static const double m = 16;    // 2 unidades del grid
  static const double l = 24;    // 3 unidades del grid
  static const double xl = 32;   // 4 unidades del grid
  static const double xxl = 48;  // 6 unidades del grid
  static const double xxxl = 64; // 8 unidades del grid
  
  // Alias semánticos para uso específico
  static const double buttonPadding = m;
  static const double cardPadding = m;
  static const double screenPadding = m;
  static const double sectionSpacing = l;
}

/// Definiciones de radios consistentes para bordes
class AppRadius {
  static const double none = 0;   // Sin radio
  static const double xs = 4;     // Radio muy pequeño
  static const double s = 8;      // Radio pequeño
  static const double m = 12;     // Radio medio (botones según spec)
  static const double l = 16;     // Radio grande
  static const double xl = 24;    // Radio extra grande
  static const double full = 999; // Radio completo (píldora)
  
  // Alias semánticos
  static const double button = m;    // 12pt según documento
  static const double card = s;      // 8pt para cards
  static const double inputField = s; // 8pt para campos
  static const double chip = full;   // Chips redondeados
}

/// Definiciones de elevaciones (sombras)
class AppElevation {
  static const double none = 0;
  static const double s = 2;     // Elevación sutil
  static const double m = 4;     // Elevación media
  static const double l = 8;     // Elevación para cards
  static const double xl = 16;   // Elevación alta
  static const double xxl = 24;  // Elevación máxima
  
  // Alias semánticos
  static const double card = s;        // Sombra suave para cards
  static const double button = s;      // Sombra sutil para botones
  static const double dialog = xl;     // Sombra pronunciada para diálogos
  static const double bottomNav = m;   // Sombra para navigation bar
}

/// Definiciones de transiciones y animaciones
class AppAnimation {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300); // Según documento
  static const Duration slow = Duration(milliseconds: 500);
  
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve emphasizedCurve = Curves.easeOutCubic;
}

/// Definiciones de tamaños de iconos
class AppIconSize {
  static const double xs = 16;
  static const double s = 20;
  static const double m = 24;
  static const double l = 32;
  static const double xl = 48;
  static const double xxl = 64;
  
  // Alias semánticos
  static const double button = m;
  static const double appBar = m;
  static const double bottomNav = m;
  static const double avatar = xl;
}

/// Definiciones de opacidades
class AppOpacity {
  static const double transparent = 0.0;
  static const double subtle = 0.05;
  static const double light = 0.15;
  static const double medium = 0.3;
  static const double high = 0.6;
  static const double heavy = 0.8;
  static const double opaque = 1.0;
  
  // Alias semánticos
  static const double disabled = 0.5;
  static const double overlay = 0.4;
  static const double divider = 0.15;
}

/// Definiciones de breakpoints para diseño responsivo
class AppBreakpoints {
  static const double mobile = 0;
  static const double tablet = 600;
  static const double desktop = 1024;
  static const double largeDesktop = 1440;
}
