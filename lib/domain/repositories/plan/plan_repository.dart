// lib/domain/repositories/plan_repository.dart

// ignore_for_file: unintended_html_in_doc_comment

import 'package:dartz/dartz.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/entities/plan/plan_with_creator_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/repository_base.dart';

import '../../entities/failure.dart';

/// Repositorio para gestión de planes
///
/// Extiende RepositoryBase y añade métodos específicos para la entidad Plan.
abstract class PlanRepository extends RepositoryBase<PlanEntity> {
  /// Obtiene planes con información de creador
  ///
  /// Retorna un Stream que emite Either<AppFailure, List<PlanWithCreatorEntity>>
  Stream<Either<AppFailure, List<PlanWithCreatorEntity>>>
      getPlansWithCreators();

  /// Indica interés en un plan (like/match)
  Future<Either<AppFailure, Unit>> matchPlan(String planId);

  /// Retira interés de un plan
  Future<Either<AppFailure, Unit>> unlikePlan(String planId);

  /// Obtiene planes creados por un usuario específico
  Future<Either<AppFailure, List<PlanEntity>>> getPlansByUserId(String userId);

  /// Obtiene planes en los que participa un usuario
  Future<Either<AppFailure, List<PlanEntity>>> getParticipatingPlans(
    String userId,
  );

  /// Obtiene un stream de planes creados por otros usuarios
  ///
  /// Retorna un Stream que emite Either<AppFailure, List<PlanEntity>>
  Stream<Either<AppFailure, List<PlanEntity>>> getOtherUserPlansStream({
    required String currentUserId,
    int limit = 20,
  });

  /// Actualiza los planes de otros usuarios en caché
  Future<Either<AppFailure, Unit>> refreshOtherUserPlans({
    required String currentUserId,
    int limit = 20,
  });

  /// Obtiene planes por categoría
  Future<Either<AppFailure, List<PlanEntity>>> getPlansByCategory(
    String category, {
    int? limit,
    String? lastDocumentId,
  });

  /// Obtiene planes cercanos a una ubicación geográfica
  Future<Either<AppFailure, List<PlanEntity>>> getNearbyPlans({
    required double latitude,
    required double longitude,
    required double radiusKm,
    int? limit,
  });

  /// Obtiene planes populares (con más likes)
  Future<Either<AppFailure, List<PlanEntity>>> getPopularPlans({
    int? limit,
    String? lastDocumentId,
  });

  /// Obtiene planes recomendados para un usuario
  Future<Either<AppFailure, List<PlanEntity>>> getRecommendedPlans({
    required String userId,
    int? limit,
  });

  /// Busca planes por texto
  Future<Either<AppFailure, List<PlanEntity>>> searchPlansByText(
    String searchText, {
    int? limit,
    String? lastDocumentId,
  });

  // ========== MÉTODOS DE BÚSQUEDA AVANZADA ==========

  /// Busca planes por texto con información del creador
  ///
  /// [query] - Texto de búsqueda
  /// [limit] - Límite de resultados
  /// [lastDocumentId] - Para paginación
  Future<Either<Failure, List<PlanWithCreatorEntity>>> searchPlans({
    required String query,
    int limit = 20,
    String? lastDocumentId,
  });

  /// Obtiene sugerencias de búsqueda
  ///
  /// [query] - Texto parcial para generar sugerencias
  /// [limit] - Límite de sugerencias
  Future<Either<Failure, List<String>>> getSearchSuggestions({
    required String query,
    int limit = 5,
  });

  /// Filtra planes por ubicación geográfica
  ///
  /// [latitude] - Latitud del punto central
  /// [longitude] - Longitud del punto central
  /// [radiusKm] - Radio de búsqueda en kilómetros
  /// [limit] - Límite de resultados
  /// [lastDocumentId] - Para paginación
  Future<Either<Failure, List<PlanWithCreatorEntity>>> filterPlansByLocation({
    required double latitude,
    required double longitude,
    required double radiusKm,
    int limit = 20,
    String? lastDocumentId,
  });

  /// Obtiene coordenadas de una ciudad
  ///
  /// [cityName] - Nombre de la ciudad
  /// Retorna un Map con 'latitude' y 'longitude'
  Future<Either<Failure, Map<String, dynamic>>> getCityCoordinates(
    String cityName,
  );

  /// Filtra planes por rango de fechas
  ///
  /// [startDate] - Fecha de inicio
  /// [endDate] - Fecha de fin
  /// [limit] - Límite de resultados
  /// [lastDocumentId] - Para paginación
  Future<Either<Failure, List<PlanWithCreatorEntity>>> filterPlansByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    int limit = 20,
    String? lastDocumentId,
  });

  /// Filtra planes por categoría específica
  ///
  /// [category] - Categoría a filtrar
  /// [limit] - Límite de resultados
  /// [lastDocumentId] - Para paginación
  Future<Either<Failure, List<PlanWithCreatorEntity>>> filterPlansByCategory({
    required String category,
    int limit = 20,
    String? lastDocumentId,
  });

  /// Filtra planes por múltiples categorías
  ///
  /// [categories] - Lista de categorías
  /// [limit] - Límite de resultados
  /// [lastDocumentId] - Para paginación
  Future<Either<Failure, List<PlanWithCreatorEntity>>>
      filterPlansByMultipleCategories({
    required List<String> categories,
    int limit = 20,
    String? lastDocumentId,
  });

  /// Obtiene planes populares por categoría
  ///
  /// [category] - Categoría específica
  /// [limit] - Límite de resultados
  Future<Either<Failure, List<PlanWithCreatorEntity>>>
      getPopularPlansByCategory({required String category, int limit = 10});

  /// Obtiene categorías sugeridas para un usuario
  ///
  /// [userId] - ID del usuario
  /// [limit] - Límite de sugerencias
  Future<Either<Failure, List<String>>> getSuggestedCategories({
    required String userId,
    int limit = 3,
  });

  /// Búsqueda avanzada combinando múltiples filtros
  ///
  /// [query] - Texto de búsqueda (opcional)
  /// [category] - Categoría (opcional)
  /// [latitude] - Latitud para filtro geográfico (opcional)
  /// [longitude] - Longitud para filtro geográfico (opcional)
  /// [radiusKm] - Radio en kilómetros (opcional)
  /// [startDate] - Fecha de inicio (opcional)
  /// [endDate] - Fecha de fin (opcional)
  /// [limit] - Límite de resultados
  /// [lastDocumentId] - Para paginación
  Future<Either<Failure, List<PlanWithCreatorEntity>>> searchPlansAdvanced({
    String? query,
    String? category,
    double? latitude,
    double? longitude,
    double? radiusKm,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 20,
    String? lastDocumentId,
  });

  /// Guarda una búsqueda en el historial del usuario
  ///
  /// [userId] - ID del usuario
  /// [query] - Término de búsqueda
  Future<Either<Failure, Unit>> saveSearchToHistory({
    required String userId,
    required String query,
  });

  /// Obtiene el historial de búsquedas del usuario
  ///
  /// [userId] - ID del usuario
  /// [limit] - Límite de búsquedas recientes
  Future<Either<Failure, List<String>>> getSearchHistory({
    required String userId,
    int limit = 10,
  });

  /// Limpia el historial de búsquedas del usuario
  ///
  /// [userId] - ID del usuario
  Future<Either<Failure, Unit>> clearSearchHistory({required String userId});
}
