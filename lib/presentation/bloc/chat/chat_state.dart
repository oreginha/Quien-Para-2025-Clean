part of 'chat_bloc.dart';

// NOTA: ZONA DE COMPATIBILIDAD - Para mantener compatibilidad durante la migración
// Estos tipos se mantendrán temporalmente para evitar romper el código existente
// Eventualmente deberían ser eliminados una vez que todo el código utilice la nueva estructura

class ChatInitial extends ChatState {
  const ChatInitial() : super.initial();
}

class ChatLoading extends ChatState {
  const ChatLoading() : super.loading();
}

class ChatError extends ChatState {
  const ChatError(super.message) : super.error();
}

class MessagesLoaded extends ChatState {
  final List<ChatMessageModel> messagesModels;

  // Eliminado 'const' porque realiza operaciones no constantes
  MessagesLoaded(this.messagesModels)
    : super(
        messages: messagesModels
            .map(
              (msg) => MessageEntity(
                id: msg.id,
                content: msg.content,
                timestamp: msg.timestamp,
                senderId: msg.senderId,
                read: msg
                    .isRead, // Cambiado a isRead que es la propiedad correcta en ChatMessageModel
              ),
            )
            .toList(),
        // Extraer chatId de forma segura
        activeConversationId: messagesModels.isNotEmpty
            ? messagesModels.first.chatId
            : null,
      );
}

class ConversationsLoaded extends ChatState {
  const ConversationsLoaded(List<ConversationEntity> loadedConversations)
    : super(conversations: loadedConversations);
}

class ConversationCreated extends ChatState {
  final String id;

  const ConversationCreated(this.id) : super(createdConversationId: id);

  /// Getter para compatibilidad con código existente
  String get conversationId => id;
}

/// Estado base para todos los estados del chat
/// Implementa el patrón de estado unificado:
/// - isLoading: Indica si la operación está en progreso
/// - errorMessage: Contiene el mensaje de error si existe
/// - conversations: Lista de conversaciones (puede ser nula)
/// - messages: Lista de mensajes para una conversación específica (puede ser nula)
/// - activeConversationId: ID de la conversación activa actualmente
class ChatState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<ConversationEntity>? conversations;
  final List<MessageEntity>? messages;
  final String? activeConversationId;
  final String? createdConversationId;

  const ChatState({
    this.isLoading = false,
    this.errorMessage,
    this.conversations,
    this.messages,
    this.activeConversationId,
    this.createdConversationId,
  });

  bool get hasError => errorMessage != null;
  bool get hasConversations =>
      conversations != null && conversations!.isNotEmpty;
  bool get hasMessages => messages != null && messages!.isNotEmpty;
  bool get hasActiveConversation => activeConversationId != null;
  bool get hasCreatedConversation => createdConversationId != null;

  /// Estado inicial cuando se crea el BLoC
  const ChatState.initial() : this();

  /// Estado de carga durante operaciones asíncronas
  const ChatState.loading() : this(isLoading: true);

  /// Estado cuando se han cargado las conversaciones
  const ChatState.conversationsLoaded(
    List<ConversationEntity> loadedConversations,
  ) : this(conversations: loadedConversations);

  /// Estado cuando se ha cargado una conversación específica con sus mensajes
  const ChatState.messagesLoaded({
    required List<MessageEntity> loadedMessages,
    required String conversationId,
    List<ConversationEntity>? existingConversations,
  }) : this(
         messages: loadedMessages,
         activeConversationId: conversationId,
         conversations: existingConversations,
       );

  /// Estado cuando se ha creado una nueva conversación
  const ChatState.conversationCreated({
    required String newConversationId,
    List<ConversationEntity>? existingConversations,
  }) : this(
         createdConversationId: newConversationId,
         conversations: existingConversations,
       );

  /// Estado de error
  const ChatState.error(String message) : this(errorMessage: message);

  /// Crear una copia del estado actual con algunos campos modificados
  ChatState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<ConversationEntity>? conversations,
    List<MessageEntity>? messages,
    String? activeConversationId,
    String? createdConversationId,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      conversations: conversations ?? this.conversations,
      messages: messages ?? this.messages,
      activeConversationId: activeConversationId ?? this.activeConversationId,
      createdConversationId:
          createdConversationId ?? this.createdConversationId,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    conversations,
    messages,
    activeConversationId,
    createdConversationId,
  ];

  @override
  String toString() {
    return 'ChatState{isLoading: $isLoading, hasError: $hasError, '
        'conversationCount: ${conversations?.length}, '
        'messageCount: ${messages?.length}, '
        'activeConversationId: $activeConversationId}';
  }
}
