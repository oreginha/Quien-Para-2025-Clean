// test/data/repositories/application_repository_test.dart

// ignore_for_file: must_be_immutable, subtype_of_sealed_class

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/data/mappers/application_mapper.dart';
import 'package:quien_para/data/repositories/application/application_repository_impl.dart';
import 'package:quien_para/domain/entities/application/application_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockQuery extends Mock implements Query<Map<String, dynamic>> {}

class MockApplicationMapper extends Mock implements ApplicationMapper {}

class MockLogger extends Mock implements Logger {}

class MockWriteBatch extends Mock implements WriteBatch {}

void main() {
  late ApplicationRepositoryImpl applicationRepository;
  late MockFirebaseFirestore mockFirestore;
  late MockApplicationMapper mockMapper;
  late MockLogger mockLogger;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockMapper = MockApplicationMapper();
    mockLogger = MockLogger();

    applicationRepository = ApplicationRepositoryImpl(
      firestore: mockFirestore,
      mapper: mockMapper,
      logger: mockLogger,
    );
  });

  group('getApplicationsForPlan', () {
    test('should return Right with a list of ApplicationEntity when successful',
        () async {
      // Arrange
      final mockCollectionRef = MockCollectionReference();
      final mockQuery = MockQuery();
      final mockQueryOrdered = MockQuery();
      final mockQuerySnapshot = MockQuerySnapshot();
      final mockDocs = [
        MockQueryDocumentSnapshot(),
        MockQueryDocumentSnapshot()
      ];
      const planId = 'test-plan-id';
      final applications = [
        ApplicationEntity(
          id: 'app1',
          planId: planId,
          applicantId: 'user1',
          status: 'pending',
          appliedAt: DateTime(2023, 1, 1),
        ),
        ApplicationEntity(
          id: 'app2',
          planId: planId,
          applicantId: 'user2',
          status: 'accepted',
          appliedAt: DateTime(2023, 1, 2),
        ),
      ];

      when(mockFirestore.collection('applications'))
          .thenReturn(mockCollectionRef);
      when(mockCollectionRef.where('planId', isEqualTo: planId))
          .thenReturn(mockQuery);
      when(mockQuery.orderBy('appliedAt', descending: true))
          .thenReturn(mockQueryOrdered);
      when(mockQueryOrdered.get())
          .thenAnswer((_) => Future.value(mockQuerySnapshot));
      when(mockQuerySnapshot.docs).thenReturn(mockDocs);
      when(mockMapper.fromFirestore(mockDocs[0])).thenReturn(applications[0]);
      when(mockMapper.fromFirestore(mockDocs[1])).thenReturn(applications[1]);

      // Act
      final result = await applicationRepository.getApplicationsForPlan(planId);

      // Assert
      expect(result,
          equals(Right<AppFailure, List<ApplicationEntity>>(applications)));
      verify(mockFirestore.collection('applications')).called(1);
      verify(mockCollectionRef.where('planId', isEqualTo: planId)).called(1);
      verify(mockQuery.orderBy('appliedAt', descending: true)).called(1);
      verify(mockQueryOrdered.get()).called(1);
      verify(mockMapper.fromFirestore(mockDocs[0])).called(1);
      verify(mockMapper.fromFirestore(mockDocs[1])).called(1);
    });

    test('should return Left with AppFailure when an error occurs', () async {
      // Arrange
      final mockCollectionRef = MockCollectionReference();
      final mockQuery = MockQuery();
      final mockQueryOrdered = MockQuery();
      const planId = 'test-plan-id';
      const errorMessage = 'Error getting applications';

      when(mockFirestore.collection('applications'))
          .thenReturn(mockCollectionRef);
      when(mockCollectionRef.where('planId', isEqualTo: planId))
          .thenReturn(mockQuery);
      when(mockQuery.orderBy('appliedAt', descending: true))
          .thenReturn(mockQueryOrdered);
      when(mockQueryOrdered.get()).thenThrow(
          FirebaseException(plugin: 'firestore', message: errorMessage));

      // Act
      final result = await applicationRepository.getApplicationsForPlan(planId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains(errorMessage)),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  group('hasUserAppliedToPlan', () {
    test('should return Right(true) when user has applied to plan', () async {
      // Arrange
      final mockCollectionRef = MockCollectionReference();
      final mockQuery1 = MockQuery();
      final mockQuery2 = MockQuery();
      final mockQuerySnapshot = MockQuerySnapshot();
      final mockDocs = [MockQueryDocumentSnapshot()];
      const userId = 'user1';
      const planId = 'plan1';

      when(mockFirestore.collection('applications'))
          .thenReturn(mockCollectionRef);
      when(mockCollectionRef.where('planId', isEqualTo: planId))
          .thenReturn(mockQuery1);
      when(mockQuery1.where('applicantId', isEqualTo: userId))
          .thenReturn(mockQuery2);
      when(mockQuery2.limit(1)).thenReturn(mockQuery2);
      when(mockQuery2.get()).thenAnswer((_) => Future.value(mockQuerySnapshot));
      when(mockQuerySnapshot.docs).thenReturn(mockDocs);

      // Act
      final result =
          await applicationRepository.hasUserAppliedToPlan(userId, planId);

      // Assert
      expect(result, equals(const Right<AppFailure, bool>(true)));
    });

    test('should return Right(false) when user has not applied to plan',
        () async {
      // Arrange
      final mockCollectionRef = MockCollectionReference();
      final mockQuery1 = MockQuery();
      final mockQuery2 = MockQuery();
      final mockQuerySnapshot = MockQuerySnapshot();
      const userId = 'user1';
      const planId = 'plan1';

      when(mockFirestore.collection('applications'))
          .thenReturn(mockCollectionRef);
      when(mockCollectionRef.where('planId', isEqualTo: planId))
          .thenReturn(mockQuery1);
      when(mockQuery1.where('applicantId', isEqualTo: userId))
          .thenReturn(mockQuery2);
      when(mockQuery2.limit(1)).thenReturn(mockQuery2);
      when(mockQuery2.get()).thenAnswer((_) => Future.value(mockQuerySnapshot));
      when(mockQuerySnapshot.docs).thenReturn([]);

      // Act
      final result =
          await applicationRepository.hasUserAppliedToPlan(userId, planId);

      // Assert
      expect(result, equals(const Right<AppFailure, bool>(false)));
    });

    test('should return Left with AppFailure when an error occurs', () async {
      // Arrange
      final mockCollectionRef = MockCollectionReference();
      final mockQuery1 = MockQuery();
      final mockQuery2 = MockQuery();
      const userId = 'user1';
      const planId = 'plan1';
      const errorMessage = 'Error checking application';

      when(mockFirestore.collection('applications'))
          .thenReturn(mockCollectionRef);
      when(mockCollectionRef.where('planId', isEqualTo: planId))
          .thenReturn(mockQuery1);
      when(mockQuery1.where('applicantId', isEqualTo: userId))
          .thenReturn(mockQuery2);
      when(mockQuery2.limit(1)).thenReturn(mockQuery2);
      when(mockQuery2.get()).thenThrow(
          FirebaseException(plugin: 'firestore', message: errorMessage));

      // Act
      final result =
          await applicationRepository.hasUserAppliedToPlan(userId, planId);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, contains(errorMessage)),
        (_) => fail('Expected Left but got Right'),
      );
    });
  });

  // Más tests para otros métodos...
}
