// ignore_for_file: unused_local_variable

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quien_para/data/mappers/plan_mapper.dart';
import 'package:quien_para/data/models/plan/plan_model.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';

void main() {
  late PlanMapper mapper;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    mapper = const PlanMapper();
    fakeFirestore = FakeFirebaseFirestore();
  });

  group('PlanMapper', () {
    final DateTime testDate = DateTime(2024, 12, 31);

    final testEntity = PlanEntity(
      id: 'test-id',
      title: 'Test Plan',
      description: 'Test Description',
      location: 'Test Location',
      date: testDate,
      category: 'Test Category',
      tags: ['tag1', 'tag2'],
      imageUrl: 'https://example.com/image.jpg',
      creatorId: 'test-user-id',
      conditions: {'condition1': 'value1', 'condition2': 'value2'},
      selectedThemes: ['theme1', 'theme2'],
      likes: 10,
      createdAt: DateTime.now(),
      updatedAt: null,
      payCondition: 'free',
      guestCount: 5,
      extraConditions: 'No smoking',
    );

    final testModel = PlanModel(
      id: 'test-id',
      title: 'Test Plan',
      description: 'Test Description',
      imageUrl: 'https://example.com/image.jpg',
      creatorId: 'test-user-id',
      date: testDate,
      likes: 10,
      category: 'Test Category',
      location: 'Test Location',
      conditions: {'condition1': 'value1', 'condition2': 'value2'},
      selectedThemes: ['theme1', 'theme2'],
      createdAt: DateTime.now().toIso8601String(),
    );

    test('should convert PlanEntity to PlanModel correctly', () {
      // Act
      final result = mapper.toModel(testEntity);

      // Assert
      expect(result, isA<PlanModel>());
      expect(result.id, equals(testEntity.id));
      expect(result.title, equals(testEntity.title));
      expect(result.description, equals(testEntity.description));
      expect(result.location, equals(testEntity.location));
      expect(result.date, equals(testEntity.date));
      expect(result.category, equals(testEntity.category));
      expect(result.imageUrl, equals(testEntity.imageUrl));
      expect(result.creatorId, equals(testEntity.creatorId));
      expect(result.conditions, equals(testEntity.conditions));
      expect(result.selectedThemes, equals(testEntity.selectedThemes));
      expect(result.likes, equals(testEntity.likes));
    });

    test('should convert PlanModel to PlanEntity correctly', () {
      // Act
      final result = mapper.toEntity(testModel);

      // Assert
      expect(result, isA<PlanEntity>());
      expect(result.id, equals(testModel.id));
      expect(result.title, equals(testModel.title));
      expect(result.description, equals(testModel.description));
      expect(result.location, equals(testModel.location));
      expect(result.date, equals(testModel.date));
      expect(result.category, equals(testModel.category));
      expect(result.imageUrl, equals(testModel.imageUrl));
      expect(result.creatorId, equals(testModel.creatorId));
      expect(result.conditions, equals(testModel.conditions));
      expect(result.selectedThemes, equals(testModel.selectedThemes));
      expect(result.likes, equals(testModel.likes));
    });

    test('should convert PlanEntity to Firestore map correctly', () {
      // Act
      final result = mapper.toFirestore(testEntity);

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], isNull); // ID no se incluye en el mapa
      expect(result['title'], equals(testEntity.title));
      expect(result['description'], equals(testEntity.description));
      expect(result['location'], equals(testEntity.location));
      expect(result['category'], equals(testEntity.category));
      expect(result['tags'], equals(testEntity.tags));
      expect(result['imageUrl'], equals(testEntity.imageUrl));
      expect(result['creatorId'], equals(testEntity.creatorId));
      expect(result['conditions'], equals(testEntity.conditions));
      expect(result['selectedThemes'], equals(testEntity.selectedThemes));
      expect(result['likes'], equals(testEntity.likes));
      expect(result['extraConditions'], equals(testEntity.extraConditions));
      expect(result['guestCount'], equals(testEntity.guestCount));
      expect(result['payCondition'], equals(testEntity.payCondition));
      expect(result['esVisible'], isTrue);
    });

    test('should convert PlanEntity to JSON correctly', () {
      // Act
      final result = mapper.toJson(testEntity);

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], equals(testEntity.id));
      expect(result['title'], equals(testEntity.title));
      expect(result['description'], equals(testEntity.description));
      expect(result['location'], equals(testEntity.location));
      expect(result['category'], equals(testEntity.category));
      expect(result['tags'], equals(testEntity.tags));
      expect(result['imageUrl'], equals(testEntity.imageUrl));
      expect(result['creatorId'], equals(testEntity.creatorId));
      expect(result['conditions'], equals(testEntity.conditions));
      expect(result['selectedThemes'], equals(testEntity.selectedThemes));
      expect(result['likes'], equals(testEntity.likes));
      expect(result['extraConditions'], equals(testEntity.extraConditions));
      expect(result['guestCount'], equals(testEntity.guestCount));
      expect(result['payCondition'], equals(testEntity.payCondition));
    });

    test('should convert JSON to PlanEntity correctly', () {
      // Arrange
      final json = {
        'id': 'test-id',
        'title': 'Test Plan',
        'description': 'Test Description',
        'location': 'Test Location',
        'date': testDate.toIso8601String(),
        'category': 'Test Category',
        'tags': ['tag1', 'tag2'],
        'imageUrl': 'https://example.com/image.jpg',
        'creatorId': 'test-user-id',
        'conditions': {'condition1': 'value1', 'condition2': 'value2'},
        'selectedThemes': ['theme1', 'theme2'],
        'likes': 10,
        'createdAt': DateTime.now().toIso8601String(),
        'payCondition': 'free',
        'guestCount': 5,
        'extraConditions': 'No smoking',
      };

      // Act
      final result = mapper.fromJson(json);

      // Assert
      expect(result, isA<PlanEntity>());
      expect(result.id, equals(json['id']));
      expect(result.title, equals(json['title']));
      expect(result.description, equals(json['description']));
      expect(result.location, equals(json['location']));
      expect(result.category, equals(json['category']));
      expect(result.tags, equals(json['tags']));
      expect(result.imageUrl, equals(json['imageUrl']));
      expect(result.creatorId, equals(json['creatorId']));
      expect(result.conditions, equals(json['conditions']));
      expect(result.selectedThemes, equals(json['selectedThemes']));
      expect(result.likes, equals(json['likes']));
      expect(result.payCondition, equals(json['payCondition']));
      expect(result.guestCount, equals(json['guestCount']));
      expect(result.extraConditions, equals(json['extraConditions']));
    });

    test('should convert list of entities to list of models correctly', () {
      // Arrange
      final entities = [testEntity, testEntity];

      // Act
      final result = mapper.toModelList(entities);

      // Assert
      expect(result, isA<List<PlanModel>>());
      expect(result.length, equals(2));
      expect(result[0].id, equals(testEntity.id));
      expect(result[1].id, equals(testEntity.id));
    });

    test('should convert list of models to list of entities correctly', () {
      // Arrange
      final models = [testModel, testModel];

      // Act
      final result = mapper.toEntityList(models);

      // Assert
      expect(result, isA<List<PlanEntity>>());
      expect(result.length, equals(2));
      expect(result[0].id, equals(testModel.id));
      expect(result[1].id, equals(testModel.id));
    });
  });
}
