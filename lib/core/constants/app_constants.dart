// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';

// lib/core/constants/app_constants.dart

class AppConstants {
  static const String appName = 'Quien para?';

  // Rutas de assets
  static const String logoPath = 'assets/images/logo.png';
  static const String logoFullPath = 'assets/images/logo_full.png';
  static const String backgroundPath = 'assets/images/background.png';

  // Duración de animaciones
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Keys para almacenamiento
  static const String userDataKey = 'userData';
  static const String authTokenKey = 'authToken';
  static const String refreshTokenKey = 'refreshToken';

  // URLs de API
  static const String baseApiUrl = 'https://api.planingapp.com/';
  static const String termsUrl = 'https://planingapp.com/terms';
  static const String privacyUrl = 'https://planingapp.com/privacy';
  static const String supportUrl = 'https://planingapp.com/support';

  // Mensajes comunes
  static const String networkErrorMessage =
      'No se pudo conectar con el servidor. Verifica tu conexión a internet.';
  static const String genericErrorMessage =
      'Ocurrió un error inesperado. Por favor, intenta nuevamente.';
  static const String sessionExpiredMessage =
      'Tu sesión ha expirado. Por favor, inicia sesión nuevamente.';

  // Dimensiones
  static const double buttonHeight = 50.0;
  static const double inputHeight = 50.0;
  static const double cardElevation = 4.0;
  static const double headerHeight = 60.0;
  static const double footerHeight = 70.0;

  // Otros
  static const int maxEventTitleLength = 50;
  static const int maxEventDescriptionLength = 500;
  static const int maxLocationLength = 100;
  static const int defaultCacheDuration = 60; // minutos
}

// Colores principales de la aplicación
class AppColors2 {
  static const Color brandYellow = Color(0xFFF39C12); // Azul principal
  static const Color secondaryColor = Color(0xFF2ECC71); // Verde secundario
  static const Color accentColor = Color(
    0xFFF39C12,
  ); // Amarillo/Naranja de acento
  static const Color darkPrimaryBackground = Color(
    0xFFECF0F1,
  ); // Gris claro de fondo
  static const Color textColor = Color(0xFF2C3E50); // Texto oscuro
  static const Color accentRed = Color(0xFFE74C3C); // Rojo para errores
  static const Color accentGreen = Color(0xFF27AE60); // Verde para éxitos
  static const Color disabledColor = Color(
    0xFFBDC3C7,
  ); // Gris para deshabilitado
  static const Color whiteColor = Colors.white; // Blanco
  static const Color blackColor = Colors.black; // Negro
}

// Tamaños de fuentes predefinidos
class AppTypographyizes {
  static const double small = 12.0;
  static const double medium = 16.0;
  static const double large = 20.0;
  static const double xlarge = 24.0;
  static const double heading = 32.0;
}

// Espaciado (paddings, margins) predefinidos
class AppSpacing {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double xlarge = 32.0;
}

// Border radius predefinidos
class AppBorderRadius {
  static const BorderRadius small = BorderRadius.all(Radius.circular(4.0));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius large = BorderRadius.all(Radius.circular(12.0));
}

// Estilos de texto predefinidos
class AppTextStyles {
  static const TextStyle regular = TextStyle(
    fontSize: AppTypographyizes.medium,
    color: AppColors2.textColor,
  );

  static const TextStyle bold = TextStyle(
    fontSize: AppTypographyizes.medium,
    color: AppColors2.textColor,
    fontWeight: FontWeight.bold,
  );

  static TextStyle title = const TextStyle(
    fontSize: AppTypographyizes.large,
    color: AppColors2.textColor,
    fontWeight: FontWeight.bold,
  );

  static TextStyle heading = const TextStyle(
    fontSize: AppTypographyizes.heading,
    color: AppColors2.textColor,
    fontWeight: FontWeight.bold,
  );

  static TextStyle error = const TextStyle(
    fontSize: AppTypographyizes.medium,
    color: AppColors2.accentRed,
  );

  static TextStyle success = const TextStyle(
    fontSize: AppTypographyizes.medium,
    color: AppColors2.accentGreen,
  );
}

// Duraciones de animaciones predefinidas
class AppDurations {
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration long = Duration(milliseconds: 600);
}

// Constantes numéricas generales
class AppNumbers {
  static const double iconSize = 24.0;
  static const double imageRadius = 50.0;
  static const int defaultListLimit = 20;
}

class PlanType {
  static const Map<String, Map<String, dynamic>> planTypes = {
    'Recitales': {
      'emoji': '🎸',
      'firestoreCategories': [
        'musica',
        'Música',
        'Música internacional',
        'música',
      ],
    },
    'Deportes': {
      'emoji': '🏟️',
      'firestoreCategories': ['deportes', 'Deportes'],
    },
    'Teatro': {
      'emoji': '🎭',
      'firestoreCategories': ['teatro', 'Teatro'],
    },
    'Cine': {
      'emoji': '🎬',
      'firestoreCategories': ['cine', 'Cine'],
    },
    'Eventos Sociales': {
      'emoji': '👥',
      'firestoreCategories': ['social', 'Social'],
    },
    'Restaurantes': {
      'emoji': '🍽️',
      'firestoreCategories': ['restaurantes', 'Restaurantes'],
    },
    'Infantiles': {
      'emoji': '🎪',
      'firestoreCategories': ['infantiles', 'Infantiles'],
    },
    'Festivales': {
      'emoji': '🎉',
      'firestoreCategories': ['festivales', 'Festivales'],
    },
  };
}
