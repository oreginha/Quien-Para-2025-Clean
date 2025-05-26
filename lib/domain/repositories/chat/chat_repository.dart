// lib/domain/repositories/chat_repository.dart

import 'package:dartz/dartz.dart';
import 'package:quien_para/domain/entities/conversation/conversation_entity.dart';
import 'package:quien_para/domain/entities/message_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';

/// Interfaz mejorada para el repositorio de chat con manejo de errores consistente
abstract class ChatRepository {
  /// Crear una conversación entre participantes con un mensaje inicial opcional
  ///
  /// Retorna el ID de la conversación o un error
  Future<Either<AppFailure, String>> createConversation({
    required List<String> participants,
    String? initialMessage,
  });

  /// Obtener una conversación por ID
  ///
  /// Retorna la conversación encontrada o null si no existe
  Future<Either<AppFailure, ConversationEntity?>> getConversation(
    String conversationId,
  );

  /// Verificar si existe una conversación entre dos usuarios
  ///
  /// Retorna la conversación existente o null si no hay conversación
  Future<Either<AppFailure, ConversationEntity?>> getExistingConversation(
    String userId1,
    String userId2,
  );

  /// Obtener todas las conversaciones para un usuario
  ///
  /// Retorna un stream de conversaciones
  Stream<Either<AppFailure, List<ConversationEntity>>> getConversations(
    String userId,
  );

  /// Enviar un mensaje a una conversación
  ///
  /// Retorna void para éxito o un error
  Future<Either<AppFailure, Unit>> sendMessage({
    required String conversationId,
    required String content,
    Map<String, dynamic>? metadata,
  });

  /// Obtener mensajes de una conversación como stream
  ///
  /// Retorna un stream de mensajes
  Stream<Either<AppFailure, List<MessageEntity>>> getMessages(
    String conversationId,
  );

  /// Marcar conversación como leída
  ///
  /// Retorna void para éxito o un error
  Future<Either<AppFailure, Unit>> markConversationAsRead({
    required String conversationId,
    required String userId,
  });

  /// Eliminar una conversación
  ///
  /// Retorna void para éxito o un error
  Future<Either<AppFailure, Unit>> deleteConversation(String conversationId);

  /// Obtener el número de mensajes no leídos para un usuario
  ///
  /// Retorna un stream con el conteo de mensajes no leídos
  Stream<Either<AppFailure, int>> getUnreadMessagesCount(String userId);

  /// Marcar todos los mensajes de una conversación como leídos para un usuario específico
  ///
  /// Retorna void para éxito o un error
  Future<Either<AppFailure, Unit>> markMessagesAsRead(
    String conversationId,
    String userId,
  );
}
