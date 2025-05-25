// lib/presentation/bloc/chat/simple_chat_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'simple_chat_event.dart';
part 'simple_chat_state.dart';

/// BLoC simplificado para chat que usa Firebase directamente
/// Mantiene el patrón arquitectural sin la complejidad de Clean Architecture
class SimpleChatBloc extends Bloc<SimpleChatEvent, SimpleChatState> {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  
  StreamSubscription? _messagesSubscription;
  StreamSubscription? _conversationsSubscription;

  SimpleChatBloc({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        super(const SimpleChatState.initial()) {
    on<LoadConversations>(_onLoadConversations);
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<ConversationsUpdated>(_onConversationsUpdated);
    on<MessagesUpdated>(_onMessagesUpdated);
    on<MarkAsRead>(_onMarkAsRead);
  }

  String get _currentUserId => _auth.currentUser?.uid ?? '';

  Future<void> _onLoadConversations(
    LoadConversations event,
    Emitter<SimpleChatState> emit,
  ) async {
    if (_currentUserId.isEmpty) {
      emit(const SimpleChatState.error('Usuario no autenticado'));
      return;
    }

    emit(const SimpleChatState.loading());

    try {
      await _conversationsSubscription?.cancel();
      
      // Query simplificada sin orderBy para evitar errores
      _conversationsSubscription = _firestore
          .collection('conversations')
          .where('participants', arrayContains: _currentUserId)
          .snapshots()
          .listen(
            (snapshot) {
              if (snapshot.docs.isEmpty) {
                // Si no hay conversaciones, emitir lista vacía
                add(const ConversationsUpdated([]));
                return;
              }

              final conversations = snapshot.docs.map((doc) {
                final data = doc.data();
                final participants = List<String>.from(data['participants'] ?? []);
                final otherParticipantId = participants.firstWhere(
                  (id) => id != _currentUserId,
                  orElse: () => 'unknown',
                );

                return {
                  'id': doc.id,
                  'participants': participants,
                  'otherParticipantId': otherParticipantId,
                  'otherParticipantName': _getParticipantName(data, otherParticipantId),
                  'otherParticipantPhoto': _getParticipantPhoto(data, otherParticipantId),
                  'lastMessage': data['lastMessage'] ?? '',
                  'lastMessageTimestamp': data['lastMessageTimestamp'] ?? Timestamp.now(),
                  'unreadCount': _getUnreadCount(data, _currentUserId),
                };
              }).toList();

              // Ordenar por fecha en el cliente
              conversations.sort((a, b) {
                final timestampA = a['lastMessageTimestamp'] as Timestamp;
                final timestampB = b['lastMessageTimestamp'] as Timestamp;
                return timestampB.compareTo(timestampA);
              });

              add(ConversationsUpdated(conversations));
            },
            onError: (error) {
              if (kDebugMode) {
                print('Error en conversaciones: $error');
              }
              emit(SimpleChatState.error('Error al cargar conversaciones: $error'));
            },
          );
    } catch (e) {
      if (kDebugMode) {
        print('Error general en conversaciones: $e');
      }
      emit(SimpleChatState.error('Error: $e'));
    }
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<SimpleChatState> emit,
  ) async {
    emit(const SimpleChatState.loading());

    try {
      await _messagesSubscription?.cancel();

      _messagesSubscription = _firestore
          .collection('conversations')
          .doc(event.conversationId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(100)
          .snapshots()
          .listen(
            (snapshot) {
              final messages = snapshot.docs.map((doc) {
                final data = doc.data();
                return {
                  'id': doc.id,
                  'content': data['content'] ?? '',
                  'senderId': data['senderId'] ?? '',
                  'timestamp': data['timestamp'] ?? Timestamp.now(),
                  'read': data['read'] ?? false,
                };
              }).toList();

              add(MessagesUpdated(messages, event.conversationId));
            },
            onError: (error) {
              emit(SimpleChatState.error('Error al cargar mensajes: $error'));
            },
          );

      // Marcar mensajes como leídos si se solicita
      if (event.markAsRead) {
        add(MarkAsRead(event.conversationId));
      }
    } catch (e) {
      emit(SimpleChatState.error('Error: $e'));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<SimpleChatState> emit,
  ) async {
    try {
      // Agregar mensaje a la subcolección
      await _firestore
          .collection('conversations')
          .doc(event.conversationId)
          .collection('messages')
          .add({
        'content': event.content,
        'senderId': event.senderId,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      });

      // Actualizar información de la conversación
      await _firestore
          .collection('conversations')
          .doc(event.conversationId)
          .update({
        'lastMessage': event.content,
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
        'unreadCounts.${event.receiverId}': FieldValue.increment(1),
      });
    } catch (e) {
      emit(SimpleChatState.error('Error al enviar mensaje: $e'));
    }
  }

  void _onConversationsUpdated(
    ConversationsUpdated event,
    Emitter<SimpleChatState> emit,
  ) {
    emit(SimpleChatState.conversationsLoaded(event.conversations));
  }

  void _onMessagesUpdated(
    MessagesUpdated event,
    Emitter<SimpleChatState> emit,
  ) {
    emit(SimpleChatState.messagesLoaded(
      event.messages,
      event.conversationId,
    ));
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<SimpleChatState> emit,
  ) async {
    try {
      // Marcar mensajes como leídos
      final batch = _firestore.batch();
      
      final messagesQuery = await _firestore
          .collection('conversations')
          .doc(event.conversationId)
          .collection('messages')
          .where('senderId', isNotEqualTo: _currentUserId)
          .where('read', isEqualTo: false)
          .get();

      for (final doc in messagesQuery.docs) {
        batch.update(doc.reference, {'read': true});
      }

      // Resetear contador de no leídos
      batch.update(
        _firestore.collection('conversations').doc(event.conversationId),
        {'unreadCounts.$_currentUserId': 0},
      );

      await batch.commit();
    } catch (e) {
      // Error no crítico, no emitir estado de error
      if (kDebugMode) {
        print('Error al marcar como leído: $e');
      }
    }
  }

  String _getParticipantName(Map<String, dynamic> data, String participantId) {
    final participantsInfo = data['participantsInfo'] as Map<String, dynamic>? ?? {};
    return participantsInfo[participantId]?['name'] as String? ?? 'Usuario';
  }

  String? _getParticipantPhoto(Map<String, dynamic> data, String participantId) {
    final participantsInfo = data['participantsInfo'] as Map<String, dynamic>? ?? {};
    return participantsInfo[participantId]?['photoUrl'] as String?;
  }

  int _getUnreadCount(Map<String, dynamic> data, String userId) {
    final unreadCounts = data['unreadCounts'] as Map<String, dynamic>? ?? {};
    return unreadCounts[userId] as int? ?? 0;
  }

  @override
  Future<void> close() async {
    await _messagesSubscription?.cancel();
    await _conversationsSubscription?.cancel();
    return super.close();
  }
}
