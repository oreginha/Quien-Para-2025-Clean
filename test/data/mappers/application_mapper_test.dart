// test/data/mappers/application_mapper_test.dart

// ignore_for_file: subtype_of_sealed_class

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quien_para/data/mappers/application_mapper.dart';
import 'package:quien_para/data/models/application/application_model.dart';
import 'package:quien_para/domain/entities/application/application_entity.dart';

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
  late ApplicationMapper applicationMapper;

  setUp(() {
    applicationMapper = const ApplicationMapper();
  });

  group('ApplicationMapper', () {
    test('toEntity should convert ApplicationModel to ApplicationEntity', () {
      // Arrange
      final applicationModel = ApplicationModel(
        id: 'test-application-id',
        planId: 'test-plan-id',
        applicantId: 'user1',
        status: 'pending',
        appliedAt: DateTime(2023, 1, 1),
        message: 'Me gustaría participar',
        planTitle: 'Plan de prueba',
        planImageUrl: 'http://example.com/image.jpg',
        applicantName: 'Usuario Prueba',
        applicantPhotoUrl: 'http://example.com/user.jpg',
      );

      // Act
      final entity = applicationMapper.toEntity(applicationModel);

      // Assert
      expect(entity.id, 'test-application-id');
      expect(entity.planId, 'test-plan-id');
      expect(entity.applicantId, 'user1');
      expect(entity.status, 'pending');
      expect(entity.appliedAt, DateTime(2023, 1, 1));
      expect(entity.message, 'Me gustaría participar');
      expect(entity.planTitle, 'Plan de prueba');
      expect(entity.planImageUrl, 'http://example.com/image.jpg');
      expect(entity.applicantName, 'Usuario Prueba');
      expect(entity.applicantPhotoUrl, 'http://example.com/user.jpg');
    });

    test('toModel should convert ApplicationEntity to ApplicationModel', () {
      // Arrange
      final entity = ApplicationEntity(
        id: 'test-application-id',
        planId: 'test-plan-id',
        applicantId: 'user1',
        status: 'pending',
        appliedAt: DateTime(2023, 1, 1),
        message: 'Me gustaría participar',
        planTitle: 'Plan de prueba',
        planImageUrl: 'http://example.com/image.jpg',
        applicantName: 'Usuario Prueba',
        applicantPhotoUrl: 'http://example.com/user.jpg',
      );

      // Act
      final model = applicationMapper.toModel(entity);

      // Assert
      expect(model.id, 'test-application-id');
      expect(model.planId, 'test-plan-id');
      expect(model.applicantId, 'user1');
      expect(model.status, 'pending');
      expect(model.appliedAt, DateTime(2023, 1, 1));
      expect(model.message, 'Me gustaría participar');
      expect(model.planTitle, 'Plan de prueba');
      expect(model.planImageUrl, 'http://example.com/image.jpg');
      expect(model.applicantName, 'Usuario Prueba');
      expect(model.applicantPhotoUrl, 'http://example.com/user.jpg');
    });

    /* 
    Más pruebas pendientes de implementar cuando tengamos acceso a
    los mocks correctos para Firestore:
    
    test('fromFirestore should convert DocumentSnapshot to ApplicationEntity', () {
      // Este test requiere un mock más avanzado de DocumentSnapshot
    });

    test('toFirestore should convert ApplicationEntity to Map for Firestore', () {
      // Se implementará cuando se complete el mapper
    });
    */

    test('parseTimestamp should handle different timestamp formats', () {
      // Arrange
      final timestamp = Timestamp(1640995200, 0); // 01/01/2022 00:00:00
      final timestampStr = '2022-01-01T00:00:00.000';
      final expectedDate = DateTime(2022, 1, 1);

      // Act
      final date1 = applicationMapper.parseTimestamp(timestamp);
      final date2 = applicationMapper.parseTimestamp(timestampStr);
      final date3 = applicationMapper.parseTimestamp(null);

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
