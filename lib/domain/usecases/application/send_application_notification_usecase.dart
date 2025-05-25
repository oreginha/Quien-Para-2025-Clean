// lib/domain/usecases/application/send_application_notification_usecase.dart

import '../../interfaces/notification_service_interface.dart';
import '../../entities/application/application_entity.dart';

/// Caso de uso para enviar notificaciones relacionadas con aplicaciones
class SendApplicationNotificationUseCase {
  final NotificationServiceInterface _notificationService;

  SendApplicationNotificationUseCase(this._notificationService);

  /// Envía una notificación relacionada con una aplicación
  Future<void> call({
    required ApplicationEntity application,
    required String notificationType,
    String? customMessage,
  }) async {
    final Map<String, dynamic> notificationData = {
      'type': 'application_update',
      'application_id': application.id,
      'plan_id': application.planId,
      'status': application.status,
      'notification_type': notificationType,
    };

    String title;
    String body;

    switch (notificationType) {
      case 'new_application':
        title = 'Nueva postulación recibida';
        body = 'Alguien se ha postulado a tu plan';
        break;
      case 'application_accepted':
        title = '¡Postulación aceptada!';
        body = 'Tu postulación ha sido aceptada';
        break;
      case 'application_rejected':
        title = 'Actualización de postulación';
        body = 'Tu postulación no ha sido aceptada';
        break;
      case 'application_cancelled':
        title = 'Postulación cancelada';
        body = 'Una postulación ha sido cancelada';
        break;
      default:
        title = 'Actualización de postulación';
        body = customMessage ?? 'Hay una actualización en tu postulación';
    }

    await _notificationService.showLocalNotification(
      title: title,
      body: body,
      payload: notificationData,
    );
  }
}
