// lib/domain/entities/notification_entity.dart

import 'package:quien_para/domain/entities/entity_base.dart';

/// Entidad de dominio que representa una notificación en la aplicación
class NotificationEntity extends EntityBase {
  final String userId;
  final String? planId;
  final String? applicationId;
  final String title;
  final String message;
  final bool read;
  final DateTime createdAt;
  final String type; // info, plan_update, application, chat, etc.
  final Map<String, dynamic>? data; // datos adicionales específicos

  /// Constructor
  const NotificationEntity({
    required super.id,
    required this.userId,
    this.planId,
    this.applicationId,
    required this.title,
    required this.message,
    this.read = false,
    required this.createdAt,
    this.type = 'info',
    this.data,
  });

  /// Constructor para crear una notificación vacía
  factory NotificationEntity.empty() => NotificationEntity(
        id: '',
        userId: '',
        title: '',
        message: '',
        createdAt: DateTime.now(),
      );

  /// Crear una copia de esta entidad con campos específicos modificados
  NotificationEntity copyWith({
    String? id,
    String? userId,
    String? planId,
    String? applicationId,
    String? title,
    String? message,
    bool? read,
    DateTime? createdAt,
    String? type,
    Map<String, dynamic>? data,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      planId: planId ?? this.planId,
      applicationId: applicationId ?? this.applicationId,
      title: title ?? this.title,
      message: message ?? this.message,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      data: data ?? this.data,
    );
  }

  /// Marcar como leído
  NotificationEntity markAsRead() {
    return copyWith(read: true);
  }

  @override
  bool get isEmpty => userId.isEmpty && title.isEmpty && message.isEmpty;

  @override
  bool get isValid =>
      id.isNotEmpty &&
      userId.isNotEmpty &&
      title.isNotEmpty &&
      message.isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        userId,
        planId,
        applicationId,
        title,
        message,
        read,
        createdAt,
        type,
        data,
      ];

  /// Convertir la entidad a un mapa para almacenamiento
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'planId': planId,
      'applicationId': applicationId,
      'title': title,
      'message': message,
      'read': read,
      'createdAt': createdAt.toIso8601String(),
      'type': type,
      'data': data,
    };
  }

  /// Crear una entidad desde un mapa
  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      id: json['id'] as String,
      userId: json['userId'] as String,
      planId: json['planId'] as String?,
      applicationId: json['applicationId'] as String?,
      title: json['title'] as String,
      message: json['message'] as String,
      read: json['read'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      type: json['type'] as String? ?? 'info',
      data: json['data'] as Map<String, dynamic>?,
    );
  }
}
