// lib/data/mappers/caching_mapper.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quien_para/data/mappers/entity_mapper.dart';
import 'package:quien_para/domain/entities/entity_base.dart';

/// Clase base abstracta para mappers con capacidades de caché
///
/// Esta clase extiende EntityMapper añadiendo funcionalidad de caché para
/// reducir conversiones innecesarias entre entidades y modelos, mejorando
/// significativamente el rendimiento cuando hay muchas operaciones de mapeo
/// repetidas sobre las mismas entidades.
abstract class CachingEntityMapper<Entity extends EntityBase, Model, JsonType>
    implements EntityMapper<Entity, Model, JsonType> {
  // Caché de resultados para reutilización
  static final Map<Type, Map<String, dynamic>> _entityCache = {};
  static final Map<Type, Map<String, dynamic>> _modelCache = {};

  // Tamaño máximo por tipo de entidad
  static const int _maxCacheSize = 100;

  // Obtenemos el mapa de caché para este tipo de entidad
  Map<String, Entity> get _entityCacheMap {
    final type = Entity;
    if (!_entityCache.containsKey(type)) {
      _entityCache[type] = <String, Entity>{};
    }
    return _entityCache[type]! as Map<String, Entity>;
  }

  // Obtenemos el mapa de caché para este tipo de modelo
  Map<String, Model> get _modelCacheMap {
    final type = Model;
    if (!_modelCache.containsKey(type)) {
      _modelCache[type] = <String, Model>{};
    }
    return _modelCache[type]! as Map<String, Model>;
  }

  /// Limpia toda la caché para todos los tipos
  static void clearAllCaches() {
    _entityCache.clear();
    _modelCache.clear();
  }

  /// Limpia la caché solo para este tipo específico de entidad y modelo
  void clearCache() {
    _entityCacheMap.clear();
    _modelCacheMap.clear();
  }

  /// Mantiene un tamaño razonable de caché
  void _maintainCacheSize() {
    final entityCache = _entityCacheMap;
    final modelCache = _modelCacheMap;

    if (entityCache.length > _maxCacheSize) {
      final keysToRemove = entityCache.keys.take(entityCache.length - _maxCacheSize ~/ 2).toList();
      for (final key in keysToRemove) {
        entityCache.remove(key);
      }
    }

    if (modelCache.length > _maxCacheSize) {
      final keysToRemove = modelCache.keys.take(modelCache.length - _maxCacheSize ~/ 2).toList();
      for (final key in keysToRemove) {
        modelCache.remove(key);
      }
    }
  }

  /// Agrega una entidad a la caché
  void _cacheEntity(String id, Entity entity) {
    if (id.isNotEmpty) {
      _entityCacheMap[id] = entity;
      _maintainCacheSize();
    }
  }

  /// Agrega un modelo a la caché
  void _cacheModel(String id, Model model) {
    if (id.isNotEmpty) {
      _modelCacheMap[id] = model;
      _maintainCacheSize();
    }
  }

  /// Obtiene un ID para un modelo (debe ser implementado por la subclase)
  String getModelId(Model model);

  /// Método para convertir modelo a entidad con caché
  @override
  Entity toEntity(Model model) {
    // Obtenemos el ID para este modelo
    final id = getModelId(model);

    // Verificar caché
    if (id.isNotEmpty && _entityCacheMap.containsKey(id)) {
      return _entityCacheMap[id]!;
    }

    // Realizar conversión
    final entity = convertModelToEntity(model);

    // Guardar en caché
    _cacheEntity(id, entity);

    return entity;
  }

  /// Método para convertir entidad a modelo con caché
  @override
  Model toModel(Entity entity) {
    // Verificar caché
    if (entity.id.isNotEmpty && _modelCacheMap.containsKey(entity.id)) {
      return _modelCacheMap[entity.id]!;
    }

    // Realizar conversión
    final model = convertEntityToModel(entity);

    // Guardar en caché
    _cacheModel(entity.id, model);

    return model;
  }

  /// Método para convertir documento Firestore a entidad con caché
  @override
  Entity fromFirestore(DocumentSnapshot doc) {
    // Verificar caché
    if (_entityCacheMap.containsKey(doc.id)) {
      return _entityCacheMap[doc.id]!;
    }

    // Realizar conversión
    final entity = convertDocToEntity(doc);

    // Guardar en caché
    _cacheEntity(doc.id, entity);

    return entity;
  }

  /// Método abstracto que debe ser implementado por las subclases para 
  /// realizar la conversión real de modelo a entidad
  Entity convertModelToEntity(Model model);

  /// Método abstracto que debe ser implementado por las subclases para
  /// realizar la conversión real de entidad a modelo
  Model convertEntityToModel(Entity entity);

  /// Método abstracto que debe ser implementado por las subclases para
  /// realizar la conversión real de documento Firestore a entidad
  Entity convertDocToEntity(DocumentSnapshot doc);
}
