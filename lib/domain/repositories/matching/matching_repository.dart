import 'package:quien_para/domain/entities/application/application_entity.dart';
import 'package:quien_para/domain/entities/user/user_entity.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';

/// Interfaz consolidada para operaciones de matching
/// Combina MatchingRepository y MatchingRepository para Clean Architecture
abstract class MatchingRepository {
  /// Load applications for a specific user
  Future<List<ApplicationEntity>> loadUserApplications(String userId);

  /// Load applications for a specific plan
  Future<List<ApplicationEntity>> loadPlanApplications(String planId);

  /// Apply to a plan
  Future<ApplicationEntity> applyToPlan({
    required String planId,
    required String applicantId,
    required String message,
    required String planTitle,
    required String? applicantName,
    required String? applicantPhotoUrl,
  });

  /// Encuentra usuarios compatibles para un plan específico
  Future<List<UserEntity>> findCompatibleUsers(String planId, {int limit = 10});

  /// Encuentra planes recomendados para un usuario específico
  Future<List<PlanEntity>> findRecommendedPlans(
    String userId, {
    int limit = 15,
  });

  /// Encuentra planes similares a uno específico
  /// @param limit Limita el número de resultados (opcional)
  /// @return Lista de planes similares con información completa
  Future<List<PlanEntity>> findSimilarPlans(String planId, {int limit = 5});

  /// Accept an application
  Future<ApplicationEntity> acceptApplication(String applicationId);

  /// Reject an application
  Future<ApplicationEntity> rejectApplication(String applicationId);
}
