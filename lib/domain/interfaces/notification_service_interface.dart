import 'package:quien_para/domain/entities/notification/notification_entity.dart';

abstract class NotificationServiceInterface {
  Future<void> initialize();
  Future<String?> getToken();
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
  void dispose();
  Stream<Map<String, dynamic>> get onNotificationReceived;
  Future<void> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  });

  // CORREGIDO: Añadido tipo de retorno explícito
  Future<void> sendNotification(NotificationEntity notification);

  // Métodos adicionales requeridos por la implementación
  Future<void> setupNotificationHandlers();
  Future<bool> requestNotificationPermissions();
  Future<void> cancelNotification(String notificationId);
  Future<void> cancelAllNotifications();
  Future<void> sendApplicationNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  });
  void registerNotificationListener(Function(NotificationEntity) listener);
  void removeNotificationListener(Function(NotificationEntity) listener);
  Future<void> scheduleLocalNotification({
    required String id,
    required String title,
    required String body,
    DateTime? scheduledTime,
  });
  Future<bool> areNotificationsEnabled();
}
