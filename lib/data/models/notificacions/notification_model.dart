// lib/data/models/notification_model.dart
// ignore_for_file: always_specify_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const NotificationModel._();

  const factory NotificationModel({
    required String id,
    required String userId,
    String? planId,
    String? applicationId,
    required String title,
    required String message,
    @Default(false) bool read,
    required DateTime createdAt,
    @Default('info') String type, // info, plan_update, application, chat, etc.
    Map<String, dynamic>? data, // datos adicionales específicos
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(_prepareJson(json));

  // Método para preparar el JSON antes de deserializarlo
  static Map<String, dynamic> _prepareJson(Map<String, dynamic> json) {
    final result = Map<String, dynamic>.from(json);

    // Convertir Timestamp a String ISO8601 para createdAt
    if (json['createdAt'] is Timestamp) {
      result['createdAt'] =
          (json['createdAt'] as Timestamp).toDate().toIso8601String();
    }

    return result;
  }

  // Método para convertir a formato Firestore
  Map<String, dynamic> toFirestore() {
    return toJson()
      ..remove('id') // No guardamos el ID en el documento
      ..update('createdAt', (value) => FieldValue.serverTimestamp());
  }

  // Método para crear desde Firestore
  static NotificationModel fromFirestore(String id, Map<String, dynamic> data) {
    return NotificationModel.fromJson({
      'id': id,
      ...data,
      'createdAt': data['createdAt'] is Timestamp
          ? data['createdAt'].toDate().toIso8601String()
          : DateTime.now().toIso8601String(),
    });
  }
}
