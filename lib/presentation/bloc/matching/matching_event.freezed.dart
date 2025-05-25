// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'matching_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MatchingEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String planId, String? message) applyToPlan,
    required TResult Function(String? userId) loadUserApplications,
    required TResult Function(String planId) loadPlanApplications,
    required TResult Function(String applicationId) acceptApplication,
    required TResult Function(String applicationId) rejectApplication,
    required TResult Function(String applicationId) cancelApplication,
    required TResult Function() refreshApplications,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String planId, String? message)? applyToPlan,
    TResult? Function(String? userId)? loadUserApplications,
    TResult? Function(String planId)? loadPlanApplications,
    TResult? Function(String applicationId)? acceptApplication,
    TResult? Function(String applicationId)? rejectApplication,
    TResult? Function(String applicationId)? cancelApplication,
    TResult? Function()? refreshApplications,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String planId, String? message)? applyToPlan,
    TResult Function(String? userId)? loadUserApplications,
    TResult Function(String planId)? loadPlanApplications,
    TResult Function(String applicationId)? acceptApplication,
    TResult Function(String applicationId)? rejectApplication,
    TResult Function(String applicationId)? cancelApplication,
    TResult Function()? refreshApplications,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ApplyToPlan value) applyToPlan,
    required TResult Function(_LoadUserApplications value) loadUserApplications,
    required TResult Function(_LoadPlanApplications value) loadPlanApplications,
    required TResult Function(_AcceptApplication value) acceptApplication,
    required TResult Function(_RejectApplication value) rejectApplication,
    required TResult Function(_CancelApplication value) cancelApplication,
    required TResult Function(_RefreshApplications value) refreshApplications,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ApplyToPlan value)? applyToPlan,
    TResult? Function(_LoadUserApplications value)? loadUserApplications,
    TResult? Function(_LoadPlanApplications value)? loadPlanApplications,
    TResult? Function(_AcceptApplication value)? acceptApplication,
    TResult? Function(_RejectApplication value)? rejectApplication,
    TResult? Function(_CancelApplication value)? cancelApplication,
    TResult? Function(_RefreshApplications value)? refreshApplications,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ApplyToPlan value)? applyToPlan,
    TResult Function(_LoadUserApplications value)? loadUserApplications,
    TResult Function(_LoadPlanApplications value)? loadPlanApplications,
    TResult Function(_AcceptApplication value)? acceptApplication,
    TResult Function(_RejectApplication value)? rejectApplication,
    TResult Function(_CancelApplication value)? cancelApplication,
    TResult Function(_RefreshApplications value)? refreshApplications,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchingEventCopyWith<$Res> {
  factory $MatchingEventCopyWith(
          MatchingEvent value, $Res Function(MatchingEvent) then) =
      _$MatchingEventCopyWithImpl<$Res, MatchingEvent>;
}

/// @nodoc
class _$MatchingEventCopyWithImpl<$Res, $Val extends MatchingEvent>
    implements $MatchingEventCopyWith<$Res> {
  _$MatchingEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchingEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ApplyToPlanImplCopyWith<$Res> {
  factory _$$ApplyToPlanImplCopyWith(
          _$ApplyToPlanImpl value, $Res Function(_$ApplyToPlanImpl) then) =
      __$$ApplyToPlanImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String planId, String? message});
}

/// @nodoc
class __$$ApplyToPlanImplCopyWithImpl<$Res>
    extends _$MatchingEventCopyWithImpl<$Res, _$ApplyToPlanImpl>
    implements _$$ApplyToPlanImplCopyWith<$Res> {
  __$$ApplyToPlanImplCopyWithImpl(
      _$ApplyToPlanImpl _value, $Res Function(_$ApplyToPlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatchingEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? planId = null,
    Object? message = freezed,
  }) {
    return _then(_$ApplyToPlanImpl(
      null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String,
      freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ApplyToPlanImpl implements _ApplyToPlan {
  const _$ApplyToPlanImpl(this.planId, [this.message]);

  @override
  final String planId;
  @override
  final String? message;

  @override
  String toString() {
    return 'MatchingEvent.applyToPlan(planId: $planId, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplyToPlanImpl &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, planId, message);

  /// Create a copy of MatchingEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplyToPlanImplCopyWith<_$ApplyToPlanImpl> get copyWith =>
      __$$ApplyToPlanImplCopyWithImpl<_$ApplyToPlanImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String planId, String? message) applyToPlan,
    required TResult Function(String? userId) loadUserApplications,
    required TResult Function(String planId) loadPlanApplications,
    required TResult Function(String applicationId) acceptApplication,
    required TResult Function(String applicationId) rejectApplication,
    required TResult Function(String applicationId) cancelApplication,
    required TResult Function() refreshApplications,
  }) {
    return applyToPlan(planId, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String planId, String? message)? applyToPlan,
    TResult? Function(String? userId)? loadUserApplications,
    TResult? Function(String planId)? loadPlanApplications,
    TResult? Function(String applicationId)? acceptApplication,
    TResult? Function(String applicationId)? rejectApplication,
    TResult? Function(String applicationId)? cancelApplication,
    TResult? Function()? refreshApplications,
  }) {
    return applyToPlan?.call(planId, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String planId, String? message)? applyToPlan,
    TResult Function(String? userId)? loadUserApplications,
    TResult Function(String planId)? loadPlanApplications,
    TResult Function(String applicationId)? acceptApplication,
    TResult Function(String applicationId)? rejectApplication,
    TResult Function(String applicationId)? cancelApplication,
    TResult Function()? refreshApplications,
    required TResult orElse(),
  }) {
    if (applyToPlan != null) {
      return applyToPlan(planId, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ApplyToPlan value) applyToPlan,
    required TResult Function(_LoadUserApplications value) loadUserApplications,
    required TResult Function(_LoadPlanApplications value) loadPlanApplications,
    required TResult Function(_AcceptApplication value) acceptApplication,
    required TResult Function(_RejectApplication value) rejectApplication,
    required TResult Function(_CancelApplication value) cancelApplication,
    required TResult Function(_RefreshApplications value) refreshApplications,
  }) {
    return applyToPlan(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ApplyToPlan value)? applyToPlan,
    TResult? Function(_LoadUserApplications value)? loadUserApplications,
    TResult? Function(_LoadPlanApplications value)? loadPlanApplications,
    TResult? Function(_AcceptApplication value)? acceptApplication,
    TResult? Function(_RejectApplication value)? rejectApplication,
    TResult? Function(_CancelApplication value)? cancelApplication,
    TResult? Function(_RefreshApplications value)? refreshApplications,
  }) {
    return applyToPlan?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ApplyToPlan value)? applyToPlan,
    TResult Function(_LoadUserApplications value)? loadUserApplications,
    TResult Function(_LoadPlanApplications value)? loadPlanApplications,
    TResult Function(_AcceptApplication value)? acceptApplication,
    TResult Function(_RejectApplication value)? rejectApplication,
    TResult Function(_CancelApplication value)? cancelApplication,
    TResult Function(_RefreshApplications value)? refreshApplications,
    required TResult orElse(),
  }) {
    if (applyToPlan != null) {
      return applyToPlan(this);
    }
    return orElse();
  }
}

abstract class _ApplyToPlan implements MatchingEvent {
  const factory _ApplyToPlan(final String planId, [final String? message]) =
      _$ApplyToPlanImpl;

  String get planId;
  String? get message;

  /// Create a copy of MatchingEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplyToPlanImplCopyWith<_$ApplyToPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadUserApplicationsImplCopyWith<$Res> {
  factory _$$LoadUserApplicationsImplCopyWith(_$LoadUserApplicationsImpl value,
          $Res Function(_$LoadUserApplicationsImpl) then) =
      __$$LoadUserApplicationsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? userId});
}

/// @nodoc
class __$$LoadUserApplicationsImplCopyWithImpl<$Res>
    extends _$MatchingEventCopyWithImpl<$Res, _$LoadUserApplicationsImpl>
    implements _$$LoadUserApplicationsImplCopyWith<$Res> {
  __$$LoadUserApplicationsImplCopyWithImpl(_$LoadUserApplicationsImpl _value,
      $Res Function(_$LoadUserApplicationsImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatchingEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
  }) {
    return _then(_$LoadUserApplicationsImpl(
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LoadUserApplicationsImpl implements _LoadUserApplications {
  const _$LoadUserApplicationsImpl({this.userId});

  @override
  final String? userId;

  @override
  String toString() {
    return 'MatchingEvent.loadUserApplications(userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadUserApplicationsImpl &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId);

  /// Create a copy of MatchingEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadUserApplicationsImplCopyWith<_$LoadUserApplicationsImpl>
      get copyWith =>
          __$$LoadUserApplicationsImplCopyWithImpl<_$LoadUserApplicationsImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String planId, String? message) applyToPlan,
    required TResult Function(String? userId) loadUserApplications,
    required TResult Function(String planId) loadPlanApplications,
    required TResult Function(String applicationId) acceptApplication,
    required TResult Function(String applicationId) rejectApplication,
    required TResult Function(String applicationId) cancelApplication,
    required TResult Function() refreshApplications,
  }) {
    return loadUserApplications(userId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String planId, String? message)? applyToPlan,
    TResult? Function(String? userId)? loadUserApplications,
    TResult? Function(String planId)? loadPlanApplications,
    TResult? Function(String applicationId)? acceptApplication,
    TResult? Function(String applicationId)? rejectApplication,
    TResult? Function(String applicationId)? cancelApplication,
    TResult? Function()? refreshApplications,
  }) {
    return loadUserApplications?.call(userId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String planId, String? message)? applyToPlan,
    TResult Function(String? userId)? loadUserApplications,
    TResult Function(String planId)? loadPlanApplications,
    TResult Function(String applicationId)? acceptApplication,
    TResult Function(String applicationId)? rejectApplication,
    TResult Function(String applicationId)? cancelApplication,
    TResult Function()? refreshApplications,
    required TResult orElse(),
  }) {
    if (loadUserApplications != null) {
      return loadUserApplications(userId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ApplyToPlan value) applyToPlan,
    required TResult Function(_LoadUserApplications value) loadUserApplications,
    required TResult Function(_LoadPlanApplications value) loadPlanApplications,
    required TResult Function(_AcceptApplication value) acceptApplication,
    required TResult Function(_RejectApplication value) rejectApplication,
    required TResult Function(_CancelApplication value) cancelApplication,
    required TResult Function(_RefreshApplications value) refreshApplications,
  }) {
    return loadUserApplications(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ApplyToPlan value)? applyToPlan,
    TResult? Function(_LoadUserApplications value)? loadUserApplications,
    TResult? Function(_LoadPlanApplications value)? loadPlanApplications,
    TResult? Function(_AcceptApplication value)? acceptApplication,
    TResult? Function(_RejectApplication value)? rejectApplication,
    TResult? Function(_CancelApplication value)? cancelApplication,
    TResult? Function(_RefreshApplications value)? refreshApplications,
  }) {
    return loadUserApplications?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ApplyToPlan value)? applyToPlan,
    TResult Function(_LoadUserApplications value)? loadUserApplications,
    TResult Function(_LoadPlanApplications value)? loadPlanApplications,
    TResult Function(_AcceptApplication value)? acceptApplication,
    TResult Function(_RejectApplication value)? rejectApplication,
    TResult Function(_CancelApplication value)? cancelApplication,
    TResult Function(_RefreshApplications value)? refreshApplications,
    required TResult orElse(),
  }) {
    if (loadUserApplications != null) {
      return loadUserApplications(this);
    }
    return orElse();
  }
}

abstract class _LoadUserApplications implements MatchingEvent {
  const factory _LoadUserApplications({final String? userId}) =
      _$LoadUserApplicationsImpl;

  String? get userId;

  /// Create a copy of MatchingEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadUserApplicationsImplCopyWith<_$LoadUserApplicationsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadPlanApplicationsImplCopyWith<$Res> {
  factory _$$LoadPlanApplicationsImplCopyWith(_$LoadPlanApplicationsImpl value,
          $Res Function(_$LoadPlanApplicationsImpl) then) =
      __$$LoadPlanApplicationsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String planId});
}

/// @nodoc
class __$$LoadPlanApplicationsImplCopyWithImpl<$Res>
    extends _$MatchingEventCopyWithImpl<$Res, _$LoadPlanApplicationsImpl>
    implements _$$LoadPlanApplicationsImplCopyWith<$Res> {
  __$$LoadPlanApplicationsImplCopyWithImpl(_$LoadPlanApplicationsImpl _value,
      $Res Function(_$LoadPlanApplicationsImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatchingEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? planId = null,
  }) {
    return _then(_$LoadPlanApplicationsImpl(
      null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LoadPlanApplicationsImpl implements _LoadPlanApplications {
  const _$LoadPlanApplicationsImpl(this.planId);

  @override
  final String planId;

  @override
  String toString() {
    return 'MatchingEvent.loadPlanApplications(planId: $planId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadPlanApplicationsImpl &&
            (identical(other.planId, planId) || other.planId == planId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, planId);

  /// Create a copy of MatchingEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadPlanApplicationsImplCopyWith<_$LoadPlanApplicationsImpl>
      get copyWith =>
          __$$LoadPlanApplicationsImplCopyWithImpl<_$LoadPlanApplicationsImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String planId, String? message) applyToPlan,
    required TResult Function(String? userId) loadUserApplications,
    required TResult Function(String planId) loadPlanApplications,
    required TResult Function(String applicationId) acceptApplication,
    required TResult Function(String applicationId) rejectApplication,
    required TResult Function(String applicationId) cancelApplication,
    required TResult Function() refreshApplications,
  }) {
    return loadPlanApplications(planId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String planId, String? message)? applyToPlan,
    TResult? Function(String? userId)? loadUserApplications,
    TResult? Function(String planId)? loadPlanApplications,
    TResult? Function(String applicationId)? acceptApplication,
    TResult? Function(String applicationId)? rejectApplication,
    TResult? Function(String applicationId)? cancelApplication,
    TResult? Function()? refreshApplications,
  }) {
    return loadPlanApplications?.call(planId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String planId, String? message)? applyToPlan,
    TResult Function(String? userId)? loadUserApplications,
    TResult Function(String planId)? loadPlanApplications,
    TResult Function(String applicationId)? acceptApplication,
    TResult Function(String applicationId)? rejectApplication,
    TResult Function(String applicationId)? cancelApplication,
    TResult Function()? refreshApplications,
    required TResult orElse(),
  }) {
    if (loadPlanApplications != null) {
      return loadPlanApplications(planId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ApplyToPlan value) applyToPlan,
    required TResult Function(_LoadUserApplications value) loadUserApplications,
    required TResult Function(_LoadPlanApplications value) loadPlanApplications,
    required TResult Function(_AcceptApplication value) acceptApplication,
    required TResult Function(_RejectApplication value) rejectApplication,
    required TResult Function(_CancelApplication value) cancelApplication,
    required TResult Function(_RefreshApplications value) refreshApplications,
  }) {
    return loadPlanApplications(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ApplyToPlan value)? applyToPlan,
    TResult? Function(_LoadUserApplications value)? loadUserApplications,
    TResult? Function(_LoadPlanApplications value)? loadPlanApplications,
    TResult? Function(_AcceptApplication value)? acceptApplication,
    TResult? Function(_RejectApplication value)? rejectApplication,
    TResult? Function(_CancelApplication value)? cancelApplication,
    TResult? Function(_RefreshApplications value)? refreshApplications,
  }) {
    return loadPlanApplications?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ApplyToPlan value)? applyToPlan,
    TResult Function(_LoadUserApplications value)? loadUserApplications,
    TResult Function(_LoadPlanApplications value)? loadPlanApplications,
    TResult Function(_AcceptApplication value)? acceptApplication,
    TResult Function(_RejectApplication value)? rejectApplication,
    TResult Function(_CancelApplication value)? cancelApplication,
    TResult Function(_RefreshApplications value)? refreshApplications,
    required TResult orElse(),
  }) {
    if (loadPlanApplications != null) {
      return loadPlanApplications(this);
    }
    return orElse();
  }
}

abstract class _LoadPlanApplications implements MatchingEvent {
  const factory _LoadPlanApplications(final String planId) =
      _$LoadPlanApplicationsImpl;

  String get planId;

  /// Create a copy of MatchingEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadPlanApplicationsImplCopyWith<_$LoadPlanApplicationsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AcceptApplicationImplCopyWith<$Res> {
  factory _$$AcceptApplicationImplCopyWith(_$AcceptApplicationImpl value,
          $Res Function(_$AcceptApplicationImpl) then) =
      __$$AcceptApplicationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String applicationId});
}

/// @nodoc
class __$$AcceptApplicationImplCopyWithImpl<$Res>
    extends _$MatchingEventCopyWithImpl<$Res, _$AcceptApplicationImpl>
    implements _$$AcceptApplicationImplCopyWith<$Res> {
  __$$AcceptApplicationImplCopyWithImpl(_$AcceptApplicationImpl _value,
      $Res Function(_$AcceptApplicationImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatchingEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applicationId = null,
  }) {
    return _then(_$AcceptApplicationImpl(
      null == applicationId
          ? _value.applicationId
          : applicationId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AcceptApplicationImpl implements _AcceptApplication {
  const _$AcceptApplicationImpl(this.applicationId);

  @override
  final String applicationId;

  @override
  String toString() {
    return 'MatchingEvent.acceptApplication(applicationId: $applicationId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AcceptApplicationImpl &&
            (identical(other.applicationId, applicationId) ||
                other.applicationId == applicationId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, applicationId);

  /// Create a copy of MatchingEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AcceptApplicationImplCopyWith<_$AcceptApplicationImpl> get copyWith =>
      __$$AcceptApplicationImplCopyWithImpl<_$AcceptApplicationImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String planId, String? message) applyToPlan,
    required TResult Function(String? userId) loadUserApplications,
    required TResult Function(String planId) loadPlanApplications,
    required TResult Function(String applicationId) acceptApplication,
    required TResult Function(String applicationId) rejectApplication,
    required TResult Function(String applicationId) cancelApplication,
    required TResult Function() refreshApplications,
  }) {
    return acceptApplication(applicationId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String planId, String? message)? applyToPlan,
    TResult? Function(String? userId)? loadUserApplications,
    TResult? Function(String planId)? loadPlanApplications,
    TResult? Function(String applicationId)? acceptApplication,
    TResult? Function(String applicationId)? rejectApplication,
    TResult? Function(String applicationId)? cancelApplication,
    TResult? Function()? refreshApplications,
  }) {
    return acceptApplication?.call(applicationId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String planId, String? message)? applyToPlan,
    TResult Function(String? userId)? loadUserApplications,
    TResult Function(String planId)? loadPlanApplications,
    TResult Function(String applicationId)? acceptApplication,
    TResult Function(String applicationId)? rejectApplication,
    TResult Function(String applicationId)? cancelApplication,
    TResult Function()? refreshApplications,
    required TResult orElse(),
  }) {
    if (acceptApplication != null) {
      return acceptApplication(applicationId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ApplyToPlan value) applyToPlan,
    required TResult Function(_LoadUserApplications value) loadUserApplications,
    required TResult Function(_LoadPlanApplications value) loadPlanApplications,
    required TResult Function(_AcceptApplication value) acceptApplication,
    required TResult Function(_RejectApplication value) rejectApplication,
    required TResult Function(_CancelApplication value) cancelApplication,
    required TResult Function(_RefreshApplications value) refreshApplications,
  }) {
    return acceptApplication(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ApplyToPlan value)? applyToPlan,
    TResult? Function(_LoadUserApplications value)? loadUserApplications,
    TResult? Function(_LoadPlanApplications value)? loadPlanApplications,
    TResult? Function(_AcceptApplication value)? acceptApplication,
    TResult? Function(_RejectApplication value)? rejectApplication,
    TResult? Function(_CancelApplication value)? cancelApplication,
    TResult? Function(_RefreshApplications value)? refreshApplications,
  }) {
    return acceptApplication?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ApplyToPlan value)? applyToPlan,
    TResult Function(_LoadUserApplications value)? loadUserApplications,
    TResult Function(_LoadPlanApplications value)? loadPlanApplications,
    TResult Function(_AcceptApplication value)? acceptApplication,
    TResult Function(_RejectApplication value)? rejectApplication,
    TResult Function(_CancelApplication value)? cancelApplication,
    TResult Function(_RefreshApplications value)? refreshApplications,
    required TResult orElse(),
  }) {
    if (acceptApplication != null) {
      return acceptApplication(this);
    }
    return orElse();
  }
}

abstract class _AcceptApplication implements MatchingEvent {
  const factory _AcceptApplication(final String applicationId) =
      _$AcceptApplicationImpl;

  String get applicationId;

  /// Create a copy of MatchingEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AcceptApplicationImplCopyWith<_$AcceptApplicationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RejectApplicationImplCopyWith<$Res> {
  factory _$$RejectApplicationImplCopyWith(_$RejectApplicationImpl value,
          $Res Function(_$RejectApplicationImpl) then) =
      __$$RejectApplicationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String applicationId});
}

/// @nodoc
class __$$RejectApplicationImplCopyWithImpl<$Res>
    extends _$MatchingEventCopyWithImpl<$Res, _$RejectApplicationImpl>
    implements _$$RejectApplicationImplCopyWith<$Res> {
  __$$RejectApplicationImplCopyWithImpl(_$RejectApplicationImpl _value,
      $Res Function(_$RejectApplicationImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatchingEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applicationId = null,
  }) {
    return _then(_$RejectApplicationImpl(
      null == applicationId
          ? _value.applicationId
          : applicationId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$RejectApplicationImpl implements _RejectApplication {
  const _$RejectApplicationImpl(this.applicationId);

  @override
  final String applicationId;

  @override
  String toString() {
    return 'MatchingEvent.rejectApplication(applicationId: $applicationId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RejectApplicationImpl &&
            (identical(other.applicationId, applicationId) ||
                other.applicationId == applicationId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, applicationId);

  /// Create a copy of MatchingEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RejectApplicationImplCopyWith<_$RejectApplicationImpl> get copyWith =>
      __$$RejectApplicationImplCopyWithImpl<_$RejectApplicationImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String planId, String? message) applyToPlan,
    required TResult Function(String? userId) loadUserApplications,
    required TResult Function(String planId) loadPlanApplications,
    required TResult Function(String applicationId) acceptApplication,
    required TResult Function(String applicationId) rejectApplication,
    required TResult Function(String applicationId) cancelApplication,
    required TResult Function() refreshApplications,
  }) {
    return rejectApplication(applicationId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String planId, String? message)? applyToPlan,
    TResult? Function(String? userId)? loadUserApplications,
    TResult? Function(String planId)? loadPlanApplications,
    TResult? Function(String applicationId)? acceptApplication,
    TResult? Function(String applicationId)? rejectApplication,
    TResult? Function(String applicationId)? cancelApplication,
    TResult? Function()? refreshApplications,
  }) {
    return rejectApplication?.call(applicationId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String planId, String? message)? applyToPlan,
    TResult Function(String? userId)? loadUserApplications,
    TResult Function(String planId)? loadPlanApplications,
    TResult Function(String applicationId)? acceptApplication,
    TResult Function(String applicationId)? rejectApplication,
    TResult Function(String applicationId)? cancelApplication,
    TResult Function()? refreshApplications,
    required TResult orElse(),
  }) {
    if (rejectApplication != null) {
      return rejectApplication(applicationId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ApplyToPlan value) applyToPlan,
    required TResult Function(_LoadUserApplications value) loadUserApplications,
    required TResult Function(_LoadPlanApplications value) loadPlanApplications,
    required TResult Function(_AcceptApplication value) acceptApplication,
    required TResult Function(_RejectApplication value) rejectApplication,
    required TResult Function(_CancelApplication value) cancelApplication,
    required TResult Function(_RefreshApplications value) refreshApplications,
  }) {
    return rejectApplication(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ApplyToPlan value)? applyToPlan,
    TResult? Function(_LoadUserApplications value)? loadUserApplications,
    TResult? Function(_LoadPlanApplications value)? loadPlanApplications,
    TResult? Function(_AcceptApplication value)? acceptApplication,
    TResult? Function(_RejectApplication value)? rejectApplication,
    TResult? Function(_CancelApplication value)? cancelApplication,
    TResult? Function(_RefreshApplications value)? refreshApplications,
  }) {
    return rejectApplication?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ApplyToPlan value)? applyToPlan,
    TResult Function(_LoadUserApplications value)? loadUserApplications,
    TResult Function(_LoadPlanApplications value)? loadPlanApplications,
    TResult Function(_AcceptApplication value)? acceptApplication,
    TResult Function(_RejectApplication value)? rejectApplication,
    TResult Function(_CancelApplication value)? cancelApplication,
    TResult Function(_RefreshApplications value)? refreshApplications,
    required TResult orElse(),
  }) {
    if (rejectApplication != null) {
      return rejectApplication(this);
    }
    return orElse();
  }
}

abstract class _RejectApplication implements MatchingEvent {
  const factory _RejectApplication(final String applicationId) =
      _$RejectApplicationImpl;

  String get applicationId;

  /// Create a copy of MatchingEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RejectApplicationImplCopyWith<_$RejectApplicationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CancelApplicationImplCopyWith<$Res> {
  factory _$$CancelApplicationImplCopyWith(_$CancelApplicationImpl value,
          $Res Function(_$CancelApplicationImpl) then) =
      __$$CancelApplicationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String applicationId});
}

/// @nodoc
class __$$CancelApplicationImplCopyWithImpl<$Res>
    extends _$MatchingEventCopyWithImpl<$Res, _$CancelApplicationImpl>
    implements _$$CancelApplicationImplCopyWith<$Res> {
  __$$CancelApplicationImplCopyWithImpl(_$CancelApplicationImpl _value,
      $Res Function(_$CancelApplicationImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatchingEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applicationId = null,
  }) {
    return _then(_$CancelApplicationImpl(
      null == applicationId
          ? _value.applicationId
          : applicationId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CancelApplicationImpl implements _CancelApplication {
  const _$CancelApplicationImpl(this.applicationId);

  @override
  final String applicationId;

  @override
  String toString() {
    return 'MatchingEvent.cancelApplication(applicationId: $applicationId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CancelApplicationImpl &&
            (identical(other.applicationId, applicationId) ||
                other.applicationId == applicationId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, applicationId);

  /// Create a copy of MatchingEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CancelApplicationImplCopyWith<_$CancelApplicationImpl> get copyWith =>
      __$$CancelApplicationImplCopyWithImpl<_$CancelApplicationImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String planId, String? message) applyToPlan,
    required TResult Function(String? userId) loadUserApplications,
    required TResult Function(String planId) loadPlanApplications,
    required TResult Function(String applicationId) acceptApplication,
    required TResult Function(String applicationId) rejectApplication,
    required TResult Function(String applicationId) cancelApplication,
    required TResult Function() refreshApplications,
  }) {
    return cancelApplication(applicationId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String planId, String? message)? applyToPlan,
    TResult? Function(String? userId)? loadUserApplications,
    TResult? Function(String planId)? loadPlanApplications,
    TResult? Function(String applicationId)? acceptApplication,
    TResult? Function(String applicationId)? rejectApplication,
    TResult? Function(String applicationId)? cancelApplication,
    TResult? Function()? refreshApplications,
  }) {
    return cancelApplication?.call(applicationId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String planId, String? message)? applyToPlan,
    TResult Function(String? userId)? loadUserApplications,
    TResult Function(String planId)? loadPlanApplications,
    TResult Function(String applicationId)? acceptApplication,
    TResult Function(String applicationId)? rejectApplication,
    TResult Function(String applicationId)? cancelApplication,
    TResult Function()? refreshApplications,
    required TResult orElse(),
  }) {
    if (cancelApplication != null) {
      return cancelApplication(applicationId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ApplyToPlan value) applyToPlan,
    required TResult Function(_LoadUserApplications value) loadUserApplications,
    required TResult Function(_LoadPlanApplications value) loadPlanApplications,
    required TResult Function(_AcceptApplication value) acceptApplication,
    required TResult Function(_RejectApplication value) rejectApplication,
    required TResult Function(_CancelApplication value) cancelApplication,
    required TResult Function(_RefreshApplications value) refreshApplications,
  }) {
    return cancelApplication(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ApplyToPlan value)? applyToPlan,
    TResult? Function(_LoadUserApplications value)? loadUserApplications,
    TResult? Function(_LoadPlanApplications value)? loadPlanApplications,
    TResult? Function(_AcceptApplication value)? acceptApplication,
    TResult? Function(_RejectApplication value)? rejectApplication,
    TResult? Function(_CancelApplication value)? cancelApplication,
    TResult? Function(_RefreshApplications value)? refreshApplications,
  }) {
    return cancelApplication?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ApplyToPlan value)? applyToPlan,
    TResult Function(_LoadUserApplications value)? loadUserApplications,
    TResult Function(_LoadPlanApplications value)? loadPlanApplications,
    TResult Function(_AcceptApplication value)? acceptApplication,
    TResult Function(_RejectApplication value)? rejectApplication,
    TResult Function(_CancelApplication value)? cancelApplication,
    TResult Function(_RefreshApplications value)? refreshApplications,
    required TResult orElse(),
  }) {
    if (cancelApplication != null) {
      return cancelApplication(this);
    }
    return orElse();
  }
}

abstract class _CancelApplication implements MatchingEvent {
  const factory _CancelApplication(final String applicationId) =
      _$CancelApplicationImpl;

  String get applicationId;

  /// Create a copy of MatchingEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CancelApplicationImplCopyWith<_$CancelApplicationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RefreshApplicationsImplCopyWith<$Res> {
  factory _$$RefreshApplicationsImplCopyWith(_$RefreshApplicationsImpl value,
          $Res Function(_$RefreshApplicationsImpl) then) =
      __$$RefreshApplicationsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RefreshApplicationsImplCopyWithImpl<$Res>
    extends _$MatchingEventCopyWithImpl<$Res, _$RefreshApplicationsImpl>
    implements _$$RefreshApplicationsImplCopyWith<$Res> {
  __$$RefreshApplicationsImplCopyWithImpl(_$RefreshApplicationsImpl _value,
      $Res Function(_$RefreshApplicationsImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatchingEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RefreshApplicationsImpl implements _RefreshApplications {
  const _$RefreshApplicationsImpl();

  @override
  String toString() {
    return 'MatchingEvent.refreshApplications()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshApplicationsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String planId, String? message) applyToPlan,
    required TResult Function(String? userId) loadUserApplications,
    required TResult Function(String planId) loadPlanApplications,
    required TResult Function(String applicationId) acceptApplication,
    required TResult Function(String applicationId) rejectApplication,
    required TResult Function(String applicationId) cancelApplication,
    required TResult Function() refreshApplications,
  }) {
    return refreshApplications();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String planId, String? message)? applyToPlan,
    TResult? Function(String? userId)? loadUserApplications,
    TResult? Function(String planId)? loadPlanApplications,
    TResult? Function(String applicationId)? acceptApplication,
    TResult? Function(String applicationId)? rejectApplication,
    TResult? Function(String applicationId)? cancelApplication,
    TResult? Function()? refreshApplications,
  }) {
    return refreshApplications?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String planId, String? message)? applyToPlan,
    TResult Function(String? userId)? loadUserApplications,
    TResult Function(String planId)? loadPlanApplications,
    TResult Function(String applicationId)? acceptApplication,
    TResult Function(String applicationId)? rejectApplication,
    TResult Function(String applicationId)? cancelApplication,
    TResult Function()? refreshApplications,
    required TResult orElse(),
  }) {
    if (refreshApplications != null) {
      return refreshApplications();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ApplyToPlan value) applyToPlan,
    required TResult Function(_LoadUserApplications value) loadUserApplications,
    required TResult Function(_LoadPlanApplications value) loadPlanApplications,
    required TResult Function(_AcceptApplication value) acceptApplication,
    required TResult Function(_RejectApplication value) rejectApplication,
    required TResult Function(_CancelApplication value) cancelApplication,
    required TResult Function(_RefreshApplications value) refreshApplications,
  }) {
    return refreshApplications(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ApplyToPlan value)? applyToPlan,
    TResult? Function(_LoadUserApplications value)? loadUserApplications,
    TResult? Function(_LoadPlanApplications value)? loadPlanApplications,
    TResult? Function(_AcceptApplication value)? acceptApplication,
    TResult? Function(_RejectApplication value)? rejectApplication,
    TResult? Function(_CancelApplication value)? cancelApplication,
    TResult? Function(_RefreshApplications value)? refreshApplications,
  }) {
    return refreshApplications?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ApplyToPlan value)? applyToPlan,
    TResult Function(_LoadUserApplications value)? loadUserApplications,
    TResult Function(_LoadPlanApplications value)? loadPlanApplications,
    TResult Function(_AcceptApplication value)? acceptApplication,
    TResult Function(_RejectApplication value)? rejectApplication,
    TResult Function(_CancelApplication value)? cancelApplication,
    TResult Function(_RefreshApplications value)? refreshApplications,
    required TResult orElse(),
  }) {
    if (refreshApplications != null) {
      return refreshApplications(this);
    }
    return orElse();
  }
}

abstract class _RefreshApplications implements MatchingEvent {
  const factory _RefreshApplications() = _$RefreshApplicationsImpl;
}
