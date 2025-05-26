// lib/domain/usecases/application/enhanced_reject_application_usecase.dart
import '../../interfaces/application_repository_interface.dart';

import '../../entities/application/application_entity.dart';
import 'send_application_notification_usecase.dart';

/// Caso de uso mejorado para rechazar una aplicación
/// Encapsula toda la lógica necesaria para rechazar una aplicación y enviar notificación
class EnhancedRejectApplicationUseCase {
  final ApplicationRepositoryInterface _repository;
  final SendApplicationNotificationUseCase _notificationUseCase;

  EnhancedRejectApplicationUseCase(this._repository, this._notificationUseCase);

  /// Rechaza una aplicación y envía la notificación correspondiente
  Future<ApplicationEntity> call(String applicationId) async {
    // Actualizar el estado de la aplicación
    final either = await _repository.updateApplicationStatus(
      applicationId,
      'rejected',
    );
    final application = either.fold(
      (failure) => throw Exception(failure.message),
      (app) => app,
    );

    // Enviar notificación
    await _notificationUseCase.call(
      application: application,
      notificationType: 'application_rejected',
    );

    return application;
  }
}
