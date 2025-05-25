import 'package:quien_para/core/di/modules/di_module.dart';

import '../../services/empty_notification_service.dart';

// lib/core/di/modules/service_module.dart

import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quien_para/core/services/google_sign_in_fix.dart'; // Importamos el servicio correctivo
import 'package:quien_para/domain/repositories/auth/auth_repository.dart';
import 'package:quien_para/domain/entities/user/user_entity.dart';
import '../../../domain/interfaces/firestore_interface.dart';
import '../../../domain/interfaces/notification_service_interface.dart';
import '../../../domain/interfaces/image_service_interface.dart';
import '../../../domain/interfaces/chat_repository_interface.dart';
import '../../services/firestore_service.dart';
import '../../services/notification_service.dart';
import '../../services/fcm_token_service.dart';
import '../../services/unread_messages_service.dart';
import '../../services/image_service_factory.dart';
import '../../../core/theme/provider/theme_provider.dart';

/// Módulo para registrar los servicios de la aplicación
///
/// Este módulo registra todas las implementaciones de servicios:
/// - AuthRepository
/// - FirestoreService
/// - NotificationService
/// - FcmTokenService
/// - ChatService
/// - UnreadMessagesService
/// - ImageService
/// - ThemeProvider
/// - GoogleSignInService
class ServiceModule implements DIModule {
  static final ServiceModule _instance = ServiceModule._internal();
  factory ServiceModule() => _instance;
  ServiceModule._internal();

  /// Método privado para registrar de forma segura el servicio de notificaciones
  Future<void> _registerNotificationServiceSafely(GetIt sl) async {
    try {
      if (kDebugMode) {
        print('📱 Registrando servicio de notificaciones...');
      }

      // Si ya está registrado, no hacer nada
      if (sl.isRegistered<NotificationServiceInterface>()) {
        if (kDebugMode) {
          print('ℹ️ Servicio de notificaciones ya registrado');
        }
        return;
      }

      // En web, usar el servicio vacío
      if (kIsWeb) {
        sl.registerLazySingleton<NotificationServiceInterface>(
          () => EmptyNotificationService(),
        );
        if (kDebugMode) {
          print('ℹ️ Usando servicio de notificaciones vacío para web');
        }
        return;
      }

      // En móvil, registrar el servicio completo e inicializarlo
      try {
        final notificationService = NotificationService();
        // Intentar inicializar el servicio antes de registrarlo
        await notificationService.initialize().timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            throw TimeoutException(
                'Tiempo de espera agotado al inicializar NotificationService');
          },
        );

        // Si la inicialización fue exitosa, registrar el servicio
        sl.registerLazySingleton<NotificationServiceInterface>(
          () => notificationService,
        );

        if (kDebugMode) {
          print(
              '✅ Servicio de notificaciones registrado e inicializado correctamente');
        }
      } catch (e) {
        // Si falla la inicialización, registrar el servicio vacío como fallback
        if (kDebugMode) {
          print('⚠️ Error al inicializar NotificationService: $e');
          print('ℹ️ Usando servicio de notificaciones vacío como fallback');
        }
        sl.registerLazySingleton<NotificationServiceInterface>(
          () => EmptyNotificationService(),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error crítico al registrar el servicio de notificaciones: $e');
      }
      // En caso de error crítico, asegurar que siempre haya un servicio disponible
      if (!sl.isRegistered<NotificationServiceInterface>()) {
        sl.registerLazySingleton<NotificationServiceInterface>(
          () => EmptyNotificationService(),
        );
      }
    }
  }

  /// Registra el servicio FCM Token de forma segura
  Future<void> _registerFcmTokenServiceSafely(GetIt sl) async {
    try {
      if (kDebugMode) {
        print('🔑 Registrando servicio FCM Token...');
      }

      if (sl.isRegistered<FcmTokenService>()) {
        if (kDebugMode) {
          print('ℹ️ Servicio FCM Token ya registrado');
        }
        return;
      }

      // Verificar que el servicio de notificaciones esté registrado
      if (!sl.isRegistered<NotificationServiceInterface>()) {
        throw StateError(
            'NotificationServiceInterface debe estar registrado antes que FcmTokenService');
      }

      // Registrar el servicio
      sl.registerLazySingleton(
        () => FcmTokenService(sl<NotificationServiceInterface>()),
      );

      if (kDebugMode) {
        print('✅ Servicio FCM Token registrado correctamente');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error al registrar el servicio FCM Token: $e');
      }
    }
  }

  /// Registra el servicio de mensajes no leídos de forma segura
  Future<void> _registerUnreadMessagesServiceSafely(GetIt sl) async {
    try {
      if (kDebugMode) {
        print('📨 Registrando servicio de mensajes no leídos...');
      }

      if (sl.isRegistered<UnreadMessagesService>()) {
        if (kDebugMode) {
          print('ℹ️ Servicio de mensajes no leídos ya registrado');
        }
        return;
      }

      // Verificar dependencias necesarias
      if (!sl.isRegistered<ChatRepository>()) {
        throw StateError(
            'ChatRepository debe estar registrado antes que UnreadMessagesService');
      }

      if (!sl.isRegistered<FirebaseAuth>()) {
        throw StateError(
            'FirebaseAuth debe estar registrado antes que UnreadMessagesService');
      }

      // Registrar el servicio
      sl.registerLazySingleton<UnreadMessagesService>(
        () => UnreadMessagesService(
          sl<ChatRepository>(),
          sl<FirebaseAuth>(),
        ),
      );

      if (kDebugMode) {
        print('✅ Servicio de mensajes no leídos registrado correctamente');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error al registrar el servicio de mensajes no leídos: $e');
      }
    }
  }

  /// Registra todas las implementaciones de servicios en el contenedor DI
  @override
  Future<void> register(GetIt sl) async {
    if (kDebugMode) {
      print('🔧 Registrando módulo de Servicios');
    }

    // Registrar el servicio de GoogleSignIn para evitar el error "Future already completed"
    if (!sl.isRegistered<GoogleSignInService>()) {
      // Inicializamos GoogleSignInService primero
      final GoogleSignInService googleSignService = GoogleSignInService();
      googleSignService
          .initialize(); // Importante: inicializarlo explícitamente

      sl.registerSingleton<GoogleSignInService>(googleSignService);

      if (kDebugMode) {
        print('✅ GoogleSignInService registrado e inicializado');
      }
    }

    // Auth Service
    if (!sl.isRegistered<AuthRepository>()) {
      // Durante la consolidación de interfaces, usamos un adaptador temporal
      sl.registerLazySingleton<AuthRepository>(() {
        // Usamos una implementación interna que delega a FirebaseAuth
        // Esta es una solución temporal hasta completar la migración a Clean Architecture
        return _LegacyAuthRepositoryImpl(
            FirebaseAuth.instance, FirebaseFirestore.instance);
      });
    }

    // Firestore Service
    if (!sl.isRegistered<FirestoreInterface>()) {
      sl.registerLazySingleton<FirestoreInterface>(
        () => FirestoreServiceImpl(sl<FirebaseFirestore>()),
      );
    }

    // Registrar el servicio de notificaciones de forma segura
    await _registerNotificationServiceSafely(sl);

    // Registrar servicios de notificaciones relacionados de forma segura y ordenada
    await _registerFcmTokenServiceSafely(sl);

    // No es necesario registrar ChatService ya que ahora usamos directamente ChatRepository
    // que ya está registrado en el RepositoryModule

    await _registerUnreadMessagesServiceSafely(sl);

    // Image Service
    if (!sl.isRegistered<ImageServiceInterface>()) {
      sl.registerLazySingleton<ImageServiceInterface>(
        () => ImageServiceFactory
            .create(), // Usa el factory para seleccionar la implementación adecuada según la plataforma
      );
    }

    // Theme Provider
    if (!sl.isRegistered<ThemeProvider>()) {
      sl.registerLazySingleton<ThemeProvider>(() => ThemeProvider());
    }
  }

  @override
  Future<void> dispose(GetIt container) async {
    if (kDebugMode) {
      print('📬 Liberando recursos del módulo de servicios');
    }

    // Limpiar servicios si es necesario

    // Desregistrar GoogleSignInService
    if (container.isRegistered<GoogleSignInService>()) {
      await container.unregister<GoogleSignInService>();
    }

    // Desregistrar AuthRepository
    if (container.isRegistered<AuthRepository>()) {
      await container.unregister<AuthRepository>();
    }

    // Desregistrar FirestoreInterface
    if (container.isRegistered<FirestoreInterface>()) {
      await container.unregister<FirestoreInterface>();
    }

    // Desregistrar NotificationServiceInterface
    if (container.isRegistered<NotificationServiceInterface>()) {
      await container.unregister<NotificationServiceInterface>();
    }

    // Desregistrar FcmTokenService
    if (container.isRegistered<FcmTokenService>()) {
      await container.unregister<FcmTokenService>();
    }

    // Desregistrar UnreadMessagesService
    if (container.isRegistered<UnreadMessagesService>()) {
      await container.unregister<UnreadMessagesService>();
    }

    // Desregistrar ImageServiceInterface
    if (container.isRegistered<ImageServiceInterface>()) {
      await container.unregister<ImageServiceInterface>();
    }

    // Desregistrar ThemeProvider
    if (container.isRegistered<ThemeProvider>()) {
      await container.unregister<ThemeProvider>();
    }

    if (kDebugMode) {
      print('✅ Recursos del módulo de servicios liberados correctamente');
    }
  }

  @override
  Future<void> registerTestDependencies(GetIt container) async {
    if (kDebugMode) {
      print(
          '🚨 Registrando dependencias de prueba para el módulo de servicios');
    }

    // Registrar servicios mock para pruebas

    // GoogleSignInService mock (para pruebas)
    if (!container.isRegistered<GoogleSignInService>()) {
      final GoogleSignInService mockGoogleSignService = GoogleSignInService();
      mockGoogleSignService.initialize();
      container.registerSingleton<GoogleSignInService>(mockGoogleSignService);
    }

    // Auth Repository mock (para pruebas)
    if (!container.isRegistered<AuthRepository>()) {
      // Usar la implementación real pero con configuración de prueba
      // o una implementación mock si existiera
      container.registerLazySingleton<AuthRepository>(() {
        return _LegacyAuthRepositoryImpl(
            FirebaseAuth.instance, FirebaseFirestore.instance);
      });
    }

    // Firestore Service mock
    if (!container.isRegistered<FirestoreInterface>()) {
      container.registerLazySingleton<FirestoreInterface>(
        () => FirestoreServiceImpl(container<FirebaseFirestore>()),
      );
    }

    // Notification Service mock (siempre usar el servicio vacío para pruebas)
    if (!container.isRegistered<NotificationServiceInterface>()) {
      container.registerLazySingleton<NotificationServiceInterface>(
        () => EmptyNotificationService(),
      );
    }

    // FCM Token Service mock
    if (!container.isRegistered<FcmTokenService>()) {
      container.registerLazySingleton(
        () => FcmTokenService(container<NotificationServiceInterface>()),
      );
    }

    // Unread Messages Service mock
    if (!container.isRegistered<UnreadMessagesService>()) {
      container.registerLazySingleton<UnreadMessagesService>(
        () => UnreadMessagesService(
          container<ChatRepository>(),
          container<FirebaseAuth>(),
        ),
      );
    }

    // Image Service mock
    if (!container.isRegistered<ImageServiceInterface>()) {
      container.registerLazySingleton<ImageServiceInterface>(
        () => ImageServiceFactory.create(),
      );
    }

    // Theme Provider (usar el real para pruebas)
    if (!container.isRegistered<ThemeProvider>()) {
      container.registerLazySingleton<ThemeProvider>(() => ThemeProvider());
    }

    if (kDebugMode) {
      print(
          '✅ Dependencias de prueba para el módulo de servicios registradas correctamente');
    }
  }
}

/// Implementación temporal de AuthRepository para mantener la compatibilidad
/// durante la migración a Clean Architecture. Esta clase sirve como adaptador
/// hasta que se complete la consolidación de interfaces.
/// Implementación temporal que asegura la compatibilidad durante
/// la consolidación de interfaces, basada en la interfaz AuthRepository
class _LegacyAuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final StreamController<bool> _authStateController =
      StreamController<bool>.broadcast();

  _LegacyAuthRepositoryImpl(this._firebaseAuth, this._firestore) {
    // Suscribirse a cambios de autenticación
    _firebaseAuth.authStateChanges().listen((User? user) {
      _authStateController.add(user != null);
    });
  }

  /// Implementación del nuevo método updateUserData como parte de la consolidación de interfaces
  @override
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    try {
      // Preparar los datos para actualización
      final Map<String, dynamic> updateData = Map.from(data);

      // Agregar timestamp de actualización si no existe
      if (!updateData.containsKey('updatedAt')) {
        updateData['updatedAt'] = FieldValue.serverTimestamp();
      }

      // Realizar la actualización en Firestore
      await _firestore.collection('users').doc(userId).update(updateData);
    } catch (e) {
      throw Exception('Error al actualizar datos de usuario: $e');
    }
  }

  @override
  Stream<bool> get authStateChanges => _authStateController.stream;

  @override
  Future<bool> isAuthenticated() async {
    return _firebaseAuth.currentUser != null;
  }

  @override
  String? getCurrentUserId() {
    return _firebaseAuth.currentUser?.uid;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }

    try {
      final docSnapshot =
          await _firestore.collection('users').doc(user.uid).get();
      if (!docSnapshot.exists) {
        // Si el documento no existe, devolver datos básicos del usuario de Firebase
        return UserEntity(
          id: user.uid,
          name: user.displayName ?? 'Usuario',
          photoUrl: user.photoURL,
        );
      }

      // Si el documento existe, construir desde los datos de Firestore
      final data = docSnapshot.data()!;
      return UserEntity(
        id: user.uid,
        name: data['name'] ?? user.displayName ?? 'Usuario',
        photoUrl: data['photoUrl'] ?? user.photoURL,
      );
    } catch (e) {
      // En caso de error, usar los datos básicos de Firebase
      return UserEntity(
        id: user.uid,
        name: user.displayName ?? 'Usuario',
        photoUrl: user.photoURL,
      );
    }
  }

  @override
  Future<UserEntity?> getUserById(String userId) async {
    try {
      final docSnapshot =
          await _firestore.collection('users').doc(userId).get();
      if (!docSnapshot.exists) {
        return null;
      }

      final data = docSnapshot.data()!;
      return UserEntity(
        id: userId,
        name: data['name'] ?? 'Usuario',
        photoUrl: data['photoUrl'],
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    try {
      await _firestore.collection('users').doc(user.id).update({
        'name': user.name,
        'photoUrl': user.photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Si el documento no existe, crearlo
      await _firestore.collection('users').doc(user.id).set({
        'id': user.id,
        'name': user.name,
        'photoUrl': user.photoUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // Usar GoogleSignInService para evitar el error "Future already completed"
      if (kIsWeb) {
        if (kDebugMode) {
          print('📱 Usando GoogleSignInService para iniciar sesión en Web');
        }

        // Obtener la instancia del servicio correctivo
        final googleSignInService = GetIt.instance<GoogleSignInService>();

        // Iniciar sesión con Google
        final googleSignInAccount = await googleSignInService.signIn();

        if (googleSignInAccount == null) {
          throw Exception('Inicio de sesión cancelado por el usuario');
        }

        // Obtener credenciales de autenticación
        final googleAuth = await googleSignInAccount.authentication;

        // Crear credencial de Firebase
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Iniciar sesión en Firebase
        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          // Crear o actualizar datos del usuario
          await _firestore.collection('users').doc(user.uid).set({
            'id': user.uid,
            'name': user.displayName ?? 'Usuario de Google',
            'photoUrl': user.photoURL,
            'lastLoginAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          // Devolver datos del usuario
          return {
            'id': user.uid,
            'name': user.displayName ?? 'Usuario de Google',
            'photoUrl': user.photoURL,
            'success': true
          };
        } else {
          return {'success': false, 'error': 'No se pudo autenticar'};
        }
      } else {
        // Implementación para dispositivos móviles
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        final userCredential =
            await _firebaseAuth.signInWithPopup(googleProvider);
        final user = userCredential.user;

        if (user != null) {
          // Aseguramos que se devuelve un mapa compatible con la interfaz consolidada
          return {
            'id': user.uid,
            'name': user.displayName ?? 'Usuario de Google',
            'photoUrl': user.photoURL,
            'success': true
          };
        } else {
          return {'success': false, 'error': 'No se pudo autenticar'};
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error en signInWithGoogle: $e');
      }
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _firebaseAuth.currentUser?.delete();
    } catch (e) {
      throw Exception('No se pudo eliminar la cuenta: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final uid = getCurrentUserId();
    if (uid == null) return null;

    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();
      return docSnapshot.data();
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener datos del usuario: ${e.toString()}');
      }
      return null;
    }
  }

  // Los métodos de testing mantienen su implementación base con excepción
  @override
  Future<UserEntity> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        // Verificar si existe un documento en Firestore
        final docSnapshot =
            await _firestore.collection('users').doc(user.uid).get();

        if (docSnapshot.exists) {
          final userData = docSnapshot.data()!;
          return UserEntity(
            id: user.uid,
            name: userData['name'] as String? ?? user.displayName ?? 'Usuario',
            photoUrl: userData['photoUrl'] as String? ?? user.photoURL,
          );
        } else {
          // Si no existe documento, crear un UserEntity básico
          return UserEntity(
            id: user.uid,
            name: user.displayName ?? 'Usuario',
            photoUrl: user.photoURL,
          );
        }
      }

      throw Exception('No se pudo autenticar');
    } catch (e) {
      throw Exception('Error en autenticación: $e');
    }
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        // Actualizar el perfil del usuario con el nombre proporcionado
        await user.updateDisplayName(name);

        // Crear o actualizar el documento del usuario en Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'id': user.uid,
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'photoUrl': user.photoURL,
        });

        // Devolver la entidad de usuario
        return UserEntity(
          id: user.uid,
          name: name,
          photoUrl: user.photoURL,
        );
      }

      throw Exception('No se pudo crear la cuenta');
    } catch (e) {
      throw Exception('Error al crear cuenta: $e');
    }
  }

  // Alias para mantener compatibilidad con código existente
  Future<void> signIn() => signInWithGoogle();

  @override
  Future<void> signOut() => logout();
}
