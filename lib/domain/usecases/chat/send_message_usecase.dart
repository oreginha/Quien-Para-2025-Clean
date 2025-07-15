import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/chat/message_entity.dart';
import '../repositories/chat/chat_repository.dart';

/// Caso de uso para enviar mensajes en un chat
class SendMessageUseCase {
  final ChatRepository repository;

  const SendMessageUseCase(this.repository);

  /// Envía un mensaje a un chat específico
  /// 
  /// [chatId] - ID del chat donde enviar el mensaje
  /// [senderId] - ID del usuario que envía el mensaje
  /// [content] - Contenido del mensaje
  /// [type] - Tipo de mensaje (texto, imagen, archivo, etc.)
  /// [attachment] - Archivo adjunto opcional
  /// [location] - Datos de ubicación opcional
  /// [replyToMessageId] - ID del mensaje al que responde (opcional)
  Future<Either<Failure, MessageEntity>> call({
    required String chatId,
    required String senderId,
    required String content,
    required MessageType type,
    FileAttachment? attachment,
    LocationData? location,
    String? replyToMessageId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Validar parámetros de entrada
      if (chatId.isEmpty) {
        return Left(ValidationFailure('El ID del chat no puede estar vacío'));
      }

      if (senderId.isEmpty) {
        return Left(ValidationFailure('El ID del remitente no puede estar vacío'));
      }

      // Validar contenido según el tipo de mensaje
      final validationResult = _validateMessageContent(content, type, attachment, location);
      if (validationResult != null) {
        return Left(ValidationFailure(validationResult));
      }

      // Verificar que el usuario sea participante del chat
      final isParticipant = await repository.isUserParticipant(chatId, senderId);
      if (isParticipant.isLeft()) {
        return Left(isParticipant.fold((l) => l, (r) => ServerFailure('Error verificando participante')));
      }

      if (!isParticipant.getOrElse(() => false)) {
        return Left(PermissionFailure('El usuario no es participante del chat'));
      }

      // Crear el mensaje
      final message = MessageEntity(
        id: '', // Se generará en el repositorio
        chatId: chatId,
        senderId: senderId,
        content: content,
        type: type,
        timestamp: DateTime.now(),
        attachment: attachment,
        location: location,
        replyToMessageId: replyToMessageId,
        metadata: metadata,
        status: MessageStatus.sending,
      );

      // Enviar el mensaje
      final result = await repository.sendMessage(message);
      
      return result.fold(
        (failure) => Left(failure),
        (sentMessage) {
          // Actualizar el último mensaje del chat
          _updateChatLastMessage(chatId, sentMessage);
          return Right(sentMessage);
        },
      );
    } catch (e) {
      return Left(ServerFailure('Error inesperado al enviar mensaje: ${e.toString()}'));
    }
  }

  /// Valida el contenido del mensaje según su tipo
  String? _validateMessageContent(
    String content,
    MessageType type,
    FileAttachment? attachment,
    LocationData? location,
  ) {
    switch (type) {
      case MessageType.text:
        if (content.trim().isEmpty) {
          return 'El mensaje de texto no puede estar vacío';
        }
        if (content.length > 4000) {
          return 'El mensaje es demasiado largo (máximo 4000 caracteres)';
        }
        break;

      case MessageType.image:
      case MessageType.file:
      case MessageType.audio:
      case MessageType.video:
        if (attachment == null) {
          return 'Se requiere un archivo adjunto para este tipo de mensaje';
        }
        if (attachment.fileUrl.isEmpty) {
          return 'La URL del archivo no puede estar vacía';
        }
        break;

      case MessageType.location:
        if (location == null) {
          return 'Se requieren datos de ubicación para este tipo de mensaje';
        }
        if (location.latitude < -90 || location.latitude > 90) {
          return 'Latitud inválida';
        }
        if (location.longitude < -180 || location.longitude > 180) {
          return 'Longitud inválida';
        }
        break;

      case MessageType.system:
        // Los mensajes del sistema pueden tener contenido vacío
        break;
    }

    return null;
  }

  /// Actualiza el último mensaje del chat de forma asíncrona
  void _updateChatLastMessage(String chatId, MessageEntity message) {
    // Esta operación se ejecuta en background para no bloquear el envío
    repository.updateChatLastMessage(
      chatId: chatId,
      lastMessage: message.previewText,
      lastMessageTime: message.timestamp,
    );
  }
}

/// Caso de uso para enviar mensajes de texto rápido
class SendTextMessageUseCase {
  final SendMessageUseCase _sendMessageUseCase;

  const SendTextMessageUseCase(this._sendMessageUseCase);

  /// Envía un mensaje de texto simple
  Future<Either<Failure, MessageEntity>> call({
    required String chatId,
    required String senderId,
    required String text,
    String? replyToMessageId,
  }) async {
    return _sendMessageUseCase.call(
      chatId: chatId,
      senderId: senderId,
      content: text,
      type: MessageType.text,
      replyToMessageId: replyToMessageId,
    );
  }
}

/// Caso de uso para enviar archivos
class SendFileMessageUseCase {
  final SendMessageUseCase _sendMessageUseCase;

  const SendFileMessageUseCase(this._sendMessageUseCase);

  /// Envía un mensaje con archivo adjunto
  Future<Either<Failure, MessageEntity>> call({
    required String chatId,
    required String senderId,
    required FileAttachment attachment,
    String? caption,
    String? replyToMessageId,
  }) async {
    // Determinar el tipo de mensaje según el archivo
    MessageType messageType;
    if (attachment.isImage) {
      messageType = MessageType.image;
    } else if (attachment.isVideo) {
      messageType = MessageType.video;
    } else if (attachment.isAudio) {
      messageType = MessageType.audio;
    } else {
      messageType = MessageType.file;
    }

    return _sendMessageUseCase.call(
      chatId: chatId,
      senderId: senderId,
      content: caption ?? '',
      type: messageType,
      attachment: attachment,
      replyToMessageId: replyToMessageId,
    );
  }
}

/// Caso de uso para enviar ubicación
class SendLocationMessageUseCase {
  final SendMessageUseCase _sendMessageUseCase;

  const SendLocationMessageUseCase(this._sendMessageUseCase);

  /// Envía un mensaje con ubicación
  Future<Either<Failure, MessageEntity>> call({
    required String chatId,
    required String senderId,
    required LocationData location,
    String? description,
    String? replyToMessageId,
  }) async {
    return _sendMessageUseCase.call(
      chatId: chatId,
      senderId: senderId,
      content: description ?? 'Ubicación compartida',
      type: MessageType.location,
      location: location,
      replyToMessageId: replyToMessageId,
    );
  }
}
