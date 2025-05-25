// ignore_for_file: always_specify_types

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import de foundation eliminado ya que no se usa
import 'package:quien_para/data/models/chat_message/chat_message_model.dart';
import 'package:quien_para/domain/entities/conversation/conversation_entity.dart';
import 'package:quien_para/domain/entities/message_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/chat/chat_repository.dart';
import 'package:quien_para/domain/usecases/chat/create_conversation_usecase.dart';
import 'package:quien_para/domain/usecases/chat/get_messages_usecase.dart';
import 'package:quien_para/domain/usecases/chat/get_user_conversations_usecase.dart';
import 'package:quien_para/domain/usecases/chat/mark_messages_as_read_usecase.dart';
import 'package:quien_para/domain/usecases/chat/send_message_usecase.dart';

part 'chat_event.dart';
part 'chat_state.dart';

/// BLoC para gestionar el estado y las operaciones relacionadas con el chat
///
/// Este BLoC soporta dos modos de implementación:
/// 1. Usando la interfaz ChatRepository (modo tradicional)
/// 2. Usando casos de uso de Clean Architecture (modo refactorizado)
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  // Modo tradicional (Repositorio)
  final ChatRepository? _chatRepository;

  // Modo Clean Architecture (Casos de uso)
  final GetMessagesUseCase? _getMessagesUseCase;
  final SendMessageUseCase? _sendMessageUseCase;
  final CreateConversationUseCase? _createConversationUseCase;
  final GetUserConversationsUseCase? _getUserConversationsUseCase;
  final MarkMessagesAsReadUseCase? _markMessagesAsReadUseCase;

  // Flag para indicar qué modo usar
  final bool _useCleanArchitecture;

  // Suscripciones a streams
  StreamSubscription? _messagesSubscription;
  StreamSubscription? _conversationsSubscription;

  /// Constructor tradicional con repositorio de chat
  ChatBloc(ChatRepository chatRepository)
      : _chatRepository = chatRepository,
        _getMessagesUseCase = null,
        _sendMessageUseCase = null,
        _createConversationUseCase = null,
        _getUserConversationsUseCase = null,
        _markMessagesAsReadUseCase = null,
        _useCleanArchitecture = false,
        super(const ChatState.initial()) {
    _registerEventHandlers();
  }

  /// Constructor para Clean Architecture con casos de uso
  ChatBloc.withUseCases({
    required GetMessagesUseCase getMessagesUseCase,
    required SendMessageUseCase sendMessageUseCase,
    required CreateConversationUseCase createConversationUseCase,
    required GetUserConversationsUseCase getUserConversationsUseCase,
    required MarkMessagesAsReadUseCase markMessagesAsReadUseCase,
  })  : _chatRepository = null,
        _getMessagesUseCase = getMessagesUseCase,
        _sendMessageUseCase = sendMessageUseCase,
        _createConversationUseCase = createConversationUseCase,
        _getUserConversationsUseCase = getUserConversationsUseCase,
        _markMessagesAsReadUseCase = markMessagesAsReadUseCase,
        _useCleanArchitecture = true,
        super(const ChatState.initial()) {
    _registerEventHandlers();
  }

  /// Obtiene el ID del usuario actual autenticado.
  ///
  /// Si no hay usuario autenticado, arroja una excepción.
  Future<String> _getCurrentUserId() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception('No hay usuario autenticado');
    }

    return currentUser.uid;
  }

  /// Registra los manejadores de eventos
  void _registerEventHandlers() {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<MessagesUpdated>(_onMessagesUpdated);
    on<LoadConversations>(_onLoadConversations);
    on<CreateConversation>(_onCreateConversation);
    on<MarkMessagesAsRead>(_onMarkMessagesAsRead);
  }

  Future<void> _onLoadMessages(
      LoadMessages event, Emitter<ChatState> emit) async {
    emit(const ChatState.loading());
    try {
      // Cancelar suscripción anterior si existe
      await _messagesSubscription?.cancel();

      if (_useCleanArchitecture) {
        // Enfoque Clean Architecture
        final params = GetMessagesParams(conversationId: event.conversationId);

        // Suscribirse al stream de mensajes usando el caso de uso
        _messagesSubscription = _getMessagesUseCase!.call(params).listen(
          (result) {
            if (result.isLeft()) {
              emit(ChatState.error(result.fold((l) => l.message, (r) => '')));
              return;
            }

            final messages = result.fold((l) => [], (r) => r);
            final messageModels = messages
                .map((message) => ChatMessageModel(
                      id: message.id,
                      chatId: event.conversationId,
                      senderId: message.senderId,
                      content: message.content,
                      timestamp: message.timestamp,
                      isRead: message.read,
                    ))
                .toList();

            add(MessagesUpdated(messageModels));
          },
          onError: (error) {
            if (error is AppFailure) {
              emit(ChatState.error(error.message));
            } else {
              emit(ChatState.error(error.toString()));
            }
          },
        );

        // Marcar mensajes como leídos si es necesario
        if (event.markAsRead) {
          final userId = await _getCurrentUserId();
          await _markMessagesAsReadUseCase!.call(MarkMessagesAsReadParams(
            conversationId: event.conversationId,
            userId: userId,
          ));
        }
      } else {
        // Enfoque tradicional
        _messagesSubscription = _chatRepository!
            .getMessages(event.conversationId)
            .listen((Either<AppFailure, List<MessageEntity>> result) {
          result.fold(
            (failure) => emit(ChatState.error(failure.message)),
            (messages) {
              final messageModels = messages
                  .map((message) => ChatMessageModel(
                        id: message.id,
                        chatId: event.conversationId,
                        senderId: message.senderId,
                        content: message.content,
                        timestamp: message.timestamp,
                        isRead: message.read,
                      ))
                  .toList();

              add(MessagesUpdated(messageModels));
            },
          );
        }, onError: (error) {
          emit(ChatState.error(error.toString()));
        });

        // Marcar mensajes como leídos
        if (event.markAsRead) {
          // Obtener el userId del usuario autenticado
          final userId = await _getCurrentUserId();
          await _chatRepository!.markConversationAsRead(
            conversationId: event.conversationId,
            userId: userId,
          );
        }
      }
    } catch (e) {
      emit(ChatState.error(e.toString()));
    }
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    try {
      if (_useCleanArchitecture) {
        // Enfoque Clean Architecture
        final params = SendMessageParams(
          conversationId: event.conversationId,
          content: event.content,
          senderId: event.senderId,
        );

        await _sendMessageUseCase!.call(params);
      } else {
        // Enfoque tradicional - Adaptado a la interfaz consolidada
        await _chatRepository!.sendMessage(
          conversationId: event.conversationId,
          content: event.content,
          metadata: {
            'senderId': event.senderId,
          },
        );
      }
    } catch (e) {
      emit(ChatState.error(e.toString()));
    }
  }

  void _onMessagesUpdated(MessagesUpdated event, Emitter<ChatState> emit) {
    // Convertir ChatMessageModel a MessageEntity para mantener compatibilidad
    final messages = event.messages
        .map((msg) => MessageEntity(
              id: msg.id,
              content: msg.content,
              timestamp: msg.timestamp,
              senderId: msg.senderId,
              read: msg.isRead,
            ))
        .toList();

    emit(ChatState.messagesLoaded(
      loadedMessages: messages,
      conversationId:
          event.messages.isNotEmpty ? event.messages.first.chatId : '',
      existingConversations: state.conversations,
    ));
  }

  Future<void> _onLoadConversations(
      LoadConversations event, Emitter<ChatState> emit) async {
    emit(const ChatState.loading());
    try {
      // Cancelar suscripción anterior si existe
      await _conversationsSubscription?.cancel();

      if (_useCleanArchitecture) {
        // Enfoque Clean Architecture
        final params = GetUserConversationsParams(userId: event.userId);

        // Suscribirse al stream de conversaciones usando el caso de uso
        _conversationsSubscription =
            _getUserConversationsUseCase!.execute(params).listen(
          (conversations) => emit(ChatState.conversationsLoaded(conversations)),
          onError: (error) {
            if (error is AppFailure) {
              emit(ChatState.error(error.message));
            } else {
              emit(ChatState.error(error.toString()));
            }
          },
        );
      } else {
        // Enfoque tradicional
        _conversationsSubscription =
            _chatRepository!.getConversations(event.userId).listen(
          (result) {
            if (result.isLeft()) {
              emit(ChatState.error(result.fold((l) => l.message, (r) => '')));
              return;
            }

            final conversations = result.fold((l) => <ConversationEntity>[],
                (r) => r.map((conv) => conv).toList());
            emit(ChatState.conversationsLoaded(conversations));
          },
          onError: (error) {
            if (error is AppFailure) {
              emit(ChatState.error(error.message));
            } else {
              emit(ChatState.error(error.toString()));
            }
          },
        );
      }
    } catch (e) {
      emit(ChatState.error(e.toString()));
    }
  }

  Future<void> _onCreateConversation(
      CreateConversation event, Emitter<ChatState> emit) async {
    emit(const ChatState.loading());
    try {
      if (_useCleanArchitecture) {
        // Enfoque Clean Architecture
        final params = CreateConversationParams(
          participantIds: event.participants,
          initialMessage: event.initialMessage,
        );

        final result = await _createConversationUseCase!.call(params);
        /* result.fold(
            (failure) => emit(ChatState.error(failure.message)),
            (conversationId) => emit(ChatState.conversationCreated(
                newConversationId: conversationId)));*/
      } else {
        // Enfoque tradicional
        final result = await _chatRepository!.createConversation(
          participants: event.participants,
          initialMessage: event.initialMessage,
        );
        result.fold(
            (failure) => emit(ChatState.error(failure.message)),
            (conversationId) => emit(ChatState.conversationCreated(
                newConversationId: conversationId)));
      }
    } catch (e) {
      emit(ChatState.error(e.toString()));
    }
  }

  Future<void> _onMarkMessagesAsRead(
      MarkMessagesAsRead event, Emitter<ChatState> emit) async {
    try {
      if (_useCleanArchitecture) {
        // Enfoque Clean Architecture
        final params = MarkMessagesAsReadParams(
          conversationId: event.conversationId,
          userId: event.userId,
        );

        await _markMessagesAsReadUseCase!.call(params);
      } else {
        // Enfoque tradicional
        await _chatRepository!.markConversationAsRead(
          conversationId: event.conversationId,
          userId: event.userId,
        );
      }
    } catch (e) {
      // Solo emitimos error si algo sale mal
      emit(ChatState.error(e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _messagesSubscription?.cancel();
    await _conversationsSubscription?.cancel();
    return super.close();
  }
}
