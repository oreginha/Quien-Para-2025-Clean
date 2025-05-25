// ignore_for_file: always_specify_types

part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadMessages extends ChatEvent {
  final String conversationId;
  final bool markAsRead;

  const LoadMessages(this.conversationId, {this.markAsRead = true});

  @override
  List<Object> get props => [conversationId, markAsRead];
}

class SendMessage extends ChatEvent {
  final String conversationId;
  final String content;
  final String senderId;

  const SendMessage({
    required this.conversationId,
    required this.content,
    required this.senderId,
  });

  @override
  List<Object> get props => [conversationId, content, senderId];
}

class MessagesUpdated extends ChatEvent {
  final List<ChatMessageModel> messages;

  const MessagesUpdated(this.messages);

  @override
  List<Object> get props => [messages];
}

class LoadConversations extends ChatEvent {
  final String userId;

  const LoadConversations(this.userId);

  @override
  List<Object> get props => [userId];
}

class CreateConversation extends ChatEvent {
  final List<String> participants;
  final String initialMessage;

  const CreateConversation({
    required this.participants,
    required this.initialMessage,
  });

  @override
  List<Object> get props => [participants, initialMessage];
}

class MarkMessagesAsRead extends ChatEvent {
  final String conversationId;
  final String userId;

  const MarkMessagesAsRead(this.conversationId, this.userId);

  @override
  List<Object> get props => [conversationId, userId];
}
