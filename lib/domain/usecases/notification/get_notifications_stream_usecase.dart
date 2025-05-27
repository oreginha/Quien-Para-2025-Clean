// lib/domain/usecases/notification/get_notifications_stream_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/domain/entities/notification/notification_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/notification/notification_repository.dart';
import 'package:quien_para/domain/usecases/base/usecase_interface.dart';

/// Parámetros para obtener un stream de notificaciones
class GetNotificationsStreamParams {
  final String userId;
  final bool includeRead;

  const GetNotificationsStreamParams({
    required this.userId,
    this.includeRead = false,
  });
}

/// Caso de uso para obtener un stream de notificaciones
///
/// Este caso de uso implementa la interfaz StreamUseCaseInterface y utiliza el repositorio
/// de notificaciones para obtener un stream de notificaciones para un usuario.
class GetNotificationsStreamUseCase
    implements
        StreamUseCaseInterface<List<NotificationEntity>,
            GetNotificationsStreamParams> {
  final NotificationRepository _notificationRepository;
  final Logger _logger = Logger();

  GetNotificationsStreamUseCase(this._notificationRepository);

  @override
  Stream<Either<AppFailure, List<NotificationEntity>>> execute(
    GetNotificationsStreamParams params,
  ) {
    _logger.d(
      'GetNotificationsStreamUseCase: Obteniendo stream de notificaciones para: ${params.userId}',
    );

    // Validar parámetros
    if (params.userId.isEmpty) {
      _logger.w('GetNotificationsStreamUseCase: ID de usuario vacío');
      return Stream.value(
        Left(
          ValidationFailure(
            message: 'El ID del usuario no puede estar vacío',
            field: 'userId',
            code: '',
          ),
        ),
      );
    }

    // Delegar al repositorio
    return _notificationRepository.getNotificationsStream(
      params.userId,
      includeRead: params.includeRead,
    );
  }

  /// Método de conveniencia para usar el caso de uso como una función.
  Stream<Either<AppFailure, List<NotificationEntity>>> call(
    GetNotificationsStreamParams params,
  ) =>
      execute(params);

  /// Método de conveniencia para obtener un stream de todas las notificaciones
  Stream<Either<AppFailure, List<NotificationEntity>>>
      getAllNotificationsStream(String userId) {
    return execute(
      GetNotificationsStreamParams(userId: userId, includeRead: true),
    );
  }

  /// Método de conveniencia para obtener un stream de notificaciones sin leer
  Stream<Either<AppFailure, List<NotificationEntity>>>
      getUnreadNotificationsStream(String userId) {
    return execute(
      GetNotificationsStreamParams(userId: userId, includeRead: false),
    );
  }
}
