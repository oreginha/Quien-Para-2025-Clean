// filepath: d:\Proyectos y Desarrollo\quien_para\quien_para\lib\data\repositories\plan_repository_impl.dart
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quien_para/core/logger/logger.dart';
import 'package:quien_para/core/repositories/base_repository.dart';
import 'package:quien_para/core/services/planes_api_service.dart';
import 'package:quien_para/data/datasources/local/user_cache.dart';
import 'package:quien_para/data/mappers/user_mapper.dart';
import 'package:quien_para/domain/entities/failure.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/entities/plan/plan_with_creator_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart' as app_failures;
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'dart:async';

import '../../../domain/entities/failure.dart' as core_failure;
import '../../../domain/entities/user/user_entity.dart';

class PlanRepositoryImpl extends BaseRepository implements PlanRepository {
  final FirebaseFirestore _firestore;
  final UserCache _cache;
  final UserMapper _mapper;
  final Map<String, StreamController<Either<AppFailure, List<PlanEntity>>>>
      _plansStreamControllers = {};

  PlanRepositoryImpl(
    PlanApiService apiService, {
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required FirebaseAuth auth,
    required UserCache cache,
    required super.logger,
    required UserMapper mapper,
  })  : _firestore = firestore,
        _cache = cache,
        _mapper = mapper;

  /// Verifica si el caché está disponible para usar
  bool get _isCacheAvailable => true;

  /// Convierte AppFailure a Failure para compatibilidad con la interfaz
  Failure _convertAppFailureToFailure(AppFailure appFailure) {
    switch (appFailure.runtimeType) {
      case app_failures.NetworkFailure _:
        return const core_failure.NetworkFailure();
      case const (app_failures.DatabaseFailure):
        return core_failure.ServerFailure(null, appFailure.message);
      case const (app_failures.NotFoundFailure):
        return const core_failure.NotFoundFailure();
      case const (app_failures.ValidationFailure):
        return const core_failure.ValidationFailure();
      case const (app_failures.CacheFailure):
        return const core_failure.CacheFailure();
      case const (app_failures.AuthFailure):
        return const core_failure.AuthFailure();
      case const (app_failures.PermissionFailure):
        return const core_failure.PermissionFailure();
      default:
        return core_failure.UnexpectedFailure(appFailure.message);
    }
  }

  /// Ejecuta operaciones con manejo de errores que devuelve Failure en lugar de AppFailure
  Future<Either<Failure, T>> executeWithTryCatchFailure<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    try {
      final result = await operation();
      return Right(result);
    } catch (e, stackTrace) {
      logger.e('Error en $operationName:', error: e, stackTrace: stackTrace);
      if (e is AppFailure) {
        return Left(_convertAppFailureToFailure(e));
      }
      final appFailure = FailureHelper.fromException(e, stackTrace);
      return Left(_convertAppFailureToFailure(appFailure));
    }
  }

  @override
  Stream<Either<AppFailure, List<PlanEntity>>>? getStream({
    Map<String, dynamic>? filters,
  }) {
    if (filters == null) return null;

    final id = filters['id'] as String?;
    final currentUserId = filters['currentUserId'] as String?;

    if (id == null || currentUserId == null) return null;

    final streamController = _plansStreamControllers[id];
    if (streamController == null) {
      return null;
    }
    return streamController.stream;
  }

  Future<Either<AppFailure, List<PlanEntity>>> getOtherUserPlans({
    required String currentUserId,
  }) async {
    return executeWithTryCatch<List<PlanEntity>>(
        'obtener planes de otros usuarios', () async {
      final plans = await _firestore
          .collection('planes')
          .where('userId', isNotEqualTo: currentUserId)
          .get()
          .then((value) =>
              value.docs.map((e) => PlanEntity.fromJson(e.data())).toList());

      if (_isCacheAvailable) {
        await _cache.cacheList(
          plans,
          _otherUserPlansCachePrefix + currentUserId,
        );
      }

      return plans;
    });
  }

  @override
  Future<Either<AppFailure, Unit>> refreshOtherUserPlans({
    required String currentUserId,
    int limit = 10,
  }) async {
    return executeWithTryCatch<Unit>('actualizar planes de otros usuarios',
        () async {
      final plans = await _firestore
          .collection('planes')
          .where('userId', isNotEqualTo: currentUserId)
          .limit(limit)
          .get()
          .then((value) =>
              value.docs.map((e) => PlanEntity.fromJson(e.data())).toList());

      if (_isCacheAvailable) {
        await _cache.cacheList(
          plans,
          _otherUserPlansCachePrefix + currentUserId,
        );
      }

      return unit;
    });
  }

  static const String _otherUserPlansCachePrefix = 'other_user_plans_';

  @override
  Future<Either<AppFailure, PlanEntity>> create(PlanEntity entity) async {
    return executeWithTryCatch<PlanEntity>('crear plan', () async {
      final docRef = _firestore.collection('planes').doc();
      final plan = entity.copyWith(id: docRef.id);
      await docRef.set(plan.toJson());
      return plan;
    });
  }

  @override
  Future<Either<AppFailure, Unit>> delete(String id) async {
    return executeWithTryCatch<Unit>('eliminar plan', () async {
      await _firestore.collection('planes').doc(id).delete();
      return unit;
    });
  }

  @override
  Future<void> dispose() async {
    for (final controller in _plansStreamControllers.values) {
      await controller.close();
    }
    _plansStreamControllers.clear();
  }

  @override
  Future<Either<AppFailure, bool>> exists(String id) async {
    return executeWithTryCatch<bool>('verificar si existe plan', () async {
      final doc = await _firestore.collection('planes').doc(id).get();
      return doc.exists;
    });
  }

  @override
  Future<Either<AppFailure, List<PlanEntity>>> getAll({
    Map<String, dynamic>? filters,
    String? lastDocumentId,
    int? limit,
  }) async {
    return executeWithTryCatch<List<PlanEntity>>('obtener todos los planes',
        () async {
      Query<Map<String, dynamic>> query = _firestore.collection('planes');

      if (lastDocumentId != null) {
        final lastDoc =
            await _firestore.collection('planes').doc(lastDocumentId).get();
        query = query.startAfterDocument(lastDoc);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      if (filters != null) {
        for (final filter in filters.entries) {
          query = query.where(filter.key, isEqualTo: filter.value);
        }
      }

      final plans = await query.get().then((value) =>
          value.docs.map((e) => PlanEntity.fromJson(e.data())).toList());

      if (_isCacheAvailable) {
        await _cache.cacheList(plans, 'all_plans');
      }

      return plans;
    });
  }

  @override
  Future<Either<AppFailure, PlanEntity?>> getById(String id) async {
    return executeWithTryCatch<PlanEntity?>('obtener plan por id', () async {
      final doc = await _firestore.collection('planes').doc(id).get();
      if (!doc.exists) {
        return null;
      }
      return PlanEntity.fromJson(doc.data()!);
    });
  }

  @override
  Future<Either<AppFailure, List<PlanEntity>>> getNearbyPlans(
      {required double latitude,
      required double longitude,
      required double radiusKm,
      int? limit}) async {
    return executeWithTryCatch<List<PlanEntity>>('obtener planes cercanos',
        () async {
      // Convertir radio de km a grados (aproximación)
      final double radiusInDegrees = radiusKm / 111.32;

      // Calcular los límites del área de búsqueda
      final double latMin = latitude - radiusInDegrees;
      final double latMax = latitude + radiusInDegrees;
      final double lonMin = longitude - radiusInDegrees;
      final double lonMax = longitude + radiusInDegrees;

      // Realizar la consulta
      var query = _firestore
          .collection('planes')
          .where('location.latitude', isGreaterThanOrEqualTo: latMin)
          .where('location.latitude', isLessThanOrEqualTo: latMax);

      if (limit != null) {
        query = query.limit(limit);
      }

      final querySnapshot = await query.get();

      // Filtrar resultados por longitud y distancia
      final List<PlanEntity> nearbyPlans = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final planLat = data['location']['latitude'] as double;
        final planLon = data['location']['longitude'] as double;

        // Verificar si está dentro del rango de longitud
        if (planLon >= lonMin && planLon <= lonMax) {
          // Calcular distancia real usando la fórmula de Haversine
          final distance =
              _calculateDistance(latitude, longitude, planLat, planLon);

          if (distance <= radiusKm) {
            nearbyPlans.add(PlanEntity.fromJson(data));
          }
        }
      }

      return nearbyPlans;
    });
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Radio de la Tierra en kilómetros
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * pi / 180;

  @override
  Stream<Either<AppFailure, List<PlanEntity>>> getOtherUserPlansStream(
      {required String currentUserId, int limit = 20}) {
    return _firestore
        .collection('planes')
        .where('creatorId', isNotEqualTo: currentUserId)
        .orderBy('creatorId')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      try {
        final plans = snapshot.docs
            .map((doc) => PlanEntity.fromJson(doc.data()))
            .toList();
        return Right(plans);
      } catch (e) {
        return Left(AppFailure(
          code: 'other-plans-stream-error',
          message: 'Error al obtener planes de otros usuarios: ${e.toString()}',
        ));
      }
    });
  }

  @override
  Future<Either<AppFailure, List<PlanEntity>>> getParticipatingPlans(
      String userId) async {
    return executeWithTryCatch<List<PlanEntity>>('obtener planes participando',
        () async {
      final querySnapshot = await _firestore
          .collection('planes')
          .where('participants', arrayContains: userId)
          .orderBy('startDate', descending: true)
          .get();

      final plans = querySnapshot.docs
          .map((doc) => PlanEntity.fromJson(doc.data()))
          .toList();

      if (_isCacheAvailable) {
        await _cache.cacheList(plans, 'participating_$userId');
      }

      return plans;
    });
  }

  @override
  Future<Either<AppFailure, List<PlanEntity>>> getPlansByCategory(
    String category, {
    String? lastDocumentId,
    int? limit,
  }) async {
    return executeWithTryCatch<List<PlanEntity>>('obtener planes por categoría',
        () async {
      final plans = await _firestore
          .collection('planes')
          .where('category', isEqualTo: category)
          .get()
          .then((value) =>
              value.docs.map((e) => PlanEntity.fromJson(e.data())).toList());

      if (_isCacheAvailable) {
        await _cache.cacheList(plans, 'category_$category');
      }

      return plans;
    });
  }

  @override
  Future<Either<AppFailure, List<PlanEntity>>> getPlansByUserId(
    String userId,
  ) async {
    return executeWithTryCatch<List<PlanEntity>>('obtener planes por usuario',
        () async {
      final plans = await _firestore
          .collection('planes')
          .where('userId', isEqualTo: userId)
          .get()
          .then((value) =>
              value.docs.map((e) => PlanEntity.fromJson(e.data())).toList());

      if (_isCacheAvailable) {
        await _cache.cacheList(plans, 'user_$userId');
      }

      return plans;
    });
  }

  @override
  Future<Either<AppFailure, List<PlanEntity>>> getPopularPlans(
      {int? limit, String? lastDocumentId}) async {
    return executeWithTryCatch<List<PlanEntity>>('obtener planes populares',
        () async {
      var query = _firestore
          .collection('planes')
          .orderBy('participantCount', descending: true)
          .orderBy('rating', descending: true);

      if (lastDocumentId != null) {
        final lastDoc =
            await _firestore.collection('planes').doc(lastDocumentId).get();
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final querySnapshot = await query.get();
      final plans = querySnapshot.docs
          .map((doc) => PlanEntity.fromJson(doc.data()))
          .toList();

      if (_isCacheAvailable) {
        final cacheKey = 'popular_plans${limit ?? ''}';
        await _cache.cacheList(plans, cacheKey);
      }

      return plans;
    });
  }

  @override
  Future<Either<AppFailure, List<PlanEntity>>> getRecommendedPlans(
      {required String userId, int? limit}) async {
    return executeWithTryCatch<List<PlanEntity>>('obtener planes recomendados',
        () async {
      // Obtener preferencias del usuario
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data();
      final List<String> userInterests =
          List<String>.from(userData?['interests'] ?? []);
      final List<String> userCategories =
          List<String>.from(userData?['preferredCategories'] ?? []);

      // Construir consulta base
      var query = _firestore
          .collection('planes')
          .where('status', isEqualTo: 'active')
          .where('creatorId', isNotEqualTo: userId);

      // Si el usuario tiene intereses o categorías preferidas
      if (userInterests.isNotEmpty || userCategories.isNotEmpty) {
        query = query.where(
          Filter.or(
            Filter('tags', arrayContainsAny: userInterests),
            Filter('category', whereIn: userCategories),
          ),
        );
      }

      // Ordenar por fecha y rating
      query = query.orderBy('startDate').orderBy('rating', descending: true);

      if (limit != null) {
        query = query.limit(limit);
      }

      final querySnapshot = await query.get();
      final plans = querySnapshot.docs
          .map((doc) => PlanEntity.fromJson(doc.data()))
          .toList();

      if (_isCacheAvailable) {
        await _cache.cacheList(plans, 'recommended_$userId');
      }

      return plans;
    });
  }

  @override
  Future<Either<AppFailure, Unit>> invalidateCache() async {
    return executeWithTryCatch<Unit>('invalidar caché', () async {
      if (_isCacheAvailable) {
        try {
          final box = await Hive.openBox<dynamic>('plans_cache');
          await box.clear();
        } catch (e) {
          logger.e('Error al limpiar la caché:', error: e);
        }
      }
      return unit;
    });
  }

  @override
  Future<Either<AppFailure, Unit>> matchPlan(String planId) async {
    return executeWithTryCatch<Unit>('hacer match con plan', () async {
      // Verificar usuario autenticado
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) {
        throw Exception('Usuario no autenticado');
      }

      // Verificar si el plan existe
      final planDoc = await _firestore.collection('planes').doc(planId).get();
      if (!planDoc.exists) {
        throw Exception('Plan no encontrado');
      }

      final plan = PlanEntity.fromJson(planDoc.data()!);

      // Verificar si el usuario ya ha hecho match con este plan
      final likesRef = _firestore.collection('likes');
      final existingLike = await likesRef
          .where('userId', isEqualTo: currentUserId)
          .where('planId', isEqualTo: planId)
          .get();

      if (existingLike.docs.isNotEmpty) {
        logger.d('Usuario ya ha hecho match con este plan');
        return unit; // El usuario ya ha hecho match, no hacer nada
      }

      // Crear registro de match/like
      await likesRef.add({
        'userId': currentUserId,
        'planId': planId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Incrementar contador de likes del plan
      await _firestore.collection('planes').doc(planId).update({
        'likesCount': FieldValue.increment(1),
        'likes': FieldValue.arrayUnion([currentUserId]),
      });

      // Crear notificación para el creador del plan
      if (plan.creatorId != currentUserId) {
        await _firestore.collection('notifications').add({
          'userId': plan.creatorId, // Notificar al creador del plan
          'type': 'plan_liked',
          'planId': planId,
          'planTitle': plan.title,
          'fromUserId': currentUserId,
          'read': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return unit;
    });
  }

  @override
  Future<Either<AppFailure, PlanEntity?>> refresh(String id) async {
    return executeWithTryCatch<PlanEntity?>('actualizar plan', () async {
      // Verificar que el plan existe
      final doc = await _firestore.collection('planes').doc(id).get();
      if (!doc.exists) {
        logger.w('Plan no encontrado para refrescar: $id');
        return null;
      }

      // Obtener el plan actualizado
      final plan = PlanEntity.fromJson(doc.data()!);

      // Actualizar en caché si está disponible
      if (_isCacheAvailable) {
        // Actualizar el plan individual
        await _cache.cacheList([plan], id);

        // Actualizar en listas cacheadas que puedan contener este plan
        final allCacheKeys = await _cache.getAllCacheKeys();
        for (final key in allCacheKeys) {
          if (key != id && !key.startsWith('count_')) {
            // Evitar claves de contador
            final cachedList = await _cache.getCachedList(key);
            if (cachedList != null) {
              final index = cachedList.indexWhere((p) => p.id == id);
              if (index >= 0) {
                cachedList[index] = plan;
                await _cache.cacheList(cachedList, key);
              }
            }
          }
        }
      }

      return plan;
    });
  }

  @override
  Future<Either<AppFailure, List<PlanEntity>>> refreshAll(
      {Map<String, dynamic>? filters}) async {
    return executeWithTryCatch<List<PlanEntity>>('refrescar todos los planes',
        () async {
      // Construir la consulta base
      Query<Map<String, dynamic>> query = _firestore.collection('planes');

      // Aplicar filtros si se proporcionan
      if (filters != null) {
        for (final filter in filters.entries) {
          query = query.where(filter.key, isEqualTo: filter.value);
        }
      }

      // Ejecutar la consulta
      final snapshot = await query.get();

      // Convertir a entidades
      final List<PlanEntity> plans =
          snapshot.docs.map((doc) => PlanEntity.fromJson(doc.data())).toList();

      // Actualizar caché si está disponible
      if (_isCacheAvailable) {
        // Generar una clave para esta consulta
        String cacheKey = 'all_plans';
        if (filters != null && filters.isNotEmpty) {
          // Crear una clave basada en los filtros
          final filterParts =
              filters.entries.map((e) => '${e.key}=${e.value}').join('_');
          cacheKey = 'plans_$filterParts';
        }

        // Almacenar en caché
        await _cache.cacheList(plans, cacheKey);

        // Si no hay filtros, actualizar también la caché 'all_plans'
        if (filters == null || filters.isEmpty) {
          await _cache.cacheList(plans, 'all_plans');
        }
      }

      return plans;
    });
  }

  @override
  Future<Either<AppFailure, List<PlanEntity>>> search(
      Map<String, dynamic> criteria,
      {int? limit,
      String? lastDocumentId}) async {
    return executeWithTryCatch<List<PlanEntity>>('buscar planes', () async {
      // Intentar obtener resultados desde caché si está disponible
      if (_isCacheAvailable) {
        // Crear clave para esta búsqueda
        final criteriaParts =
            criteria.entries.map((e) => '${e.key}=${e.value}').join('_');
        final cacheKey = 'search_$criteriaParts';

        // Verificar si hay resultados en caché
        final cachedResults = await _cache.getCachedList(cacheKey);
        if (cachedResults != null) {
          logger.d(
              'Resultados de búsqueda obtenidos de caché: ${cachedResults.length} planes');

          // Aplicar paginación si es necesario
          if (lastDocumentId != null) {
            final startIndex =
                cachedResults.indexWhere((p) => p.id == lastDocumentId);
            if (startIndex >= 0 && startIndex < cachedResults.length - 1) {
              final paginatedResults = cachedResults.sublist(startIndex + 1);
              return limit != null && paginatedResults.length > limit
                  ? paginatedResults.sublist(0, limit)
                  : paginatedResults;
            }
          } else if (limit != null && cachedResults.length > limit) {
            return cachedResults.sublist(0, limit);
          }

          return cachedResults;
        }
      }

      // No hay resultados en caché, realizar búsqueda en Firestore
      QuerySnapshot<Map<String, dynamic>> snapshot;

      // Construir consulta base
      Query<Map<String, dynamic>> query = _firestore.collection('planes');

      // Aplicar filtros de búsqueda
      final textSearch = criteria['text'] as String?;

      // Quitar criterios especiales del mapa de filtros
      if (textSearch != null) {
        criteria.remove('text');
      }

      // Aplicar filtros restantes directamente a la consulta
      for (final entry in criteria.entries) {
        query = query.where(entry.key, isEqualTo: entry.value);
      }

      // Ordenar por fecha de creación (más recientes primero)
      query = query.orderBy('createdAt', descending: true);

      // Aplicar paginación si se proporciona un ID de documento
      if (lastDocumentId != null) {
        final lastDoc =
            await _firestore.collection('planes').doc(lastDocumentId).get();
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      // Aplicar límite si se proporciona
      if (limit != null) {
        query = query.limit(limit);
      }

      // Ejecutar consulta
      snapshot = await query.get();

      // Convertir a entidades
      List<PlanEntity> results =
          snapshot.docs.map((doc) => PlanEntity.fromJson(doc.data())).toList();

      // Filtrar por texto si es necesario (filtrado en cliente)
      if (textSearch != null && textSearch.isNotEmpty) {
        final searchLower = textSearch.toLowerCase();
        results = results
            .where((plan) =>
                plan.title.toLowerCase().contains(searchLower) ||
                plan.description.toLowerCase().contains(searchLower) ||
                (plan.category.toLowerCase().contains(searchLower)))
            .toList();
      }

      // Guardar resultados en caché si está disponible
      if (_isCacheAvailable) {
        final criteriaParts =
            criteria.entries.map((e) => '${e.key}=${e.value}').join('_');
        final cacheKey = 'search_$criteriaParts';

        await _cache.cacheList(results, cacheKey);
      }

      return results;
    });
  }

  @override
  Future<Either<AppFailure, List<PlanEntity>>> searchPlansByText(
    String text, {
    String? lastDocumentId,
    int? limit,
  }) async {
    return executeWithTryCatch<List<PlanEntity>>('buscar planes por texto',
        () async {
      final textLower = text.toLowerCase();
      final plans = await _firestore.collection('planes').get().then((value) =>
          value.docs
              .map((e) => PlanEntity.fromJson(e.data()))
              .where((plan) =>
                  plan.title.toLowerCase().contains(textLower) ||
                  plan.description.toLowerCase().contains(textLower))
              .toList());

      return plans;
    });
  }

  @override
  Future<Either<AppFailure, Unit>> unlikePlan(String planId) async {
    return executeWithTryCatch<Unit>('quitar like a plan', () async {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) {
        throw Exception('Usuario no autenticado');
      }

      await _firestore.collection('planes').doc(planId).update({
        'likes': FieldValue.arrayRemove([currentUserId]),
      });
      return unit;
    });
  }

  @override
  Future<Either<AppFailure, PlanEntity>> update(PlanEntity entity) async {
    return executeWithTryCatch<PlanEntity>('actualizar plan', () async {
      // Verificar que el plan existe
      final docRef = _firestore.collection('planes').doc(entity.id);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw Exception('Plan no encontrado: ${entity.id}');
      }

      // Verificar permisos (solo el creador puede actualizar)
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      final existingPlan = PlanEntity.fromJson(doc.data()!);

      if (currentUserId != existingPlan.creatorId) {
        throw Exception('No tienes permiso para actualizar este plan');
      }

      // Preservar campos que no deben ser modificados por el usuario
      final updatedPlan = entity.copyWith(
        createdAt: existingPlan.createdAt,
        creatorId: existingPlan.creatorId,
        likes: existingPlan.likes,
        // likesCount: existingPlan.likesCount, // <-- Fix: Remove or update this line
      );

      // Actualizar en Firestore
      await docRef.update(updatedPlan.toJson());

      // Actualizar en caché si está disponible
      if (_isCacheAvailable) {
        // Actualizar el plan individual
        await _cache.cacheList([updatedPlan], entity.id);

        // Actualizar en listas cacheadas que puedan contener este plan
        final allCacheKeys = await _cache.getAllCacheKeys();
        for (final key in allCacheKeys) {
          if (key != entity.id && !key.startsWith('count_')) {
            final cachedList = await _cache.getCachedList(key);
            if (cachedList != null) {
              final index = cachedList.indexWhere((p) => p.id == entity.id);
              if (index >= 0) {
                cachedList[index] = updatedPlan;
                await _cache.cacheList(cachedList, key);
              }
            }
          }
        }
      }

      return updatedPlan;
    });
  }

  @override
  Stream<Either<AppFailure, List<PlanWithCreatorEntity>>>
      getPlansWithCreators() {
    logger.d('Iniciando stream de planes con creadores');

    // Crear un nuevo controller
    final controller = StreamController<
        Either<AppFailure, List<PlanWithCreatorEntity>>>.broadcast();

    // Crear consulta Firestore para obtener planes
    final plansQuery = _firestore
        .collection('planes')
        .orderBy('createdAt', descending: true)
        .limit(20); // Limitar a 20 planes por defecto

    // Suscribirse a los cambios en planes
    final subscription = plansQuery.snapshots().listen(
      (planSnapshot) async {
        // Convertir a entidades Plan
        final List<PlanEntity> plans = planSnapshot.docs
            .map((doc) => PlanEntity.fromJson(doc.data()))
            .toList();

        // Recopilar IDs de usuarios únicos
        final Set<String> userIds = plans.map((plan) => plan.creatorId).toSet();

        // Obtener información de usuarios
        final Map<String, UserEntity> usersMap = {};

        // Consultar usuarios en lotes de 10 (límite de Firestore para consultas "in")
        for (int i = 0; i < userIds.length; i += 10) {
          final int end = (i + 10 < userIds.length) ? i + 10 : userIds.length;
          final batch = userIds.skip(i).take(end - i).toList();

          final usersSnapshot = await _firestore
              .collection('usuarios')
              .where(FieldPath.documentId, whereIn: batch)
              .get();

          for (final userDoc in usersSnapshot.docs) {
            final userData = userDoc.data();
            final user = _mapper.fromJson(userData);
            usersMap[userDoc.id] = user;
          }
        }

        // Combinar planes con sus creadores
        final List<PlanWithCreatorEntity> plansWithCreators = plans
            .map((plan) => PlanWithCreatorEntity(
                  plan: plan,
                  creatorData: usersMap[plan.creatorId] != null
                      ? _mapper.toJson(usersMap[plan.creatorId]!)
                      : null,
                ))
            .toList();

        // Enviar al stream
        controller.add(Right(plansWithCreators));
      },
      onError: (error, stackTrace) {
        logger.e('Error en stream de planes con creadores:',
            error: error, stackTrace: stackTrace);
        controller.add(Left(AppFailure(
            message: 'Error en stream de planes: $error',
            code: 'stream_error')));
      },
    );

    // Manejar cierre del controller
    controller.onCancel = () {
      logger.d('Cerrando stream de planes con creadores');
      subscription.cancel();
    };

    return controller.stream;
  }

  /// Método auxiliar para añadir información de creadores a una lista de planes
  Future<List<PlanWithCreatorEntity>> _addCreatorInfoToPlans(
      List<PlanEntity> plans) async {
    final Set<String> userIds = plans.map((plan) => plan.creatorId).toSet();
    final Map<String, UserEntity> usersMap = {};

    // Consultar usuarios en lotes de 10
    for (int i = 0; i < userIds.length; i += 10) {
      final batch = userIds.skip(i).take(10).toList();
      final usersSnapshot = await _firestore
          .collection('usuarios')
          .where(FieldPath.documentId, whereIn: batch)
          .get();

      for (final userDoc in usersSnapshot.docs) {
        final user = _mapper.fromJson(userDoc.data());
        usersMap[userDoc.id] = user;
      }
    }

    // Combinar planes con creadores
    return plans
        .map((plan) => PlanWithCreatorEntity(
              plan: plan,
              creatorData: usersMap[plan.creatorId] != null
                  ? _mapper.toJson(usersMap[plan.creatorId]!)
                  : null,
            ))
        .toList();
  }

  @override
  Future<Either<Failure, Unit>> clearSearchHistory(
      {required String userId}) async {
    return executeWithTryCatchFailure<Unit>('limpiar historial de búsqueda',
        () async {
      await _firestore
          .collection('search_history')
          .where('userId', isEqualTo: userId)
          .get()
          .then((snapshot) {
        for (final doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      // También limpiar del caché local si está disponible
      if (_isCacheAvailable) {
        try {
          final box = await Hive.openBox<List<String>>('search_history');
          await box.delete(userId);
        } catch (e) {
          logger.w('Error al limpiar historial del caché local: $e');
        }
      }

      return unit;
    });
  }

  @override
  Future<Either<Failure, List<PlanWithCreatorEntity>>> filterPlansByCategory(
      {required String category,
      int limit = 20,
      String? lastDocumentId}) async {
    return executeWithTryCatchFailure<List<PlanWithCreatorEntity>>(
        'filtrar planes por categoría', () async {
      // Construir consulta
      Query<Map<String, dynamic>> query = _firestore
          .collection('planes')
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true);

      // Aplicar paginación
      if (lastDocumentId != null) {
        final lastDoc =
            await _firestore.collection('planes').doc(lastDocumentId).get();
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      // Aplicar límite
      query = query.limit(limit);

      // Ejecutar consulta
      final snapshot = await query.get();
      final plans =
          snapshot.docs.map((doc) => PlanEntity.fromJson(doc.data())).toList();

      // Obtener información de creadores
      final result = await _addCreatorInfoToPlans(plans);
      return result;
    });
  }

  @override
  Future<Either<Failure, List<PlanWithCreatorEntity>>> filterPlansByDateRange(
      {required DateTime startDate,
      required DateTime endDate,
      int limit = 20,
      String? lastDocumentId}) async {
    return executeWithTryCatchFailure<List<PlanWithCreatorEntity>>(
        'filtrar planes por rango de fechas', () async {
      // Construir consulta con filtro de fechas
      Query<Map<String, dynamic>> query = _firestore
          .collection('planes')
          .where('startDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('startDate');

      // Aplicar paginación
      if (lastDocumentId != null) {
        final lastDoc =
            await _firestore.collection('planes').doc(lastDocumentId).get();
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      // Aplicar límite
      query = query.limit(limit);

      // Ejecutar consulta
      final snapshot = await query.get();
      final plans =
          snapshot.docs.map((doc) => PlanEntity.fromJson(doc.data())).toList();

      // Obtener información de creadores
      final result = await _addCreatorInfoToPlans(plans);
      return result;
    });
  }

  @override
  Future<Either<Failure, List<PlanWithCreatorEntity>>> filterPlansByLocation(
      {required double latitude,
      required double longitude,
      required double radiusKm,
      int limit = 20,
      String? lastDocumentId}) async {
    return executeWithTryCatchFailure<List<PlanWithCreatorEntity>>(
        'filtrar planes por ubicación', () async {
      // Usar el método existente getNearbyPlans para obtener planes cercanos
      final nearbyPlansResult = await getNearbyPlans(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
        limit: limit,
      );

      // Convertir el resultado a Either<Failure, ...>
      return nearbyPlansResult.fold(
        (failure) => throw Exception(failure.message),
        (plans) async {
          // Aplicar paginación si es necesario
          List<PlanEntity> paginatedPlans = plans;
          if (lastDocumentId != null) {
            final startIndex = plans.indexWhere((p) => p.id == lastDocumentId);
            if (startIndex >= 0 && startIndex < plans.length - 1) {
              paginatedPlans = plans.sublist(startIndex + 1);
            }
          }

          // Obtener información de creadores
          final result = await _addCreatorInfoToPlans(paginatedPlans);
          return result;
        },
      );
    });
  }

  @override
  Future<Either<Failure, List<PlanWithCreatorEntity>>>
      filterPlansByMultipleCategories(
          {required List<String> categories,
          int limit = 20,
          String? lastDocumentId}) async {
    return executeWithTryCatchFailure<List<PlanWithCreatorEntity>>(
        'filtrar planes por múltiples categorías', () async {
      // Construir consulta con filtro de categorías múltiples
      Query<Map<String, dynamic>> query = _firestore
          .collection('planes')
          .where('category', whereIn: categories)
          .orderBy('createdAt', descending: true);

      // Aplicar paginación
      if (lastDocumentId != null) {
        final lastDoc =
            await _firestore.collection('planes').doc(lastDocumentId).get();
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      // Aplicar límite
      query = query.limit(limit);

      // Ejecutar consulta
      final snapshot = await query.get();
      final plans =
          snapshot.docs.map((doc) => PlanEntity.fromJson(doc.data())).toList();

      // Obtener información de creadores
      final result = await _addCreatorInfoToPlans(plans);
      return result;
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCityCoordinates(
      String cityName) async {
    return executeWithTryCatchFailure<Map<String, dynamic>>(
        'obtener coordenadas de ciudad', () async {
      // Implementación básica usando un mapa estático
      // En el futuro se puede integrar con Google Geocoding API
      final Map<String, Map<String, double>> cityCoordinates = {
        'madrid': {'latitude': 40.4168, 'longitude': -3.7038},
        'barcelona': {'latitude': 41.3851, 'longitude': 2.1734},
        'valencia': {'latitude': 39.4699, 'longitude': -0.3763},
        'sevilla': {'latitude': 37.3891, 'longitude': -5.9845},
        'zaragoza': {'latitude': 41.6488, 'longitude': -0.8891},
        'malaga': {'latitude': 36.7213, 'longitude': -4.4217},
        'murcia': {'latitude': 37.9922, 'longitude': -1.1307},
        'palma': {'latitude': 39.5696, 'longitude': 2.6502},
        'las palmas': {'latitude': 28.1248, 'longitude': -15.4300},
        'bilbao': {'latitude': 43.2627, 'longitude': -2.9253},
      };

      final cityKey = cityName.toLowerCase().trim();
      final coordinates = cityCoordinates[cityKey];

      if (coordinates == null) {
        throw Exception('Ciudad no encontrada: $cityName');
      }

      return {
        'latitude': coordinates['latitude']!,
        'longitude': coordinates['longitude']!,
        'cityName': cityName,
      };
    });
  }

  @override
  Future<Either<Failure, List<PlanWithCreatorEntity>>>
      getPopularPlansByCategory(
          {required String category, int limit = 10}) async {
    return executeWithTryCatchFailure<List<PlanWithCreatorEntity>>(
        'obtener planes populares por categoría', () async {
      // Construir consulta para planes populares en una categoría específica
      final query = _firestore
          .collection('planes')
          .where('category', isEqualTo: category)
          .orderBy('likesCount', descending: true)
          .orderBy('participantCount', descending: true)
          .limit(limit);

      // Ejecutar consulta
      final snapshot = await query.get();
      final plans =
          snapshot.docs.map((doc) => PlanEntity.fromJson(doc.data())).toList();

      // Obtener información de creadores
      final result = await _addCreatorInfoToPlans(plans);
      return result;
    });
  }

  @override
  Future<Either<Failure, List<String>>> getSearchHistory(
      {required String userId, int limit = 10}) async {
    return executeWithTryCatchFailure<List<String>>(
        'obtener historial de búsqueda', () async {
      // Intentar obtener del caché local primero
      if (_isCacheAvailable) {
        try {
          final box = await Hive.openBox<List<String>>('search_history');
          final cachedHistory = box.get(userId);
          if (cachedHistory != null && cachedHistory.isNotEmpty) {
            return cachedHistory.take(limit).toList();
          }
        } catch (e) {
          logger.w('Error al obtener historial del caché local: $e');
        }
      }

      // Si no hay en caché, obtener de Firestore
      final snapshot = await _firestore
          .collection('search_history')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      final searchHistory =
          snapshot.docs.map((doc) => doc.data()['query'] as String).toList();

      // Guardar en caché local
      if (_isCacheAvailable) {
        try {
          final box = await Hive.openBox<List<String>>('search_history');
          await box.put(userId, searchHistory);
        } catch (e) {
          logger.w('Error al guardar historial en caché local: $e');
        }
      }

      return searchHistory;
    });
  }

  @override
  Future<Either<Failure, List<String>>> getSearchSuggestions(
      {required String query, int limit = 5}) async {
    return executeWithTryCatchFailure<List<String>>(
        'obtener sugerencias de búsqueda', () async {
      final queryLower = query.toLowerCase();

      // Obtener sugerencias basadas en títulos de planes existentes
      final plansSnapshot = await _firestore.collection('planes').get();

      final Set<String> suggestions = <String>{};

      // Extraer palabras clave de títulos y categorías
      for (final doc in plansSnapshot.docs) {
        final data = doc.data();
        final title = (data['title'] as String? ?? '').toLowerCase();
        final category = (data['category'] as String? ?? '').toLowerCase();
        final description =
            (data['description'] as String? ?? '').toLowerCase();

        // Buscar coincidencias en título
        if (title.contains(queryLower)) {
          final words = title.split(' ');
          for (final word in words) {
            if (word.startsWith(queryLower) &&
                word.length > queryLower.length) {
              suggestions.add(word);
            }
          }
        }

        // Buscar coincidencias en categoría
        if (category.startsWith(queryLower)) {
          suggestions.add(category);
        }

        // Buscar coincidencias en descripción
        if (description.contains(queryLower)) {
          final words = description.split(' ');
          for (final word in words) {
            if (word.startsWith(queryLower) &&
                word.length > queryLower.length) {
              suggestions.add(word);
            }
          }
        }
      }

      // Convertir a lista y limitar resultados
      final suggestionsList = suggestions.toList();
      suggestionsList.sort(); // Ordenar alfabéticamente

      return suggestionsList.take(limit).toList();
    });
  }

  @override
  Future<Either<Failure, List<String>>> getSuggestedCategories(
      {required String userId, int limit = 3}) async {
    return executeWithTryCatchFailure<List<String>>(
        'obtener categorías sugeridas', () async {
      // Obtener historial del usuario para analizar sus preferencias
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data();

      // Obtener categorías preferidas del usuario si existen
      final List<String> userPreferences =
          List<String>.from(userData?['preferredCategories'] ?? []);

      // Obtener categorías de planes en los que ha participado
      final participatingPlansSnapshot = await _firestore
          .collection('planes')
          .where('participants', arrayContains: userId)
          .get();

      final Map<String, int> categoryCount = {};

      // Contar frecuencia de categorías en planes participados
      for (final doc in participatingPlansSnapshot.docs) {
        final category = doc.data()['category'] as String?;
        if (category != null) {
          categoryCount[category] = (categoryCount[category] ?? 0) + 1;
        }
      }

      // Combinar preferencias del usuario con análisis de comportamiento
      final Set<String> suggestedCategories = <String>{};

      // Añadir categorías preferidas del usuario
      suggestedCategories.addAll(userPreferences.take(limit));

      // Añadir categorías más frecuentes en su historial
      final sortedCategories = categoryCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      for (final entry in sortedCategories) {
        if (suggestedCategories.length < limit) {
          suggestedCategories.add(entry.key);
        }
      }

      // Completar con categorías populares si es necesario
      final popularCategories = ['deportes', 'cine', 'comida'];
      for (final category in popularCategories) {
        if (suggestedCategories.length < limit &&
            !suggestedCategories.contains(category)) {
          suggestedCategories.add(category);
        }
      }

      return suggestedCategories.take(limit).toList();
    });
  }

  @override
  Future<Either<Failure, Unit>> saveSearchToHistory(
      {required String userId, required String query}) async {
    return executeWithTryCatchFailure<Unit>('guardar búsqueda en historial',
        () async {
      // Evitar guardar búsquedas vacías o muy cortas
      if (query.trim().length < 2) {
        return unit;
      }

      final queryTrimmed = query.trim().toLowerCase();

      // Verificar si la búsqueda ya existe para evitar duplicados
      final existingSearch = await _firestore
          .collection('search_history')
          .where('userId', isEqualTo: userId)
          .where('query', isEqualTo: queryTrimmed)
          .get();

      if (existingSearch.docs.isNotEmpty) {
        // Si ya existe, actualizar la fecha
        final docId = existingSearch.docs.first.id;
        await _firestore.collection('search_history').doc(docId).update({
          'createdAt': FieldValue.serverTimestamp(),
          'count': FieldValue.increment(1),
        });
      } else {
        // Si no existe, crear nuevo registro
        await _firestore.collection('search_history').add({
          'userId': userId,
          'query': queryTrimmed,
          'createdAt': FieldValue.serverTimestamp(),
          'count': 1,
        });
      }

      // Limpiar historial antiguo (mantener solo los últimos 50)
      final allUserSearches = await _firestore
          .collection('search_history')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      if (allUserSearches.docs.length > 50) {
        final docsToDelete = allUserSearches.docs.skip(50);
        for (final doc in docsToDelete) {
          await doc.reference.delete();
        }
      }

      // Actualizar caché local
      if (_isCacheAvailable) {
        try {
          final box = await Hive.openBox<List<String>>('search_history');
          final currentHistory = box.get(userId) ?? <String>[];

          // Remover si ya existe y añadir al principio
          currentHistory.remove(queryTrimmed);
          currentHistory.insert(0, queryTrimmed);

          // Mantener solo los últimos 20 en caché
          if (currentHistory.length > 20) {
            currentHistory.removeRange(20, currentHistory.length);
          }

          await box.put(userId, currentHistory);
        } catch (e) {
          logger.w('Error al actualizar caché de historial: $e');
        }
      }

      return unit;
    });
  }

  @override
  Future<Either<Failure, List<PlanWithCreatorEntity>>> searchPlans(
      {required String query, int limit = 20, String? lastDocumentId}) async {
    return executeWithTryCatchFailure<List<PlanWithCreatorEntity>>(
        'buscar planes', () async {
      final queryLower = query.toLowerCase();

      // Construir consulta base
      Query<Map<String, dynamic>> firestoreQuery =
          _firestore.collection('planes');

      // Aplicar paginación si se proporciona
      if (lastDocumentId != null) {
        final lastDoc =
            await _firestore.collection('planes').doc(lastDocumentId).get();
        if (lastDoc.exists) {
          firestoreQuery = firestoreQuery.startAfterDocument(lastDoc);
        }
      }

      // Aplicar límite
      firestoreQuery = firestoreQuery.limit(limit);

      // Ejecutar consulta
      final snapshot = await firestoreQuery.get();

      // Filtrar resultados por texto (búsqueda en cliente)
      final filteredPlans = snapshot.docs
          .map((doc) => PlanEntity.fromJson(doc.data()))
          .where((plan) =>
              plan.title.toLowerCase().contains(queryLower) ||
              plan.description.toLowerCase().contains(queryLower) ||
              plan.category.toLowerCase().contains(queryLower) ||
              plan.location.toLowerCase().contains(queryLower))
          .toList();

      // Obtener información de los creadores
      final Set<String> userIds =
          filteredPlans.map((plan) => plan.creatorId).toSet();
      final Map<String, UserEntity> usersMap = {};

      // Consultar usuarios en lotes
      for (int i = 0; i < userIds.length; i += 10) {
        final batch = userIds.skip(i).take(10).toList();
        final usersSnapshot = await _firestore
            .collection('usuarios')
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        for (final userDoc in usersSnapshot.docs) {
          final user = _mapper.fromJson(userDoc.data());
          usersMap[userDoc.id] = user;
        }
      }

      // Combinar planes con creadores
      final result = filteredPlans
          .map((plan) => PlanWithCreatorEntity(
                plan: plan,
                creatorData: usersMap[plan.creatorId] != null
                    ? _mapper.toJson(usersMap[plan.creatorId]!)
                    : null,
              ))
          .toList();

      return result;
    });
  }

  @override
  Future<Either<Failure, List<PlanWithCreatorEntity>>> searchPlansAdvanced(
      {String? query,
      String? category,
      double? latitude,
      double? longitude,
      double? radiusKm,
      DateTime? startDate,
      DateTime? endDate,
      int limit = 20,
      String? lastDocumentId}) async {
    return executeWithTryCatchFailure<List<PlanWithCreatorEntity>>(
        'búsqueda avanzada de planes', () async {
      // Construir consulta base
      Query<Map<String, dynamic>> firestoreQuery =
          _firestore.collection('planes');

      // Aplicar filtro de categoría si se proporciona
      if (category != null && category.isNotEmpty) {
        firestoreQuery = firestoreQuery.where('category', isEqualTo: category);
      }

      // Aplicar filtro de fechas si se proporciona
      if (startDate != null && endDate != null) {
        firestoreQuery = firestoreQuery
            .where('startDate',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where('startDate',
                isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }

      // Ordenar por fecha de creación
      firestoreQuery = firestoreQuery.orderBy('createdAt', descending: true);

      // Aplicar paginación si se proporciona
      if (lastDocumentId != null) {
        final lastDoc =
            await _firestore.collection('planes').doc(lastDocumentId).get();
        if (lastDoc.exists) {
          firestoreQuery = firestoreQuery.startAfterDocument(lastDoc);
        }
      }

      // Aplicar límite
      firestoreQuery =
          firestoreQuery.limit(limit * 2); // Obtener más para filtrar

      // Ejecutar consulta
      final snapshot = await firestoreQuery.get();
      List<PlanEntity> plans =
          snapshot.docs.map((doc) => PlanEntity.fromJson(doc.data())).toList();

      // Filtrar por texto si se proporciona (filtrado en cliente)
      if (query != null && query.isNotEmpty) {
        final queryLower = query.toLowerCase();
        plans = plans
            .where((plan) =>
                plan.title.toLowerCase().contains(queryLower) ||
                plan.description.toLowerCase().contains(queryLower) ||
                plan.category.toLowerCase().contains(queryLower) ||
                plan.location.toLowerCase().contains(queryLower))
            .toList();
      }

      // Filtrar por ubicación si se proporciona (filtrado en cliente)
      if (latitude != null && longitude != null && radiusKm != null) {
        // Como PlanEntity no tiene coordenadas, por ahora filtramos por nombre de ubicación
        // En el futuro se pueden añadir campos latitude/longitude a PlanEntity
        plans = plans.where((plan) {
          // Filtrado temporal por nombre de ubicación que contenga coordenadas como string
          final locationLower = plan.location.toLowerCase();
          final latStr = latitude.toString();
          final lonStr = longitude.toString();

          // Si la ubicación contiene números similares a las coordenadas
          return locationLower.contains(latStr.substring(0, 2)) ||
              locationLower.contains(lonStr.substring(0, 2));
        }).toList();
      }

      // Limitar a la cantidad solicitada
      if (plans.length > limit) {
        plans = plans.take(limit).toList();
      }

      // Obtener información de los creadores
      final result = await _addCreatorInfoToPlans(plans);
      return result;
    });
  }
}
