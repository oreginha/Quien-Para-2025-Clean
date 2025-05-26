import 'package:quien_para/data/models/chat_message/chat_message_model.dart';
import 'package:quien_para/domain/entities/message_entity.dart';

/// Mapper para convertir entre [ChatMessageModel] y [MessageEntity]
///
/// Este mapper es responsable de la conversión bidireccional entre modelos de datos
/// y entidades de dominio, manteniendo la separación entre capas.
class ChatMessageMapper {
  /// Convierte un [ChatMessageModel] a [MessageEntity]
  ///
  /// Esta conversión va desde la capa de datos hacia la capa de dominio.
  static MessageEntity toEntity(ChatMessageModel model) {
    return MessageEntity(
      id: model.id,
      senderId: model.senderId,
      content: model.content,
      timestamp: model.timestamp,
      read: model.isRead,
    );
  }

  /// Convierte una lista de [ChatMessageModel] a lista de [MessageEntity]
  ///
  /// Útil para mapear colecciones completas de mensajes.
  static List<MessageEntity> toEntityList(List<ChatMessageModel> models) {
    return models.map((model) => toEntity(model)).toList();
  }

  /// Convierte un [MessageEntity] a [ChatMessageModel]
  ///
  /// Esta conversión va desde la capa de dominio hacia la capa de datos.
  /// Nota: Requiere parámetros adicionales que no están presentes en la entidad,
  /// pero son necesarios para el modelo.
  static ChatMessageModel fromEntity(
    MessageEntity entity, {
    required String chatId,
    MessageType type = MessageType.text,
    String? mediaUrl,
    bool isSystemMessage = false,
  }) {
    return ChatMessageModel(
      id: entity.id,
      chatId: chatId,
      senderId: entity.senderId,
      content: entity.content,
      timestamp: entity.timestamp,
      isRead: entity.read,
      type: type,
      mediaUrl: mediaUrl,
      isSystemMessage: isSystemMessage,
    );
  }

  /// Convierte una lista de [MessageEntity] a lista de [ChatMessageModel]
  ///
  /// Útil para mapear colecciones completas de mensajes.
  /// Requiere un chatId común para todos los mensajes.
  static List<ChatMessageModel> fromEntityList(
    List<MessageEntity> entities, {
    required String chatId,
    MessageType type = MessageType.text,
  }) {
    return entities
        .map((entity) => fromEntity(entity, chatId: chatId, type: type))
        .toList();
  }
}
