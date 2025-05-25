import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/core/services/planes_api_service.dart';
import 'package:quien_para/data/datasources/local/user_cache.dart';
import 'package:quien_para/data/mappers/user_mapper.dart';
import 'package:quien_para/data/repositories/plan/plan_repository_impl.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';

import '../../data/repositories/enhanced_user_repository_impl_test.dart';

// Mocks para dependencias
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCache extends Mock implements UserCache {}

class MockPlanApiService extends Mock implements PlanApiService {}

class MockUserMapper extends Mock implements UserMapper {}

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late MockFirebaseAuth mockAuth;
  late MockFirebaseStorage mockStorage;
  late MockUserCache mockCache;
  late MockPlanApiService mockApiService;
  late Logger logger;
  late PlanRepository repository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    mockAuth = MockFirebaseAuth();
    mockStorage = MockFirebaseStorage();
    mockCache = MockUserCache();
    mockApiService = MockPlanApiService();
    logger = Logger();
    final mockMapper = MockUserMapper();

    repository = PlanRepositoryImpl(
      mockApiService,
      firestore: fakeFirestore,
      storage: mockStorage,
      auth: mockAuth,
      cache: mockCache,
      logger: logger,
      mapper: mockMapper,
    );
  });

  group('PlanRepositoryImpl Integration Tests', () {
    final testPlan = PlanEntity(
      id: '',
      creatorId: 'test-user-id',
      title: 'Test Plan',
      description: 'Test Description',
      location: 'Test Location',
      date: DateTime(2024, 12, 31),
      category: 'Test Category',
      imageUrl: 'https://example.com/image.jpg',
      conditions: {'condition1': 'value1', 'condition2': 'value2'},
      selectedThemes: ['theme1', 'theme2'],
      tags: ['tag1', 'tag2'],
      likes: 0,
      createdAt: DateTime.now(),
      updatedAt: null,
      payCondition: null,
      guestCount: null,
      extraConditions: '',
    );

    test('should create a plan in Firestore and retrieve it by ID', () async {
      // Create a plan
      final createResult = await repository.create(testPlan);

      // Get the created plan ID
      String planId = '';
      createResult.fold(
        (failure) => fail('Should not return failure'),
        (plan) {
          planId = plan.id;
          expect(planId, isNotEmpty);
        },
      );

      // Retrieve the plan by ID
      final retrieveResult = await repository.getById(planId);

      // Verify retrieval
      retrieveResult.fold(
        (failure) => fail('Should not return failure'),
        (plan) {
          expect(plan, isNotNull);
          expect(plan?.id, equals(planId));
          expect(plan?.title, equals(testPlan.title));
          expect(plan?.description, equals(testPlan.description));
          expect(plan?.creatorId, equals(testPlan.creatorId));
        },
      );
    });

    test('should update an existing plan in Firestore', () async {
      // First create a plan
      final createResult = await repository.create(testPlan);

      // Get the created plan ID
      String planId = '';
      createResult.fold(
        (failure) => fail('Should not return failure'),
        (plan) {
          planId = plan.id;
          expect(planId, isNotEmpty);
        },
      );

      // Now update the plan
      final updatedPlan = testPlan.copyWith(
        id: planId,
        title: 'Updated Title',
        description: 'Updated Description',
      );

      final updateResult = await repository.update(updatedPlan);

      // Verify update was successful
      updateResult.fold(
        (failure) => fail('Should not return failure'),
        (plan) {
          expect(plan.id, equals(planId));
          expect(plan.title, equals('Updated Title'));
          expect(plan.description, equals('Updated Description'));
        },
      );

      // Verify the update is persisted in the database
      final retrieveResult = await repository.getById(planId);

      retrieveResult.fold(
        (failure) => fail('Should not return failure'),
        (plan) {
          expect(plan, isNotNull);
          expect(plan?.title, equals('Updated Title'));
          expect(plan?.description, equals('Updated Description'));
        },
      );
    });

    test('should delete a plan from Firestore', () async {
      // First create a plan
      final createResult = await repository.create(testPlan);

      // Get the created plan ID
      String planId = '';
      createResult.fold(
        (failure) => fail('Should not return failure'),
        (plan) {
          planId = plan.id;
          expect(planId, isNotEmpty);
        },
      );

      // Now delete the plan
      final deleteResult = await repository.delete(planId);

      // Verify delete was successful
      deleteResult.fold(
        (failure) => fail('Should not return failure'),
        (unit) => expect(unit, isNotNull), // Unit is always non-null
      );

      // Verify the plan is deleted from the database
      final retrieveResult = await repository.getById(planId);

      retrieveResult.fold(
        (failure) => fail('Should not return failure'),
        (plan) => expect(plan, isNull),
      );
    });

    test('should retrieve a list of plans', () async {
      // Create multiple plans
      for (int i = 0; i < 3; i++) {
        final plan = testPlan.copyWith(
          title: 'Test Plan $i',
          description: 'Test Description $i',
        );

        final result = await repository.create(plan);
        result.fold(
          (failure) => fail('Should not return failure'),
          (plan) => expect(plan.id, isNotEmpty),
        );
      }

      // Retrieve all plans
      final getResult = await repository.getAll(limit: 10);

      // Verify we got all plans
      getResult.fold(
        (failure) => fail('Should not return failure'),
        (plans) {
          expect(plans, isNotEmpty);
          expect(plans.length, equals(3));

          // Verify the plans have the expected titles
          final titles = plans.map((p) => p.title).toList();
          expect(titles,
              containsAll(['Test Plan 0', 'Test Plan 1', 'Test Plan 2']));
        },
      );
    });

    test('should filter plans by category', () async {
      // Create plans with different categories
      final categories = ['sports', 'food', 'movies', 'sports'];

      for (int i = 0; i < categories.length; i++) {
        final plan = testPlan.copyWith(
          title: 'Test Plan $i',
          category: categories[i],
        );

        final result = await repository.create(plan);
        result.fold(
          (failure) => fail('Should not return failure'),
          (plan) => expect(plan.id, isNotEmpty),
        );
      }

      // Search for sports plans
      final searchResult = await repository.search({'category': 'sports'});

      // Verify we get only sports plans
      searchResult.fold(
        (failure) => fail('Should not return failure'),
        (plans) {
          expect(plans, isNotEmpty);
          expect(plans.length, equals(2)); // We created 2 sports plans

          // Verify all plans have sports category
          for (final plan in plans) {
            expect(plan.category, equals('sports'));
          }
        },
      );
    });

    test('should retrieve plans created by a specific user', () async {
      // Create plans with different creator IDs
      final creatorIds = ['user1', 'user2', 'user1', 'user3'];

      for (int i = 0; i < creatorIds.length; i++) {
        final plan = testPlan.copyWith(
          title: 'Test Plan $i',
          creatorId: creatorIds[i],
        );

        final result = await repository.create(plan);
        result.fold(
          (failure) => fail('Should not return failure'),
          (plan) => expect(plan.id, isNotEmpty),
        );
      }

      // Get plans by user1
      final result = await repository.getPlansByUserId('user1');

      // Verify we get only user1's plans
      result.fold(
        (failure) => fail('Should not return failure'),
        (plans) {
          expect(plans, isNotEmpty);
          expect(plans.length, equals(2)); // We created 2 plans for user1

          // Verify all plans have user1 as creator
          for (final plan in plans) {
            expect(plan.creatorId, equals('user1'));
          }
        },
      );
    });
  });
}
