import 'package:quien_para/domain/entities/conversation/conversation_entity.dart';
import 'package:quien_para/domain/repositories/chat/chat_repository.dart';
import 'package:quien_para/domain/usecases/base/base_usecase.dart';

/// Parámetros para el caso de uso [GetConversationUseCase]
class GetConversationParams {
  /// ID de la conversación que se quiere obtener
  final String conversationId;

  /// Constructor
  GetConversationParams({required this.conversationId});
}

/// Caso de uso para obtener una conversación específica por su ID
///
/// Este caso de uso encapsula la lógica para obtener los detalles
/// de una conversación específica, incluyendo sus participantes
/// y metadatos como último mensaje y conteo de mensajes no leídos.
class GetConversationUseCase
    implements UseCase<ConversationEntity?, GetConversationParams> {
  final ChatRepository _chatRepository;

  /// Constructor
  GetConversationUseCase(this._chatRepository);

  @override
  Future<ConversationEntity?> call(GetConversationParams params) async {
    final either = await _chatRepository.getConversation(params.conversationId);
    return either.fold(
      (failure) => throw Exception(failure.message),
      (conversation) => conversation,
    );
  }
}
