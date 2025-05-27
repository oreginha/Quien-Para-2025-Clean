// lib/data/models/plan_model_simple.dart
// ignore_for_file: always_specify_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';

class PlanModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String creatorId;
  final DateTime date;
  final int likes;
  final String category;
  final String location;
  final Map<String, String> conditions;
  final List<String> selectedThemes;
  final String? createdAt;
  final bool esVisible;

  const PlanModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl = '',
    required this.creatorId,
    required this.date,
    this.likes = 0,
    this.category = '',
    this.location = '',
    this.conditions = const {},
    this.selectedThemes = const [],
    this.createdAt,
    this.esVisible = true,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        creatorId,
        date,
        likes,
        category,
        location,
        conditions,
        selectedThemes,
        createdAt,
        esVisible,
      ];

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    final prepared = _prepareJson(json);

    return PlanModel(
      id: prepared['id'] as String,
      title: prepared['title'] as String,
      description: prepared['description'] as String,
      imageUrl: (prepared['imageUrl'] as String?) ?? '',
      creatorId: prepared['creatorId'] as String,
      date: DateTime.parse(prepared['date'] as String),
      likes: (prepared['likes'] as int?) ?? 0,
      category: (prepared['category'] as String?) ?? '',
      location: (prepared['location'] as String?) ?? '',
      conditions: Map<String, String>.from(
        (prepared['conditions'] as Map<String, dynamic>?) ?? {},
      ),
      selectedThemes: List<String>.from(
        (prepared['selectedThemes'] as List<dynamic>?) ?? [],
      ),
      createdAt: prepared['createdAt'] as String?,
      esVisible: (prepared['esVisible'] as bool?) ?? true,
    );
  }

  factory PlanModel.fromPlanEntity(PlanEntity entity) {
    return PlanModel(
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
      createdAt: DateTime.now().toIso8601String(),
      esVisible: true,
    );
  }

  static Map<String, dynamic> _prepareJson(Map<String, dynamic> json) {
    final Map<String, dynamic> prepared = Map<String, dynamic>.from(json);

    if (prepared['date'] is Timestamp) {
      prepared['date'] =
          (prepared['date'] as Timestamp).toDate().toIso8601String();
    } else if (prepared['date'] is String) {
      try {
        DateTime.parse(prepared['date'] as String);
      } catch (e) {
        prepared['date'] = DateTime.now().toIso8601String();
      }
    } else {
      prepared['date'] = DateTime.now().toIso8601String();
    }

    // Sanitize imageUrl if it's a base64 image
    if (prepared['imageUrl'] != null &&
        prepared['imageUrl'].toString().startsWith('data:image/')) {
      prepared['imageUrl'] = '';
    }

    if (prepared['conditions'] != null && prepared['conditions'] is Map) {
      prepared['conditions'] = (prepared['conditions'] as Map).map(
        (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
      );
    }

    if (prepared['selectedThemes'] != null &&
        prepared['selectedThemes'] is List) {
      prepared['selectedThemes'] = (prepared['selectedThemes'] as List)
          .map((item) => item?.toString() ?? '')
          .toList();
    }

    return prepared;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'creatorId': creatorId,
      'date': date.toIso8601String(),
      'likes': likes,
      'category': category,
      'location': location,
      'conditions': conditions,
      'selectedThemes': selectedThemes,
      'createdAt': createdAt ?? DateTime.now().toIso8601String(),
      'esVisible': esVisible,
    };
  }

  PlanEntity toPlanEntity() {
    return PlanEntity(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      creatorId: creatorId,
      date: date,
      likes: likes,
      category: category,
      location: location,
      conditions: conditions,
      selectedThemes: selectedThemes,
      tags: [],
      extraConditions: '',
    );
  }

  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = toJson();
    data['date'] = Timestamp.fromDate(date);

    if (data['createdAt'] == null) {
      data['createdAt'] = DateTime.now().toIso8601String();
    }

    data['esVisible'] = esVisible;
    return data;
  }

  PlanModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? creatorId,
    DateTime? date,
    int? likes,
    String? category,
    String? location,
    Map<String, String>? conditions,
    List<String>? selectedThemes,
    String? createdAt,
    bool? esVisible,
  }) {
    return PlanModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      creatorId: creatorId ?? this.creatorId,
      date: date ?? this.date,
      likes: likes ?? this.likes,
      category: category ?? this.category,
      location: location ?? this.location,
      conditions: conditions ?? this.conditions,
      selectedThemes: selectedThemes ?? this.selectedThemes,
      createdAt: createdAt ?? this.createdAt,
      esVisible: esVisible ?? this.esVisible,
    );
  }
}
