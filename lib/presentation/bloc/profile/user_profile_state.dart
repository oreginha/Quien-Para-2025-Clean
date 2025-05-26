part of 'user_profile_bloc.dart';

enum UserProfileStatus { initial, loading, loaded, saved, error }

class UserProfileState extends Equatable {
  final String name;
  final int? age;
  final String? gender;
  final String? location;
  final List<String> interests;
  final List<File> photos;
  final String bio;
  final String? orientation;
  final UserProfileStatus status;
  final String? errorMessage;

  const UserProfileState({
    this.name = '',
    this.age,
    this.gender,
    this.location,
    this.interests = const <String>[],
    this.photos = const <File>[],
    this.bio = '',
    this.orientation,
    this.status = UserProfileStatus.initial,
    this.errorMessage,
  });

  UserProfileState copyWith({
    final String? name,
    final int? age,
    final String? gender,
    final String? location,
    final List<String>? interests,
    final List<File>? photos,
    final String? bio,
    final String? orientation,
    final UserProfileStatus? status,
    final String? errorMessage,
  }) {
    return UserProfileState(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      interests: interests ?? this.interests,
      photos: photos ?? this.photos,
      bio: bio ?? this.bio,
      orientation: orientation ?? this.orientation,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    name,
    age,
    gender,
    location,
    interests,
    photos,
    bio,
    orientation,
    status,
    errorMessage,
  ];
}
