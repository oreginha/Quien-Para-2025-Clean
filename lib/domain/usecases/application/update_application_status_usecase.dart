// lib/domain/usecases/application/update_application_status_usecase.dart

import 'package:dartz/dartz.dart';
import '../../failures/app_failures.dart';
import '../../entities/application/application_entity.dart';
import '../../interfaces/application_repository_interface.dart';

/// Caso de uso para actualizar el estado de una aplicación
class UpdateApplicationStatusUseCase {
  final ApplicationRepositoryInterface _repository;

  UpdateApplicationStatusUseCase(this._repository);

  /// Actualiza el estado de una aplicación específica
  Future<Either<AppFailure, ApplicationEntity>> call(
    String applicationId,
    String status,
  ) async {
    return await _repository.updateApplicationStatus(applicationId, status);
  }
}
