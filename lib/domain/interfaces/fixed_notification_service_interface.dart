// lib/domain/interfaces/fixed_notification_service_interface.dart
// Interfaz corregida para el servicio de notificaciones

import 'package:quien_para/domain/entities/notification/notification_entity.dart';

/// Interfaz corregida para el servicio de notificaciones con firmas de métodos adecuadas
abstract class NotificationServiceInterface {
  /// Inicializar el servicio de notificaciones
  Future<void> initialize();

  /// Obtener el token FCM para notificaciones push
  Future<String?> getToken();

  /// Suscribirse a un tema de notificaciones
  Future<void> subscribeToTopic(String topic);

  /// Anular suscripción a un tema de notificaciones
  Future<void> unsubscribeFromTopic(String topic);

  /// Liberar recursos del servicio
  void dispose();

  /// Stream para recibir notificaciones
  Stream<Map<String, dynamic>> get onNotificationReceived;

  /// Mostrar una notificación local en el dispositivo
  Future<void> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  });

  /// Enviar una notificación
  Future<void> sendNotification(NotificationEntity notification);

  /// Configurar manejadores de notificaciones
  Future<void> setupNotificationHandlers();

  /// Solicitar permisos de notificación
  Future<bool> requestNotificationPermissions();

  /// Cancelar una notificación específica
  Future<void> cancelNotification(String notificationId);

  /// Cancelar todas las notificaciones
  Future<void> cancelAllNotifications();

  /// Enviar notificación de aplicación específica
  Future<void> sendApplicationNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  });

  /// Registrar un listener para notificaciones
  void registerNotificationListener(Function(NotificationEntity) listener);

  /// Remover un listener de notificaciones
  void removeNotificationListener(Function(NotificationEntity) listener);

  /// Programar una notificación local
  Future<void> scheduleLocalNotification({
    required String id,
    required String title,
    required String body,
    DateTime? scheduledTime,
  });

  /// Verificar si las notificaciones están habilitadas
  Future<bool> areNotificationsEnabled();
}
