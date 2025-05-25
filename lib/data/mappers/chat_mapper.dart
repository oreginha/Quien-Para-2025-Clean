// lib/data/mappers/chat_mapper.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quien_para/data/models/chat/chat_model.dart';
import 'package:quien_para/domain/entities/conversation/conversation_entity.dart';

/// Mapper responsable de la transformación entre ConversationEntity (dominio) y ChatModel (datos)
class ChatMapper {
  const ChatMapper();

  /// Convierte un ChatModel a una ConversationEntity
  static ConversationEntity toEntity(ChatModel model) {
    // Convertir los participantes al formato requerido por ConversationEntity
    final List<Map<String, dynamic>> participantMaps = [];
    for (final String userId in model.participants) {
      participantMaps.add({
        'id': userId,
        'name':
            '', // Estos datos normalmente se cargarían desde los perfiles de usuario
        'photoUrl': '',
      });
    }

    return ConversationEntity(
      id: model.id,
      participants: participantMaps,
      lastMessage: model.lastMessage,
      lastMessageTime: model.lastMessageTimestamp,
      unreadCount: model.unreadCount,
    );
  }

  /// Convierte una ConversationEntity a ChatModel
  static ChatModel toModel(ConversationEntity entity) {
    // Extraer las IDs de los participantes
    final List<String> participantIds = [];
    for (final Map<String, dynamic> participant in entity.participants) {
      final String? id = participant['id'] as String?;
      if (id != null && id.isNotEmpty) {
        participantIds.add(id);
      }
    }

    return ChatModel(
      id: entity.id,
      participants: participantIds,
      createdAt: entity.lastMessageTime ?? DateTime.now(),
      lastMessageTimestamp: entity.lastMessageTime,
      lastMessage: entity.lastMessage,
      unreadCount: entity.unreadCount,
      isGroupChat: entity.participants.length > 2,
    );
  }

  /// Convierte un documento de Firestore a una ConversationEntity
  ConversationEntity fromFirestore(DocumentSnapshot doc) {
    if (!doc.exists) {
      throw Exception('El documento no existe: ${doc.reference.path}');
    }

    // Convertir de documento a modelo directamente sin usar data
    final model = ChatModel.fromFirestore(doc);

    // Convertir del modelo a entidad
    return toEntity(model);
  }

  /// Convierte una entidad a un formato adecuado para Firestore
  Map<String, dynamic> toFirestore(ConversationEntity entity) {
    final model = toModel(entity);
    return model.toFirestore();
  }

  /// Convierte una lista de documentos de Firestore a una lista de entidades
  List<ConversationEntity> fromFirestoreList(List<DocumentSnapshot> docs) {
    return docs.map((doc) => fromFirestore(doc)).toList();
  }
}
