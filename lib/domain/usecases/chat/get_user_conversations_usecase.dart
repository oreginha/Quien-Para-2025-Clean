import 'package:quien_para/domain/entities/conversation/conversation_entity.dart';
import 'package:quien_para/domain/repositories/chat/chat_repository.dart';

/// Parámetros para el caso de uso [GetUserConversationsUseCase]
class GetUserConversationsParams {
  /// ID del usuario cuyas conversaciones se quieren obtener
  final String userId;

  /// Constructor
  GetUserConversationsParams({required this.userId});
}

/// Caso de uso para obtener todas las conversaciones de un usuario
///
/// Este caso de uso encapsula la lógica para obtener todas las conversaciones
/// en las que participa un usuario específico, ordenadas típicamente
/// por la fecha del último mensaje.
class GetUserConversationsUseCase {
  final ChatRepository _chatRepository;

  /// Constructor
  GetUserConversationsUseCase(this._chatRepository);

  Stream<List<ConversationEntity>> execute(GetUserConversationsParams params) {
    return _chatRepository
        .getConversations(params.userId)
        .map(
          (either) => either.fold(
            (failure) => <ConversationEntity>[],
            (convs) => convs,
          ),
        );
  }
}
