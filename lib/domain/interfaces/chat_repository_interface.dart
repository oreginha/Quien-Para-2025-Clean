// lib/domain/repositories/chat_repository_interface.dart

import 'package:quien_para/domain/entities/conversation/conversation_entity.dart';
import 'package:quien_para/domain/entities/message_entity.dart';

/// Repositorio unificado para gestión de chat
abstract class ChatRepository {
  /// Obtiene los mensajes de una conversación
  Stream<List<MessageEntity>> getMessages(String conversationId);

  /// Envía un mensaje a una conversación
  Future<MessageEntity> sendMessage(
    String conversationId,
    String senderId,
    String content,
  );

  /// Marca todos los mensajes de una conversación como leídos para el usuario actual
  Future<void> markAsRead(String conversationId, String userId);

  /// Obtiene todas las conversaciones de un usuario
  Future<List<ConversationEntity>> getUserConversations(String userId);

  /// Crea una nueva conversación entre usuarios
  Future<String> createConversation(
    List<String> participants,
    String initialMessage,
  );

  /// Verifica si existe una conversación entre usuarios específicos
  Future<String?> getExistingConversation(List<String> participants);

  /// Obtiene una conversación por ID
  Future<ConversationEntity?> getConversation(String conversationId);

  /// Elimina una conversación
  Future<void> deleteConversation(String conversationId);

  /// Obtiene el conteo de mensajes no leídos para un usuario
  Stream<int> getUnreadMessagesCount(String userId);
}
