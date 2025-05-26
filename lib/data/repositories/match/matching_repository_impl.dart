import 'package:quien_para/data/datasources/matching_data_source.dart';
import 'package:quien_para/domain/entities/application/application_entity.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/entities/user/user_entity.dart';
import 'package:quien_para/domain/repositories/matching/matching_repository.dart';

/// Implementation of [MatchingRepository] interface
class MatchingRepositoryImpl implements MatchingRepository {
  final MatchingDataSource _remoteDataSource;
  // We could add a local data source for caching later

  MatchingRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApplicationEntity> acceptApplication(String applicationId) {
    return _remoteDataSource.acceptApplication(applicationId);
  }

  @override
  Future<ApplicationEntity> applyToPlan({
    required String planId,
    required String applicantId,
    required String message,
    required String planTitle,
    required String? applicantName,
    required String? applicantPhotoUrl,
  }) {
    return _remoteDataSource.applyToPlan(
      planId: planId,
      applicantId: applicantId,
      message: message,
      planTitle: planTitle,
      applicantName: applicantName ?? 'Usuario Anónimo',
      applicantPhotoUrl: applicantPhotoUrl ?? '',
    );
  }

  @override
  Future<List<PlanEntity>> findSimilarPlans(
    String planId, {
    int limit = 5,
  }) async {
    // Obtener las aplicaciones
    final applications = await _remoteDataSource.findSimilarPlans(planId);

    // Aquí deberíamos convertir las ApplicationEntity a PlanEntity
    // Esta es una implementación temporal hasta que se complete la consolidación
    // En una implementación real, obtendríamos los detalles completos de los planes
    return _convertApplicationsToPlanEntities(applications, limit: limit);
  }

  // Método auxiliar para convertir ApplicationEntity a PlanEntity
  List<PlanEntity> _convertApplicationsToPlanEntities(
    List<ApplicationEntity> applications, {
    int limit = 5,
  }) {
    final List<PlanEntity> plans = [];

    // Limitar la cantidad de planes según el parámetro
    final limitedApplications = applications.take(limit).toList();

    for (var app in limitedApplications) {
      // Crear un PlanEntity básico a partir de la aplicación
      // En un caso real, obtendríamos todos los datos del plan
      plans.add(
        PlanEntity(
          id: app.planId,
          title: app.planTitle ?? 'Plan sin título', // Manejo de valor nulo
          creatorId: '',
          description: '',
          location: '',
          category: '',
          tags: [],
          likes: 0,
          extraConditions: '',
          imageUrl: '',
          conditions: {},
          selectedThemes: [], // No tenemos este dato en la aplicación
          // Agregamos valores predeterminados para los campos requeridos
        ),
      );
    }

    return plans;
  }

  // Método de la antigua interfaz MatchingRepository, mantenido por compatibilidad
  @override
  Future<List<UserEntity>> findCompatibleUsers(
    String planId, {
    int limit = 10,
  }) async {
    // Implementación temporal - se debe reemplazar con lógica real
    return [];
  }

  // Método de la antigua interfaz MatchingRepository, mantenido por compatibilidad
  @override
  Future<List<PlanEntity>> findRecommendedPlans(
    String userId, {
    int limit = 15,
  }) async {
    // Implementación temporal - se debe reemplazar con lógica real
    return [];
  }

  // Método de la antigua interfaz MatchingRepository, mantenido por compatibilidad
  Future<double> calculateCompatibility(String userId, String planId) async {
    // Implementación temporal - devuelve un valor de compatibilidad aleatorio
    return 0.75;
  }

  @override
  Future<List<ApplicationEntity>> loadPlanApplications(String planId) async {
    return await _remoteDataSource.loadPlanApplications(planId);
  }

  @override
  Future<List<ApplicationEntity>> loadUserApplications(String userId) async {
    return await _remoteDataSource.loadUserApplications(userId);
  }

  @override
  Future<ApplicationEntity> rejectApplication(String applicationId) async {
    return await _remoteDataSource.rejectApplication(applicationId);
  }
}
