// lib/presentation/bloc/chat/simple_chat_state.dart
part of 'simple_chat_bloc.dart';

class SimpleChatState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<Map<String, dynamic>>? conversations;
  final List<Map<String, dynamic>>? messages;
  final String? currentConversationId;

  const SimpleChatState._({
    this.isLoading = false,
    this.errorMessage,
    this.conversations,
    this.messages,
    this.currentConversationId,
  });

  const SimpleChatState.initial() : this._();

  const SimpleChatState.loading() : this._(isLoading: true);

  const SimpleChatState.error(String message) : this._(errorMessage: message);

  const SimpleChatState.conversationsLoaded(
    List<Map<String, dynamic>> conversations,
  ) : this._(conversations: conversations);

  const SimpleChatState.messagesLoaded(
    List<Map<String, dynamic>> messages,
    String conversationId,
  ) : this._(messages: messages, currentConversationId: conversationId);

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        conversations,
        messages,
        currentConversationId,
      ];

  // Getters de conveniencia para compatibilidad
  bool get hasError => errorMessage != null;
  bool get hasConversations =>
      conversations != null && conversations!.isNotEmpty;
  bool get hasMessages => messages != null && messages!.isNotEmpty;
}
