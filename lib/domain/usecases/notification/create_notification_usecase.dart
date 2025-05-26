// lib/domain/usecases/notification/create_notification_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/domain/entities/notification/notification_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/interfaces/notification_repository_interface.dart';
import 'package:quien_para/domain/usecases/base/usecase_interface.dart';

/// Caso de uso para crear una nueva notificación
///
/// Este caso de uso implementa la interfaz UseCaseInterface y utiliza el repositorio
/// de notificaciones para crear una nueva notificación.
class CreateNotificationUseCase
    implements UseCaseInterface<Unit, NotificationEntity> {
  final INotificationRepository _notificationRepository;
  final Logger _logger = Logger();

  CreateNotificationUseCase(this._notificationRepository);

  @override
  Future<Either<AppFailure, Unit>> execute(
    NotificationEntity notification,
  ) async {
    _logger.d(
      'CreateNotificationUseCase: Creando notificación para: ${notification.userId}',
    );

    // Validar notificación
    if (!notification.isValid) {
      _logger.w('CreateNotificationUseCase: Notificación inválida');
      return Left(
        ValidationFailure(
          message: 'La notificación no es válida, faltan campos requeridos',
          code: '',
          field: '',
        ),
      );
    }

    // Delegar al repositorio
    return _notificationRepository.createNotification(notification);
  }

  /// Método de conveniencia para usar el caso de uso como una función.
  Future<Either<AppFailure, Unit>> call(NotificationEntity notification) =>
      execute(notification);

  /// Método de conveniencia para crear una notificación simple
  Future<Either<AppFailure, Unit>> createSimpleNotification({
    required String userId,
    required String title,
    required String message,
    String type = 'info',
    String? planId,
    String? applicationId,
    Map<String, dynamic>? data,
  }) {
    final notification = NotificationEntity(
      id: '', // ID vacío para que el repositorio lo genere
      userId: userId,
      title: title,
      message: message,
      type: type,
      planId: planId,
      applicationId: applicationId,
      data: data,
      createdAt: DateTime.now(),
      read: false,
    );

    return execute(notification);
  }
}
