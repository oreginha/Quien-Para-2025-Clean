import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/chat/message_entity.dart';
import '../repositories/chat/chat_repository.dart';

/// Caso de uso para obtener mensajes de un chat
class GetMessagesUseCase {
  final ChatRepository repository;

  const GetMessagesUseCase(this.repository);

  /// Obtiene los mensajes de un chat con paginación
  /// 
  /// [chatId] - ID del chat del cual obtener mensajes
  /// [userId] - ID del usuario que solicita los mensajes (para verificar permisos)
  /// [limit] - Número máximo de mensajes a obtener (default: 50)
  /// [beforeTimestamp] - Obtener mensajes anteriores a esta fecha (para paginación)
  /// [markAsRead] - Si marcar los mensajes como leídos (default: true)
  Future<Either<Failure, List<MessageEntity>>> call({
    required String chatId,
    required String userId,
    int limit = 50,
    DateTime? beforeTimestamp,
    bool markAsRead = true,
  }) async {
    try {
      // Validar parámetros de entrada
      if (chatId.isEmpty) {
        return Left(ValidationFailure('El ID del chat no puede estar vacío'));
      }

      if (userId.isEmpty) {
        return Left(ValidationFailure('El ID del usuario no puede estar vacío'));
      }

      if (limit <= 0 || limit > 100) {
        return Left(ValidationFailure('El límite debe estar entre 1 y 100'));
      }

      // Verificar que el usuario sea participante del chat
      final isParticipant = await repository.isUserParticipant(chatId, userId);
      if (isParticipant.isLeft()) {
        return Left(isParticipant.fold((l) => l, (r) => ServerFailure('Error verificando participante')));
      }

      if (!isParticipant.getOrElse(() => false)) {
        return Left(PermissionFailure('El usuario no es participante del chat'));
      }

      // Obtener los mensajes
      final result = await repository.getMessages(
        chatId: chatId,
        limit: limit,
        beforeTimestamp: beforeTimestamp,
      );

      return result.fold(
        (failure) => Left(failure),
        (messages) async {
          // Marcar mensajes como leídos si es necesario
          if (markAsRead && messages.isNotEmpty) {
            _markMessagesAsRead(chatId, userId, messages);
          }

          return Right(messages);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Error inesperado al obtener mensajes: ${e.toString()}'));
    }
  }

  /// Marca los mensajes como leídos de forma asíncrona
  void _markMessagesAsRead(String chatId, String userId, List<MessageEntity> messages) {
    // Filtrar mensajes no leídos por el usuario
    final unreadMessages = messages
        .where((message) => 
            message.senderId != userId && // No marcar propios mensajes
            !message.isReadBy(userId) && // Solo mensajes no leídos
            !message.isDeleted) // No marcar mensajes eliminados
        .toList();

    if (unreadMessages.isEmpty) return;

    // Marcar como leídos en background
    for (final message in unreadMessages) {
      repository.markMessageAsRead(
        messageId: message.id,
        userId: userId,
      );
    }

    // Actualizar contador de no leídos del chat
    repository.updateUnreadCount(chatId, userId, 0);
  }
}

/// Caso de uso para obtener mensajes en tiempo real
class GetRealTimeMessagesUseCase {
  final ChatRepository repository;

  const GetRealTimeMessagesUseCase(this.repository);

  /// Obtiene un stream de mensajes en tiempo real
  /// 
  /// [chatId] - ID del chat del cual escuchar mensajes
  /// [userId] - ID del usuario que solicita el stream
  /// [limit] - Número inicial de mensajes a cargar (default: 50)
  Stream<Either<Failure, List<MessageEntity>>> call({
    required String chatId,
    required String userId,
    int limit = 50,
  }) async* {
    try {
      // Validar parámetros de entrada
      if (chatId.isEmpty) {
        yield Left(ValidationFailure('El ID del chat no puede estar vacío'));
        return;
      }

      if (userId.isEmpty) {
        yield Left(ValidationFailure('El ID del usuario no puede estar vacío'));
        return;
      }

      // Verificar permisos (solo una vez al inicio)
      final isParticipant = await repository.isUserParticipant(chatId, userId);
      if (isParticipant.isLeft()) {
        yield Left(isParticipant.fold((l) => l, (r) => ServerFailure('Error verificando participante')));
        return;
      }

      if (!isParticipant.getOrElse(() => false)) {
        yield Left(PermissionFailure('El usuario no es participante del chat'));
        return;
      }

      // Obtener stream de mensajes
      await for (final result in repository.getMessagesStream(chatId, limit)) {
        yield result.fold(
          (failure) => Left(failure),
          (messages) {
            // Auto-marcar mensajes como leídos
            if (messages.isNotEmpty) {
              _markNewMessagesAsRead(chatId, userId, messages);
            }
            return Right(messages);
          },
        );
      }
    } catch (e) {
      yield Left(ServerFailure('Error en stream de mensajes: ${e.toString()}'));
    }
  }

  /// Marca automáticamente los nuevos mensajes como leídos
  void _markNewMessagesAsRead(String chatId, String userId, List<MessageEntity> messages) {
    // Solo marcar el último mensaje si no es del usuario actual
    final lastMessage = messages.lastOrNull;
    if (lastMessage != null && 
        lastMessage.senderId != userId && 
        !lastMessage.isReadBy(userId)) {
      
      repository.markMessageAsRead(
        messageId: lastMessage.id,
        userId: userId,
      );
    }
  }
}

/// Caso de uso para buscar mensajes en un chat
class SearchMessagesUseCase {
  final ChatRepository repository;

  const SearchMessagesUseCase(this.repository);

  /// Busca mensajes que contengan el texto especificado
  /// 
  /// [chatId] - ID del chat donde buscar
  /// [userId] - ID del usuario que realiza la búsqueda
  /// [query] - Texto a buscar
  /// [messageType] - Tipo de mensaje a filtrar (opcional)
  /// [limit] - Número máximo de resultados (default: 50)
  Future<Either<Failure, List<MessageEntity>>> call({
    required String chatId,
    required String userId,
    required String query,
    MessageType? messageType,
    int limit = 50,
  }) async {
    try {
      // Validar parámetros
      if (chatId.isEmpty) {
        return Left(ValidationFailure('El ID del chat no puede estar vacío'));
      }

      if (userId.isEmpty) {
        return Left(ValidationFailure('El ID del usuario no puede estar vacío'));
      }

      if (query.trim().isEmpty) {
        return Left(ValidationFailure('La consulta de búsqueda no puede estar vacía'));
      }

      if (query.trim().length < 2) {
        return Left(ValidationFailure('La consulta debe tener al menos 2 caracteres'));
      }

      // Verificar permisos
      final isParticipant = await repository.isUserParticipant(chatId, userId);
      if (isParticipant.isLeft()) {
        return Left(isParticipant.fold((l) => l, (r) => ServerFailure('Error verificando participante')));
      }

      if (!isParticipant.getOrElse(() => false)) {
        return Left(PermissionFailure('El usuario no es participante del chat'));
      }

      // Realizar búsqueda
      return await repository.searchMessages(
        chatId: chatId,
        query: query.trim(),
        messageType: messageType,
        limit: limit,
      );
    } catch (e) {
      return Left(ServerFailure('Error en búsqueda de mensajes: ${e.toString()}'));
    }
  }
}

/// Caso de uso para obtener un mensaje específico
class GetMessageByIdUseCase {
  final ChatRepository repository;

  const GetMessageByIdUseCase(this.repository);

  /// Obtiene un mensaje específico por su ID
  /// 
  /// [messageId] - ID del mensaje a obtener
  /// [userId] - ID del usuario que solicita el mensaje
  Future<Either<Failure, MessageEntity?>> call({
    required String messageId,
    required String userId,
  }) async {
    try {
      // Validar parámetros
      if (messageId.isEmpty) {
        return Left(ValidationFailure('El ID del mensaje no puede estar vacío'));
      }

      if (userId.isEmpty) {
        return Left(ValidationFailure('El ID del usuario no puede estar vacío'));
      }

      // Obtener el mensaje
      final result = await repository.getMessageById(messageId);
      
      return result.fold(
        (failure) => Left(failure),
        (message) async {
          if (message == null) {
            return const Right(null);
          }

          // Verificar que el usuario tenga acceso al chat del mensaje
          final isParticipant = await repository.isUserParticipant(message.chatId, userId);
          if (isParticipant.isLeft()) {
            return Left(isParticipant.fold((l) => l, (r) => ServerFailure('Error verificando participante')));
          }

          if (!isParticipant.getOrElse(() => false)) {
            return Left(PermissionFailure('El usuario no tiene acceso a este mensaje'));
          }

          return Right(message);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Error al obtener mensaje: ${e.toString()}'));
    }
  }
}
