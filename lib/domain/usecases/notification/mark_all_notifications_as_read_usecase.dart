// lib/domain/usecases/notification/mark_all_notifications_as_read_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/usecases/base/usecase_interface.dart';

import '../../interfaces/notification_repository_interface.dart';

/// Caso de uso para marcar todas las notificaciones de un usuario como leídas
///
/// Este caso de uso implementa la interfaz UseCaseInterface y utiliza el repositorio
/// de notificaciones para marcar todas las notificaciones de un usuario como leídas.
class MarkAllNotificationsAsReadUseCase
    implements UseCaseInterface<Unit, String> {
  final INotificationRepository _notificationRepository;
  final Logger _logger = Logger();

  MarkAllNotificationsAsReadUseCase(this._notificationRepository);

  @override
  Future<Either<AppFailure, Unit>> execute(String userId) async {
    _logger.d(
      'MarkAllNotificationsAsReadUseCase: Marcando todas las notificaciones como leídas para: $userId',
    );

    // Validar parámetros
    if (userId.isEmpty) {
      _logger.w('MarkAllNotificationsAsReadUseCase: ID de usuario vacío');
      return Left(
        ValidationFailure(
          message: 'El ID del usuario no puede estar vacío',
          field: 'userId',
          code: '',
        ),
      );
    }

    // Delegar al repositorio
    return _notificationRepository.markAllAsRead(userId);
  }

  /// Método de conveniencia para usar el caso de uso como una función.
  Future<Either<AppFailure, Unit>> call(String userId) => execute(userId);
}
