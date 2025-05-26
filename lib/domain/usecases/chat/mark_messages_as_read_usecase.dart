import 'package:dartz/dartz.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/chat/chat_repository.dart';
import 'package:quien_para/domain/usecases/base/usecase.dart';

/// Parámetros para el caso de uso [MarkMessagesAsReadUseCase]
class MarkMessagesAsReadParams {
  /// ID de la conversación cuyos mensajes se marcarán como leídos
  final String conversationId;

  /// ID del usuario que ha leído los mensajes
  final String userId;

  /// Constructor
  MarkMessagesAsReadParams({
    required this.conversationId,
    required this.userId,
  });
}

/// Caso de uso para marcar mensajes como leídos
///
/// Este caso de uso encapsula la lógica para marcar todos los mensajes
/// de una conversación como leídos para un usuario específico.
class MarkMessagesAsReadUseCase
    implements UseCase<void, MarkMessagesAsReadParams> {
  final ChatRepository _chatRepository;

  /// Constructor
  MarkMessagesAsReadUseCase(this._chatRepository);

  @override
  Future<Either<AppFailure, void>> call(MarkMessagesAsReadParams params) async {
    await _chatRepository.markMessagesAsRead(
      params.conversationId,
      params.userId,
    );
    return const Right(null);
  }
}
