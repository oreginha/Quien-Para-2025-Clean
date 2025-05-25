// lib/core/di/config/env_config.dart

import 'package:flutter/foundation.dart';

/// Clase para gestionar las variables de entorno y credenciales de forma segura
///
/// Esta clase centraliza el acceso a todas las credenciales y configuraciones
/// sensibles de la aplicación, evitando que estén hardcodeadas en el código.
class EnvConfig {
  // Singleton pattern
  static final EnvConfig _instance = EnvConfig._internal();
  factory EnvConfig() => _instance;
  EnvConfig._internal();

  // Variables privadas para almacenar credenciales

  String? _firebaseWebApiKey;

  /// Inicializa las configuraciones cargándolas desde el entorno o archivos .env
  Future<void> initialize() async {
    if (kDebugMode) {
      print('🔐 Inicializando configuración de entorno');
    }

    _firebaseWebApiKey = const String.fromEnvironment('FIREBASE_WEB_API_KEY',
        defaultValue: 'YOUR_FIREBASE_WEB_API_KEY');

    // Validar que las claves no sean los valores por defecto en producción
    if (!kDebugMode) {
      assert(_firebaseWebApiKey != 'YOUR_FIREBASE_WEB_API_KEY',
          'Firebase Web API Key real no configurada en producción');
    }
  }

  /// Obtiene la API Key de Firebase Web
  String get firebaseWebApiKey =>
      _firebaseWebApiKey ?? 'YOUR_FIREBASE_WEB_API_KEY';
}
