// test/data/repositories/chat_repository_impl_test.dart

// ignore_for_file: must_be_immutable, subtype_of_sealed_class

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/data/mappers/chat_mapper.dart';
import 'package:quien_para/data/mappers/message_mapper.dart';
import 'package:quien_para/data/repositories/chat/chat_repository_impl.dart';
import 'package:quien_para/domain/entities/conversation/conversation_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockUser extends Mock implements User {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockChatMapper extends Mock implements ChatMapper {}

class MockMessageMapper extends Mock implements MessageMapper {}

class MockLogger extends Mock implements Logger {}

class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

void main() {
  late ChatRepositoryImpl chatRepository;
  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseAuth mockAuth;
  late MockChatMapper mockChatMapper;
  late MockMessageMapper mockMessageMapper;
  late MockLogger mockLogger;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockAuth = MockFirebaseAuth();
    mockChatMapper = MockChatMapper();
    mockMessageMapper = MockMessageMapper();
    mockLogger = MockLogger();

    chatRepository = ChatRepositoryImpl(
      firestore: mockFirestore,
      auth: mockAuth,
      chatMapper: mockChatMapper,
      messageMapper: mockMessageMapper,
      logger: mockLogger,
    );
  });

  group('createConversation', () {
    test('should return Right with conversation ID when successful', () async {
      // Arrange
      final mockCollectionRef = MockCollectionReference();
      final mockDocRef = MockDocumentReference();
      final mockUser = MockUser();
      final participants = ['user1', 'user2'];
      const conversationId = 'test-conversation-id';

      when(mockFirestore.collection('chats')).thenReturn(mockCollectionRef);
      when(mockCollectionRef.doc()).thenReturn(mockDocRef);
      when(mockDocRef.id).thenReturn(conversationId);
      when(mockDocRef.set(mockCollectionRef as Map<String, dynamic>))
          .thenAnswer((invocation) async {
        final Map<String, dynamic> data =
            invocation.positionalArguments[0] as Map<String, dynamic>;
        // Puedes agregar asserts aquí si quieres validar el contenido de data
        return Future.value();
      });
      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('user1');

      // Act
      final result = await chatRepository.createConversation(
        participants: participants,
        initialMessage: 'Hello',
      );

      // Assert
      expect(result, equals(const Right<AppFailure, String>(conversationId)));
      verify(mockFirestore.collection('chats')).called(1);
      verify(mockDocRef.set(conversationId as Map<String, dynamic>)).called(1);
      verifyNever(mockDocRef.collection('messages'));

      // Verify the data structure matches expected format
      final verificationResult =
          verify(mockDocRef.set(mockCollectionRef as Map<String, dynamic>))
              .captured
              .single as Map<String, dynamic>;
      expect(verificationResult, {
        'participants': participants,
        'lastMessage': 'Hello',
        'createdAt': any,
        'lastMessageTime': any,
        'unreadCount': 0,
      });
      verify(mockDocRef.set(mockCollectionRef as Map<String, dynamic>));
      verify(mockDocRef.set(mockCollectionRef as Map<String, dynamic>));
      verify(mockDocRef.set(mockCollectionRef as Map<String, dynamic>))
          .called(1);
    });

    test('should return Left with AppFailure when an error occurs', () async {
      // Arrange
      final mockCollectionRef = MockCollectionReference();
      final mockDocRef = MockDocumentReference();
      final participants = ['user1', 'user2'];
      const errorMessage = 'Error creating conversation';

      when(mockFirestore.collection('chats')).thenReturn(mockCollectionRef);
      when(mockCollectionRef.doc()).thenReturn(mockDocRef);
      when(mockDocRef.set(mockCollectionRef as Map<String, dynamic>)).thenThrow(
          FirebaseException(plugin: 'firestore', message: errorMessage));
      when(mockAuth.currentUser).thenReturn(null);

      // Act
      final result = await chatRepository.createConversation(
        participants: participants,
        initialMessage: 'Test message',
      );

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains(errorMessage)),
        (_) => fail('Expected Left but got Right'),
      );
      verify(mockDocRef.set(mockCollectionRef as Map<String, dynamic>))
          .called(1);
      verifyNever(mockDocRef.collection('messages'));

      // Verify the data structure matches expected format
      final verificationResult =
          verify(mockDocRef.set(mockCollectionRef as Map<String, dynamic>))
              .captured
              .single as Map<String, dynamic>;
      expect(verificationResult, {
        'participants': participants,
        'lastMessage': 'Test message',
        'createdAt': any,
        'lastMessageTime': any,
        'unreadCount': 0,
      });
      verify(mockDocRef.set(mockCollectionRef as Map<String, dynamic>))
          .called(1);
    });
  });

  group('getConversation', () {
    test('should return Right with ConversationEntity when found', () async {
      // Arrange
      final mockCollectionRef = MockCollectionReference();
      final mockDocRef = MockDocumentReference();
      final mockDocSnapshot = MockDocumentSnapshot();
      const conversationId = 'test-conversation-id';
      final expectedConversation = ConversationEntity(
        id: conversationId,
        participants: [
          {'id': 'user1', 'name': 'User 1', 'photoUrl': 'url1'},
          {'id': 'user2', 'name': 'User 2', 'photoUrl': 'url2'},
        ],
      );

      when(mockFirestore.collection('chats')).thenReturn(mockCollectionRef);
      when(mockCollectionRef.doc(conversationId)).thenReturn(mockDocRef);
      when(mockDocRef.get()).thenAnswer((_) => Future.value(mockDocSnapshot));
      when(mockDocSnapshot.exists).thenReturn(true);
      when(mockDocSnapshot.data()).thenReturn(<String, dynamic>{});
      when(mockDocSnapshot.data()).thenReturn(<String, dynamic>{
        'id': conversationId,
        'participants': [
          {'id': 'user1', 'name': 'User 1', 'photoUrl': 'url1'},
          {'id': 'user2', 'name': 'User 2', 'photoUrl': 'url2'}
        ],
        'lastMessage': 'Test message',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'createdBy': 'user1'
      });
      when(mockChatMapper.fromFirestore(mockDocSnapshot))
          .thenReturn(expectedConversation);

      // Act
      final result = await chatRepository.getConversation(conversationId);

      // Assert
      expect(result,
          equals(Right<AppFailure, ConversationEntity?>(expectedConversation)));
      verify(mockFirestore.collection('chats')).called(1);
      verify(mockDocRef.get()).called(1);
      verify(mockChatMapper.fromFirestore(mockDocSnapshot)).called(1);
    });

    test('should return Right with null when conversation not found', () async {
      // Arrange
      final mockCollectionRef = MockCollectionReference();
      final mockDocRef = MockDocumentReference();
      final mockDocSnapshot = MockDocumentSnapshot();
      const conversationId = 'test-conversation-id';

      when(mockFirestore.collection('chats')).thenReturn(mockCollectionRef);
      when(mockCollectionRef.doc(conversationId)).thenReturn(mockDocRef);
      when(mockDocRef.get()).thenAnswer((_) => Future.value(mockDocSnapshot));
      when(mockDocSnapshot.exists).thenReturn(false);
      when(mockDocSnapshot.data()).thenReturn(<String, dynamic>{});

      // Act
      final result = await chatRepository.getConversation(conversationId);

      // Assert
      expect(
          result, equals(const Right<AppFailure, ConversationEntity?>(null)));
      verify(mockFirestore.collection('chats')).called(1);
      verify(mockDocRef.get()).called(1);
    });

    test('should return Left with AppFailure when an error occurs', () async {
      // Arrange
      final mockCollectionRef = MockCollectionReference();
      final mockDocRef = MockDocumentReference();
      const conversationId = 'test-conversation-id';
      const errorMessage = 'Error getting conversation';

      when(mockFirestore.collection('chats')).thenReturn(mockCollectionRef);
      when(mockCollectionRef.doc(conversationId)).thenReturn(mockDocRef);
      when(mockDocRef.get()).thenThrow(
          FirebaseException(plugin: 'firestore', message: errorMessage));

      // Act
      final result = await chatRepository.getConversation(conversationId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains(errorMessage)),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  // Más tests para los demás métodos del repository
  // ...
}
