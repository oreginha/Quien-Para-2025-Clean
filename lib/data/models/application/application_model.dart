// lib/data/models/application_model.dart
// ignore_for_file: always_specify_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quien_para/domain/entities/application/application_entity.dart';
part 'application_model.freezed.dart';
part 'application_model.g.dart';

@freezed
class ApplicationModel with _$ApplicationModel {
  const ApplicationModel._();

  const factory ApplicationModel({
    required String id,
    required String planId,
    required String applicantId,
    required String status, // pending, accepted, rejected, cancelled
    required DateTime appliedAt,
    String? message,
    DateTime? processedAt,
    String? planTitle, // Para mostrar info adicional en la UI
    String? planImageUrl, // Para mostrar info adicional en la UI
    String? applicantName, // Para mostrar info adicional en la UI
    String? applicantPhotoUrl, // Para mostrar info adicional en la UI
    String?
        responsibleMessage, // Mensaje del creador del plan al aceptar/rechazar
  }) = _ApplicationModel;

  factory ApplicationModel.fromJson(Map<String, dynamic> json) =>
      _$ApplicationModelFromJson(_prepareJson(json));

  // Método para preparar el JSON antes de deserializarlo
  static Map<String, dynamic> _prepareJson(Map<String, dynamic> json) {
    final result = Map<String, dynamic>.from(json);

    // Convertir Timestamp a String ISO8601 para appliedAt
    if (json['appliedAt'] is Timestamp) {
      result['appliedAt'] =
          (json['appliedAt'] as Timestamp).toDate().toIso8601String();
    }

    // Convertir Timestamp a String ISO8601 para processedAt
    if (json['processedAt'] is Timestamp) {
      result['processedAt'] =
          (json['processedAt'] as Timestamp).toDate().toIso8601String();
    }

    return result;
  }

  // Método para convertir a formato Firestore
  Map<String, dynamic> toFirestore() {
    return toJson()
      ..remove('id') // No guardamos el ID en el documento
      ..update('appliedAt', (value) => FieldValue.serverTimestamp());
  }

  // Método para crear desde Firestore
  static ApplicationModel fromFirestore(String id, Map<String, dynamic> data) {
    return ApplicationModel.fromJson({
      'id': id,
      ...data,
      'appliedAt': data['appliedAt'] is Timestamp
          ? data['appliedAt'].toDate().toIso8601String()
          : DateTime.now().toIso8601String(),
      'processedAt': data['processedAt'] is Timestamp
          ? data['processedAt'].toDate().toIso8601String()
          : null,
    });
  }

  // Método para convertir de entidad a modelo
  factory ApplicationModel.fromEntity(ApplicationEntity entity) {
    return ApplicationModel(
      id: entity.id,
      planId: entity.planId,
      applicantId: entity.applicantId,
      status: entity.status,
      appliedAt: entity.appliedAt,
      message: entity.message,
      processedAt: entity.processedAt,
      planTitle: entity.planTitle,
      planImageUrl: entity.planImageUrl,
      applicantName: entity.applicantName,
      applicantPhotoUrl: entity.applicantPhotoUrl,
    );
  }

  // Método para convertir de modelo a entidad
  ApplicationEntity toEntity() {
    return ApplicationEntity(
      id: id,
      planId: planId,
      applicantId: applicantId,
      status: status,
      appliedAt: appliedAt,
      message: message,
      processedAt: processedAt,
      planTitle: planTitle,
      planImageUrl: planImageUrl,
      applicantName: applicantName,
      applicantPhotoUrl: applicantPhotoUrl,
    );
  }
}
