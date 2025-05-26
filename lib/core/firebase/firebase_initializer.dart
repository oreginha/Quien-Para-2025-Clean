// lib/core/firebase/firebase_initializer.dart
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/config/firebase_options.dart';
import '../utils/performance_logger.dart';

/// Clase optimizada para inicializar Firebase con manejo de errores
class FirebaseInitializer {
  static bool _initialized = false;

  /// Inicializa los servicios básicos de Firebase de forma optimizada
  static Future<void> initializeEssential() async {
    if (_initialized) return;

    try {
      await PerformanceLogger.logAsyncOperation('Firebase-Core-Init', () async {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      });

      // Configurar Firestore con diferentes ajustes según la plataforma
      if (kIsWeb) {
        // Para web, habilitamos persistencia para mantener la sesión
        FirebaseFirestore.instance.settings = const Settings(
          cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
          persistenceEnabled: true, // Habilitar persistencia para web
        );

        // Forzar persistencia de Firebase Auth para web
        // La persistencia ya se habilitó en Settings
        // El equivalente de enablePersistence con synchronizeTabs: true ya no es necesario
        // pues se maneja directamente en la configuración de Settings

        if (kDebugMode) {
          print('✅ Firebase Firestore configurado para web CON persistencia');
        }
      } else {
        // Para dispositivos móviles, usar persistencia completa
        FirebaseFirestore.instance.settings = const Settings(
          persistenceEnabled: true,
          cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        );

        if (kDebugMode) {
          print('✅ Firebase Firestore configurado para móvil CON persistencia');
        }
      }

      // Marcamos como inicializado
      _initialized = true;

      if (kDebugMode) {
        print('✅ Firebase Core inicializado correctamente');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error al inicializar Firebase Core: $e');
      }

      // Reintentar una vez si falló
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        _initialized = true;
        if (kDebugMode) {
          print('✅ Firebase Core inicializado en segundo intento');
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error fatal al inicializar Firebase: $e');
        }
        rethrow; // Esta es una inicialización crítica, propagamos el error
      }
    }
  }

  /// Configura Firebase Messaging con mejor manejo de errores
  static Future<void> initializeMessaging() async {
    if (!_initialized) {
      await initializeEssential();
    }

    try {
      // Configurar el manejo de mensajes en segundo plano
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // Solicitar permisos de notificación
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (kDebugMode) {
        print('✅ Estado de permiso FCM: ${settings.authorizationStatus}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error no crítico al configurar FCM: $e');
      }
      // No propagamos este error ya que FCM no es crítico para el inicio
    }
  }
}

/// Manejador de mensajes en segundo plano independiente
/// Debe ser una función de nivel superior y no puede llamar a initializeApp
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(dynamic message) async {
  // No es necesario inicializar Firebase aquí, ya se inicializó en main()
  if (kDebugMode) {
    print('📨 Mensaje recibido en segundo plano');
  }
}
