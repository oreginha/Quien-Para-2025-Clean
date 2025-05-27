// lib/data/datasources/local/notification_cache.dart
// ignore_for_file: always_specify_types

import 'dart:io';
import '../../../core/logger/logger.dart';
import '../../../domain/entities/notification/notification_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'cache_interface.dart';

/// Clase para manejar la caché de notificaciones
class NotificationCache implements Cache<NotificationEntity> {
  static const String _notificationsCacheBox = 'notifications_cache';
  static const String _lastFetchKey = 'notification_last_fetch_time';
  static const Duration _cacheDuration = Duration(minutes: 30);

  static bool _initialized = false;
  late Box<dynamic> _box;

  @override
  bool get isAvailable =>
      _initialized && Hive.isBoxOpen(_notificationsCacheBox);

  /// Inicializar Hive de forma segura
  @override
  Future<void> init() async {
    try {
      if (!_initialized) {
        try {
          final Directory appDir = await getApplicationDocumentsDirectory();
          await Hive.initFlutter(appDir.path);
        } catch (e) {
          logger.w(
            'Path provider no disponible, usando inicialización básica de Hive',
          );
          await Hive.initFlutter();
        }

        try {
          _box = await Hive.openBox<dynamic>(_notificationsCacheBox);
          _initialized = true;
          logger.d('Notification cache initialized successfully');
        } catch (boxError) {
          logger.e('Error opening Hive box:', error: boxError);
          _initialized = false;
        }
      }
    } catch (e) {
      logger.e('Error initializing notification cache:', error: e);
      _initialized = false;
    }
  }

  @override
  Future<void> cacheItems(List<NotificationEntity> items, {String? key}) async {
    if (!isAvailable) return;

    try {
      final String cacheKey = key ?? _lastFetchKey;
      await _box.put(cacheKey, items.map((e) => e.toJson()).toList());
      await _box.put('${cacheKey}_timestamp', DateTime.now().toIso8601String());
    } catch (e) {
      logger.e('Error caching notifications:', error: e);
    }
  }

  @override
  Future<List<NotificationEntity>?> getCachedItems({String? key}) async {
    if (!isAvailable) return null;

    try {
      final String cacheKey = key ?? _lastFetchKey;
      final List<dynamic>? data = _box.get(cacheKey);
      if (data == null) return null;

      return data
          .map(
            (item) => NotificationEntity.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      logger.e('Error retrieving cached notifications:', error: e);
      return null;
    }
  }

  @override
  Future<void> invalidateCache({String? key}) async {
    if (!isAvailable) return;
    final String cacheKey = key ?? _lastFetchKey;
    await _box.delete(cacheKey);
    await _box.delete('${cacheKey}_timestamp');
  }

  @override
  Future<void> clearCache() async {
    if (!isAvailable) return;
    await _box.clear();
  }

  @override
  Future<bool> hasCachedItems({String? key}) async {
    if (!isAvailable) return false;

    try {
      final String cacheKey = key ?? _lastFetchKey;
      final timestamp = await getLastUpdateTime(key: cacheKey);
      if (timestamp == null) return false;

      return DateTime.now().difference(timestamp) <= _cacheDuration;
    } catch (e) {
      logger.e('Error checking cached items:', error: e);
      return false;
    }
  }

  @override
  Future<DateTime?> getLastUpdateTime({String? key}) async {
    if (!isAvailable) return null;

    try {
      final String cacheKey = key ?? _lastFetchKey;
      final String? timestamp = _box.get('${cacheKey}_timestamp');
      if (timestamp == null) return null;

      return DateTime.parse(timestamp);
    } catch (e) {
      logger.e('Error getting last update time:', error: e);
      return null;
    }
  }

  @override
  Future<void> setExpirationTime(int seconds, {String? key}) async {
    if (!isAvailable) return;
    final String cacheKey = key ?? _lastFetchKey;
    await _box.put('${cacheKey}_expiration', seconds);
  }

  /// Obtiene el conteo de notificaciones no leídas desde la caché
  Future<int?> getCachedUnreadCount(String userId) async {
    if (!isAvailable) return null;

    try {
      final String cacheKey = '${userId}_unread_count';
      return _box.get(cacheKey) as int?;
    } catch (e) {
      logger.e('Error getting unread count from cache:', error: e);
      return null;
    }
  }

  /// Guarda el conteo de notificaciones no leídas en la caché
  Future<void> cacheUnreadCount(String userId, int count) async {
    if (!isAvailable) return;

    try {
      final String cacheKey = '${userId}_unread_count';
      await _box.put(cacheKey, count);
      await _box.put('${cacheKey}_timestamp', DateTime.now().toIso8601String());
    } catch (e) {
      logger.e('Error caching unread count:', error: e);
    }
  }

  /// Obtiene la lista de notificaciones no leídas para un usuario específico
  Future<List<NotificationEntity>?> getUnreadNotifications(
    String userId,
  ) async {
    final notifications = await getCachedItems(key: userId);
    if (notifications == null) return null;

    return notifications.where((notification) => !notification.read).toList();
  }

  /// Invalida el conteo de no leídas para un usuario específico
  Future<void> invalidateUnreadCount(String userId) async {
    if (!isAvailable) return;

    try {
      final String cacheKey = '${userId}_unread_count';
      await _box.delete(cacheKey);
      await _box.delete('${cacheKey}_timestamp');
    } catch (e) {
      logger.e('Error invalidating unread count:', error: e);
    }
  }

  /// Invalida la caché de todas las notificaciones de un usuario
  Future<void> invalidateNotificationsCache(String userId) async {
    if (!isAvailable) return;

    try {
      await invalidateCache(key: userId);
      logger.d('Caché de notificaciones invalidada para el usuario: $userId');
    } catch (e) {
      logger.e('Error invalidando caché de notificaciones:', error: e);
    }
  }

  /// Invalida la caché del conteo de notificaciones no leídas de un usuario
  Future<void> invalidateUnreadCountCache(String userId) async {
    if (!isAvailable) return;

    try {
      await invalidateUnreadCount(userId);
      logger.d('Caché de conteo no leído invalidada para el usuario: $userId');
    } catch (e) {
      logger.e('Error invalidando caché de conteo no leído:', error: e);
    }
  }

  /// Invalida la caché de una notificación específica
  Future<void> invalidateNotificationCache(String notificationId) async {
    if (!isAvailable) return;

    try {
      // Aquí necesitamos obtener todas las notificaciones, quitar la específica y volver a guardar
      final notifications = await getCachedItems();
      if (notifications != null) {
        final updatedNotifications =
            notifications.where((n) => n.id != notificationId).toList();
        await cacheItems(updatedNotifications);
        logger.d(
          'Caché de notificación específica invalidada: $notificationId',
        );
      }
    } catch (e) {
      logger.e('Error invalidando caché de notificación específica:', error: e);
    }
  }

  /// Guarda una notificación individual en la caché
  Future<void> cacheNotification(NotificationEntity notification) async {
    if (!isAvailable) return;

    try {
      // Obtener las notificaciones existentes del usuario
      final notifications =
          await getCachedItems(key: notification.userId) ?? [];

      // Actualizar o añadir la notificación
      final index = notifications.indexWhere((n) => n.id == notification.id);
      if (index >= 0) {
        notifications[index] = notification;
      } else {
        notifications.add(notification);
      }

      // Guardar la lista actualizada
      await cacheItems(notifications, key: notification.userId);

      logger.d('Notificación guardada en caché: ${notification.id}');
    } catch (e) {
      logger.e('Error guardando notificación en caché:', error: e);
    }
  }

  @override
  Future<void> cacheCount(int count, {String? key}) async {
    if (!isAvailable) return;

    try {
      final String cacheKey = key ?? 'default_count';
      await _box.put(cacheKey, count);
      await _box.put('${cacheKey}_timestamp', DateTime.now().toIso8601String());
      logger.d('Contador guardado en caché ($cacheKey): $count');
    } catch (e) {
      logger.e('Error al guardar contador en caché:', error: e);
    }
  }

  @override
  Future<int?> getCachedCount({String? key}) async {
    if (!isAvailable) return null;

    try {
      final String cacheKey = key ?? 'default_count';
      final int? count = _box.get(cacheKey) as int?;

      if (count != null) {
        logger.d('Contador recuperado de caché ($cacheKey): $count');
      } else {
        logger.d('No se encontró contador en caché: $cacheKey');
      }

      return count;
    } catch (e) {
      logger.e('Error al obtener contador de caché:', error: e);
      return null;
    }
  }

  @override
  Future<void> invalidateCount({String? key}) async {
    if (!isAvailable) return;

    try {
      final String cacheKey = key ?? 'default_count';
      await _box.delete(cacheKey);
      await _box.delete('${cacheKey}_timestamp');
      logger.d('Contador invalidado en caché: $cacheKey');
    } catch (e) {
      logger.e('Error al invalidar contador en caché:', error: e);
    }
  }
}
