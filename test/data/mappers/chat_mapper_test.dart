// test/data/mappers/chat_mapper_test.dart

// ignore_for_file: subtype_of_sealed_class, unused_local_variable

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quien_para/data/mappers/chat_mapper.dart';
import 'package:quien_para/data/models/chat/chat_model.dart';
import 'package:quien_para/domain/entities/conversation/conversation_entity.dart';

// Mock de DocumentSnapshot para pruebas
class MockDocumentSnapshot extends Mock implements DocumentSnapshot {
  final Map<String, dynamic> _data;
  final String _id;

  MockDocumentSnapshot(this._id, this._data);

  @override
  Map<String, dynamic> data() => _data;

  @override
  String get id => _id;

  @override
  bool get exists => true;
}

void main() {
  late ChatMapper chatMapper;

  setUp(() {
    chatMapper = const ChatMapper();
  });

  group('ChatMapper', () {
    test('toEntity should convert ChatModel to ConversationEntity', () {
      // Arrange
      final chatModel = ChatModel(
        id: 'test-chat-id',
        participants: ['user1', 'user2'],
        createdAt: DateTime(2023, 1, 1),
        lastMessageTimestamp: DateTime(2023, 1, 2),
        lastMessage: 'Hello',
        lastMessageSenderId: 'user1',
        unreadCount: 2,
      );

      // Act
      final entity = ChatMapper.toEntity(chatModel);

      // Assert
      expect(entity.id, 'test-chat-id');
      expect(entity.participants.length, 2);
      expect(entity.participants[0]['id'], 'user1');
      expect(entity.participants[1]['id'], 'user2');
      expect(entity.lastMessage, 'Hello');
      expect(entity.lastMessageTime, DateTime(2023, 1, 2));
      expect(entity.unreadCount, 2);
    });

    test('toModel should convert ConversationEntity to ChatModel', () {
      // Arrange
      final entity = ConversationEntity(
        id: 'test-chat-id',
        participants: [
          {'id': 'user1', 'name': 'User 1', 'photoUrl': 'url1'},
          {'id': 'user2', 'name': 'User 2', 'photoUrl': 'url2'},
        ],
        lastMessage: 'Hello',
        lastMessageTime: DateTime(2023, 1, 2),
        unreadCount: 2,
      );

      // Act
      final model = ChatMapper.toModel(entity);

      // Assert
      expect(model.id, 'test-chat-id');
      expect(model.participants, ['user1', 'user2']);
      expect(model.lastMessage, 'Hello');
      expect(model.lastMessageTimestamp, DateTime(2023, 1, 2));
      expect(model.unreadCount, 2);
    });

    /* 
    Más pruebas pendientes de implementar cuando tengamos acceso a
    los mocks correctos para Firestore:
    
    test('fromFirestore should convert DocumentSnapshot to ConversationEntity', () {
      // Este test requiere un mock más avanzado de DocumentSnapshot
    });

    test('toFirestore should convert ConversationEntity to Map for Firestore', () {
      // Se implementará cuando se complete el mapper
    });
    */
  });
}
