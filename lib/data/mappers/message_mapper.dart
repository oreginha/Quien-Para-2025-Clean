// lib/data/mappers/message_mapper.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quien_para/data/models/chat_message/chat_message_model.dart';
import 'package:quien_para/domain/entities/message_entity.dart';

/// Mapper responsable de la transformación entre MessageEntity (dominio) y ChatMessageModel (datos)
class MessageMapper {
  const MessageMapper();

  /// Convierte un ChatMessageModel a un MessageEntity
  MessageEntity toEntity(ChatMessageModel model) {
    return MessageEntity(
      id: model.id,
      senderId: model.senderId,
      content: model.content,
      timestamp: model.timestamp,
      read: model.isRead,
    );
  }

  /// Convierte un MessageEntity a ChatMessageModel
  ChatMessageModel toModel(MessageEntity entity, {required String chatId}) {
    return ChatMessageModel(
      id: entity.id,
      chatId: chatId,
      senderId: entity.senderId,
      content: entity.content,
      timestamp: entity.timestamp,
      isRead: entity.read,
      type: MessageType.text, // Por defecto, asumimos que es texto
    );
  }

  /// Convierte un documento de Firestore a un MessageEntity
  MessageEntity fromFirestore(DocumentSnapshot doc) {
    if (!doc.exists) {
      throw Exception('El documento no existe: ${doc.reference.path}');
    }
    
    // Obtener el modelo a partir del documento sin usar data
    final model = ChatMessageModel.fromFirestore(doc);
    
    // Convertir del modelo a entidad
    return toEntity(model);
  }

  /// Convierte una entidad a un formato adecuado para Firestore
  Map<String, dynamic> toFirestore(MessageEntity entity, {required String chatId}) {
    final model = toModel(entity, chatId: chatId);
    return model.toFirestore();
  }

  /// Convierte una lista de documentos de Firestore a una lista de entidades
  List<MessageEntity> fromFirestoreList(List<DocumentSnapshot> docs) {
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
