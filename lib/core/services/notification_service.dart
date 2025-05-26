// lib/core/services/notification_service_consolidated.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quien_para/domain/entities/notification/notification_entity.dart';
import 'package:quien_para/domain/interfaces/notification_service_interface.dart';

/// Implementación consolidada del servicio de notificaciones
///
/// Esta implementación combina la simplicidad del stub con la estructura
/// de la implementación real. Es suficientemente completa para satisfacer
/// las necesidades de la aplicación sin introducir complejidad innecesaria.
class NotificationService implements NotificationServiceInterface {
  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  // Lista de listeners para las notificaciones
  final List<Function(NotificationEntity)> _listeners = [];

  // Plugin para notificaciones locales
  FlutterLocalNotificationsPlugin? _localNotifications;

  // Stream controller para notificaciones recibidas
  final StreamController<Map<String, dynamic>> _notificationStreamController =
      StreamController<Map<String, dynamic>>.broadcast();

  // Cache para el token FCM
  String? _cachedFcmToken;
  bool _isInitialized = false;

  // Constructor normal para usar instancias reales
  NotificationService({
    FirebaseMessaging? messaging,
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) : _messaging = messaging ?? FirebaseMessaging.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance {
    if (kDebugMode) {
      print('📱 NotificationService: Inicializado con implementación completa');
    }
  }

  /// Constructor factory para crear una versión stub del servicio
  ///
  /// Esta versión no realiza operaciones reales, solo simula el comportamiento
  /// para propósitos de testing o cuando las funcionalidades no están disponibles.
  factory NotificationService.stub() {
    return NotificationService(messaging: null, firestore: null, auth: null)
      .._isStubMode = true;
  }

  bool _isStubMode = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) {
      if (kDebugMode) {
        print('📱 NotificationService: Ya inicializado');
      }
      return;
    }

    if (_isStubMode) {
      if (kDebugMode) {
        print('📱 NotificationService: Inicialización simulada (modo stub)');
      }
      _isInitialized = true;
      return;
    }

    try {
      if (kDebugMode) {
        print('📱 NotificationService: Iniciando inicialización');
      }

      // 1. Inicializar notificaciones locales
      await _initLocalNotifications();

      // 2. Solicitar permisos
      await requestNotificationPermissions();

      // 3. Configurar handlers para mensajes
      await setupNotificationHandlers();

      _isInitialized = true;
      if (kDebugMode) {
        print('📱 NotificationService: Inicialización completa');
      }
    } catch (e) {
      if (kDebugMode) {
        print('📱 NotificationService: Error en inicialización: $e');
      }
      rethrow;
    }
  }

  Future<void> _initLocalNotifications() async {
    if (_isStubMode) return;

    try {
      _localNotifications = FlutterLocalNotificationsPlugin();

      // Configuración para Android
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // Configuración para iOS
      final DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      // Configuración unificada
      final InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
          );

      // Inicializar el plugin
      await _localNotifications!.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      if (kDebugMode) {
        print('📱 NotificationService: Notificaciones locales inicializadas');
      }
    } catch (e) {
      if (kDebugMode) {
        print(
          '📱 NotificationService: Error inicializando notificaciones locales: $e',
        );
      }
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print(
        '📱 NotificationService: Notificación tocada con payload: ${response.payload}',
      );
    }

    // Emitir evento en el stream para que la app pueda manejarlo
    _notificationStreamController.add({
      'type': 'notification_tapped',
      'payload': response.payload,
    });
  }

  @override
  Future<bool> requestNotificationPermissions() async {
    if (_isStubMode) return true;

    try {
      final NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      final bool granted =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;

      if (kDebugMode) {
        print(
          '📱 NotificationService: Permisos ${granted ? "concedidos" : "denegados"}',
        );
      }

      return granted;
    } catch (e) {
      if (kDebugMode) {
        print('📱 NotificationService: Error solicitando permisos: $e');
      }
      return false;
    }
  }

  @override
  Future<void> setupNotificationHandlers() async {
    if (_isStubMode) return;

    try {
      // Mensaje recibido cuando la app está en primer plano
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          print('📱 NotificationService: Mensaje recibido en primer plano');
        }

        // Mostrar notificación local
        _showNotificationFromMessage(message);

        // Emitir al stream
        _notificationStreamController.add({
          'title': message.notification?.title,
          'body': message.notification?.body,
          'data': message.data,
        });
      });

      // Cuando la app está en segundo plano y se toca la notificación
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (kDebugMode) {
          print('📱 NotificationService: App abierta desde notificación');
        }

        // Emitir al stream
        _notificationStreamController.add({
          'type': 'notification_opened_app',
          'title': message.notification?.title,
          'body': message.notification?.body,
          'data': message.data,
        });
      });

      // Verificar si la app fue abierta desde una notificación mientras estaba cerrada
      final RemoteMessage? initialMessage = await _messaging
          .getInitialMessage();
      if (initialMessage != null) {
        if (kDebugMode) {
          print(
            '📱 NotificationService: App abierta desde notificación inicial',
          );
        }

        // Emitir al stream
        _notificationStreamController.add({
          'type': 'notification_initial',
          'title': initialMessage.notification?.title,
          'body': initialMessage.notification?.body,
          'data': initialMessage.data,
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('📱 NotificationService: Error configurando handlers: $e');
      }
    }
  }

  Future<void> _showNotificationFromMessage(RemoteMessage message) async {
    if (_localNotifications == null || message.notification == null) return;

    try {
      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'quien_para_channel',
            'Notificaciones Quién Para',
            channelDescription: 'Notificaciones de la app Quién Para',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
          );

      final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications!.show(
        message.hashCode,
        message.notification!.title,
        message.notification!.body,
        platformDetails,
        payload: message.data.toString(),
      );
    } catch (e) {
      if (kDebugMode) {
        print('📱 NotificationService: Error mostrando notificación local: $e');
      }
    }
  }

  @override
  Future<String?> getToken() async {
    if (_isStubMode) return 'stub-fcm-token-example';

    try {
      if (_cachedFcmToken != null) {
        return _cachedFcmToken;
      }

      _cachedFcmToken = await _messaging.getToken();

      if (_cachedFcmToken != null) {
        // Guardar token en Firestore si hay usuario autenticado
        final User? currentUser = _auth.currentUser;
        if (currentUser != null) {
          await _firestore.collection('users').doc(currentUser.uid).update({
            'fcmToken': _cachedFcmToken,
            'tokenUpdatedAt': FieldValue.serverTimestamp(),
          });
        }
      }

      return _cachedFcmToken;
    } catch (e) {
      if (kDebugMode) {
        print('📱 NotificationService: Error obteniendo token FCM: $e');
      }
      return null;
    }
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    if (_isStubMode) return;

    try {
      await _messaging.subscribeToTopic(topic);
      if (kDebugMode) {
        print('📱 NotificationService: Suscrito a tema: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('📱 NotificationService: Error suscribiendo a tema: $e');
      }
    }
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    if (_isStubMode) return;

    try {
      await _messaging.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        print('📱 NotificationService: Desuscrito de tema: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('📱 NotificationService: Error desuscribiendo de tema: $e');
      }
    }
  }

  @override
  Future<void> sendNotification(NotificationEntity notification) async {
    if (_isStubMode) {
      if (kDebugMode) {
        print(
          '📱 NotificationService: Simulando envío de notificación: ${notification.title} (modo stub)',
        );
      }
      return;
    }

    try {
      // Guardar la notificación en Firestore
      final docRef = await _firestore.collection('notifications').add({
        ...notification.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Obtener el token FCM del usuario destinatario
      final userDoc = await _firestore
          .collection('users')
          .doc(notification.userId)
          .get();
      final String? fcmToken = userDoc.data()?['fcmToken'] as String?;

      if (fcmToken != null) {
        // Guardar en la cola de mensajes para ser procesada por una Cloud Function
        await _firestore.collection('messaging_queue').add({
          'token': fcmToken,
          'notification': {
            'title': notification.title,
            'body': notification.message,
          },
          'data': {
            'type': notification.type,
            'notificationId': docRef.id,
            'planId': notification.planId ?? '',
            'applicationId': notification.applicationId ?? '',
            ...?notification.data,
          },
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (kDebugMode) {
          print('📱 NotificationService: Notificación encolada para enviar');
        }
      } else {
        if (kDebugMode) {
          print(
            '📱 NotificationService: Token FCM no encontrado para el usuario',
          );
        }
      }

      // También, mostrar una notificación local si está en la aplicación
      await showLocalNotification(
        title: notification.title,
        body: notification.message,
        payload: notification.data,
      );
    } catch (e) {
      if (kDebugMode) {
        print('📱 NotificationService: Error enviando notificación: $e');
      }
    }
  }

  @override
  Future<void> sendApplicationNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    // Crear una entidad de notificación
    final notification = NotificationEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      title: title,
      message: body,
      type: 'application_notification',
      data: data,
      createdAt: DateTime.now(),
      read: false,
    );

    // Usar el método genérico para enviar la notificación
    await sendNotification(notification);
  }

  @override
  Future<void> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    if (_isStubMode || _localNotifications == null) {
      if (kDebugMode) {
        print(
          '📱 NotificationService: Simulando mostrar notificación local: $title (modo stub)',
        );
      }
      return;
    }

    try {
      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'quien_para_channel',
            'Notificaciones Quién Para',
            channelDescription: 'Notificaciones de la app Quién Para',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
          );

      final DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications!.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        platformDetails,
        payload: payload?.toString(),
      );

      if (kDebugMode) {
        print('📱 NotificationService: Notificación local mostrada: $title');
      }
    } catch (e) {
      if (kDebugMode) {
        print('📱 NotificationService: Error mostrando notificación local: $e');
      }
    }
  }

  @override
  Future<void> cancelNotification(String notificationId) async {
    if (_isStubMode || _localNotifications == null) return;

    try {
      await _localNotifications!.cancel(int.parse(notificationId));
      if (kDebugMode) {
        print(
          '📱 NotificationService: Notificación cancelada: $notificationId',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('📱 NotificationService: Error cancelando notificación: $e');
      }
    }
  }

  @override
  Future<void> cancelAllNotifications() async {
    if (_isStubMode || _localNotifications == null) return;

    try {
      await _localNotifications!.cancelAll();
      if (kDebugMode) {
        print('📱 NotificationService: Todas las notificaciones canceladas');
      }
    } catch (e) {
      if (kDebugMode) {
        print(
          '📱 NotificationService: Error cancelando todas las notificaciones: $e',
        );
      }
    }
  }

  @override
  void registerNotificationListener(Function(NotificationEntity) listener) {
    _listeners.add(listener);
    if (kDebugMode) {
      print('📱 NotificationService: Listener registrado');
    }
  }

  @override
  void removeNotificationListener(Function(NotificationEntity) listener) {
    _listeners.remove(listener);
    if (kDebugMode) {
      print('📱 NotificationService: Listener eliminado');
    }
  }

  @override
  Future<void> scheduleLocalNotification({
    required String id,
    required String title,
    required String body,
    DateTime? scheduledTime,
  }) async {
    if (_isStubMode || _localNotifications == null) {
      if (kDebugMode) {
        print(
          '📱 NotificationService: Simulando programación de notificación (modo stub)',
        );
      }
      return;
    }

    try {
      final androidDetails = AndroidNotificationDetails(
        'quien_para_channel',
        'Notificaciones Quién Para',
        channelDescription: 'Notificaciones de la app Quién Para',
        importance: Importance.max,
        priority: Priority.high,
      );

      final iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      if (scheduledTime != null) {
        final now = DateTime.now();
        final duration = scheduledTime.difference(now);

        if (duration.isNegative) {
          // El tiempo ya pasó, mostrar inmediatamente
          await _localNotifications!.show(
            int.parse(id),
            title,
            body,
            platformDetails,
          );
        } else {
          // Usar Future.delayed para simular programación
          Future.delayed(duration, () async {
            await _localNotifications!.show(
              int.parse(id),
              title,
              body,
              platformDetails,
            );
            if (kDebugMode) {
              print('📱 NotificationService: Notificación programada mostrada');
            }
          });
        }
      } else {
        // Mostrar inmediatamente
        await _localNotifications!.show(
          int.parse(id),
          title,
          body,
          platformDetails,
        );
      }

      if (kDebugMode) {
        print('📱 NotificationService: Notificación programada correctamente');
      }
    } catch (e) {
      if (kDebugMode) {
        print('📱 NotificationService: Error programando notificación: $e');
      }
    }
  }

  @override
  Future<bool> areNotificationsEnabled() async {
    if (_isStubMode) return true;

    try {
      final settings = await _messaging.getNotificationSettings();
      final bool enabled =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;

      return enabled;
    } catch (e) {
      if (kDebugMode) {
        print(
          '📱 NotificationService: Error verificando estado de notificaciones: $e',
        );
      }
      return false;
    }
  }

  @override
  void dispose() {
    _notificationStreamController.close();
    _listeners.clear();

    if (kDebugMode) {
      print('📱 NotificationService: Recursos liberados');
    }
  }

  @override
  Stream<Map<String, dynamic>> get onNotificationReceived =>
      _notificationStreamController.stream;
}
