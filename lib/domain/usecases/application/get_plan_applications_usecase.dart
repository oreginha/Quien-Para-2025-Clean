// lib/domain/usecases/application/get_plan_applications_usecase.dart

import 'package:dartz/dartz.dart';
import '../../failures/app_failures.dart';
import '../../entities/application/application_entity.dart';
import '../../interfaces/application_repository_interface.dart';

/// Caso de uso para obtener las aplicaciones de un plan
class GetPlanApplicationsUseCase {
  final ApplicationRepositoryInterface _repository;

  GetPlanApplicationsUseCase(this._repository);

  /// Obtiene todas las aplicaciones asociadas a un plan específico
  Future<Either<AppFailure, List<ApplicationEntity>>> call(
    String planId,
  ) async {
    return await _repository.getApplicationsForPlan(planId);
  }
}
