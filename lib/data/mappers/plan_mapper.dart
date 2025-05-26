// lib/data/mappers/plan_mapper.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quien_para/data/mappers/entity_mapper.dart';
import 'package:quien_para/data/models/plan/plan_model.dart';

import 'package:quien_para/domain/entities/plan/plan_entity.dart';

/// Clase responsable de toda la lógica de mapeo entre PlanEntity y PlanModel
/// y la conversión entre formatos de datos.
///
/// Esta clase centraliza toda la lógica de transformación que antes estaba
/// distribuida entre la entidad y el modelo.
class PlanMapper
    implements EntityMapper<PlanEntity, PlanModel, Map<String, dynamic>> {
  const PlanMapper();

  // Caché de resultados para reutilización
  static final Map<String, PlanEntity> _entityCache = {};
  static final Map<String, PlanModel> _modelCache = {};

  // Tamaño máximo de la caché
  static const int _maxCacheSize = 50;

  /// Limpia la caché de entidades y modelos
  static void clearCache() {
    _entityCache.clear();
    _modelCache.clear();
  }

  /// Mantiene la caché en un tamaño razonable
  void _maintainCacheSize() {
    if (_entityCache.length > _maxCacheSize) {
      final keysToRemove = _entityCache.keys.take(
        _entityCache.length - _maxCacheSize,
      );
      for (final key in keysToRemove) {
        _entityCache.remove(key);
      }
    }

    if (_modelCache.length > _maxCacheSize) {
      final keysToRemove = _modelCache.keys.take(
        _modelCache.length - _maxCacheSize,
      );
      for (final key in keysToRemove) {
        _modelCache.remove(key);
      }
    }
  }

  /// Convierte una entidad de dominio en un modelo de datos
  @override
  PlanModel toModel(PlanEntity entity) {
    // Verificar si ya existe en caché
    if (entity.id.isNotEmpty && _modelCache.containsKey(entity.id)) {
      return _modelCache[entity.id]!;
    }

    final model = PlanModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      imageUrl: entity.imageUrl,
      creatorId: entity.creatorId,
      date: entity.date ?? DateTime.now(),
      likes: entity.likes,
      category: entity.category,
      location: entity.location,
      conditions: entity.conditions,
      selectedThemes: entity.selectedThemes,
      createdAt: entity.createdAt?.toIso8601String(),
      esVisible: true,
    );

    // Guardar en caché si tiene ID
    if (entity.id.isNotEmpty) {
      _modelCache[entity.id] = model;
      _maintainCacheSize();
    }

    return model;
  }

  /// Convierte un modelo de datos en una entidad de dominio
  @override
  PlanEntity toEntity(PlanModel model) {
    // Verificar si ya existe en caché
    if (model.id.isNotEmpty && _entityCache.containsKey(model.id)) {
      return _entityCache[model.id]!;
    }

    final entity = PlanEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      location: model.location,
      date: model.date,
      category: model.category,
      tags: [], // No hay mapeo directo en el modelo
      imageUrl: model.imageUrl,
      creatorId: model.creatorId,
      conditions: model.conditions,
      selectedThemes: model.selectedThemes,
      likes: model.likes,
      createdAt: model.createdAt != null
          ? DateTime.parse(model.createdAt!)
          : null,
      updatedAt: null, // No hay mapeo directo en el modelo
      payCondition: model.conditions['payCondition'],
      guestCount: int.tryParse(model.conditions['guestCount'] ?? ''),
      extraConditions: model.conditions['extraConditions'] ?? '',
    );

    // Guardar en caché si tiene ID
    if (model.id.isNotEmpty) {
      _entityCache[model.id] = entity;
      _maintainCacheSize();
    }

    return entity;
  }

  /// Mapea datos de Firestore directamente a una entidad
  @override
  PlanEntity fromFirestore(DocumentSnapshot doc) {
    // Verificar si ya existe en caché
    if (_entityCache.containsKey(doc.id)) {
      return _entityCache[doc.id]!;
    }
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Procesamiento de fechas
    DateTime? dateTime;
    if (data['date'] is Timestamp) {
      dateTime = (data['date'] as Timestamp).toDate();
    } else if (data['date'] is String) {
      try {
        dateTime = DateTime.parse(data['date'] as String);
      } catch (_) {
        dateTime = null;
      }
    }

    DateTime? createdAt;
    if (data['createdAt'] is Timestamp) {
      createdAt = (data['createdAt'] as Timestamp).toDate();
    } else if (data['createdAt'] is String) {
      try {
        createdAt = DateTime.parse(data['createdAt'] as String);
      } catch (_) {
        createdAt = null;
      }
    }

    DateTime? updatedAt;
    if (data['updatedAt'] is Timestamp) {
      updatedAt = (data['updatedAt'] as Timestamp).toDate();
    } else if (data['updatedAt'] is String) {
      try {
        updatedAt = DateTime.parse(data['updatedAt'] as String);
      } catch (_) {
        updatedAt = null;
      }
    }

    // Procesamiento de condiciones
    final Map<String, String> conditions = <String, String>{};
    if (data['conditions'] is Map) {
      (data['conditions'] as Map).forEach((key, value) {
        conditions[key.toString()] = value?.toString() ?? '';
      });
    }

    // Procesamiento de tags
    final List<String> tags = <String>[];
    if (data['tags'] is List) {
      for (final tag in (data['tags'] as List)) {
        tags.add(tag?.toString() ?? '');
      }
    }

    // Procesamiento de temas seleccionados
    final List<String> selectedThemes = <String>[];
    if (data['selectedThemes'] is List) {
      for (final theme in (data['selectedThemes'] as List)) {
        selectedThemes.add(theme?.toString() ?? '');
      }
    }

    // Retornar la entidad completamente construida
    final entity = PlanEntity(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      location: data['location'] as String? ?? '',
      date: dateTime,
      category: data['category'] as String? ?? '',
      tags: tags,
      imageUrl: data['imageUrl'] as String? ?? '',
      creatorId: data['creatorId'] as String? ?? '',
      conditions: conditions,
      selectedThemes: selectedThemes,
      likes: data['likes'] as int? ?? 0,
      createdAt: createdAt,
      updatedAt: updatedAt,
      payCondition: data['payCondition'] as String?,
      guestCount: data['guestCount'] as int?,
      extraConditions: data['extraConditions'] as String? ?? '',
    );

    // Guardar en caché
    _entityCache[doc.id] = entity;
    _maintainCacheSize();

    return entity;
  }

  /// Transforma una entidad a un formato adecuado para Firestore
  @override
  Map<String, dynamic> toFirestore(PlanEntity entity) {
    final Map<String, dynamic> data = <String, dynamic>{
      'title': entity.title,
      'description': entity.description,
      'location': entity.location,
      'date': entity.date != null ? Timestamp.fromDate(entity.date!) : null,
      'category': entity.category,
      'tags': entity.tags,
      'imageUrl': entity.imageUrl,
      'creatorId': entity.creatorId,
      'conditions': entity.conditions,
      'selectedThemes': entity.selectedThemes,
      'likes': entity.likes,
      'extraConditions': entity.extraConditions,
    };

    // Solo añadir los campos opcionales si tienen valor
    if (entity.createdAt != null) {
      data['createdAt'] = Timestamp.fromDate(entity.createdAt!);
    }

    if (entity.updatedAt != null) {
      data['updatedAt'] = Timestamp.fromDate(entity.updatedAt!);
    }

    if (entity.payCondition != null) {
      data['payCondition'] = entity.payCondition;
    }

    if (entity.guestCount != null) {
      data['guestCount'] = entity.guestCount;
    }

    data['esVisible'] = true;

    return data;
  }

  /// Convierte una lista de documentos de Firestore a una lista de entidades
  @override
  List<PlanEntity> fromFirestoreList(List<DocumentSnapshot> docs) {
    return docs.map((doc) => fromFirestore(doc)).toList();
  }

  /// Convierte una lista de entidades a una lista de modelos
  @override
  List<PlanModel> toModelList(List<PlanEntity> entities) {
    return entities.map((entity) => toModel(entity)).toList();
  }

  /// Convierte una lista de modelos a una lista de entidades
  @override
  List<PlanEntity> toEntityList(List<PlanModel> models) {
    return models.map((model) => toEntity(model)).toList();
  }

  /// Convierte JSON a entidad directamente (para usar con API)
  @override
  PlanEntity fromJson(Map<String, dynamic> json) {
    return PlanEntity(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      location: json['location'] as String? ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : null,
      category: json['category'] as String? ?? '',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
      imageUrl: json['imageUrl'] as String? ?? '',
      creatorId: json['creatorId'] as String? ?? '',
      conditions:
          (json['conditions'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as String),
          ) ??
          const <String, String>{},
      selectedThemes:
          (json['selectedThemes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      likes: json['likes'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      payCondition: json['payCondition'] as String?,
      guestCount: json['guestCount'] as int?,
      extraConditions: json['extraConditions'] as String? ?? '',
    );
  }

  /// Convierte entidad a JSON directamente (para usar con API)
  @override
  Map<String, dynamic> toJson(PlanEntity entity) {
    return {
      'id': entity.id,
      'title': entity.title,
      'description': entity.description,
      'location': entity.location,
      'date': entity.date?.toIso8601String(),
      'category': entity.category,
      'tags': entity.tags,
      'imageUrl': entity.imageUrl,
      'creatorId': entity.creatorId,
      'conditions': entity.conditions,
      'selectedThemes': entity.selectedThemes,
      'likes': entity.likes,
      'createdAt': entity.createdAt?.toIso8601String(),
      'updatedAt': entity.updatedAt?.toIso8601String(),
      'payCondition': entity.payCondition,
      'guestCount': entity.guestCount,
      'extraConditions': entity.extraConditions,
    };
  }

  /// Convierte una lista de entidades a una lista de mapas JSON
  @override
  List<Map<String, dynamic>> toJsonList(List<PlanEntity> entities) {
    return entities.map((entity) => toJson(entity)).toList();
  }

  /// Convierte una lista de mapas JSON a una lista de entidades
  @override
  List<PlanEntity> fromJsonList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }
}
