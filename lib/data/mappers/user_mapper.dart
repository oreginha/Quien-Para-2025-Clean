// lib/data/mappers/user_mapper.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quien_para/data/mappers/entity_mapper.dart';
import 'package:quien_para/data/models/user/user_model.dart';
import 'package:quien_para/domain/entities/user/user_entity.dart';

/// Clase responsable de transformar entre UserEntity (dominio) y UserModel (datos)
///
/// Esta clase centraliza toda la lógica de transformación entre la capa de dominio y
/// la capa de datos para las entidades de usuario.
class UserMapper
    implements EntityMapper<UserEntity, UserModel, Map<String, dynamic>> {
  const UserMapper();

  /// Convierte un UserEntity (dominio) a UserModel (datos)
  ///
  /// Usado cuando se envían datos del dominio a la capa de persistencia
  @override
  UserModel toModel(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name ?? '',
      email: entity.email ?? '',
      age: entity.age ?? 0,
      photoUrls: entity.photoUrls ?? [],
      interests: entity.interests ?? [],
      bio: entity.bio,
      isVisible: true, // Por defecto los usuarios son visibles
      hasCompletedOnboarding:
          entity.interests != null && entity.interests!.isNotEmpty,
      createdAt: entity.createdAt,
      lastLogin: entity.updatedAt,
    );
  }

  /// Convierte un UserModel (datos) a UserEntity (dominio)
  ///
  /// Usado cuando se recuperan datos de la capa de persistencia para su uso en el dominio
  @override
  UserEntity toEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      name: model.name,
      email: model.email,
      age: model.age,
      photoUrl: model.photoUrls.isNotEmpty ? model.photoUrls.first : null,
      photoUrls: model.photoUrls,
      interests: model.interests,
      bio: model.bio,
      createdAt: model.createdAt,
      updatedAt: model.lastLogin,
    );
  }

  /// Convierte un documento de Firestore directamente a UserEntity
  ///
  /// Simplifica el proceso de transformación entre Firestore y el dominio
  @override
  UserEntity fromFirestore(DocumentSnapshot doc) {
    if (!doc.exists) {
      return UserEntity(); // Devolver entidad vacía si el documento no existe
    }

    final data = doc.data() as Map<String, dynamic>;

    // Usar el modelo como paso intermedio para una transformación más segura
    final model = UserModelX.fromFirestore(doc.id, data);
    return toEntity(model);
  }

  /// Convierte una lista de documentos de Firestore a una lista de entidades
  @override
  List<UserEntity> fromFirestoreList(List<DocumentSnapshot> docs) {
    return docs.map((doc) => fromFirestore(doc)).toList();
  }

  /// Transforma una entidad a un formato adecuado para Firestore
  @override
  Map<String, dynamic> toFirestore(UserEntity entity) {
    return {
      'name': entity.name ?? '',
      'email': entity.email ?? '',
      'age': entity.age ?? 0,
      'photoUrls': entity.photoUrls ?? [],
      'interests': entity.interests ?? [],
      'bio': entity.bio,
      'gender': entity.gender,
      'location': entity.location,
      'orientation': entity.orientation,
      'isVisible': true,
      'hasCompletedOnboarding':
          entity.interests != null && entity.interests!.isNotEmpty,
      'createdAt': entity.createdAt != null
          ? Timestamp.fromDate(entity.createdAt!)
          : Timestamp.now(),
      'updatedAt': entity.updatedAt != null
          ? Timestamp.fromDate(entity.updatedAt!)
          : Timestamp.now(),
    };
  }

  @override
  Map<String, dynamic> toJson(UserEntity entity) {
    return {
      'id': entity.id,
      'name': entity.name ?? '',
      'email': entity.email ?? '',
      'age': entity.age ?? 0,
      'photoUrls': entity.photoUrls ?? [],
      'photoUrl': entity.photoUrl,
      'interests': entity.interests ?? [],
      'bio': entity.bio,
      'gender': entity.gender,
      'location': entity.location,
      'orientation': entity.orientation,
      'createdAt': entity.createdAt?.toIso8601String(),
      'updatedAt': entity.updatedAt?.toIso8601String(),
    };
  }

  @override
  UserEntity fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as String? ?? '',
      name: json['name'] as String?,
      email: json['email'] as String?,
      photoUrl: json['photoUrl'] as String?,
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      location: json['location'] as String?,
      interests: _parseStringList(json['interests']),
      photoUrls: _parseStringList(json['photoUrls']),
      bio: json['bio'] as String?,
      orientation: json['orientation'] as String?,
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
    );
  }

  /// Convierte una lista de entidades a una lista de modelos
  @override
  List<UserModel> toModelList(List<UserEntity> entities) {
    return entities.map((entity) => toModel(entity)).toList();
  }

  /// Convierte una lista de modelos a una lista de entidades
  @override
  List<UserEntity> toEntityList(List<UserModel> models) {
    return models.map((model) => toEntity(model)).toList();
  }

  /// Convierte una lista de entidades a una lista de JSONs
  @override
  List<Map<String, dynamic>> toJsonList(List<UserEntity> entities) {
    return entities.map((entity) => toJson(entity)).toList();
  }

  /// Convierte una lista de JSONs a una lista de entidades
  @override
  List<UserEntity> fromJsonList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }

  /// Utilidad para parsear listas de strings
  List<String>? _parseStringList(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    return null;
  }

  /// Utilidad para parsear fechas desde distintos formatos
  DateTime? _parseDateTime(dynamic value) {
    if (value == null) {
      return null;
    } else if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    } else if (value is DateTime) {
      return value;
    }
    return null;
  }
}
