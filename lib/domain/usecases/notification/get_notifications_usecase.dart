// lib/domain/usecases/notification/get_notifications_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/domain/entities/notification/notification_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/interfaces/notification_repository_interface.dart';
import 'package:quien_para/domain/usecases/base/usecase_interface.dart';

/// Parámetros para obtener notificaciones de un usuario
class GetNotificationsParams {
  final String userId;
  final int? limit;
  final bool includeRead;

  const GetNotificationsParams({
    required this.userId,
    this.limit,
    this.includeRead = false,
  });
}

/// Caso de uso para obtener notificaciones de un usuario
///
/// Este caso de uso implementa la interfaz UseCaseInterface y utiliza el repositorio
/// de notificaciones para obtener las notificaciones de un usuario.
class GetNotificationsUseCase
    implements
        UseCaseInterface<List<NotificationEntity>, GetNotificationsParams> {
  final INotificationRepository _notificationRepository;
  final Logger _logger = Logger();

  GetNotificationsUseCase(this._notificationRepository);

  @override
  Future<Either<AppFailure, List<NotificationEntity>>> execute(
    GetNotificationsParams params,
  ) async {
    _logger.d(
      'GetNotificationsUseCase: Obteniendo notificaciones para usuario: ${params.userId}',
    );

    // Validar parámetros
    if (params.userId.isEmpty) {
      _logger.w('GetNotificationsUseCase: ID de usuario vacío');
      return Left(
        ValidationFailure(
          message: 'El ID del usuario no puede estar vacío',
          field: 'userId',
          code: '',
        ),
      );
    }

    // Delegar al repositorio
    return _notificationRepository.getNotificationsForUser(
      params.userId,
      limit: params.limit,
      includeRead: params.includeRead,
    );
  }

  /// Método de conveniencia para usar el caso de uso como una función.
  Future<Either<AppFailure, List<NotificationEntity>>> call(
    GetNotificationsParams params,
  ) =>
      execute(params);

  /// Método de conveniencia para obtener todas las notificaciones de un usuario
  Future<Either<AppFailure, List<NotificationEntity>>> getAllNotifications(
    String userId, {
    int? limit,
  }) {
    return execute(
      GetNotificationsParams(userId: userId, limit: limit, includeRead: true),
    );
  }

  /// Método de conveniencia para obtener solo notificaciones sin leer
  Future<Either<AppFailure, List<NotificationEntity>>> getUnreadNotifications(
    String userId, {
    int? limit,
  }) {
    return execute(
      GetNotificationsParams(userId: userId, limit: limit, includeRead: false),
    );
  }
}
