// lib/domain/usecases/match_plan_usecase.dart

import 'package:dartz/dartz.dart';

import 'package:quien_para/domain/failures/app_failures.dart';

import '../../repositories/plan/plan_repository.dart';

class MatchPlanUseCase {
  final PlanRepository _planRepository;

  MatchPlanUseCase(this._planRepository);

  Future<Future<Either<AppFailure, Unit>>> call(final String planId) async {
    // Implementar la lógica para hacer match al plan con el id recibido
    // Por ejemplo, llamar a un método del repository
    return _planRepository.matchPlan(planId);
  }
}
