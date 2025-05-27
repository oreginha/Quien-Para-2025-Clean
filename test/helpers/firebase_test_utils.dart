// ignore_for_file: always_specify_types, unused_import

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';

/// Clase de utilidad para configurar mocks de Firebase en pruebas
class FirebaseTestUtils {
  /// Configura los mocks necesarios para Firebase Core
  static void setupFirebaseCoreMocks() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Registrar el mock de la plataforma Firebase
    final List<MethodCall> methodCalls = <MethodCall>[];

    // Configurar el mock para Firebase
    const MethodChannel channel = MethodChannel(
      'plugins.flutter.io/firebase_core',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      methodCalls.add(methodCall);
      switch (methodCall.method) {
        case 'Firebase#initializeApp':
          return {
            'name': '[DEFAULT]',
            'options': {
              'apiKey': 'test-api-key',
              'appId': 'test-app-id',
              'messagingSenderId': 'test-messaging-sender-id',
              'projectId': 'test-project-id',
            },
          };
        case 'Firebase#options':
          return {
            'apiKey': 'test-api-key',
            'appId': 'test-app-id',
            'messagingSenderId': 'test-messaging-sender-id',
            'projectId': 'test-project-id',
          };
        default:
          return null;
      }
    });

    // Configurar la implementación de la plataforma Firebase
    TestFirebaseCoreHostApi.setup();
  }

  /// Inicializa Firebase para pruebas
  static Future<void> initializeFirebase() async {
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
  }
}

/// Clase para configurar la API de host de Firebase Core
class TestFirebaseCoreHostApi extends FirebasePlatform {
  static void setup() {
    FirebasePlatform.instance = TestFirebaseCoreHostApi();
  }

  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    return TestFirebaseAppPlatform(
      this,
      name,
      const FirebaseOptions(
        apiKey: 'test-api-key',
        appId: 'test-app-id',
        messagingSenderId: 'test-messaging-sender-id',
        projectId: 'test-project-id',
      ),
    );
  }

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return TestFirebaseAppPlatform(
      this,
      name ?? defaultFirebaseAppName,
      options ??
          const FirebaseOptions(
            apiKey: 'test-api-key',
            appId: 'test-app-id',
            messagingSenderId: 'test-messaging-sender-id',
            projectId: 'test-project-id',
          ),
    );
  }

  @override
  List<FirebaseAppPlatform> get apps => <FirebaseAppPlatform>[];
}

/// Implementación de prueba de FirebaseAppPlatform
class TestFirebaseAppPlatform extends FirebaseAppPlatform {
  TestFirebaseAppPlatform(FirebasePlatform delegate, super.name, super.options);
}
