// lib/domain/interfaces/notification_repository_interface.dart

import 'package:dartz/dartz.dart';
import '../entities/notification/notification_entity.dart';
import '../../domain/failures/app_failures.dart';

/// Interfaz para servicios de notificaciones push y locales
abstract class INotificationRepository {
  /// Inicializa el servicio de notificaciones
  Future<Either<AppFailure, Unit>> initialize();

  /// Obtiene el token FCM actual
  Future<String?> getToken();

  /// Suscribe al usuario a un topic
  Future<Either<AppFailure, Unit>> subscribeToTopic(String topic);

  /// Desuscribe al usuario de un topic
  Future<Either<AppFailure, Unit>> unsubscribeFromTopic(String topic);

  /// Libera recursos del servicio
  void dispose();

  /// Stream de notificaciones recibidas
  Stream<Map<String, dynamic>> get onNotificationReceived;

  /// Muestra una notificación local
  Future<Either<AppFailure, Unit>> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  });

  /// Crea una nueva notificación
  Future<Either<AppFailure, Unit>> createNotification(
    NotificationEntity notification,
  );

  /// Obtiene las notificaciones de un usuario
  Future<Either<AppFailure, List<NotificationEntity>>> getNotificationsForUser(
    String userId, {
    int? limit,
    bool includeRead = false,
  });

  /// Obtiene el conteo de notificaciones sin leer para un usuario
  Future<Either<AppFailure, int>> getUnreadNotificationCount(String userId);

  /// Obtiene notificaciones relacionadas con un plan
  Future<Either<AppFailure, List<NotificationEntity>>> getNotificationsForPlan(
    String planId,
  );

  /// Elimina notificaciones antiguas
  Future<Either<AppFailure, Unit>> cleanupOldNotifications(int olderThanDays);

  /// Obtiene un stream de notificaciones para un usuario
  Stream<Either<AppFailure, List<NotificationEntity>>> getNotificationsStream(
    String userId, {
    bool includeRead = false,
  });

  /// Marca una notificación como leída
  Future<Either<AppFailure, Unit>> markNotificationAsRead(
    String notificationId,
  );

  /// Marca todas las notificaciones como leídas para un usuario
  Future<Either<AppFailure, Unit>> markAllAsRead(String userId);
}
