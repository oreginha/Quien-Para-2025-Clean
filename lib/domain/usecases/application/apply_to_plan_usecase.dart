// lib/domain/usecases/application/apply_to_plan_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../failures/app_failures.dart';
import '../../entities/application/application_entity.dart';
import '../../interfaces/application_repository_interface.dart';
import 'send_application_notification_usecase.dart';

/// Caso de uso para aplicar a un plan
///
/// Combina toda la funcionalidad relacionada con aplicaciones a planes en una clase
/// lo suficientemente flexible para adaptarse a diferentes patrones de uso.
class ApplyToPlanUseCase {
  final ApplicationRepositoryInterface repository;
  final SendApplicationNotificationUseCase? notificationUseCase;
  final FirebaseAuth? auth;

  /// Constructor con dependencias opcionales para mayor flexibilidad
  ApplyToPlanUseCase(
    this.repository, {
    this.notificationUseCase,
    this.auth,
  });

  /// Método principal para aplicar a un plan
  Future<Either<AppFailure, ApplicationEntity>> call(
      ApplicationEntity application) async {
    return await repository.applyToPlan(application);
  }

  /// Crea una entidad de aplicación con los campos requeridos
  Future<ApplicationEntity> createApplicationEntity({
    required String planId,
    required String status,
    required DateTime appliedAt,
    String? message,
  }) async {
    final userId = auth?.currentUser?.uid;
    if (userId == null) {
      throw Exception('Usuario no autenticado');
    }

    return ApplicationEntity(
      id: '',
      planId: planId,
      applicantId: userId,
      status: status,
      appliedAt: appliedAt,
      message: message,
    );
  }
}
