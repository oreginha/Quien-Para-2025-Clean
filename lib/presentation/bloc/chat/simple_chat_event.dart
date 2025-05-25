// lib/presentation/bloc/chat/simple_chat_event.dart
part of 'simple_chat_bloc.dart';

abstract class SimpleChatEvent extends Equatable {
  const SimpleChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadConversations extends SimpleChatEvent {
  const LoadConversations();
}

class LoadMessages extends SimpleChatEvent {
  final String conversationId;
  final bool markAsRead;

  const LoadMessages(this.conversationId, {this.markAsRead = false});

  @override
  List<Object?> get props => [conversationId, markAsRead];
}

class SendMessage extends SimpleChatEvent {
  final String conversationId;
  final String content;
  final String senderId;
  final String receiverId;

  const SendMessage({
    required this.conversationId,
    required this.content,
    required this.senderId,
    required this.receiverId,
  });

  @override
  List<Object?> get props => [conversationId, content, senderId, receiverId];
}

class ConversationsUpdated extends SimpleChatEvent {
  final List<Map<String, dynamic>> conversations;

  const ConversationsUpdated(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

class MessagesUpdated extends SimpleChatEvent {
  final List<Map<String, dynamic>> messages;
  final String conversationId;

  const MessagesUpdated(this.messages, this.conversationId);

  @override
  List<Object?> get props => [messages, conversationId];
}

class MarkAsRead extends SimpleChatEvent {
  final String conversationId;

  const MarkAsRead(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}
