// lib/core/services/fixed_notification_service_stub.dart
import 'package:flutter/foundation.dart';
import 'package:quien_para/domain/entities/notification/notification_entity.dart';

import '../../domain/interfaces/notification_service_interface.dart';

/// Implementación stub simple de NotificationService que no hace nada
/// pero cumple con la interfaz requerida
class FixedNotificationServiceStub implements NotificationServiceInterface {
  @override
  Future<void> sendNotification(NotificationEntity notification) async {
    // No hace nada, es un stub
    if (kDebugMode) {
      print('📱 NotificationService Stub: Envío de notificación simulado');
      print('  - Usuario: ${notification.userId}');
      print('  - Título: ${notification.title}');
      print('  - Cuerpo: ${notification.message}');
    }
  }

  @override
  Future<void> sendApplicationNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    // No hace nada, es un stub
    if (kDebugMode) {
      print('📱 NotificationService Stub: Notificación de aplicación simulada');
      print('  - Usuario: $userId');
      print('  - Título: $title');
      print('  - Cuerpo: $body');
      print('  - Data: $data');
    }
  }

  @override
  Future<void> sendStatusUpdateNotification({
    required String planId,
    required String planTitle,
    required String applicantId,
    required String status,
  }) async {
    // No hace nada, es un stub
    if (kDebugMode) {
      print('📱 NotificationService Stub: Notificación de estado simulada');
      print('  - Plan: $planTitle');
      print('  - Aplicante: $applicantId');
      print('  - Estado: $status');
    }
  }

  @override
  Future<bool> hasPermission() async {
    // Siempre devuelve true para el stub
    return true;
  }

  @override
  Future<void> requestPermission() async {
    // No hace nada, es un stub
    if (kDebugMode) {
      print('📱 NotificationService Stub: Permisos de notificación simulados');
    }
  }

  @override
  Future<void> initialize() async {
    // No hace nada, es un stub
    if (kDebugMode) {
      print('📱 NotificationService Stub: Inicialización simulada');
    }
  }

  @override
  Future<bool> areNotificationsEnabled() {
    // TODO: implement areNotificationsEnabled
    throw UnimplementedError();
  }

  @override
  Future<void> cancelAllNotifications() {
    // TODO: implement cancelAllNotifications
    throw UnimplementedError();
  }

  @override
  Future<void> cancelNotification(String notificationId) {
    // TODO: implement cancelNotification
    throw UnimplementedError();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future<String?> getToken() {
    // TODO: implement getToken
    throw UnimplementedError();
  }

  @override
  // TODO: implement onNotificationReceived
  Stream<Map<String, dynamic>> get onNotificationReceived =>
      throw UnimplementedError();

  @override
  void registerNotificationListener(Function(NotificationEntity p1) listener) {
    // TODO: implement registerNotificationListener
  }

  @override
  void removeNotificationListener(Function(NotificationEntity p1) listener) {
    // TODO: implement removeNotificationListener
  }

  @override
  Future<bool> requestNotificationPermissions() {
    // TODO: implement requestNotificationPermissions
    throw UnimplementedError();
  }

  @override
  Future<void> scheduleLocalNotification({
    required String id,
    required String title,
    required String body,
    DateTime? scheduledTime,
  }) {
    // TODO: implement scheduleLocalNotification
    throw UnimplementedError();
  }

  @override
  Future<void> setupNotificationHandlers() {
    // TODO: implement setupNotificationHandlers
    throw UnimplementedError();
  }

  @override
  Future<void> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) {
    // TODO: implement showLocalNotification
    throw UnimplementedError();
  }

  @override
  Future<void> subscribeToTopic(String topic) {
    // TODO: implement subscribeToTopic
    throw UnimplementedError();
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) {
    // TODO: implement unsubscribeFromTopic
    throw UnimplementedError();
  }
}
