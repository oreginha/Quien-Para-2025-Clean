// lib/domain/repositories/application_repository.dart

import 'package:dartz/dartz.dart';
import '../../entities/application/application_entity.dart';
import '../../failures/app_failures.dart';

/// Interfaz para el repositorio de aplicaciones
abstract class ApplicationRepository {
  /// Aplica a un plan
  Future<Either<AppFailure, ApplicationEntity>> applyToPlan(
    ApplicationEntity application,
  );

  /// Obtiene las aplicaciones de un plan
  Future<Either<AppFailure, List<ApplicationEntity>>> getPlanApplications(
    String planId,
  );

  /// Obtiene las aplicaciones de un usuario
  Future<Either<AppFailure, List<ApplicationEntity>>> getUserApplications(
    String userId,
  );

  /// Actualiza el estado de una aplicación
  Future<Either<AppFailure, ApplicationEntity>> updateApplicationStatus(
    String applicationId,
    String status,
  );

  /// Cancela una aplicación
  Future<Either<AppFailure, ApplicationEntity>> cancelApplication(
    String applicationId,
  );

  /// Obtiene una aplicación por su ID
  Future<Either<AppFailure, ApplicationEntity>> getApplicationById(
    String applicationId,
  );
}
