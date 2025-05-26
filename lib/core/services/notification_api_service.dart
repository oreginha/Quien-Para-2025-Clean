// lib/core/services/notification_api_service.dart

import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/core/logger/logger.dart';
import 'package:quien_para/domain/entities/notification/notification_entity.dart';

/// Servicio para manejar las operaciones relacionadas con las notificaciones.
///
/// Incluye integración con Firebase Cloud Messaging y operaciones
/// para manejar el envío y recepción de notificaciones.
class NotificationApiService {
  final Logger _logger = logger as Logger;

  /// Instancia de Firebase Messaging
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Instancia de Flutter Local Notifications
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Stream controller para notificaciones recibidas
  final _notificationController =
      StreamController<Map<String, dynamic>>.broadcast();

  /// Stream de notificaciones recibidas
  Stream<Map<String, dynamic>> get onNotificationReceived =>
      _notificationController.stream;

  /// Constructor
  NotificationApiService();

  /// Inicializar el servicio
  Future<void> init() async {
    try {
      // Solicitar permisos
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      _logger.d(
        'Notification permissions status: ${settings.authorizationStatus}',
      );

      // Inicializar notificaciones locales
      const initializationSettingsAndroid = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const initializationSettingsIOS = DarwinInitializationSettings();
      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );
      await _localNotifications.initialize(initializationSettings);

      // Obtener token
      final token = await _messaging.getToken();
      _logger.d('FCM Token: $token');

      // Configurar manejadores de notificaciones
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    } catch (e) {
      _logger.e('Error initializing notification service:', error: e);
    }
  }

  /// Maneja mensajes que llegan mientras la app está en primer plano
  void _handleForegroundMessage(RemoteMessage message) {
    try {
      final notification = Map<String, dynamic>.from(message.data);
      notification['title'] = message.notification?.title;
      notification['body'] = message.notification?.body;

      _notificationController.add(notification);
      showLocalNotification(
        title: message.notification?.title ?? 'Nueva notificación',
        body: message.notification?.body ?? '',
      );
    } catch (e) {
      _logger.e('Error handling foreground message:', error: e);
    }
  }

  /// Maneja cuando se abre una notificación con la app en segundo plano
  void _handleMessageOpenedApp(RemoteMessage message) {
    try {
      final notification = Map<String, dynamic>.from(message.data);
      notification['title'] = message.notification?.title;
      notification['body'] = message.notification?.body;

      _notificationController.add(notification);
    } catch (e) {
      _logger.e('Error handling opened app message:', error: e);
    }
  }

  /// Envía una notificación a un usuario específico
  Future<NotificationEntity> sendNotification(
    NotificationEntity notification,
  ) async {
    try {
      _logger.d('Sending notification to user: ${notification.userId}');

      // En una implementación real, aquí se enviaría una solicitud a un
      // servidor backend para enviar la notificación a través de FCM

      // Simulamos una respuesta exitosa
      return notification.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );
    } catch (e) {
      _logger.e('Error sending notification:', error: e);
      rethrow;
    }
  }

  /// Obtiene el token FCM del dispositivo actual
  Future<String?> getDeviceToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      _logger.e('Error getting device token:', error: e);
      return null;
    }
  }

  /// Suscribe el dispositivo a un topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      _logger.d('Subscribed to topic: $topic');
    } catch (e) {
      _logger.e('Error subscribing to topic:', error: e);
      rethrow;
    }
  }

  /// Desuscribe el dispositivo de un topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      _logger.d('Unsubscribed from topic: $topic');
    } catch (e) {
      _logger.e('Error unsubscribing from topic:', error: e);
      rethrow;
    }
  }

  /// Muestra una notificación local
  Future<void> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'default_channel',
        'Default Channel',
        channelDescription: 'Default notification channel',
        importance: Importance.high,
        priority: Priority.high,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        0, // ID único para la notificación
        title,
        body,
        notificationDetails,
        payload: payload?.toString(),
      );
    } catch (e) {
      _logger.e('Error showing local notification:', error: e);
      rethrow;
    }
  }

  /// Limpia recursos
  void dispose() {
    _notificationController.close();
  }
}
