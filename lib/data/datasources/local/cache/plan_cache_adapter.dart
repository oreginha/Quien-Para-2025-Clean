// lib/data/datasources/local/cache/plan_cache_adapter.dart

import 'dart:convert';
import 'package:quien_para/data/datasources/local/cache/generic_cache_interface.dart';
import 'package:quien_para/data/datasources/local/cache/generic_compressed_cache.dart';
import 'package:quien_para/data/datasources/local/plan_cache_interface.dart';

import 'package:quien_para/domain/entities/plan/plan_entity.dart';

/// Adaptador que permite usar el sistema de caché genérico para planes
/// Implementa la interfaz PlanCacheInterface para mantener compatibilidad con el código existente
class PlanCacheAdapter implements PlanCacheInterface {
  /// Instancia del caché genérico
  final GenericCompressedCache<PlanEntity> _cache;

  /// Constructor
  PlanCacheAdapter()
      : _cache = GenericCompressedCache<PlanEntity>(
          cacheName: 'plans',
          serializeCallback: (plan) => jsonEncode(plan.toJson()),
          deserializeCallback: (json) => PlanEntity.fromJson(jsonDecode(json)),
        ) {
    // Configurar opciones del caché
    _cache.setDefaultCacheDuration(const Duration(minutes: 15));
    _cache.setPriorityCacheDuration(const Duration(minutes: 30));
    _cache.setMaxCachedItems(200);
    _cache.setInvalidationPolicy(CacheInvalidationPolicy.leastRecentlyUsed);
  }

  @override
  bool get isAvailable => _cache.isAvailable;

  @override
  double get hitRate => _cache.hitRate;

  @override
  Future<void> init() => _cache.init();

  @override
  Future<void> cachePlans(List<PlanEntity> plans, {bool isPriority = false}) {
    return _cache.cacheItems(plans, isPriority: isPriority);
  }

  @override
  Future<void> cacheCategoryPlans(String category, List<PlanEntity> plans,
      {bool isPriority = false}) {
    return _cache.cacheItems(plans,
        isPriority: isPriority, collectionKey: 'category_$category');
  }

  @override
  Future<List<PlanEntity>?> getCachedPlans({bool isPriority = false}) {
    return _cache.getCachedItems(isPriority: isPriority);
  }

  @override
  Future<List<PlanEntity>?> getCategoryPlans(String category,
      {bool isPriority = false}) {
    return _cache.getCachedItems(
        isPriority: isPriority, collectionKey: 'category_$category');
  }

  @override
  Future<void> storeOtherUserPlans(
      String currentUserId, List<PlanEntity> plans) {
    return _cache.cacheItems(
      plans,
      collectionKey: 'other_user_$currentUserId',
      customDuration: const Duration(hours: 1),
    );
  }

  @override
  Future<List<PlanEntity>?> getOtherUserPlans(String currentUserId) {
    return _cache.getCachedItems(collectionKey: 'other_user_$currentUserId');
  }

  @override
  Future<void> invalidatePlan(String planId) {
    return _cache.invalidateItem(planId);
  }

  @override
  Future<void> clearCache() {
    return _cache.clearCache();
  }

  @override
  Future<Map<String, int>> getCacheSize() {
    return _cache.getCacheSize();
  }

  @override
  Map<String, dynamic> getPerformanceStats() {
    return _cache.getPerformanceStats();
  }
}
