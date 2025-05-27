// lib/data/models/user.dart
// ignore_for_file: prefer_final_parameters, always_specify_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required int age,
    required String email,
    @Default([]) List<String> photoUrls,
    @Default([]) List<String> interests,
    String? bio,
    @Default(true) bool isVisible,
    @Default(false) bool hasCompletedOnboarding,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  Map<String, dynamic> toFirestore() {
    return toJson()
      ..remove('id') // No guardamos el ID en el documento
      ..addAll({
        'createdAt': createdAt ?? DateTime.now(),
        'lastLogin': lastLogin ?? DateTime.now(),
      });
  }

  static UserModel fromFirestore(String id, Map<String, dynamic> data) {
    return UserModel.fromJson({
      'id': id,
      ...data,
      'createdAt':
          (data['createdAt'] as Timestamp?)?.toDate().toIso8601String(),
      'lastLogin':
          (data['lastLogin'] as Timestamp?)?.toDate().toIso8601String(),
    });
  }
}
