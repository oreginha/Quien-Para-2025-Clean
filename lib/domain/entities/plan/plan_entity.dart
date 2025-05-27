// lib/domain/entities/plan_entity.dart

import '../entity_base.dart';
import 'package:quien_para/data/mappers/plan_mapper.dart';

/// Entidad que representa un plan o evento en el dominio de la aplicación
///
/// Esta entidad es inmutable y representa el concepto de Plan en el dominio de negocio.
/// No contiene lógica de serialización/deserialización para almacenamiento. Esa
/// responsabilidad reside en los Mappers.
class PlanEntity extends EntityBase {
  final String title;
  final String description;
  final String location;
  final DateTime? date;
  final String category;
  final List<String> tags;
  final String imageUrl;
  final String creatorId;
  final Map<String, String> conditions;
  final List<String> selectedThemes;
  final int likes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? payCondition;
  final int? guestCount;
  final String extraConditions;

  /// Constructor constante para garantizar inmutabilidad
  const PlanEntity({
    required super.id,
    required this.title,
    required this.description,
    required this.location,
    this.date,
    required this.category,
    required this.tags,
    required this.imageUrl,
    required this.creatorId,
    required this.conditions,
    required this.selectedThemes,
    required this.likes,
    this.createdAt,
    this.updatedAt,
    this.payCondition,
    this.guestCount,
    required this.extraConditions,
  });

  /// Constructor de fábrica para crear una instancia vacía
  factory PlanEntity.empty() => const PlanEntity(
        id: '',
        title: '',
        description: '',
        location: '',
        date: null,
        category: '',
        tags: <String>[],
        imageUrl: '',
        creatorId: '',
        conditions: <String, String>{},
        selectedThemes: <String>[],
        likes: 0,
        createdAt: null,
        updatedAt: null,
        payCondition: null,
        guestCount: null,
        extraConditions: '',
      );

  /// Constructor para crear una entidad a partir de JSON
  /// Delega la creación al PlanMapper
  factory PlanEntity.fromJson(Map<String, dynamic> json) {
    final mapper = const PlanMapper();
    return mapper.fromJson(json);
  }

  /// Método para convertir la entidad a JSON
  /// Delega la conversión al PlanMapper
  Map<String, dynamic> toJson() {
    final mapper = const PlanMapper();
    return mapper.toJson(this);
  }

  /// Método copyWith mejorado para crear una nueva instancia con valores modificados
  PlanEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    DateTime? date,
    bool clearDate = false,
    String? category,
    List<String>? tags,
    String? imageUrl,
    String? creatorId,
    Map<String, String>? conditions,
    List<String>? selectedThemes,
    int? likes,
    DateTime? createdAt,
    bool clearCreatedAt = false,
    DateTime? updatedAt,
    bool clearUpdatedAt = false,
    String? payCondition,
    bool clearPayCondition = false,
    int? guestCount,
    bool clearGuestCount = false,
    String? extraConditions,
  }) {
    return PlanEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      date: clearDate ? null : (date ?? this.date),
      category: category ?? this.category,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      creatorId: creatorId ?? this.creatorId,
      conditions: conditions ?? this.conditions,
      selectedThemes: selectedThemes ?? this.selectedThemes,
      likes: likes ?? this.likes,
      createdAt: clearCreatedAt ? null : (createdAt ?? this.createdAt),
      updatedAt: clearUpdatedAt ? null : (updatedAt ?? this.updatedAt),
      payCondition:
          clearPayCondition ? null : (payCondition ?? this.payCondition),
      guestCount: clearGuestCount ? null : (guestCount ?? this.guestCount),
      extraConditions: extraConditions ?? this.extraConditions,
    );
  }

  /// Método para verificar si la entidad está vacía
  @override
  bool get isEmpty =>
      title.isEmpty &&
      description.isEmpty &&
      location.isEmpty &&
      date == null &&
      category.isEmpty &&
      imageUrl.isEmpty;

  /// Método para verificar si la entidad tiene todos los campos requeridos
  @override
  bool get isValid =>
      id.isNotEmpty &&
      title.isNotEmpty &&
      description.isNotEmpty &&
      location.isNotEmpty &&
      creatorId.isNotEmpty;

  /// Método para formatear la fecha para mostrar en la UI
  String get formattedDate {
    if (date == null) return 'Fecha no especificada';
    return '${date!.day}/${date!.month}/${date!.year}';
  }

  /// Método para obtener condiciones específicas
  String getCondition(String key, {String defaultValue = ''}) {
    return conditions[key] ?? defaultValue;
  }

  /// Método para verificar si hay condiciones extras
  bool get hasExtraConditions => extraConditions.isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        location,
        date,
        category,
        tags,
        imageUrl,
        creatorId,
        conditions,
        selectedThemes,
        likes,
        createdAt,
        updatedAt,
        payCondition,
        guestCount,
        extraConditions,
      ];

  @override
  String toString() {
    return 'PlanEntity(id: $id, title: $title, category: $category, location: $location, likes: $likes)';
  }
}
