// lib/domain/repositories/user_repository.dart

import 'dart:io';

abstract class UserRepositoryImpl {
  String? getCurrentUserId();

  Future<List<String>> uploadUserPhotos(final List<File> photos);

  Future<void> saveUserProfile({
    required final String name,
    required final int? age,
    required final String? gender,
    required final String? location,
    required final List<String> interests,
    required final List<String> photoUrls,
    required final String bio,
    required final String? orientation,
  });

  Future<Map<String, dynamic>?> getUserProfileById(final String userId);

  Future<Map<String, dynamic>?> getUserProfile();
}
