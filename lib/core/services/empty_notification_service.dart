// empty_notification_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:quien_para/domain/entities/notification/notification_entity.dart';
import '../../domain/interfaces/notification_service_interface.dart';

/// Implementación vacía del servicio de notificaciones para usar cuando
/// Firebase Messaging está deshabilitado - Implementación completada
class EmptyNotificationService implements NotificationServiceInterface {
  // Lista de listeners para simular el comportamiento
  final List<Function(NotificationEntity)> _listeners = [];

  EmptyNotificationService() {
    if (kDebugMode) {
      print('📱 EmptyNotificationService inicializado - sin operación');
    }
  }

  @override
  Future<void> initialize() async {
    if (kDebugMode) {
      print('EmptyNotificationService: initialize() llamado - sin operación');
    }
    return;
  }

  @override
  Stream<Map<String, dynamic>> get onNotificationReceived =>
      const Stream<Map<String, dynamic>>.empty();

  @override
  Future<String?> getToken() async {
    if (kDebugMode) {
      print('EmptyNotificationService: getToken() llamado - sin operación');
    }
    return null;
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    if (kDebugMode) {
      print(
          'EmptyNotificationService: subscribeToTopic() llamado - sin operación');
    }
    return;
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    if (kDebugMode) {
      print(
          'EmptyNotificationService: unsubscribeFromTopic() llamado - sin operación');
    }
    return;
  }

  @override
  void dispose() {
    if (kDebugMode) {
      print('EmptyNotificationService: dispose() llamado - sin operación');
    }
    _listeners.clear();
  }

  @override
  Future<void> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    if (kDebugMode) {
      print(
          'EmptyNotificationService: showLocalNotification() llamado - sin operación');
    }
    return;
  }

  @override
  Future<void> sendNotification(NotificationEntity notification) async {
    if (kDebugMode) {
      print(
          'EmptyNotificationService: sendNotification() llamado - sin operación');
      print(
          'Notification details: ${notification.title} - ${notification.message}');
    }
    return;
  }

  @override
  Future<void> setupNotificationHandlers() async {
    if (kDebugMode) {
      print(
          'EmptyNotificationService: setupNotificationHandlers() - sin operación');
    }
    return;
  }

  @override
  Future<bool> requestNotificationPermissions() async {
    if (kDebugMode) {
      print(
          'EmptyNotificationService: requestNotificationPermissions() - sin operación');
    }
    // Simular que los permisos fueron concedidos
    return true;
  }

  @override
  Future<void> cancelNotification(String notificationId) async {
    if (kDebugMode) {
      print('EmptyNotificationService: cancelNotification() - sin operación');
    }
    return;
  }

  @override
  Future<void> cancelAllNotifications() async {
    if (kDebugMode) {
      print(
          'EmptyNotificationService: cancelAllNotifications() - sin operación');
    }
    return;
  }

  @override
  Future<void> sendApplicationNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    if (kDebugMode) {
      print(
          'EmptyNotificationService: sendApplicationNotification() - sin operación');
    }
    return;
  }

  @override
  void registerNotificationListener(Function(NotificationEntity) listener) {
    if (kDebugMode) {
      print(
          'EmptyNotificationService: registerNotificationListener() - sin operación');
    }
    _listeners.add(listener);
  }

  @override
  void removeNotificationListener(Function(NotificationEntity) listener) {
    if (kDebugMode) {
      print(
          'EmptyNotificationService: removeNotificationListener() - sin operación');
    }
    _listeners.remove(listener);
  }

  @override
  Future<void> scheduleLocalNotification({
    required String id,
    required String title,
    required String body,
    DateTime? scheduledTime,
  }) async {
    if (kDebugMode) {
      print(
          'EmptyNotificationService: scheduleLocalNotification() - sin operación');
    }
    return;
  }

  @override
  Future<bool> areNotificationsEnabled() async {
    if (kDebugMode) {
      print(
          'EmptyNotificationService: areNotificationsEnabled() - sin operación');
    }
    // Simular que las notificaciones están deshabilitadas
    return false;
  }
}
