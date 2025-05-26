// lib/data/mappers/entity_mapper.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quien_para/domain/entities/entity_base.dart';

/// Clase base abstracta para todos los mappers entre entidades y modelos
///
/// Define la interfaz común que todos los mappers deben implementar
/// permitiendo un comportamiento polimórfico y consistente en toda la app.
abstract class EntityMapper<Entity extends EntityBase, Model, JsonType> {
  /// Convierte una entidad de dominio a un modelo de datos
  Model toModel(Entity entity);

  /// Convierte un modelo de datos a una entidad de dominio
  Entity toEntity(Model model);

  /// Convierte un documento de Firestore a una entidad de dominio
  Entity fromFirestore(DocumentSnapshot doc);

  /// Convierte una entidad de dominio a un formato adecuado para Firestore
  Map<String, dynamic> toFirestore(Entity entity);

  /// Convierte una entidad de dominio a formato JSON (para APIs)
  JsonType toJson(Entity entity);

  /// Convierte un JSON a una entidad de dominio
  Entity fromJson(JsonType json);

  /// Convierte una lista de documentos Firestore a una lista de entidades
  List<Entity> fromFirestoreList(List<DocumentSnapshot> docs) {
    return docs.map((doc) => fromFirestore(doc)).toList();
  }

  /// Convierte una lista de entidades a una lista de modelos
  List<Model> toModelList(List<Entity> entities) {
    return entities.map((entity) => toModel(entity)).toList();
  }

  /// Convierte una lista de modelos a una lista de entidades
  List<Entity> toEntityList(List<Model> models) {
    return models.map((model) => toEntity(model)).toList();
  }

  /// Convierte una lista de entidades a una lista de JSONs
  List<JsonType> toJsonList(List<Entity> entities) {
    return entities.map((entity) => toJson(entity)).toList();
  }

  /// Convierte una lista de JSONs a una lista de entidades
  List<Entity> fromJsonList(List<JsonType> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }
}
