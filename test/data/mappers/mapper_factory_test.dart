import 'package:flutter_test/flutter_test.dart';
import 'package:quien_para/data/mappers/entity_mapper.dart';
import 'package:quien_para/data/mappers/mapper_factory.dart';
import 'package:quien_para/data/mappers/plan_mapper.dart';
import 'package:quien_para/data/mappers/user_mapper.dart';
import 'package:quien_para/data/mappers/notification_mapper.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';

void main() {
  late MapperFactory mapperFactory;

  setUp(() {
    mapperFactory = MapperFactory();
  });

  group('MapperFactory', () {
    test('should return PlanMapper instance', () {
      // Act
      final mapper = mapperFactory.getPlanMapper();

      // Assert
      expect(mapper, isA<PlanMapper>());
    });

    test('should return UserMapper instance', () {
      // Act
      final mapper = mapperFactory.getUserMapper();

      // Assert
      expect(mapper, isA<UserMapper>());
    });

    test('should return NotificationMapper instance', () {
      // Act
      final mapper = mapperFactory.getNotificationMapper();

      // Assert
      expect(mapper, isA<NotificationMapper>());
    });

    test(
      'should cache mappers and return same instance on subsequent calls',
      () {
        // Act
        final mapper1 = mapperFactory.getPlanMapper();
        final mapper2 = mapperFactory.getPlanMapper();

        // Assert
        expect(mapper1, same(mapper2)); // Se espera que sean la misma instancia
      },
    );

    test('should throw UnsupportedError for unsupported entity type', () {
      // Act & Assert
      expect(
        () => mapperFactory.getMapper<EntityMapper<PlanEntity, void, void>,
            PlanEntity, void, void>(),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('should clear all cached mappers', () {
      // Arrange
      final mapper1 = mapperFactory.getPlanMapper();

      // Act
      mapperFactory.clearMappers();
      final mapper2 = mapperFactory.getPlanMapper();

      // Assert
      expect(
        mapper1,
        isNot(same(mapper2)),
      ); // No deberían ser la misma instancia
    });

    test('should register custom mapper', () {
      // Arrange
      final originalMapper = mapperFactory.getPlanMapper();
      final customMapper = PlanMapper(); // Crear una nueva instancia

      // Act
      mapperFactory.registerMapper<PlanEntity>(customMapper);
      final retrievedMapper = mapperFactory.getPlanMapper();

      // Assert
      expect(retrievedMapper, isNot(same(originalMapper)));
      expect(retrievedMapper, same(customMapper));
    });
  });
}
