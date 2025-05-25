// lib/data/mappers/application_mapper.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quien_para/data/models/application/application_model.dart';
import 'package:quien_para/domain/entities/application/application_entity.dart';

/// Mapper responsable de la transformación entre ApplicationEntity (dominio) y ApplicationModel (datos)
class ApplicationMapper {
  const ApplicationMapper();

  /// Convierte un ApplicationModel a un ApplicationEntity
  ApplicationEntity toEntity(ApplicationModel model) {
    return model.toEntity();
  }

  /// Convierte un ApplicationEntity a ApplicationModel
  ApplicationModel toModel(ApplicationEntity entity) {
    return ApplicationModel.fromEntity(entity);
  }

  /// Convierte un documento de Firestore a un ApplicationEntity
  ApplicationEntity fromFirestore(DocumentSnapshot doc) {
    if (!doc.exists) {
      throw Exception('El documento no existe: ${doc.reference.path}');
    }

    final data = doc.data() as Map<String, dynamic>;

    // Convertir de documento a modelo
    final model = ApplicationModel.fromFirestore(doc.id, data);

    // Convertir del modelo a entidad
    return toEntity(model);
  }

  /// Convierte una entidad a un formato adecuado para Firestore
  Map<String, dynamic> toFirestore(ApplicationEntity entity) {
    final model = toModel(entity);
    return model.toFirestore();
  }

  /// Convierte una lista de documentos de Firestore a una lista de entidades
  List<ApplicationEntity> fromFirestoreList(List<DocumentSnapshot> docs) {
    return docs.map((doc) => fromFirestore(doc)).toList();
  }

  /// Parse timestamp data from Firestore to DateTime
  DateTime parseTimestamp(dynamic timestampData) {
    if (timestampData == null) return DateTime.now();
    if (timestampData is Timestamp) return timestampData.toDate();
    if (timestampData is String) {
      try {
        return DateTime.parse(timestampData);
      } catch (_) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }
}
