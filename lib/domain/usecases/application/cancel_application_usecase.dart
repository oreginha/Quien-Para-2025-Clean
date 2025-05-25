// lib/domain/usecases/application/cancel_application_usecase.dart

import 'package:dartz/dartz.dart';
import '../../failures/app_failures.dart';
import '../../interfaces/application_repository_interface.dart';

/// Caso de uso para cancelar una aplicación
class CancelApplicationUseCase {
  final ApplicationRepositoryInterface _repository;

  CancelApplicationUseCase(this._repository);

  /// Cancela una aplicación específica
  Future<Either<AppFailure, Unit>> call(String applicationId) async {
    return await _repository.deleteApplication(applicationId);
  }
}
