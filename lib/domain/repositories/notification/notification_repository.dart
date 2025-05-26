// lib/domain/repositories/notification_repository.dart

import 'package:dartz/dartz.dart';
import 'package:quien_para/domain/entities/notification/notification_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/repository_base.dart';

/// Repositorio para la gestión de notificaciones
abstract class NotificationRepository
    extends RepositoryBase<NotificationEntity> {
  /// Obtiene las notificaciones de un usuario
  Future<Either<AppFailure, List<NotificationEntity>>> getNotificationsForUser(
    String userId, {
    int? limit,
    bool includeRead = false,
  });

  /// Obtiene la cantidad de notificaciones sin leer
  Future<Either<AppFailure, int>> getUnreadCount(String userId);

  /// Marca una notificación como leída
  Future<Either<AppFailure, NotificationEntity>> markAsRead(
    String notificationId,
  );

  /// Marca todas las notificaciones de un usuario como leídas
  Future<Either<AppFailure, Unit>> markAllAsRead(String userId);

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

  /// Obtiene el token de notificaciones
  Future<String?> getToken();

  /// Obtiene el stream de notificaciones recibidas
  Stream<Map<String, dynamic>> get onNotificationReceived;

  /// Muestra una notificación local
  Future<Either<AppFailure, Unit>> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  });

  /// Se suscribe a un topic
  Future<Either<AppFailure, Unit>> subscribeToTopic(String topic);
}
