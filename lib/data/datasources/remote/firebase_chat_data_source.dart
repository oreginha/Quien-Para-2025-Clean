import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/data/datasources/chat_data_source.dart';
import 'package:quien_para/data/mappers/chat_mapper.dart';
import 'package:quien_para/data/mappers/chat_message_mapper.dart';
import 'package:quien_para/data/models/chat/chat_model.dart';
import 'package:quien_para/data/models/chat_message/chat_message_model.dart';
import 'package:quien_para/domain/entities/conversation/conversation_entity.dart';
import 'package:quien_para/domain/entities/message_entity.dart';

/// Implementación Firebase de [ChatDataSource]
///
/// Esta clase maneja las operaciones de datos relacionadas con chat en Firebase Firestore.
/// Utiliza mappers para convertir entre modelos de datos y entidades de dominio,
/// siguiendo los principios de Clean Architecture.
class FirebaseChatDataSource implements ChatDataSource {
  final FirebaseFirestore _firestore;
  final Logger _logger;

  FirebaseChatDataSource({FirebaseFirestore? firestore, Logger? logger})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _logger = logger ?? Logger();

  @override
  Future<String> createConversation(
    List<String> participants,
    String initialMessage,
  ) async {
    try {
      // Ensure participants list is sorted to maintain consistent conversation IDs
      final sortedParticipants = [...participants]..sort();

      // Check if the conversation already exists
      final querySnapshot = await _firestore
          .collection('conversations')
          .where('participantIds', isEqualTo: sortedParticipants)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Conversation exists, return its ID
        final existingConversationId = querySnapshot.docs.first.id;

        // Send the initial message if provided
        if (initialMessage.isNotEmpty) {
          await sendMessage(
            existingConversationId,
            participants[0], // Assuming the first participant is the sender
            initialMessage,
          );
        }

        return existingConversationId;
      }

      // Create a new conversation
      final conversationDoc = await _firestore.collection('conversations').add({
        'participantIds': sortedParticipants,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessage': initialMessage,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Send the initial message
      if (initialMessage.isNotEmpty) {
        await sendMessage(
          conversationDoc.id,
          participants[0], // Assuming the first participant is the sender
          initialMessage,
        );
      }

      return conversationDoc.id;
    } catch (e) {
      _logger.e('Error creating conversation: $e');
      throw Exception('Failed to create conversation: $e');
    }
  }

  @override
  Future<ConversationEntity?> getConversation(String conversationId) async {
    try {
      final docSnapshot = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .get();

      if (!docSnapshot.exists) return null;

      final data = docSnapshot.data() ?? {};
      final participantIds = List<String>.from(data['participantIds'] ?? []);

      final Timestamp? lastMessageTime = data['lastMessageTime'] as Timestamp?;

      // Crear modelo de chat
      final chatModel = ChatModel(
        id: conversationId,
        participants: participantIds,
        createdAt: data['createdAt'] != null
            ? (data['createdAt'] as Timestamp).toDate()
            : DateTime.now(),
        lastMessageTimestamp: lastMessageTime?.toDate(),
        lastMessage: data['lastMessage'] as String?,
        lastMessageSenderId: data['lastSenderId'] as String?,
        unreadCount: data['unreadCount'] as int? ?? 0,
      );

      // Convertir modelo a entidad usando el mapper
      return ChatMapper.toEntity(chatModel);
    } catch (e) {
      _logger.e('Error getting conversation: $e');
      return null;
    }
  }

  @override
  Future<List<ConversationEntity>> getUserConversations(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('conversations')
          .where('participantIds', arrayContains: userId)
          .orderBy('lastMessageTime', descending: true)
          .get();

      final List<ConversationEntity> conversations = [];

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final participantIds = List<String>.from(data['participantIds'] ?? []);

        // Los detalles de los participantes se cargarán bajo demanda

        final Timestamp? lastMessageTime =
            data['lastMessageTime'] as Timestamp?;

        // Crear modelo de chat
        final chatModel = ChatModel(
          id: doc.id,
          participants: participantIds,
          createdAt: data['createdAt'] != null
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
          lastMessageTimestamp: lastMessageTime?.toDate(),
          lastMessage: data['lastMessage'] as String?,
          lastMessageSenderId: data['lastSenderId'] as String?,
          unreadCount:
              (data['unreadCount'] as Map<String, dynamic>?)?[userId] as int? ??
              0,
        );

        // Convertir modelo a entidad usando el mapper
        conversations.add(ChatMapper.toEntity(chatModel));
      }

      return conversations;
    } catch (e) {
      _logger.e('Error getting user conversations: $e');
      return [];
    }
  }

  @override
  Future<MessageEntity> sendMessage(
    String conversationId,
    String senderId,
    String content,
  ) async {
    try {
      final messageDoc = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .add({
            'senderId': senderId,
            'content': content,
            'timestamp': FieldValue.serverTimestamp(),
            'read': false,
          });

      // Update conversation with last message info
      await _firestore.collection('conversations').doc(conversationId).update({
        'lastMessage': content,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastSenderId': senderId,
      });

      // Crear modelo de mensaje
      final messageModel = ChatMessageModel(
        id: messageDoc.id,
        chatId: conversationId,
        senderId: senderId,
        content: content,
        timestamp: DateTime.now(),
        isRead: false,
      );

      // Convertir modelo a entidad usando el mapper
      return ChatMessageMapper.toEntity(messageModel);
    } catch (e) {
      _logger.e('Error sending message: $e');
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Stream<List<MessageEntity>> getMessages(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          // Convertir documentos a modelos de mensaje
          final List<ChatMessageModel> messageModels = snapshot.docs.map((doc) {
            final data = doc.data();
            final Timestamp? timestamp = data['timestamp'] as Timestamp?;

            return ChatMessageModel(
              id: doc.id,
              chatId: conversationId,
              senderId: data['senderId'] as String,
              content: data['content'] as String,
              timestamp: timestamp?.toDate() ?? DateTime.now(),
              isRead: data['read'] as bool? ?? false,
            );
          }).toList();

          // Convertir modelos a entidades usando el mapper
          return ChatMessageMapper.toEntityList(messageModels);
        });
  }

  @override
  Future<void> markAsRead(String conversationId, String userId) async {
    try {
      // Get the messages that aren't from the current user and aren't read
      final querySnapshot = await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .where('senderId', isNotEqualTo: userId)
          .where('read', isEqualTo: false)
          .get();

      // Update each message
      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {'read': true});
      }

      await batch.commit();

      // Reset unread count for this user
      await _firestore.collection('conversations').doc(conversationId).update({
        'unreadCount.$userId': 0,
      });
    } catch (e) {
      _logger.e('Error marking messages as read: $e');
    }
  }
}
