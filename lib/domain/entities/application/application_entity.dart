// lib/domain/entities/application_entity.dart

import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Entidad que representa una aplicación/postulación a un plan
class ApplicationEntity extends Equatable {
  final String id;
  final String planId;
  final String applicantId;
  final String status; // pending, accepted, rejected, cancelled
  final DateTime appliedAt;
  final String? message;
  final DateTime? processedAt;
  final String? planTitle; // Para mostrar info adicional en la UI
  final String? planImageUrl; // Para mostrar info adicional en la UI
  final String? applicantName; // Para mostrar info adicional en la UI
  final String? applicantPhotoUrl; // Para mostrar info adicional en la UI

  const ApplicationEntity({
    required this.id,
    required this.planId,
    required this.applicantId,
    required this.status,
    required this.appliedAt,
    this.message,
    this.processedAt,
    this.planTitle,
    this.planImageUrl,
    this.applicantName,
    this.applicantPhotoUrl,
  });

  // Método para crear una copia con algunos campos modificados
  ApplicationEntity copyWith({
    String? id,
    String? planId,
    String? applicantId,
    String? status,
    DateTime? appliedAt,
    String? message,
    DateTime? processedAt,
    String? planTitle,
    String? planImageUrl,
    String? applicantName,
    String? applicantPhotoUrl,
  }) {
    return ApplicationEntity(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      applicantId: applicantId ?? this.applicantId,
      status: status ?? this.status,
      appliedAt: appliedAt ?? this.appliedAt,
      message: message ?? this.message,
      processedAt: processedAt ?? this.processedAt,
      planTitle: planTitle ?? this.planTitle,
      planImageUrl: planImageUrl ?? this.planImageUrl,
      applicantName: applicantName ?? this.applicantName,
      applicantPhotoUrl: applicantPhotoUrl ?? this.applicantPhotoUrl,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        planId,
        applicantId,
        status,
        appliedAt,
        message,
        processedAt,
        planTitle,
        planImageUrl,
        applicantName,
        applicantPhotoUrl,
      ];

  // Método para convertir la entidad a un Map para Firestore
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'planId': planId,
      'applicantId': applicantId,
      'status': status,
      'appliedAt': appliedAt.toIso8601String(),
      'message': message,
      'processedAt': processedAt?.toIso8601String(),
      // Estos campos son transitorios y no se guardan en Firestore
      // 'planTitle': planTitle,
      // 'planImageUrl': planImageUrl,
      // 'applicantName': applicantName,
      // 'applicantPhotoUrl': applicantPhotoUrl,
    };
  }

  // Método para crear una entidad desde un Map de Firestore
  factory ApplicationEntity.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    // Convertir appliedAt desde Timestamp o String
    DateTime parseDate(dynamic dateValue) {
      if (dateValue is Timestamp) {
        return dateValue.toDate();
      } else if (dateValue is String) {
        return DateTime.parse(dateValue);
      }
      return DateTime.now(); // Fallback para valores inválidos
    }

    return ApplicationEntity(
      id: documentId,
      planId: map['planId'] as String,
      applicantId: map['applicantId'] as String,
      status: map['status'] as String,
      appliedAt: parseDate(map['appliedAt']),
      message: map['message'] as String?,
      processedAt:
          map['processedAt'] != null ? parseDate(map['processedAt']) : null,
      planTitle: map['planTitle'] as String?,
      planImageUrl: map['planImageUrl'] as String?,
      applicantName: map['applicantName'] as String?,
      applicantPhotoUrl: map['applicantPhotoUrl'] as String?,
    );
  }

  factory ApplicationEntity.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ApplicationEntity.fromMap(data, doc.id);
  }
}
