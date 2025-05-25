// lib/domain/usecases/notification/get_unread_count_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/interfaces/notification_repository_interface.dart';
import 'package:quien_para/domain/usecases/base/usecase_interface.dart';

/// Caso de uso para obtener la cantidad de notificaciones sin leer
///
/// Este caso de uso implementa la interfaz UseCaseInterface y utiliza el repositorio
/// de notificaciones para obtener la cantidad de notificaciones sin leer de un usuario.
class GetUnreadCountUseCase implements UseCaseInterface<int, String> {
  final INotificationRepository _repository;
  final Logger _logger = Logger();

  GetUnreadCountUseCase(this._repository);

  @override
  Future<Either<AppFailure, int>> execute(String userId) async {
    _logger.d(
        'GetUnreadCountUseCase: Obteniendo cantidad de notificaciones sin leer para: $userId');

    // Validar parámetros
    if (userId.isEmpty) {
      _logger.w('GetUnreadCountUseCase: ID de usuario vacío');
      return Left(ValidationFailure(
        message: 'El ID del usuario no puede estar vacío',
        field: 'userId',
        code: '',
      ));
    }

    // Delegar al repositorio
    return _repository.getUnreadNotificationCount(userId);
  }

  /// Método de conveniencia para usar el caso de uso como una función.
  Future<Either<AppFailure, int>> call(String userId) => execute(userId);
}
