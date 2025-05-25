import 'package:quien_para/domain/repositories/chat/chat_repository.dart';
import 'package:quien_para/domain/usecases/base/base_usecase.dart';

/// Parámetros para el caso de uso [CreateConversationUseCase]
class CreateConversationParams {
  /// Lista de IDs de los participantes en la conversación
  final List<String> participantIds;

  /// Mensaje inicial de la conversación (opcional)
  final String initialMessage;

  /// Constructor
  CreateConversationParams({
    required this.participantIds,
    this.initialMessage = '',
  });
}

/// Caso de uso para crear una nueva conversación
///
/// Este caso de uso encapsula la lógica para crear una nueva conversación
/// entre un conjunto de participantes, opcionalmente con un mensaje inicial.
/// Si una conversación entre los mismos participantes ya existe, se devolverá
/// esa conversación existente en lugar de crear una nueva.
class CreateConversationUseCase
    implements UseCase<String, CreateConversationParams> {
  final ChatRepository _chatRepository;

  /// Constructor
  CreateConversationUseCase(this._chatRepository);

  @override
  Future<String> call(CreateConversationParams params) => execute(params);

  Future<String> execute(CreateConversationParams params) async {
    // Validar que hay al menos dos participantes
    if (params.participantIds.length < 2) {
      throw ArgumentError(
          'Una conversación requiere al menos dos participantes');
    }

    // Validar que los IDs de los participantes son únicos
    final uniqueParticipants = params.participantIds.toSet().toList();
    if (uniqueParticipants.length != params.participantIds.length) {
      throw ArgumentError(
          'No puede haber participantes duplicados en una conversación');
    }

    final either = await _chatRepository.createConversation(
      participants: params.participantIds,
      initialMessage:
          params.initialMessage.isNotEmpty ? params.initialMessage : null,
    );
    return either.fold(
      (failure) => throw Exception(failure.message),
      (conversationId) => conversationId,
    );
  }
}
