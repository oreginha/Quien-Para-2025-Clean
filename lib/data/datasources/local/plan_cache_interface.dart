// lib/data/datasources/local/plan_cache_interface.dart

import 'package:quien_para/domain/entities/plan/plan_entity.dart';

/// Interfaz base para implementaciones de caché de planes
abstract class PlanCacheInterface {
  /// Indica si el caché está disponible para su uso
  bool get isAvailable;

  /// Obtiene la tasa de aciertos del caché (hit rate)
  double get hitRate;

  /// Inicializa el sistema de caché
  Future<void> init();

  /// Almacena un listado de planes en caché
  Future<void> cachePlans(List<PlanEntity> plans, {bool isPriority = false});

  /// Almacena planes por categoría en caché
  Future<void> cacheCategoryPlans(
    String category,
    List<PlanEntity> plans, {
    bool isPriority = false,
  });

  /// Obtiene planes desde el caché
  Future<List<PlanEntity>?> getCachedPlans({bool isPriority = false});

  /// Obtiene planes por categoría desde el caché
  Future<List<PlanEntity>?> getCategoryPlans(
    String category, {
    bool isPriority = false,
  });

  /// Almacena planes de otros usuarios en el caché
  Future<void> storeOtherUserPlans(
    String currentUserId,
    List<PlanEntity> plans,
  );

  /// Obtiene planes de otros usuarios desde el caché
  Future<List<PlanEntity>?> getOtherUserPlans(String currentUserId);

  /// Invalida un plan específico en todas las colecciones del caché
  Future<void> invalidatePlan(String planId);

  /// Limpia todo el caché
  Future<void> clearCache();

  /// Obtiene el tamaño del caché
  Future<Map<String, int>> getCacheSize();

  /// Obtiene estadísticas de rendimiento del caché
  Map<String, dynamic> getPerformanceStats();
}
