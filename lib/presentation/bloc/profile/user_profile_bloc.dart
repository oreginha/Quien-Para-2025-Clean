// lib/core/bloc/profile/user_profile_bloc.dart
// ignore_for_file: always_specify_types

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quien_para/domain/entities/user/user_entity.dart';
import 'package:quien_para/domain/repositories/user/user_repository_interface.dart';
import 'package:logger/logger.dart';

import '../../../domain/validators/profile_validator.dart';
part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final IUserRepository _userRepository;
  final Logger logger = Logger();

  UserProfileBloc({required final IUserRepository userRepository})
      : _userRepository = userRepository,
        super(const UserProfileState()) {
    on<UpdateNameEvent>(_onUpdateName);
    on<UpdateAgeEvent>(_onUpdateAge);
    on<UpdateGenderEvent>(_onUpdateGender);
    on<UpdateLocationEvent>(_onUpdateLocation);
    on<UpdateInterestsEvent>(_onUpdateInterests);
    on<UpdatePhotosEvent>(_onUpdatePhotos);
    on<UpdateBioEvent>(_onUpdateBio);
    on<UpdateOrientationEvent>(_onUpdateOrientation);
    on<SaveUserProfileEvent>(_onSaveUserProfile);
    on<LoadUserProfileEvent>(_onLoadUserProfile);
  }

  void _onUpdateName(
    final UpdateNameEvent event,
    final Emitter<UserProfileState> emit,
  ) {
    emit(
      state.copyWith(
        name: event.name,
        status: UserProfileStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onUpdateAge(
    final UpdateAgeEvent event,
    final Emitter<UserProfileState> emit,
  ) {
    emit(
      state.copyWith(
        age: event.age,
        status: UserProfileStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onUpdateGender(
    final UpdateGenderEvent event,
    final Emitter<UserProfileState> emit,
  ) {
    emit(
      state.copyWith(
        gender: event.gender,
        status: UserProfileStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onUpdateLocation(
    final UpdateLocationEvent event,
    final Emitter<UserProfileState> emit,
  ) {
    emit(
      state.copyWith(
        location: event.location,
        status: UserProfileStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onUpdateInterests(
    final UpdateInterestsEvent event,
    final Emitter<UserProfileState> emit,
  ) {
    emit(
      state.copyWith(
        interests: event.interests,
        status: UserProfileStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onUpdatePhotos(
    final UpdatePhotosEvent event,
    final Emitter<UserProfileState> emit,
  ) {
    emit(
      state.copyWith(
        photos: event.photos,
        status: UserProfileStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onUpdateBio(
    final UpdateBioEvent event,
    final Emitter<UserProfileState> emit,
  ) {
    emit(
      state.copyWith(
        bio: event.bio,
        status: UserProfileStatus.initial,
        errorMessage: null,
      ),
    );
  }

  void _onUpdateOrientation(
    final UpdateOrientationEvent event,
    final Emitter<UserProfileState> emit,
  ) {
    emit(
      state.copyWith(
        orientation: event.orientation,
        status: UserProfileStatus.initial,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onSaveUserProfile(
    final SaveUserProfileEvent event,
    final Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(status: UserProfileStatus.loading));

      // Validate profile data
      ProfileValidator.validate(
        name: state.name,
        age: state.age,
        gender: state.gender,
        location: state.location,
        interests: state.interests,
        photos: state.photos,
        bio: state.bio,
        orientation: state.orientation,
      );

      // Upload photos first
      final uploadResult = await _userRepository.uploadUserPhotos(state.photos);

      final List<String> photoUrls = uploadResult.fold(
        (failure) => throw Exception(failure.message),
        (urls) => urls,
      );

      // Then save the complete profile
      final userEntity = UserEntity(
        name: state.name,
        age: state.age,
        gender: state.gender,
        location: state.location,
        interests: state.interests,
        photoUrls: photoUrls,
        bio: state.bio,
        orientation: state.orientation,
      );

      final saveResult = await _userRepository.saveUserProfile(userEntity);

      saveResult.fold(
        (failure) => throw Exception(failure.message),
        (_) => emit(state.copyWith(status: UserProfileStatus.saved)),
      );
    } catch (e) {
      if (kDebugMode) {
        logger.d('Error in saveUserProfile: $e');
      }
      emit(
        state.copyWith(
          status: UserProfileStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadUserProfile(
    final LoadUserProfileEvent event,
    final Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(status: UserProfileStatus.loading));

      final profileResult = await _userRepository.getUserProfile();

      profileResult.fold((failure) => throw Exception(failure.message), (
        userEntity,
      ) {
        if (userEntity != null) {
          emit(
            state.copyWith(
              name: userEntity.name ?? '',
              age: userEntity.age,
              gender: userEntity.gender,
              location: userEntity.location,
              interests: userEntity.interests ?? <String>[],
              bio: userEntity.bio ?? '',
              orientation: userEntity.orientation,
              status: UserProfileStatus.loaded,
            ),
          );
        } else {
          emit(state.copyWith(status: UserProfileStatus.initial));
        }
      });
    } catch (e) {
      emit(
        state.copyWith(
          status: UserProfileStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
