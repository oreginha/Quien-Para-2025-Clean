import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/core/services/planes_api_service.dart';
import 'package:quien_para/data/datasources/local/user_cache.dart';
import 'package:quien_para/data/mappers/user_mapper.dart';
import 'package:quien_para/data/models/user/user_model.dart';
import 'package:quien_para/data/repositories/plan/plan_repository_impl.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/entities/user/user_entity.dart';

import '../../helpers/mock_firebase_auth.dart' as helpers;

import 'package:mockito/annotations.dart';
import 'plan_repository_impl_test.mocks.dart';

@GenerateMocks([FirebaseStorage, UserCache, PlanApiService, Logger],
    customMocks: [MockSpec<UserMapper>(as: #MockUserMapper)])
const testPlanId = 'test-plan-id';
final testPlan = PlanEntity(
  id: testPlanId,
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

final testUserModel = UserModel(
  id: 'test-user-id',
  name: 'Test User',
  email: 'test@example.com',
  age: 25,
  interests: const [],
  bio: null,
  createdAt: DateTime.now(),
);

void main() {
  late PlanRepositoryImpl repository;
  late FakeFirebaseFirestore fakeFirestore;
  late helpers.MockFirebaseAuth mockAuth;
  late MockFirebaseStorage mockStorage;
  late MockUserCache mockCache;
  late MockPlanApiService mockApiService;
  late MockLogger mockLogger;
  late MockUserMapper mockUserMapper;

  setUp(() {
    // Inicializar mocks
    fakeFirestore = FakeFirebaseFirestore();
    mockAuth = helpers.MockFirebaseAuth();
    mockStorage = MockFirebaseStorage();
    mockCache = MockUserCache();
    mockApiService = MockPlanApiService();
    mockLogger = MockLogger();
    mockUserMapper = MockUserMapper();

    // Configurar comportamiento básico de los mocks
    when(mockUserMapper.toEntity(testUserModel)).thenReturn(const UserEntity(
      id: 'test-user-id',
      name: 'Test User',
      email: 'test@example.com',
      age: 25,
    ));

    // Crear repositorio
    repository = PlanRepositoryImpl(
      mockApiService,
      firestore: fakeFirestore,
      storage: mockStorage,
      auth: mockAuth,
      cache: mockCache,
      logger: mockLogger,
      mapper: mockUserMapper,
    );
  });

  group('PlanRepositoryImpl Tests', () {
    test('create should succeed when given valid plan', () async {
      // Preparar el plan de prueba
      final planToCreate = testPlan.copyWith(id: '');

      // Llamar al método create
      final result = await repository.create(planToCreate);

      // Verificar el resultado
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not return failure'),
        (plan) {
          expect(plan.title, equals(planToCreate.title));
          expect(plan.description, equals(planToCreate.description));
          expect(plan.id, isNotEmpty);
        },
      );
    });

    test('getById should return plan when document exists', () async {
      // Primero crear el plan
      await fakeFirestore
          .collection('plans')
          .doc(testPlanId)
          .set({'test': 'data'});

      // Obtener el plan
      final result = await repository.getById(testPlanId);

      // Verificar el resultado
      expect(result.isRight(), isTrue);
    });
  });
}
