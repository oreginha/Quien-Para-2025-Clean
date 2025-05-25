// lib/data/repositories/notification_repository_impl.dart

// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:quien_para/core/logger/logger.dart' as app_logger;
import 'package:quien_para/core/services/notification_api_service.dart';
import 'package:quien_para/data/datasources/local/cache_interface.dart';
import 'package:quien_para/data/mappers/notification_mapper.dart';
import 'package:quien_para/domain/entities/notification/notification_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/domain/failures/failure_helper.dart'
    as failure_helper;
import 'package:quien_para/domain/interfaces/notification_repository_interface.dart';

/// Implementación del repositorio de notificaciones
class NotificationRepositoryImpl implements INotificationRepository {
  final FirebaseFirestore _firestore;
  final NotificationApiService _apiService;
  final Cache<NotificationEntity>? _cache;
  final NotificationMapper _mapper;
  final String _collection;
  late final Logger _logger;

  bool get _isCacheAvailable => _cache != null && _cache!.isAvailable;

  // Controladores de streams para notificaciones por usuario
  final Map<String,
          StreamController<Either<AppFailure, List<NotificationEntity>>>>
      _notificationStreams = {};

  /// Constructor
  NotificationRepositoryImpl({
    required FirebaseFirestore firestore,
    required NotificationApiService apiService,
    Cache<NotificationEntity>? cache,
    NotificationMapper? mapper,
    String collection = 'notifications',
  })  : _firestore = firestore,
        _apiService = apiService,
        _cache = cache,
        _mapper = mapper ?? const NotificationMapper(),
        _collection = collection {
    _logger = app_logger.logger as Logger;
    _logger.d(
        'NotificationRepositoryImpl initialized: Cache available: $_isCacheAvailable');
  }

  @override
  Future<Either<AppFailure, Unit>> initialize() async {
    try {
      // Aquí puedes inicializar lo que necesites
      return const Right(unit);
    } catch (e, stackTrace) {
      _logger.e('Error initializing notification repository:',
          error: e, stackTrace: stackTrace);
      return Left(failure_helper.FailureHelper.fromException(e, stackTrace));
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      // Implementa la obtención del token FCM si es necesario
      return null;
    } catch (e, stackTrace) {
      _logger.e('Error getting FCM token:', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<Either<AppFailure, Unit>> subscribeToTopic(String topic) async {
    try {
      await _apiService.subscribeToTopic(topic);
      return const Right(unit);
    } catch (e, stackTrace) {
      _logger.e('Error subscribing to topic:',
          error: e, stackTrace: stackTrace);
      return Left(failure_helper.FailureHelper.fromException(e, stackTrace));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> unsubscribeFromTopic(String topic) async {
    try {
      await _apiService.unsubscribeFromTopic(topic);
      return const Right(unit);
    } catch (e, stackTrace) {
      _logger.e('Error unsubscribing from topic:',
          error: e, stackTrace: stackTrace);
      return Left(failure_helper.FailureHelper.fromException(e, stackTrace));
    }
  }

  @override
  void dispose() {
    for (final controller in _notificationStreams.values) {
      controller.close();
    }
    _notificationStreams.clear();
  }

  @override
  Stream<Map<String, dynamic>> get onNotificationReceived =>
      _apiService.onNotificationReceived;

  @override
  Future<Either<AppFailure, Unit>> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    try {
      await _apiService.showLocalNotification(
        title: title,
        body: body,
        payload: payload,
      );
      return const Right(unit);
    } catch (e, stackTrace) {
      _logger.e('Error showing local notification:',
          error: e, stackTrace: stackTrace);
      return Left(failure_helper.FailureHelper.fromException(e, stackTrace));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> markNotificationAsRead(
      String notificationId) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(notificationId)
          .update({'read': true});

      if (_isCacheAvailable) {
        final cachedItems = await _cache!.getCachedItems();
        if (cachedItems != null) {
          final index = cachedItems.indexWhere((n) => n.id == notificationId);
          if (index != -1) {
            cachedItems[index] = cachedItems[index].copyWith(read: true);
            await _cache!.cacheItems(cachedItems);
          }
        }
      }

      return const Right(unit);
    } catch (e, stackTrace) {
      _logger.e('Error marking notification as read:',
          error: e, stackTrace: stackTrace);
      return Left(failure_helper.FailureHelper.fromException(e, stackTrace));
    }
  }

  Future<Either<AppFailure, Unit>> markAllNotificationsAsRead() async {
    try {
      final batch = _firestore.batch();

      final querySnapshot = await _firestore
          .collection(_collection)
          .where('read', isEqualTo: false)
          .get();

      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {'read': true});
      }

      await batch.commit();

      if (_isCacheAvailable) {
        final cachedItems = await _cache!.getCachedItems();
        if (cachedItems != null) {
          for (var i = 0; i < cachedItems.length; i++) {
            cachedItems[i] = cachedItems[i].copyWith(read: true);
          }
          await _cache!.cacheItems(cachedItems);
        }
      }

      return const Right(unit);
    } catch (e, stackTrace) {
      _logger.e('Error marking all notifications as read:',
          error: e, stackTrace: stackTrace);
      return Left(failure_helper.FailureHelper.fromException(e, stackTrace));
    }
  }

  Future<Either<AppFailure, Unit>> deleteNotification(
      String notificationId) async {
    try {
      await _firestore.collection(_collection).doc(notificationId).delete();

      if (_isCacheAvailable) {
        final cachedItems = await _cache!.getCachedItems();
        if (cachedItems != null) {
          cachedItems.removeWhere((n) => n.id == notificationId);
          await _cache!.cacheItems(cachedItems);
        }
      }

      return const Right(unit);
    } catch (e, stackTrace) {
      _logger.e('Error deleting notification:',
          error: e, stackTrace: stackTrace);
      return Left(failure_helper.FailureHelper.fromException(e, stackTrace));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> createNotification(
      NotificationEntity notification) async {
    try {
      final docRef = _firestore.collection(_collection).doc();
      final notificationWithId = notification.copyWith(id: docRef.id);

      await docRef.set(_mapper.toFirestore(notificationWithId));

      if (_isCacheAvailable) {
        final cachedItems = await _cache!.getCachedItems() ?? [];
        cachedItems.add(notificationWithId);
        await _cache!.cacheItems(cachedItems);
      }

      return const Right(unit);
    } catch (e, stackTrace) {
      _logger.e('Error creating notification:',
          error: e, stackTrace: stackTrace);
      return Left(failure_helper.FailureHelper.fromException(e, stackTrace));
    }
  }

  @override
  Future<Either<AppFailure, List<NotificationEntity>>> getNotificationsForUser(
    String userId, {
    int? limit = 20,
    bool includeRead = false,
  }) async {
    try {
      _logger.d('Obteniendo notificaciones para usuario: $userId');

      // Intentar obtener de caché si está disponible y queremos todas las notificaciones
      if (includeRead && _isCacheAvailable) {
        final cachedItems = await _cache!.getCachedItems(key: userId);
        if (cachedItems != null) {
          _logger.d('Notificaciones obtenidas de caché: ${cachedItems.length}');
          return Right(cachedItems.take(limit ?? 20).toList());
        }
      }

      // Obtener de Firestore
      final QuerySnapshot<Map<String, dynamic>> snapshot;
      try {
        Query<Map<String, dynamic>> query = _firestore
            .collection(_collection)
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .limit(limit ?? 20);

        if (!includeRead) {
          query = query.where('read', isEqualTo: false);
        }

        snapshot = await query.get();
      } catch (e) {
        _logger.e('Error al obtener notificaciones de Firestore: $e');
        return Left(DatabaseFailure(
          message: 'Error al obtener notificaciones',
          code: 'get-notifications-failed',
        ));
      }

      final List<NotificationEntity> notifications =
          snapshot.docs.map((doc) => _mapper.fromFirestore(doc)).toList();

      // Guardar en caché si incluye todas las notificaciones
      if (includeRead && _isCacheAvailable) {
        await _cache!.cacheItems(notifications, key: userId);
      }

      return Right(notifications);
    } catch (e, stackTrace) {
      _logger.e('Error al obtener notificaciones: $e\n$stackTrace');
      return Left(failure_helper.FailureHelper.fromException(e, stackTrace));
    }
  }

  @override
  Future<Either<AppFailure, int>> getUnreadNotificationCount(
      String userId) async {
    try {
      _logger.d(
          'Obteniendo conteo de notificaciones no leídas para: $userId'); // Intentar obtener de caché si está disponible
      if (_isCacheAvailable) {
        final cachedCount = await _cache!.getCachedCount(key: '$userId:unread');
        if (cachedCount != null) {
          _logger.d('Conteo obtenido de caché: $cachedCount');
          return Right(cachedCount);
        }
      }

      // Obtener de Firestore usando count()
      final aggregateQuery = _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('read', isEqualTo: false);

      final aggregateSnapshot = await aggregateQuery.count().get();
      final count = aggregateSnapshot.count ?? 0; // Guardar en caché
      if (_isCacheAvailable) {
        await _cache!.cacheCount(count, key: '$userId:unread');
      }

      return Right(count);
    } catch (e, stackTrace) {
      _logger.e('Error al obtener conteo de notificaciones: $e\n$stackTrace');
      return Left(failure_helper.FailureHelper.fromException(e, stackTrace));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> cleanupOldNotifications(
      int olderThanDays) async {
    try {
      _logger.d('Limpiando notificaciones antiguas (> $olderThanDays días)');

      // Calcular fecha límite
      final limitDate = DateTime.now().subtract(Duration(days: olderThanDays));

      // Consultar notificaciones antiguas
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('createdAt', isLessThan: limitDate)
          .get();

      if (querySnapshot.docs.isEmpty) {
        _logger.d('No hay notificaciones antiguas para eliminar');
        return const Right(unit);
      }

      _logger
          .d('Eliminando ${querySnapshot.docs.length} notificaciones antiguas');

      // Usar batch para eliminar en grupo
      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      // Actualizar caché si está disponible
      if (_isCacheAvailable) {
        final cachedItems = await _cache!.getCachedItems();
        if (cachedItems != null) {
          cachedItems.removeWhere(
              (notification) => notification.createdAt.isBefore(limitDate));
          await _cache!.cacheItems(cachedItems);
        }
      }

      return const Right(unit);
    } catch (e, stackTrace) {
      _logger.e('Error al limpiar notificaciones antiguas:',
          error: e, stackTrace: stackTrace);
      return Left(failure_helper.FailureHelper.fromException(e, stackTrace));
    }
  }

  @override
  Stream<Either<AppFailure, List<NotificationEntity>>> getNotificationsStream(
      String userId,
      {bool includeRead = false}) {
    try {
      _logger.d('Iniciando stream de notificaciones para usuario: $userId');

      // Verificar si ya existe un stream para este usuario
      if (_notificationStreams.containsKey(userId)) {
        _logger.d('Devolviendo stream existente para $userId');
        return _notificationStreams[userId]!.stream;
      }

      // Crear un nuevo stream controller
      final controller = StreamController<
          Either<AppFailure, List<NotificationEntity>>>.broadcast();
      _notificationStreams[userId] = controller;

      // Crear consulta Firestore
      Query<Map<String, dynamic>> query = _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true);

      if (!includeRead) {
        query = query.where('read', isEqualTo: false);
      }

      // Suscribirse a los cambios
      final subscription = query.snapshots().listen(
        (snapshot) {
          final List<NotificationEntity> notifications =
              snapshot.docs.map((doc) => _mapper.fromFirestore(doc)).toList();

          // Actualizar caché si es necesario
          if (_isCacheAvailable) {
            _cache!.cacheItems(notifications, key: userId);
          }

          // Enviar al stream
          controller.add(Right(notifications));
        },
        onError: (error, stackTrace) {
          _logger.e('Error en stream de notificaciones:',
              error: error, stackTrace: stackTrace);
          controller.add(Left(
              failure_helper.FailureHelper.fromException(error, stackTrace)));
        },
      );

      // Manejar cierre del controller
      controller.onCancel = () {
        _logger.d('Cerrando stream de notificaciones para $userId');
        subscription.cancel();
        _notificationStreams.remove(userId);
      };

      return controller.stream;
    } catch (e, stackTrace) {
      _logger.e('Error al crear stream de notificaciones:',
          error: e, stackTrace: stackTrace);

      // Crear un stream con error
      final controller = StreamController<
          Either<AppFailure, List<NotificationEntity>>>.broadcast();
      controller.addError(e, stackTrace);
      controller.close();
      return controller.stream;
    }
  }

  @override
  Future<Either<AppFailure, Unit>> markAllAsRead(String userId) async {
    try {
      _logger.d(
          'Marcando todas las notificaciones como leídas para usuario: $userId');

      // Obtener todas las notificaciones no leídas del usuario
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('read', isEqualTo: false)
          .get();

      if (querySnapshot.docs.isEmpty) {
        _logger.d('No hay notificaciones sin leer para el usuario $userId');
        return const Right(unit);
      }

      _logger.d(
          'Marcando ${querySnapshot.docs.length} notificaciones como leídas');

      // Usar batch para actualizar en grupo
      final batch = _firestore.batch();
      final timestamp = DateTime.now();

      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {
          'read': true,
          'readAt': timestamp,
        });
      }

      await batch.commit();

      // Actualizar caché si está disponible
      if (_isCacheAvailable) {
        final cachedItems = await _cache!.getCachedItems(key: userId);
        if (cachedItems != null) {
          for (var i = 0; i < cachedItems.length; i++) {
            if (!cachedItems[i].read) {
              cachedItems[i] = cachedItems[i].copyWith(
                read: true,
                // readAt: timestamp, // Removed because 'readAt' is not a defined parameter
              );
            }
          }
          await _cache!.cacheItems(cachedItems, key: userId);

          // Actualizar contador de no leídos a cero
          await _cache!.cacheCount(0, key: '$userId:unread');
        }
      }

      return const Right(unit);
    } catch (e, stackTrace) {
      _logger.e('Error al marcar todas las notificaciones como leídas:',
          error: e, stackTrace: stackTrace);
      return Left(failure_helper.FailureHelper.fromException(e, stackTrace));
    }
  }

  @override
  Future<Either<AppFailure, List<NotificationEntity>>> getNotificationsForPlan(
      String planId) async {
    try {
      _logger.d('Fetching notifications for plan: $planId');

      final querySnapshot = await _firestore
          .collection(_collection)
          .where('planId', isEqualTo: planId)
          .orderBy('createdAt', descending: true)
          .get();

      final notifications = querySnapshot.docs
          .map((doc) => _mapper.fromFirestore(doc))
          .where((notification) => notification != null)
          .cast<NotificationEntity>()
          .toList();

      _logger.d('Found ${notifications.length} notifications for plan $planId');
      return Right(notifications);
    } catch (e, stackTrace) {
      _logger.e('Error fetching notifications for plan:',
          error: e, stackTrace: stackTrace);
      return Left(failure_helper.FailureHelper.fromException(e, stackTrace));
    }
  }
}
