// lib/domain/repositories/notification_repository_interface.dart

import 'package:dartz/dartz.dart';
import 'package:quien_para/domain/entities/notification/notification_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/repository_base.dart';

/// Interfaz base para repositorio de notificaciones que extiende RepositoryBase
abstract class NotificationRepository
    extends RepositoryBase<NotificationEntity> {
  /// Obtiene las notificaciones de un usuario
  Future<Either<AppFailure, List<NotificationEntity>>> getNotificationsForUser(
    String userId, {
    int? limit,
    bool includeRead = false,
  });

  /// Obtiene la cantidad de notificaciones sin leer
  Future<Either<AppFailure, int>> getUnreadCount(userId);

  /// Marca una notificación como leída
  Future<Either<AppFailure, NotificationEntity>> markAsRead(notificationId);

  /// Marca todas las notificaciones de un usuario como leídas
  Future<Either<AppFailure, Unit>> markAllAsRead(userId);

  /// Obtiene notificaciones relacionadas con un plan
  Future<Either<AppFailure, List<NotificationEntity>>> getNotificationsForPlan(
    planId,
  );

  /// Elimina notificaciones antiguas
  Future<Either<AppFailure, Unit>> cleanupOldNotifications(int olderThanDays);

  /// Obtiene un stream de notificaciones para un usuario
  Stream<Either<AppFailure, List<NotificationEntity>>> getNotificationsStream(
    String userId, {
    bool includeRead = false,
  });

  /// Obtiene el conteo de notificaciones no leídas
  Future<Either<AppFailure, int>> getUnreadNotificationCount(String userId);

  /// Marca una notificación como leída
  Future<Either<AppFailure, Unit>> markNotificationAsRead(
    String notificationId,
  );

  /// Marca todas las notificaciones como leídas
  Future<Either<AppFailure, Unit>> markAllNotificationsAsRead();

  /// Elimina una notificación
  Future<Either<AppFailure, Unit>> deleteNotification(String notificationId);

  /// Crea una nueva notificación
  Future<Either<AppFailure, String>> createNotification(
    NotificationEntity notification,
  );
}
