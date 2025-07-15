import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/chat/chat_entity.dart';
import '../entities/chat/message_entity.dart';
import '../entities/chat/chat_participant_entity.dart';

/// Repositorio abstracto para operaciones de chat
abstract class ChatRepository {
  // =================== OPERACIONES DE CHAT ===================
  
  /// Crea un nuevo chat
  Future<Either<Failure, ChatEntity>> createChat({
    required List<String> participants,
    required ChatType type,
    GroupInfo? groupInfo,
  });

  /// Obtiene un chat por su ID
  Future<Either<Failure, ChatEntity?>> getChatById(String chatId);

  /// Obtiene todos los chats de un usuario
  Future<Either<Failure, List<ChatEntity>>> getUserChats({
    required String userId,
    int limit = 50,
    String? lastChatId,
  });

  /// Obtiene chats en tiempo real para un usuario
  Stream<Either<Failure, List<ChatEntity>>> getUserChatsStream(String userId);

  /// Actualiza información del chat
  Future<Either<Failure, ChatEntity>> updateChat({
    required String chatId,
    String? lastMessage,
    DateTime? lastMessageTime,
    GroupInfo? groupInfo,
    bool? isActive,
  });

  /// Elimina un chat
  Future<Either<Failure, void>> deleteChat(String chatId);

  /// Actualiza el último mensaje del chat
  Future<Either<Failure, void>> updateChatLastMessage({
    required String chatId,
    required String lastMessage,
    required DateTime lastMessageTime,
  });

  // =================== OPERACIONES DE MENSAJES ===================

  /// Envía un mensaje
  Future<Either<Failure, MessageEntity>> sendMessage(MessageEntity message);

  /// Obtiene mensajes de un chat
  Future<Either<Failure, List<MessageEntity>>> getMessages({
    required String chatId,
    int limit = 50,
    DateTime? beforeTimestamp,
  });

  /// Obtiene mensajes en tiempo real
  Stream<Either<Failure, List<MessageEntity>>> getMessagesStream(
    String chatId,
    int limit,
  );

  /// Obtiene un mensaje por ID
  Future<Either<Failure, MessageEntity?>> getMessageById(String messageId);

  /// Busca mensajes en un chat
  Future<Either<Failure, List<MessageEntity>>> searchMessages({
    required String chatId,
    required String query,
    MessageType? messageType,
    int limit = 50,
  });

  /// Actualiza un mensaje
  Future<Either<Failure, MessageEntity>> updateMessage({
    required String messageId,
    String? content,
    bool? isDeleted,
  });

  /// Elimina un mensaje
  Future<Either<Failure, void>> deleteMessage(String messageId);

  /// Marca un mensaje como leído
  Future<Either<Failure, void>> markMessageAsRead({
    required String messageId,
    required String userId,
  });

  /// Marca todos los mensajes de un chat como leídos
  Future<Either<Failure, void>> markAllMessagesAsRead({
    required String chatId,
    required String userId,
  });

  // =================== OPERACIONES DE PARTICIPANTES ===================

  /// Verifica si un usuario es participante de un chat
  Future<Either<Failure, bool>> isUserParticipant(String chatId, String userId);

  /// Obtiene participantes de un chat
  Future<Either<Failure, List<ChatParticipantEntity>>> getChatParticipants(String chatId);

  /// Obtiene participantes con información de usuario
  Future<Either<Failure, List<ChatParticipantWithUserInfo>>> getChatParticipantsWithUserInfo(String chatId);

  /// Añade un participante al chat
  Future<Either<Failure, ChatParticipantEntity>> addParticipant({
    required String chatId,
    required String userId,
    required String addedByUserId,
    ParticipantRole role = ParticipantRole.member,
  });

  /// Remueve un participante del chat
  Future<Either<Failure, void>> removeParticipant({
    required String chatId,
    required String userId,
    required String removedByUserId,
  });

  /// Actualiza el rol de un participante
  Future<Either<Failure, ChatParticipantEntity>> updateParticipantRole({
    required String chatId,
    required String userId,
    required ParticipantRole newRole,
    required String updatedByUserId,
  });

  /// Actualiza el estado de un participante
  Future<Either<Failure, ChatParticipantEntity>> updateParticipantStatus({
    required String chatId,
    required String userId,
    required ParticipantStatus newStatus,
  });

  /// Abandona un chat
  Future<Either<Failure, void>> leaveChat({
    required String chatId,
    required String userId,
  });

  // =================== OPERACIONES DE TYPING ===================

  /// Indica que un usuario está escribiendo
  Future<Either<Failure, void>> setUserTyping({
    required String chatId,
    required String userId,
    required bool isTyping,
  });

  /// Obtiene usuarios que están escribiendo
  Stream<Either<Failure, List<String>>> getTypingUsers(String chatId);

  // =================== OPERACIONES DE ARCHIVOS ===================

  /// Sube un archivo para el chat
  Future<Either<Failure, FileAttachment>> uploadFile({
    required String chatId,
    required String filePath,
    required String fileName,
    String? mimeType,
  });

  /// Elimina un archivo del chat
  Future<Either<Failure, void>> deleteFile({
    required String chatId,
    required String fileUrl,
  });

  // =================== OPERACIONES DE ESTADO ===================

  /// Actualiza la última conexión de un usuario
  Future<Either<Failure, void>> updateUserLastSeen({
    required String userId,
    required DateTime lastSeen,
  });

  /// Actualiza el contador de mensajes no leídos
  Future<Either<Failure, void>> updateUnreadCount(
    String chatId,
    String userId,
    int count,
  );

  /// Obtiene el contador de mensajes no leídos
  Future<Either<Failure, int>> getUnreadCount(String chatId, String userId);

  /// Obtiene el total de mensajes no leídos de un usuario
  Future<Either<Failure, int>> getTotalUnreadCount(String userId);

  // =================== OPERACIONES DE NOTIFICACIONES ===================

  /// Configura las preferencias de notificación para un chat
  Future<Either<Failure, void>> updateNotificationSettings({
    required String chatId,
    required String userId,
    required bool enabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
  });

  /// Obtiene las preferencias de notificación
  Future<Either<Failure, Map<String, dynamic>>> getNotificationSettings({
    required String chatId,
    required String userId,
  });

  // =================== OPERACIONES DE BÚSQUEDA ===================

  /// Busca chats por nombre o participantes
  Future<Either<Failure, List<ChatEntity>>> searchChats({
    required String userId,
    required String query,
    int limit = 20,
  });

  /// Obtiene estadísticas del chat
  Future<Either<Failure, Map<String, dynamic>>> getChatStats(String chatId);

  // =================== OPERACIONES DE RESPALDO ===================

  /// Exporta mensajes de un chat
  Future<Either<Failure, String>> exportChatMessages({
    required String chatId,
    required String userId,
    DateTime? fromDate,
    DateTime? toDate,
  });

  /// Importa mensajes a un chat
  Future<Either<Failure, void>> importChatMessages({
    required String chatId,
    required String messagesData,
  });

  // =================== OPERACIONES DE MODERACIÓN ===================

  /// Reporta un mensaje
  Future<Either<Failure, void>> reportMessage({
    required String messageId,
    required String reportedByUserId,
    required String reason,
    String? details,
  });

  /// Bloquea un usuario en un chat
  Future<Either<Failure, void>> blockUser({
    required String chatId,
    required String userId,
    required String blockedByUserId,
  });

  /// Desbloquea un usuario en un chat
  Future<Either<Failure, void>> unblockUser({
    required String chatId,
    required String userId,
    required String unblockedByUserId,
  });

  // =================== OPERACIONES DE CONFIGURACIÓN ===================

  /// Actualiza configuración del chat
  Future<Either<Failure, void>> updateChatSettings({
    required String chatId,
    required String userId,
    Map<String, dynamic>? settings,
  });

  /// Obtiene configuración del chat
  Future<Either<Failure, Map<String, dynamic>>> getChatSettings({
    required String chatId,
    required String userId,
  });

  // =================== OPERACIONES DE LIMPIEZA ===================

  /// Limpia mensajes antiguos
  Future<Either<Failure, void>> cleanupOldMessages({
    required String chatId,
    required Duration maxAge,
  });

  /// Limpia archivos no utilizados
  Future<Either<Failure, void>> cleanupUnusedFiles();

  // =================== OPERACIONES DE SINCRONIZACIÓN ===================

  /// Sincroniza datos offline
  Future<Either<Failure, void>> syncOfflineData(String userId);

  /// Obtiene datos para cache offline
  Future<Either<Failure, Map<String, dynamic>>> getOfflineData({
    required String userId,
    int maxChats = 10,
    int maxMessagesPerChat = 100,
  });
}
