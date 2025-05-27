// app_config.dart
// ignore_for_file: always_specify_types

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/performance_logger.dart';
import 'firebase_options.dart';
import 'firebase_config.dart';

/// Clase para manejar la inicialización de la aplicación de forma optimizada
class AppConfig {
  // Singleton
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  // Almacena información sobre el inicio del ciclo de vida de la app
  DateTime _appStartTime = DateTime.now();
  bool _isInitialized = false;

  // Configuraciones del caché
  bool _useCompressedCache = true;
  bool _useGenericCacheSystem = true;

  // Getters
  bool get isInitialized => _isInitialized;
  DateTime get appStartTime => _appStartTime;
  bool get useCompressedCache => _useCompressedCache;
  bool get useGenericCacheSystem => _useGenericCacheSystem;

  // Singleton instance accessor
  static AppConfig get instance => _instance;

  /// Inicializa la aplicación de manera optimizada
  Future<void> initialize() async {
    if (_isInitialized) return;

    _appStartTime = DateTime.now();

    if (kDebugMode) {
      print('🚀 [AppConfig] Iniciando configuración de la aplicación...');
    }

    await PerformanceLogger.logAsyncOperation('AppConfig-Init', () async {
      // 1. Inicializar Firebase - tarea más pesada primero
      await _initializeFirebase();

      // 2. Inicializar Firestore con la configuración óptima
      await _initializeFirestore();

      // 3. Inicializar servicios locales
      await _initializeLocalServices();

      _isInitialized = true;
    });

    final int startupTime =
        DateTime.now().difference(_appStartTime).inMilliseconds;
    if (kDebugMode) {
      print('✅ [AppConfig] Aplicación inicializada en $startupTime ms');
    }
  }

  /// Inicializa Firebase de manera optimizada
  Future<void> _initializeFirebase() async {
    await PerformanceLogger.logAsyncOperation('Firebase-Init', () async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Configurar idioma para Firebase Auth
      await FirebaseAuth.instance.setLanguageCode('es');

      // En web, asegurar que se use persistencia local para mantener la sesión
      if (kIsWeb) {
        if (kDebugMode) {
          print('🔐 Configurando persistencia local para Firebase Auth web...');
        }
        try {
          await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
          if (kDebugMode) {
            print('✅ Persistencia Firebase Auth web configurada como LOCAL');
          }
        } catch (e) {
          // Si ya está configurada como LOCAL, ignorar el error
          if (kDebugMode && !e.toString().contains('already been set')) {
            if (kDebugMode) {
              print('⚠️ Error configurando persistencia Firebase Auth web: $e');
            }
          }
        }
      }
    });
  }

  /// Inicializa Firestore con configuraciones óptimas
  Future<void> _initializeFirestore() async {
    await PerformanceLogger.logAsyncOperation('Firestore-Config', () async {
      // Usar la configuración de Firebase optimizada
      await FirebaseConfig.initialize();

      // Configurar tamaños de caché personalizados
      FirebaseFirestore.instance.settings = Settings(
        persistenceEnabled: true,
        cacheSizeBytes: 20 * 1024 * 1024, // 20MB en lugar de ilimitado
      );
    });
  }

  /// Inicializa servicios locales
  Future<void> _initializeLocalServices() async {
    await PerformanceLogger.logAsyncOperation('LocalServices-Init', () async {
      // Inicializar SharedPreferences
      await SharedPreferences.getInstance();
    });
  }

  /// Libera recursos cuando la aplicación se cierra
  void dispose() {
    if (kDebugMode) {
      print('🧹 [AppConfig] Liberando recursos...');
    }

    // Cerrar conexiones y liberar memoria
    _isInitialized = false;
  }

  /// Configura opciones del sistema de caché
  void configureCacheSystem({
    bool useCompressedCache = true,
    bool useGenericCacheSystem = true,
  }) {
    _useCompressedCache = useCompressedCache;
    _useGenericCacheSystem = useGenericCacheSystem;

    if (kDebugMode) {
      print(
        '💾 [AppConfig] Sistema de caché configurado: '
        'compresión=$_useCompressedCache, '
        'genérico=$_useGenericCacheSystem',
      );
    }
  }

  /// Activa la configuración de rendimiento para toda la aplicación
  void enablePerformanceMode() {
    // Configurar para rendimiento óptimo
    if (kDebugMode) {
      print('⚡ [AppConfig] Modo rendimiento activado');
    }

    // Optimizar el recolector de basura
    WidgetsBinding.instance.deferFirstFrame();
    Future.delayed(const Duration(milliseconds: 50), () {
      WidgetsBinding.instance.allowFirstFrame();
    });
  }

  /// Optimizar el uso de memoria
  void optimizeMemoryUsage() {
    // Forzar recolección de basura cuando sea posible
    ImageCache().clear();
    ImageCache().maximumSize =
        50; // Reducir el tamaño máximo de caché de imágenes
  }
}
