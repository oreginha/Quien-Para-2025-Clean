// lib/domain/usecases/application/enhanced_cancel_application_usecase.dart
import 'package:firebase_auth/firebase_auth.dart';
import '../../interfaces/application_repository_interface.dart';
import '../../entities/application/application_entity.dart';
import 'send_application_notification_usecase.dart';

/// Caso de uso mejorado para cancelar una aplicación
/// Encapsula toda la lógica necesaria para cancelar una aplicación y enviar notificación
class EnhancedCancelApplicationUseCase {
  final ApplicationRepositoryInterface _repository;
  final SendApplicationNotificationUseCase _notificationUseCase;
  final FirebaseAuth _auth;

  EnhancedCancelApplicationUseCase(
    this._repository,
    this._notificationUseCase,
    this._auth,
  );

  /// Cancela una aplicación y envía la notificación correspondiente
  Future<ApplicationEntity> call(String applicationId) async {
    // Verificar si el usuario está autenticado
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('Usuario no autenticado');
    }

    // Obtener la aplicación antes de eliminarla (si se necesita el plan ID)
    ApplicationEntity? originalApplication;
    try {
      final either = await _repository.getApplicationById(applicationId);
      originalApplication = either.fold((failure) => null, (app) => app);
    } catch (e) {
      // Si no podemos obtener la aplicación original, continuamos con la eliminación
    }

    // Crear una aplicación temporal con el ID para mostrar en el estado
    final ApplicationEntity tempApplication = ApplicationEntity(
      id: applicationId,
      planId: originalApplication?.planId ?? '',
      applicantId: currentUser.uid,
      status: 'cancelled',
      appliedAt: DateTime.now(),
    );

    // Eliminar la aplicación
    await _repository.deleteApplication(applicationId);

    // Enviar notificación
    await _notificationUseCase.call(
      application: tempApplication,
      notificationType: 'application_cancelled',
    );

    return tempApplication;
  }
}
