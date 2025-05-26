import 'dart:io';

import 'package:quien_para/presentation/widgets/errors/app_exceptions.dart';

class ProfileValidator {
  static void validate({
    required final String name,
    required final int? age,
    required final String? gender,
    required final String? location,
    required final List<String> interests,
    required final List<File> photos,
    required final String bio,
    required final String? orientation,
  }) {
    final List<String> errors = <String>[];

    // Validate name
    if (name.isEmpty) {
      errors.add('Name cannot be empty');
    } else if (name.length < 2) {
      errors.add('Name is too short (min 2 characters)');
    } else if (name.length > 50) {
      errors.add('Name is too long (max 50 characters)');
    }

    // Validate age
    if (age != null) {
      if (age < 18) {
        errors.add('You must be at least 18 years old');
      } else if (age > 120) {
        errors.add('Please enter a valid age');
      }
    }

    // Validate gender
    if (gender != null && gender.isNotEmpty) {
      final List<String> validGenders = <String>[
        'Hombre',
        'Mujer',
        'No binario',
        'Prefiero no decirlo',
      ];
      if (!validGenders.contains(gender)) {
        errors.add('Invalid gender selection');
      }
    }

    // Validate location
    if (location != null && location.isNotEmpty) {
      if (location.length < 2) {
        errors.add('Location is too short');
      } else if (location.length > 100) {
        errors.add('Location is too long (max 100 characters)');
      }
    }

    // Validate interests
    if (interests.isEmpty) {
      errors.add('Please add at least one interest');
    } else if (interests.length > 10) {
      errors.add('Too many interests (max 10)');
    } else {
      for (final String interest in interests) {
        if (interest.isEmpty) {
          errors.add('Interest cannot be empty');
        } else if (interest.length > 30) {
          errors.add('Interest is too long (max 30 characters): $interest');
        }
      }
    }

    // Validate photos
    if (photos.isEmpty) {
      errors.add('Please add at least one photo');
    } else if (photos.length > 6) {
      errors.add('Too many photos (max 6)');
    }

    // Validate bio
    if (bio.isEmpty) {
      errors.add('Bio cannot be empty');
    } else if (bio.length < 10) {
      errors.add('Bio is too short (min 10 characters)');
    } else if (bio.length > 500) {
      errors.add('Bio is too long (max 500 characters)');
    }

    // Validate orientation
    if (orientation != null && orientation.isNotEmpty) {
      final List<String> validOrientations = <String>[
        'straight',
        'gay',
        'lesbian',
        'bisexual',
        'other',
      ];
      if (!validOrientations.contains(orientation.toLowerCase())) {
        errors.add('Invalid orientation selection');
      }
    }

    // If there are any errors, throw ValidationException
    if (errors.isNotEmpty) {
      throw ValidationException(errors.join('\n'));
    }
  }
}
