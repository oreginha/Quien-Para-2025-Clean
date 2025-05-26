// lib/domain/usecases/notification/mark_notification_as_read_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/usecases/base/usecase_interface.dart';

import '../../interfaces/notification_repository_interface.dart';

/// Caso de uso para marcar una notificación como leída
///
/// Este caso de uso implementa la interfaz UseCaseInterface y utiliza el repositorio
/// de notificaciones para marcar una notificación como leída.
class MarkNotificationAsReadUseCase implements UseCaseInterface<Unit, String> {
  final INotificationRepository _repository;
  final Logger _logger = Logger();

  MarkNotificationAsReadUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> execute(String notificationId) async {
    _logger.d(
      'MarkNotificationAsReadUseCase: Marcando notificación como leída: $notificationId',
    );

    // Validar parámetros
    if (notificationId.isEmpty) {
      _logger.w('MarkNotificationAsReadUseCase: ID de notificación vacío');
      return Left(
        ValidationFailure(
          message: 'El ID de la notificación no puede estar vacío',
          field: 'notificationId',
          code: '',
        ),
      );
    }

    return _repository.markNotificationAsRead(notificationId);
  }
}
