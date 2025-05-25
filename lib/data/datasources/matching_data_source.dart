import 'package:quien_para/domain/entities/application/application_entity.dart';

/// Interface for matching-related data operations
abstract class MatchingDataSource {
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

  /// Accept an application
  Future<ApplicationEntity> acceptApplication(String applicationId);

  /// Reject an application
  Future<ApplicationEntity> rejectApplication(String applicationId);

  /// Find similar plans
  Future<List<ApplicationEntity>> findSimilarPlans(String planId);
}
