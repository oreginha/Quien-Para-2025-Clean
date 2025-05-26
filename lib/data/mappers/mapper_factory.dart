// lib/data/mappers/mapper_factory.dart

import 'package:quien_para/data/mappers/entity_mapper.dart';
import 'package:quien_para/data/mappers/plan_mapper.dart';
import 'package:quien_para/data/mappers/notification_mapper.dart';
import 'package:quien_para/data/mappers/user_mapper.dart';
import 'package:quien_para/data/models/plan/plan_model.dart';
import 'package:quien_para/data/models/notification/notification_model.dart';
import 'package:quien_para/data/models/user/user_model.dart';
import 'package:quien_para/domain/entities/entity_base.dart';
import 'package:quien_para/domain/entities/notification/notification_entity.dart';
import 'package:quien_para/domain/entities/user/user_entity.dart';

import 'package:quien_para/domain/entities/plan/plan_entity.dart';

/// Fábrica para crear mappers de entidades.
///
/// Proporciona una forma centralizada de obtener mappers para diferentes tipos
/// de entidades, lo que facilita la inyección de dependencias y mejora la testabilidad.
class MapperFactory {
  // Instancia singleton para reutilización
  static final MapperFactory _instance = MapperFactory._internal();

  // Fábrica para acceder a la instancia singleton
  factory MapperFactory() => _instance;

  // Constructor interno privado para el singleton
  MapperFactory._internal();

  // Caché de mappers para reutilización
  final Map<Type, EntityMapper<EntityBase, dynamic, dynamic>> _mappers = {};

  /// Obtiene un mapper para un tipo específico de entidad
  ///
  /// Si el mapper ya fue creado anteriormente, retorna la instancia en caché.
  /// En caso contrario, crea una nueva instancia.
  ///
  /// Ejemplo:
  /// ```dart
  /// final planMapper = MapperFactory().getMapper<PlanEntity, PlanModel, Map<String, dynamic>>();
  /// ```
  T getMapper<T extends EntityMapper<E, M, J>, E extends EntityBase, M, J>() {
    // Verificar si ya existe una instancia en caché
    if (_mappers.containsKey(E)) {
      return _mappers[E] as T;
    }

    // Crear nueva instancia según el tipo
    late T mapper;

    if (E == PlanEntity) {
      mapper = PlanMapper() as T;
    } else if (E == NotificationEntity) {
      mapper = NotificationMapper() as T;
    } else if (E == UserEntity) {
      mapper = UserMapper() as T;
    } else {
      throw UnsupportedError(
        'No hay mapper disponible para el tipo ${E.toString()}',
      );
    }

    // Guardar en caché para futuras solicitudes
    _mappers[E] = mapper as EntityMapper<EntityBase, dynamic, dynamic>;

    return mapper;
  }

  /// Obtiene específicamente un mapper de planes
  ///
  /// Método de conveniencia para obtener el mapper de planes sin necesidad de usar genéricos.
  PlanMapper getPlanMapper() {
    return getMapper<PlanMapper, PlanEntity, PlanModel, Map<String, dynamic>>();
  }

  /// Obtiene específicamente un mapper de notificaciones
  ///
  /// Método de conveniencia para obtener el mapper de notificaciones sin necesidad de usar genéricos.
  NotificationMapper getNotificationMapper() {
    return getMapper<
      NotificationMapper,
      NotificationEntity,
      NotificationModel,
      Map<String, dynamic>
    >();
  }

  /// Obtiene específicamente un mapper de usuarios
  ///
  /// Método de conveniencia para obtener el mapper de usuarios sin necesidad de usar genéricos.
  UserMapper getUserMapper() {
    return getMapper<UserMapper, UserEntity, UserModel, Map<String, dynamic>>();
  }

  /// Registra un mapper personalizado para un tipo específico
  ///
  /// Útil para pruebas cuando se necesita reemplazar un mapper con un mock.
  void registerMapper<E extends EntityBase>(
    EntityMapper<E, dynamic, dynamic> mapper,
  ) {
    _mappers[E] = mapper as EntityMapper<EntityBase, dynamic, dynamic>;
  }

  /// Elimina todos los mappers en caché
  ///
  /// Útil para reiniciar el estado en pruebas o cuando se necesita limpiar la memoria.
  void clearMappers() {
    _mappers.clear();
  }
}
