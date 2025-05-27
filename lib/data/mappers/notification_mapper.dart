// lib/data/mappers/notification_mapper.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quien_para/data/mappers/entity_mapper.dart';
import 'package:quien_para/data/models/notification/notification_model.dart';
import 'package:quien_para/domain/entities/notification/notification_entity.dart';

/// Mapper para convertir entre NotificationEntity y formatos de datos.
///
/// Este mapper implementa EntityMapper y se encarga de la conversión
/// entre la entidad de dominio y los formatos de datos que se usan
/// en las capas de datos.
class NotificationMapper
    implements
        EntityMapper<NotificationEntity, NotificationModel,
            Map<String, dynamic>> {
  const NotificationMapper();

  @override
  List<NotificationEntity> fromFirestoreList(List<DocumentSnapshot> docs) {
    return docs.map((doc) => fromFirestore(doc)).toList();
  }

  @override
  List<NotificationEntity> fromJsonList(List<Map<String, dynamic>> jsonList) {
    return jsonList
        .map((json) => toEntity(NotificationModel.fromJson(json)))
        .toList();
  }

  @override
  List<NotificationEntity> toEntityList(List<NotificationModel> models) {
    return models.map((model) => toEntity(model)).toList();
  }

  @override
  List<Map<String, dynamic>> toJsonList(List<NotificationEntity> entities) {
    return entities.map((entity) => toModel(entity).toJson()).toList();
  }

  @override
  List<NotificationModel> toModelList(List<NotificationEntity> entities) {
    return entities.map((entity) => toModel(entity)).toList();
  }

  @override
  NotificationModel toModel(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      userId: entity.userId,
      title: entity.title,
      body: entity.message,
      createdAt: entity.createdAt,
      read: entity.read,
      type: entity.type,
      data: entity.data,
    );
  }

  @override
  NotificationEntity toEntity(NotificationModel model) {
    return NotificationEntity(
      id: model.id,
      userId: model.userId,
      title: model.title,
      message: model.body,
      read: model.read,
      createdAt: model.createdAt,
      type: model.type.toString(),
      data: model.data,
    );
  }

  @override
  NotificationEntity fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Convertir la marca de tiempo de Firestore a DateTime si existe
    if (data['createdAt'] is Timestamp) {
      final DateTime dateTime = (data['createdAt'] as Timestamp).toDate();
      data['createdAt'] = dateTime.toIso8601String();
    }

    // Asegurar que el ID esté presente
    data['id'] = doc.id;

    // Crear modelo y convertirlo a entidad
    final NotificationModel model = NotificationModel.fromJson(data);
    return toEntity(model);
  }

  @override
  Map<String, dynamic> toFirestore(NotificationEntity entity) {
    final NotificationModel model = toModel(entity);
    final Map<String, dynamic> data = model.toJson();
    data.remove('id'); // No guardamos el ID en el documento

    // Convertir DateTime a Timestamp para Firestore
    data['createdAt'] = Timestamp.fromDate(entity.createdAt);

    return data;
  }

  @override
  Map<String, dynamic> toJson(NotificationEntity entity) {
    return toModel(entity).toJson();
  }

  @override
  NotificationEntity fromJson(Map<String, dynamic> json) {
    return toEntity(NotificationModel.fromJson(json));
  }
}
