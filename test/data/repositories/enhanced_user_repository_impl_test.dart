// test/data/repositories/enhanced_user_repository_impl_test.dart

// ignore_for_file: must_be_immutable, subtype_of_sealed_class

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/data/mappers/user_mapper.dart';
import 'package:quien_para/data/repositories/user/user_repository_impl.dart';
import 'package:quien_para/domain/entities/user/user_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/data/datasources/local/user_cache.dart';

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

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockUserMapper extends Mock implements UserMapper {}

class MockLogger extends Mock implements Logger {}

class MockReference extends Mock implements Reference {}

class MockUploadTask extends Mock implements UploadTask {}

class MockTaskSnapshot extends Mock implements TaskSnapshot {}

class MockFile extends Mock implements File {}

class MockUserCache extends Mock implements UserCache {}

void main() {
  late UserRepositoryImpl userRepository;
  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseAuth mockAuth;
  late MockFirebaseStorage mockStorage;
  late MockUserMapper mockMapper;
  late MockLogger mockLogger;
  late MockUserCache mockCache;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockAuth = MockFirebaseAuth();
    mockStorage = MockFirebaseStorage();
    mockMapper = MockUserMapper();
    mockLogger = MockLogger();
    mockCache = MockUserCache();

    userRepository = UserRepositoryImpl(
      firestore: mockFirestore,
      auth: mockAuth,
      storage: mockStorage,
      mapper: mockMapper,
      cache: mockCache,
    );
  });

  group('getCurrentUserId', () {
    test('should return Right with user ID when authenticated', () {
      // Arrange
      final mockUser = MockUser();
      const userId = 'test-user-id';

      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn(userId);

      // Act
      final result = userRepository.getCurrentUserId();

      // Assert
      expect(result, equals(const Right<AppFailure, String?>(userId)));
      verify(mockAuth.currentUser).called(1);
      verify(mockUser.uid).called(1);
    });

    test('should return Right with null when not authenticated', () {
      // Arrange
      when(mockAuth.currentUser).thenReturn(null);

      // Act
      final result = userRepository.getCurrentUserId();

      // Assert
      expect(result, equals(const Right<AppFailure, String?>(null)));
      verify(mockAuth.currentUser).called(1);
    });

    test('should return Left with AppFailure when an error occurs', () {
      // Arrange
      const errorMessage = 'Auth error';
      when(mockAuth.currentUser).thenThrow(
          FirebaseAuthException(code: 'error', message: errorMessage));

      // Act
      final result = userRepository.getCurrentUserId();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains(errorMessage)),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('getUserProfile', () {
    test('should return Right with UserEntity when profile exists', () async {
      // Arrange
      final mockUser = MockUser();
      final mockCollectionRef = MockCollectionReference();
      final mockDocRef = MockDocumentReference();
      final mockDocSnapshot = MockDocumentSnapshot();
      const userId = 'test-user-id';
      final expectedUser = UserEntity(
        id: userId,
        name: 'Test User',
        email: 'test@example.com',
      );

      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn(userId);
      when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
      when(mockCollectionRef.doc(userId)).thenReturn(mockDocRef);
      when(mockDocRef.get()).thenAnswer((_) => Future.value(mockDocSnapshot));
      when(mockDocSnapshot.exists).thenReturn(true);
      when(mockMapper.fromFirestore(mockDocSnapshot)).thenReturn(expectedUser);

      // Act
      final result = await userRepository.getUserProfile();

      // Assert
      expect(result, equals(Right<AppFailure, UserEntity?>(expectedUser)));
      verify(mockAuth.currentUser).called(1);
      verify(mockFirestore.collection('users')).called(1);
      verify(mockDocRef.get()).called(1);
      verify(mockMapper.fromFirestore(mockDocSnapshot)).called(1);
    });

    test('should return Right with null when profile does not exist', () async {
      // Arrange
      final mockUser = MockUser();
      final mockCollectionRef = MockCollectionReference();
      final mockDocRef = MockDocumentReference();
      final mockDocSnapshot = MockDocumentSnapshot();
      const userId = 'test-user-id';

      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn(userId);
      when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
      when(mockCollectionRef.doc(userId)).thenReturn(mockDocRef);
      when(mockDocRef.get()).thenAnswer((_) => Future.value(mockDocSnapshot));
      when(mockDocSnapshot.exists).thenReturn(false);

      // Act
      final result = await userRepository.getUserProfile();

      // Assert
      expect(result, equals(const Right<AppFailure, UserEntity?>(null)));
      verify(mockAuth.currentUser).called(1);
      verify(mockFirestore.collection('users')).called(1);
      verify(mockDocRef.get()).called(1);
    });

    test('should return Right with null when user is not authenticated',
        () async {
      // Arrange
      when(mockAuth.currentUser).thenReturn(null);

      // Act
      final result = await userRepository.getUserProfile();

      // Assert
      expect(result, equals(const Right<AppFailure, UserEntity?>(null)));
      verify(mockAuth.currentUser).called(1);
    });

    test('should return Left with AppFailure when an error occurs', () async {
      // Arrange
      final mockUser = MockUser();
      final mockCollectionRef = MockCollectionReference();
      final mockDocRef = MockDocumentReference();
      const userId = 'test-user-id';
      const errorMessage = 'Firestore error';

      when(mockAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn(userId);
      when(mockFirestore.collection('users')).thenReturn(mockCollectionRef);
      when(mockCollectionRef.doc(userId)).thenReturn(mockDocRef);
      when(mockDocRef.get()).thenThrow(
          FirebaseException(plugin: 'firestore', message: errorMessage));

      // Act
      final result = await userRepository.getUserProfile();

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
