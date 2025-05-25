// lib/domain/interfaces/application_repository_interface.dart

import 'package:dartz/dartz.dart';
import 'package:quien_para/domain/entities/application/application_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';

/// Interfaz mejorada para el repositorio de aplicaciones con manejo de errores consistente
abstract class ApplicationRepositoryInterface {
  /// Obtener todas las aplicaciones para un plan específico
  Future<Either<AppFailure, List<ApplicationEntity>>> getApplicationsForPlan(
      String planId);

  /// Obtener todas las aplicaciones de un usuario
  Future<Either<AppFailure, List<ApplicationEntity>>> getUserApplications(
      String userId);

  /// Aplicar a un plan
  Future<Either<AppFailure, ApplicationEntity>> applyToPlan(
      ApplicationEntity application);

  /// Actualizar el estado de una aplicación
  Future<Either<AppFailure, ApplicationEntity>> updateApplicationStatus(
      String applicationId, String status,
      {String? message});

  /// Eliminar una aplicación
  Future<Either<AppFailure, Unit>> deleteApplication(String applicationId);

  /// Obtener una aplicación por su ID
  Future<Either<AppFailure, ApplicationEntity>> getApplicationById(
      String applicationId);

  /// Verificar si un usuario ya ha aplicado a un plan
  Future<Either<AppFailure, bool>> hasUserAppliedToPlan(
      String userId, String planId);

  /// Obtener la aplicación de un usuario para un plan específico
  Future<Either<AppFailure, ApplicationEntity?>> getUserApplicationForPlan(
      String userId, String planId);
}
