// lib/domain/repositories/matching_repository_interface.dart

import 'package:quien_para/domain/entities/application/application_entity.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/entities/user/user_entity.dart';

/// Repositorio unificado para funcionalidades de matching y aplicaciones
abstract class MatchingRepositoryInterface {
  /// Encuentra usuarios compatibles para un plan específico
  Future<List<UserEntity>> findCompatibleUsers(String planId, {int limit = 10});

  /// Encuentra planes recomendados para un usuario específico
  Future<List<PlanEntity>> findRecommendedPlans(String userId,
      {int limit = 15});

  /// Encuentra planes similares a uno específico
  Future<List<PlanEntity>> findSimilarPlans(String planId, {int limit = 5});

  /// Carga aplicaciones de un usuario específico
  Future<List<ApplicationEntity>> loadUserApplications(String userId);

  /// Carga aplicaciones para un plan específico
  Future<List<ApplicationEntity>> loadPlanApplications(String planId);

  /// Aplica a un plan
  Future<ApplicationEntity> applyToPlan({
    required String planId,
    required String applicantId,
    required String message,
    required String planTitle,
    required String? applicantName,
    required String? applicantPhotoUrl,
  });

  /// Acepta una aplicación
  Future<ApplicationEntity> acceptApplication(String applicationId);

  /// Rechaza una aplicación
  Future<ApplicationEntity> rejectApplication(String applicationId);

  /// Calcula la compatibilidad entre un usuario y un plan
  Future<double> calculateCompatibility(String userId, String planId);
}
