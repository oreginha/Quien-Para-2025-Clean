import 'package:dartz/dartz.dart';
import 'package:quien_para/domain/entities/message_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/chat/chat_repository.dart';
import 'package:quien_para/domain/usecases/base/usecase.dart';

/// Parámetros para el caso de uso [GetMessagesUseCase]
class GetMessagesParams {
  /// ID de la conversación cuyos mensajes queremos obtener
  final String conversationId;

  /// Constructor
  GetMessagesParams({required this.conversationId});
}

/// Caso de uso para obtener un flujo de mensajes de una conversación
///
/// Este caso de uso encapsula la lógica para obtener un flujo de mensajes
/// de una conversación específica, devolviendo los mensajes en tiempo real
/// a medida que se añaden nuevos mensajes o se actualizan los existentes.
class GetMessagesUseCase
    implements StreamUseCase<List<MessageEntity>, GetMessagesParams> {
  final ChatRepository _chatRepository;

  /// Constructor
  GetMessagesUseCase(this._chatRepository);

  @override
  Stream<Either<AppFailure, List<MessageEntity>>> call(
    GetMessagesParams params,
  ) {
    return _chatRepository.getMessages(params.conversationId);
  }
}
