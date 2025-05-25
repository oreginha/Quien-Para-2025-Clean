// lib/domain/usecases/application/enhanced_accept_application_usecase.dart
import 'package:dartz/dartz.dart';
import '../../failures/app_failures.dart';
import '../../interfaces/application_repository_interface.dart';

import '../../entities/application/application_entity.dart';
import '../../../core/services/application_chat_service.dart';
import 'package:flutter/foundation.dart';

import 'send_application_notification_usecase.dart';

/// Caso de uso mejorado para aceptar una aplicación
/// Encapsula toda la lógica necesaria para aceptar una aplicación y crear un chat
class EnhancedAcceptApplicationUseCase {
  final ApplicationRepositoryInterface _repository;
  final SendApplicationNotificationUseCase _notificationUseCase;
  final ApplicationChatService _chatService;

  EnhancedAcceptApplicationUseCase(
    this._repository,
    this._notificationUseCase,
  ) : _chatService = ApplicationChatService();

  /// Acepta una aplicación, envía la notificación correspondiente y crea un chat
  Future<ApplicationEntity> call(String applicationId) async {
    // Actualizar el estado de la aplicación
    final Either<AppFailure, ApplicationEntity> result =
        await _repository.updateApplicationStatus(applicationId, 'accepted');

    return result.fold(
      (failure) =>
          throw Exception('Failed to accept application: ${failure.message}'),
      (application) async {
        // Enviar notificación
        await _notificationUseCase.call(
          application: application,
          notificationType: 'application_accepted',
        );

        // Si la aplicación fue aceptada, crear un chat entre los usuarios
        try {
          final String? chatId =
              await _chatService.createChatForAcceptedApplication(application);
          if (chatId != null && kDebugMode) {
            if (kDebugMode) {
              print('Chat creado con éxito: $chatId');
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error al crear chat: $e');
          }
          // No hacemos rethrow para no interrumpir el flujo principal si falla la creación del chat
        }

        return application;
      },
    );
  }
}
