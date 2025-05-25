// lib/core/di/modules/core_module.dart

import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:quien_para/core/di/modules/di_module.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../core/network/network_helper.dart';

/// Módulo para registrar los servicios básicos y fundamentales de la aplicación
///
/// Este módulo se encarga de registrar:
/// - Servicios de Firebase (Auth, Firestore, Storage, Messaging)
/// - SharedPreferences
/// - FlutterLocalNotificationsPlugin
/// - NetworkHelper
class CoreModule implements DIModule {
  static final CoreModule _instance = CoreModule._internal();
  factory CoreModule() => _instance;
  CoreModule._internal();

  /// Registra todas las dependencias básicas en el contenedor DI
  @override
  Future<void> register(GetIt sl) async {
    if (kDebugMode) {
      print('📦 Registrando módulo Core');
    }

    // Shared Preferences
    if (!sl.isRegistered<SharedPreferences>()) {
      final sharedPreferences = await SharedPreferences.getInstance();
      sl.registerLazySingleton(() => sharedPreferences);
    }

    // Firebase Services
    _registerFirebaseServices(sl);

    // Network Helper
    if (!sl.isRegistered<NetworkHelper>()) {
      sl.registerLazySingleton(() => NetworkHelper());
    }
  }

  /// Registra los servicios de Firebase con opciones optimizadas
  void _registerFirebaseServices(GetIt sl) {
    try {
      // Firebase Firestore
      if (!sl.isRegistered<FirebaseFirestore>()) {
        final firestore = FirebaseFirestore.instance;

        // Configurar opciones de persistencia y caché
        firestore.settings = const Settings(
          persistenceEnabled: true,
          cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        );

        sl.registerLazySingleton(() => firestore);
      }

      // Firebase Storage
      // Firebase Storage
      if (!sl.isRegistered<FirebaseStorage>()) {
        sl.registerLazySingleton(() => FirebaseStorage.instance);
      }

      // Firebase Auth
      if (!sl.isRegistered<FirebaseAuth>()) {
        sl.registerLazySingleton(() => FirebaseAuth.instance);
      }

      // Firebase Messaging
      if (!sl.isRegistered<FirebaseMessaging>()) {
        final messaging = FirebaseMessaging.instance;
        sl.registerLazySingleton(() => messaging);
      }

      // Flutter Local Notifications
      if (!sl.isRegistered<FlutterLocalNotificationsPlugin>()) {
        final notificationsPlugin = FlutterLocalNotificationsPlugin();

        const initializationSettings = InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
        );

        notificationsPlugin.initialize(initializationSettings);
        sl.registerLazySingleton(() => notificationsPlugin);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error al registrar servicios de Firebase: $e');
      }
      rethrow;
    }
  }

  @override
  Future<void> dispose(GetIt container) async {
    if (kDebugMode) {
      print('🗑 Liberando recursos del módulo Core');
    }

    // No necesitamos liberar Firestore, Auth o Storage ya que son servicios singleton de Firebase
    // y su ciclo de vida está manejado por Firebase

    // Para NetworkHelper, podemos hacer alguna limpieza si es necesario
    if (container.isRegistered<NetworkHelper>()) {
      // Obtener NetworkHelper directamente sin asignar a una variable
      container<NetworkHelper>();
      // No hay método dispose() en NetworkHelper
    }

    // Aquí se pueden agregar más recursos que necesiten ser liberados

    if (kDebugMode) {
      print('✅ Recursos del módulo Core liberados exitosamente');
    }
  }

  @override
  Future<void> registerTestDependencies(GetIt container) async {
    if (kDebugMode) {
      print('📣 Registrando dependencias de prueba para módulo Core');
    }

    // Implementar mocks para pruebas
    // Shared Preferences (usar una implementación en memoria para pruebas)
    if (!container.isRegistered<SharedPreferences>()) {
      // Usar un mock o implementación para pruebas de SharedPreferences
      // Para pruebas reales, podríamos usar una librería como mockito
      container.registerLazySingleton<SharedPreferences>(() {
        // En un entorno real de pruebas, crearías un mock usando mockito o similar
        throw UnimplementedError(
            'Para pruebas, debes proporcionar un mock de SharedPreferences');
      });
    }

    // Firebase Firestore (mock)
    if (!container.isRegistered<FirebaseFirestore>()) {
      container.registerLazySingleton<FirebaseFirestore>(() {
        // En un entorno real de pruebas, crearías un mock usando mockito o similar
        throw UnimplementedError(
            'Para pruebas, debes proporcionar un mock de FirebaseFirestore');
      });
    }

    // Firebase Storage (mock)
    if (!container.isRegistered<FirebaseStorage>()) {
      container.registerLazySingleton<FirebaseStorage>(() {
        // En un entorno real de pruebas, crearías un mock usando mockito o similar
        throw UnimplementedError(
            'Para pruebas, debes proporcionar un mock de FirebaseStorage');
      });
    }

    // Firebase Auth (mock)
    if (!container.isRegistered<FirebaseAuth>()) {
      container.registerLazySingleton<FirebaseAuth>(() {
        // En un entorno real de pruebas, crearías un mock usando mockito o similar
        throw UnimplementedError(
            'Para pruebas, debes proporcionar un mock de FirebaseAuth');
      });
    }

    // Network Helper (mock o implementación para pruebas)
    if (!container.isRegistered<NetworkHelper>()) {
      container.registerLazySingleton<NetworkHelper>(() {
        // Implementación para pruebas, ajusta según el constructor real de NetworkHelper
        return NetworkHelper();
      });
    }

    if (kDebugMode) {
      print(
          '✅ Dependencias de prueba para módulo Core registradas exitosamente');
    }
  }
}
