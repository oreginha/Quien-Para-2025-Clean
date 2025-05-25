import 'package:dartz/dartz.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/chat/chat_repository.dart';
import 'package:quien_para/domain/usecases/base/usecase.dart';

/// Parámetros para el caso de uso [SendMessageUseCase]
class SendMessageParams {
  /// ID de la conversación donde enviar el mensaje
  final String conversationId;

  /// ID del remitente del mensaje
  final String senderId;

  /// Contenido del mensaje
  final String content;

  /// Constructor
  SendMessageParams({
    required this.conversationId,
    required this.senderId,
    required this.content,
  });
}

/// Caso de uso para enviar un mensaje a una conversación
///
/// Este caso de uso encapsula la lógica para enviar un mensaje
/// a una conversación específica, validando el contenido del mensaje.
class SendMessageUseCase implements UseCase<void, SendMessageParams> {
  final ChatRepository _chatRepository;

  /// Constructor
  SendMessageUseCase(this._chatRepository);

  @override
  Future<Either<AppFailure, void>> call(SendMessageParams params) async {
    // Validar que el mensaje no esté vacío
    if (params.content.trim().isEmpty) {
      return Left(ValidationFailure(
          message: 'El contenido del mensaje no puede estar vacío',
          code: '',
          field: ''));
    }

    // Llamar al método sendMessage con los parámetros nombrados según la interfaz consolidada
    await _chatRepository.sendMessage(
      conversationId: params.conversationId,
      content: params.content,
      metadata: {'senderId': params.senderId},
    );
    return const Right(null);
  }
}
