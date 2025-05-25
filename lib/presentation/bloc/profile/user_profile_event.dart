part of 'user_profile_bloc.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class UpdateNameEvent extends UserProfileEvent {
  final String name;

  const UpdateNameEvent(this.name);

  @override
  List<Object> get props => <Object>[name];
}

class UpdateAgeEvent extends UserProfileEvent {
  final int age;

  const UpdateAgeEvent(this.age);

  @override
  List<Object> get props => <Object>[age];
}

class UpdateGenderEvent extends UserProfileEvent {
  final String gender;

  const UpdateGenderEvent(this.gender);

  @override
  List<Object> get props => <Object>[gender];
}

class UpdateLocationEvent extends UserProfileEvent {
  final String location;

  const UpdateLocationEvent(this.location);

  @override
  List<Object> get props => <Object>[location];
}

class UpdateInterestsEvent extends UserProfileEvent {
  final List<String> interests;

  const UpdateInterestsEvent(this.interests);

  @override
  List<Object> get props => <Object>[interests];
}

class UpdatePhotosEvent extends UserProfileEvent {
  final List<File> photos;

  const UpdatePhotosEvent(this.photos);

  @override
  List<Object> get props => <Object>[photos];
}

class UpdateBioEvent extends UserProfileEvent {
  final String bio;

  const UpdateBioEvent(this.bio);

  @override
  List<Object> get props => <Object>[bio];
}

class UpdateOrientationEvent extends UserProfileEvent {
  final String orientation;

  const UpdateOrientationEvent(this.orientation);

  @override
  List<Object> get props => <Object>[orientation];
}

class SaveUserProfileEvent extends UserProfileEvent {}

class LoadUserProfileEvent extends UserProfileEvent {}
