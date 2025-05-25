import 'package:quien_para/domain/entities/conversation/conversation_entity.dart';
import 'package:quien_para/domain/entities/message_entity.dart';

/// Interface for chat operations
abstract class ChatDataSource {
  /// Create or retrieve a conversation between participants
  Future<String> createConversation(
      List<String> participants, String initialMessage);

  /// Get a conversation by ID
  Future<ConversationEntity?> getConversation(String conversationId);

  /// Get all conversations for a user
  Future<List<ConversationEntity>> getUserConversations(String userId);

  /// Send a message to a conversation
  Future<MessageEntity> sendMessage(
      String conversationId, String senderId, String content);

  /// Get messages for a conversation
  Stream<List<MessageEntity>> getMessages(String conversationId);

  /// Mark messages as read
  Future<void> markAsRead(String conversationId, String userId);
}
