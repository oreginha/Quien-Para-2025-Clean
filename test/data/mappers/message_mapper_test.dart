// test/data/mappers/message_mapper_test.dart

// ignore_for_file: subtype_of_sealed_class

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quien_para/data/mappers/message_mapper.dart';
import 'package:quien_para/data/models/chat_message/chat_message_model.dart';
import 'package:quien_para/domain/entities/message_entity.dart';

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
  late MessageMapper messageMapper;

  setUp(() {
    messageMapper = const MessageMapper();
  });

  group('MessageMapper', () {
    test('toEntity should convert ChatMessageModel to MessageEntity', () {
      // Arrange
      final chatMessageModel = ChatMessageModel(
        id: 'test-message-id',
        chatId: 'test-chat-id',
        senderId: 'user1',
        content: 'Hello',
        timestamp: DateTime(2023, 1, 1),
        isRead: false,
        type: MessageType.text,
      );

      // Act
      final entity = messageMapper.toEntity(chatMessageModel);

      // Assert
      expect(entity.id, 'test-message-id');
      expect(entity.senderId, 'user1');
      expect(entity.content, 'Hello');
      expect(entity.timestamp, DateTime(2023, 1, 1));
      expect(entity.read, false);
    });

    test('toModel should convert MessageEntity to ChatMessageModel', () {
      // Arrange
      final entity = MessageEntity(
        id: 'test-message-id',
        senderId: 'user1',
        content: 'Hello',
        timestamp: DateTime(2023, 1, 1),
        read: false,
      );

      const chatId = 'test-chat-id';

      // Act
      final model = messageMapper.toModel(entity, chatId: chatId);

      // Assert
      expect(model.id, 'test-message-id');
      expect(model.chatId, 'test-chat-id');
      expect(model.senderId, 'user1');
      expect(model.content, 'Hello');
      expect(model.timestamp, DateTime(2023, 1, 1));
      expect(model.isRead, false);
      expect(model.type, MessageType.text);
    });

    /* 
    Más pruebas pendientes de implementar cuando tengamos acceso a
    los mocks correctos para Firestore:
    
    test('fromFirestore should convert DocumentSnapshot to MessageEntity', () {
      // Este test requiere un mock más avanzado de DocumentSnapshot
    });

    test('toFirestore should convert MessageEntity to Map for Firestore', () {
      // Se implementará cuando se complete el mapper
    });
    */

    test('parseTimestamp should handle different timestamp formats', () {
      // Arrange
      final timestamp = Timestamp(1641006000, 0); // 01/01/2023 00:00:00
      final timestampStr = '2023-01-01T00:00:00.000';
      final expectedDate = DateTime(2023, 1, 1);

      // Act
      final date1 = messageMapper.parseTimestamp(timestamp);
      final date2 = messageMapper.parseTimestamp(timestampStr);
      final date3 = messageMapper.parseTimestamp(null);

      // Assert
      expect(date1, expectedDate);
      expect(date2, expectedDate);
      expect(
        date3.year,
        DateTime.now().year,
      ); // Debería ser una fecha cercana a ahora
    });
  });
}
