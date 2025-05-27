// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'matching_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$MatchingState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ApplicationEntity> applications)
        userApplicationsLoaded,
    required TResult Function(List<ApplicationEntity> applications)
        planApplicationsLoaded,
    required TResult Function(String message, ApplicationEntity application)
        applicationActionSuccess,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ApplicationEntity> applications)?
        userApplicationsLoaded,
    TResult? Function(List<ApplicationEntity> applications)?
        planApplicationsLoaded,
    TResult? Function(String message, ApplicationEntity application)?
        applicationActionSuccess,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ApplicationEntity> applications)?
        userApplicationsLoaded,
    TResult Function(List<ApplicationEntity> applications)?
        planApplicationsLoaded,
    TResult Function(String message, ApplicationEntity application)?
        applicationActionSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_UserApplicationsLoaded value)
        userApplicationsLoaded,
    required TResult Function(_PlanApplicationsLoaded value)
        planApplicationsLoaded,
    required TResult Function(_ApplicationActionSuccess value)
        applicationActionSuccess,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_UserApplicationsLoaded value)? userApplicationsLoaded,
    TResult? Function(_PlanApplicationsLoaded value)? planApplicationsLoaded,
    TResult? Function(_ApplicationActionSuccess value)?
        applicationActionSuccess,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_UserApplicationsLoaded value)? userApplicationsLoaded,
    TResult Function(_PlanApplicationsLoaded value)? planApplicationsLoaded,
    TResult Function(_ApplicationActionSuccess value)? applicationActionSuccess,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchingStateCopyWith<$Res> {
  factory $MatchingStateCopyWith(
    MatchingState value,
    $Res Function(MatchingState) then,
  ) = _$MatchingStateCopyWithImpl<$Res, MatchingState>;
}

/// @nodoc
class _$MatchingStateCopyWithImpl<$Res, $Val extends MatchingState>
    implements $MatchingStateCopyWith<$Res> {
  _$MatchingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
    _$InitialImpl value,
    $Res Function(_$InitialImpl) then,
  ) = __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$MatchingStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'MatchingState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ApplicationEntity> applications)
        userApplicationsLoaded,
    required TResult Function(List<ApplicationEntity> applications)
        planApplicationsLoaded,
    required TResult Function(String message, ApplicationEntity application)
        applicationActionSuccess,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ApplicationEntity> applications)?
        userApplicationsLoaded,
    TResult? Function(List<ApplicationEntity> applications)?
        planApplicationsLoaded,
    TResult? Function(String message, ApplicationEntity application)?
        applicationActionSuccess,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ApplicationEntity> applications)?
        userApplicationsLoaded,
    TResult Function(List<ApplicationEntity> applications)?
        planApplicationsLoaded,
    TResult Function(String message, ApplicationEntity application)?
        applicationActionSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_UserApplicationsLoaded value)
        userApplicationsLoaded,
    required TResult Function(_PlanApplicationsLoaded value)
        planApplicationsLoaded,
    required TResult Function(_ApplicationActionSuccess value)
        applicationActionSuccess,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_UserApplicationsLoaded value)? userApplicationsLoaded,
    TResult? Function(_PlanApplicationsLoaded value)? planApplicationsLoaded,
    TResult? Function(_ApplicationActionSuccess value)?
        applicationActionSuccess,
    TResult? Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_UserApplicationsLoaded value)? userApplicationsLoaded,
    TResult Function(_PlanApplicationsLoaded value)? planApplicationsLoaded,
    TResult Function(_ApplicationActionSuccess value)? applicationActionSuccess,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements MatchingState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
    _$LoadingImpl value,
    $Res Function(_$LoadingImpl) then,
  ) = __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$MatchingStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
    _$LoadingImpl _value,
    $Res Function(_$LoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'MatchingState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ApplicationEntity> applications)
        userApplicationsLoaded,
    required TResult Function(List<ApplicationEntity> applications)
        planApplicationsLoaded,
    required TResult Function(String message, ApplicationEntity application)
        applicationActionSuccess,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ApplicationEntity> applications)?
        userApplicationsLoaded,
    TResult? Function(List<ApplicationEntity> applications)?
        planApplicationsLoaded,
    TResult? Function(String message, ApplicationEntity application)?
        applicationActionSuccess,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ApplicationEntity> applications)?
        userApplicationsLoaded,
    TResult Function(List<ApplicationEntity> applications)?
        planApplicationsLoaded,
    TResult Function(String message, ApplicationEntity application)?
        applicationActionSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_UserApplicationsLoaded value)
        userApplicationsLoaded,
    required TResult Function(_PlanApplicationsLoaded value)
        planApplicationsLoaded,
    required TResult Function(_ApplicationActionSuccess value)
        applicationActionSuccess,
    required TResult Function(_Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_UserApplicationsLoaded value)? userApplicationsLoaded,
    TResult? Function(_PlanApplicationsLoaded value)? planApplicationsLoaded,
    TResult? Function(_ApplicationActionSuccess value)?
        applicationActionSuccess,
    TResult? Function(_Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_UserApplicationsLoaded value)? userApplicationsLoaded,
    TResult Function(_PlanApplicationsLoaded value)? planApplicationsLoaded,
    TResult Function(_ApplicationActionSuccess value)? applicationActionSuccess,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements MatchingState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$UserApplicationsLoadedImplCopyWith<$Res> {
  factory _$$UserApplicationsLoadedImplCopyWith(
    _$UserApplicationsLoadedImpl value,
    $Res Function(_$UserApplicationsLoadedImpl) then,
  ) = __$$UserApplicationsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<ApplicationEntity> applications});
}

/// @nodoc
class __$$UserApplicationsLoadedImplCopyWithImpl<$Res>
    extends _$MatchingStateCopyWithImpl<$Res, _$UserApplicationsLoadedImpl>
    implements _$$UserApplicationsLoadedImplCopyWith<$Res> {
  __$$UserApplicationsLoadedImplCopyWithImpl(
    _$UserApplicationsLoadedImpl _value,
    $Res Function(_$UserApplicationsLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? applications = null}) {
    return _then(
      _$UserApplicationsLoadedImpl(
        null == applications
            ? _value._applications
            : applications // ignore: cast_nullable_to_non_nullable
                as List<ApplicationEntity>,
      ),
    );
  }
}

/// @nodoc

class _$UserApplicationsLoadedImpl implements _UserApplicationsLoaded {
  const _$UserApplicationsLoadedImpl(final List<ApplicationEntity> applications)
      : _applications = applications;

  final List<ApplicationEntity> _applications;
  @override
  List<ApplicationEntity> get applications {
    if (_applications is EqualUnmodifiableListView) return _applications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_applications);
  }

  @override
  String toString() {
    return 'MatchingState.userApplicationsLoaded(applications: $applications)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserApplicationsLoadedImpl &&
            const DeepCollectionEquality().equals(
              other._applications,
              _applications,
            ));
  }

  @override
  int get hashCode => Object.hash(
        runtimeType,
        const DeepCollectionEquality().hash(_applications),
      );

  /// Create a copy of MatchingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserApplicationsLoadedImplCopyWith<_$UserApplicationsLoadedImpl>
      get copyWith => __$$UserApplicationsLoadedImplCopyWithImpl<
              _$UserApplicationsLoadedImpl>(
            this,
            _$identity,
          );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ApplicationEntity> applications)
        userApplicationsLoaded,
    required TResult Function(List<ApplicationEntity> applications)
        planApplicationsLoaded,
    required TResult Function(String message, ApplicationEntity application)
        applicationActionSuccess,
    required TResult Function(String message) error,
  }) {
    return userApplicationsLoaded(applications);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ApplicationEntity> applications)?
        userApplicationsLoaded,
    TResult? Function(List<ApplicationEntity> applications)?
        planApplicationsLoaded,
    TResult? Function(String message, ApplicationEntity application)?
        applicationActionSuccess,
    TResult? Function(String message)? error,
  }) {
    return userApplicationsLoaded?.call(applications);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ApplicationEntity> applications)?
        userApplicationsLoaded,
    TResult Function(List<ApplicationEntity> applications)?
        planApplicationsLoaded,
    TResult Function(String message, ApplicationEntity application)?
        applicationActionSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (userApplicationsLoaded != null) {
      return userApplicationsLoaded(applications);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_UserApplicationsLoaded value)
        userApplicationsLoaded,
    required TResult Function(_PlanApplicationsLoaded value)
        planApplicationsLoaded,
    required TResult Function(_ApplicationActionSuccess value)
        applicationActionSuccess,
    required TResult Function(_Error value) error,
  }) {
    return userApplicationsLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_UserApplicationsLoaded value)? userApplicationsLoaded,
    TResult? Function(_PlanApplicationsLoaded value)? planApplicationsLoaded,
    TResult? Function(_ApplicationActionSuccess value)?
        applicationActionSuccess,
    TResult? Function(_Error value)? error,
  }) {
    return userApplicationsLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_UserApplicationsLoaded value)? userApplicationsLoaded,
    TResult Function(_PlanApplicationsLoaded value)? planApplicationsLoaded,
    TResult Function(_ApplicationActionSuccess value)? applicationActionSuccess,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (userApplicationsLoaded != null) {
      return userApplicationsLoaded(this);
    }
    return orElse();
  }
}

abstract class _UserApplicationsLoaded implements MatchingState {
  const factory _UserApplicationsLoaded(
    final List<ApplicationEntity> applications,
  ) = _$UserApplicationsLoadedImpl;

  List<ApplicationEntity> get applications;

  /// Create a copy of MatchingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserApplicationsLoadedImplCopyWith<_$UserApplicationsLoadedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PlanApplicationsLoadedImplCopyWith<$Res> {
  factory _$$PlanApplicationsLoadedImplCopyWith(
    _$PlanApplicationsLoadedImpl value,
    $Res Function(_$PlanApplicationsLoadedImpl) then,
  ) = __$$PlanApplicationsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<ApplicationEntity> applications});
}

/// @nodoc
class __$$PlanApplicationsLoadedImplCopyWithImpl<$Res>
    extends _$MatchingStateCopyWithImpl<$Res, _$PlanApplicationsLoadedImpl>
    implements _$$PlanApplicationsLoadedImplCopyWith<$Res> {
  __$$PlanApplicationsLoadedImplCopyWithImpl(
    _$PlanApplicationsLoadedImpl _value,
    $Res Function(_$PlanApplicationsLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? applications = null}) {
    return _then(
      _$PlanApplicationsLoadedImpl(
        null == applications
            ? _value._applications
            : applications // ignore: cast_nullable_to_non_nullable
                as List<ApplicationEntity>,
      ),
    );
  }
}

/// @nodoc

class _$PlanApplicationsLoadedImpl implements _PlanApplicationsLoaded {
  const _$PlanApplicationsLoadedImpl(final List<ApplicationEntity> applications)
      : _applications = applications;

  final List<ApplicationEntity> _applications;
  @override
  List<ApplicationEntity> get applications {
    if (_applications is EqualUnmodifiableListView) return _applications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_applications);
  }

  @override
  String toString() {
    return 'MatchingState.planApplicationsLoaded(applications: $applications)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanApplicationsLoadedImpl &&
            const DeepCollectionEquality().equals(
              other._applications,
              _applications,
            ));
  }

  @override
  int get hashCode => Object.hash(
        runtimeType,
        const DeepCollectionEquality().hash(_applications),
      );

  /// Create a copy of MatchingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanApplicationsLoadedImplCopyWith<_$PlanApplicationsLoadedImpl>
      get copyWith => __$$PlanApplicationsLoadedImplCopyWithImpl<
              _$PlanApplicationsLoadedImpl>(
            this,
            _$identity,
          );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ApplicationEntity> applications)
        userApplicationsLoaded,
    required TResult Function(List<ApplicationEntity> applications)
        planApplicationsLoaded,
    required TResult Function(String message, ApplicationEntity application)
        applicationActionSuccess,
    required TResult Function(String message) error,
  }) {
    return planApplicationsLoaded(applications);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ApplicationEntity> applications)?
        userApplicationsLoaded,
    TResult? Function(List<ApplicationEntity> applications)?
        planApplicationsLoaded,
    TResult? Function(String message, ApplicationEntity application)?
        applicationActionSuccess,
    TResult? Function(String message)? error,
  }) {
    return planApplicationsLoaded?.call(applications);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ApplicationEntity> applications)?
        userApplicationsLoaded,
    TResult Function(List<ApplicationEntity> applications)?
        planApplicationsLoaded,
    TResult Function(String message, ApplicationEntity application)?
        applicationActionSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (planApplicationsLoaded != null) {
      return planApplicationsLoaded(applications);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_UserApplicationsLoaded value)
        userApplicationsLoaded,
    required TResult Function(_PlanApplicationsLoaded value)
        planApplicationsLoaded,
    required TResult Function(_ApplicationActionSuccess value)
        applicationActionSuccess,
    required TResult Function(_Error value) error,
  }) {
    return planApplicationsLoaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_UserApplicationsLoaded value)? userApplicationsLoaded,
    TResult? Function(_PlanApplicationsLoaded value)? planApplicationsLoaded,
    TResult? Function(_ApplicationActionSuccess value)?
        applicationActionSuccess,
    TResult? Function(_Error value)? error,
  }) {
    return planApplicationsLoaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_UserApplicationsLoaded value)? userApplicationsLoaded,
    TResult Function(_PlanApplicationsLoaded value)? planApplicationsLoaded,
    TResult Function(_ApplicationActionSuccess value)? applicationActionSuccess,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (planApplicationsLoaded != null) {
      return planApplicationsLoaded(this);
    }
    return orElse();
  }
}

abstract class _PlanApplicationsLoaded implements MatchingState {
  const factory _PlanApplicationsLoaded(
    final List<ApplicationEntity> applications,
  ) = _$PlanApplicationsLoadedImpl;

  List<ApplicationEntity> get applications;

  /// Create a copy of MatchingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlanApplicationsLoadedImplCopyWith<_$PlanApplicationsLoadedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ApplicationActionSuccessImplCopyWith<$Res> {
  factory _$$ApplicationActionSuccessImplCopyWith(
    _$ApplicationActionSuccessImpl value,
    $Res Function(_$ApplicationActionSuccessImpl) then,
  ) = __$$ApplicationActionSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, ApplicationEntity application});
}

/// @nodoc
class __$$ApplicationActionSuccessImplCopyWithImpl<$Res>
    extends _$MatchingStateCopyWithImpl<$Res, _$ApplicationActionSuccessImpl>
    implements _$$ApplicationActionSuccessImplCopyWith<$Res> {
  __$$ApplicationActionSuccessImplCopyWithImpl(
    _$ApplicationActionSuccessImpl _value,
    $Res Function(_$ApplicationActionSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? application = null}) {
    return _then(
      _$ApplicationActionSuccessImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                as String,
        null == application
            ? _value.application
            : application // ignore: cast_nullable_to_non_nullable
                as ApplicationEntity,
      ),
    );
  }
}

/// @nodoc

class _$ApplicationActionSuccessImpl implements _ApplicationActionSuccess {
  const _$ApplicationActionSuccessImpl(this.message, this.application);

  @override
  final String message;
  @override
  final ApplicationEntity application;

  @override
  String toString() {
    return 'MatchingState.applicationActionSuccess(message: $message, application: $application)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationActionSuccessImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.application, application) ||
                other.application == application));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, application);

  /// Create a copy of MatchingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicationActionSuccessImplCopyWith<_$ApplicationActionSuccessImpl>
      get copyWith => __$$ApplicationActionSuccessImplCopyWithImpl<
          _$ApplicationActionSuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ApplicationEntity> applications)
        userApplicationsLoaded,
    required TResult Function(List<ApplicationEntity> applications)
        planApplicationsLoaded,
    required TResult Function(String message, ApplicationEntity application)
        applicationActionSuccess,
    required TResult Function(String message) error,
  }) {
    return applicationActionSuccess(message, application);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ApplicationEntity> applications)?
        userApplicationsLoaded,
    TResult? Function(List<ApplicationEntity> applications)?
        planApplicationsLoaded,
    TResult? Function(String message, ApplicationEntity application)?
        applicationActionSuccess,
    TResult? Function(String message)? error,
  }) {
    return applicationActionSuccess?.call(message, application);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ApplicationEntity> applications)?
        userApplicationsLoaded,
    TResult Function(List<ApplicationEntity> applications)?
        planApplicationsLoaded,
    TResult Function(String message, ApplicationEntity application)?
        applicationActionSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (applicationActionSuccess != null) {
      return applicationActionSuccess(message, application);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_UserApplicationsLoaded value)
        userApplicationsLoaded,
    required TResult Function(_PlanApplicationsLoaded value)
        planApplicationsLoaded,
    required TResult Function(_ApplicationActionSuccess value)
        applicationActionSuccess,
    required TResult Function(_Error value) error,
  }) {
    return applicationActionSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_UserApplicationsLoaded value)? userApplicationsLoaded,
    TResult? Function(_PlanApplicationsLoaded value)? planApplicationsLoaded,
    TResult? Function(_ApplicationActionSuccess value)?
        applicationActionSuccess,
    TResult? Function(_Error value)? error,
  }) {
    return applicationActionSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_UserApplicationsLoaded value)? userApplicationsLoaded,
    TResult Function(_PlanApplicationsLoaded value)? planApplicationsLoaded,
    TResult Function(_ApplicationActionSuccess value)? applicationActionSuccess,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (applicationActionSuccess != null) {
      return applicationActionSuccess(this);
    }
    return orElse();
  }
}

abstract class _ApplicationActionSuccess implements MatchingState {
  const factory _ApplicationActionSuccess(
    final String message,
    final ApplicationEntity application,
  ) = _$ApplicationActionSuccessImpl;

  String get message;
  ApplicationEntity get application;

  /// Create a copy of MatchingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplicationActionSuccessImplCopyWith<_$ApplicationActionSuccessImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
    _$ErrorImpl value,
    $Res Function(_$ErrorImpl) then,
  ) = __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$MatchingStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
    _$ErrorImpl _value,
    $Res Function(_$ErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MatchingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                as String,
      ),
    );
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'MatchingState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of MatchingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<ApplicationEntity> applications)
        userApplicationsLoaded,
    required TResult Function(List<ApplicationEntity> applications)
        planApplicationsLoaded,
    required TResult Function(String message, ApplicationEntity application)
        applicationActionSuccess,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<ApplicationEntity> applications)?
        userApplicationsLoaded,
    TResult? Function(List<ApplicationEntity> applications)?
        planApplicationsLoaded,
    TResult? Function(String message, ApplicationEntity application)?
        applicationActionSuccess,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<ApplicationEntity> applications)?
        userApplicationsLoaded,
    TResult Function(List<ApplicationEntity> applications)?
        planApplicationsLoaded,
    TResult Function(String message, ApplicationEntity application)?
        applicationActionSuccess,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_UserApplicationsLoaded value)
        userApplicationsLoaded,
    required TResult Function(_PlanApplicationsLoaded value)
        planApplicationsLoaded,
    required TResult Function(_ApplicationActionSuccess value)
        applicationActionSuccess,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_UserApplicationsLoaded value)? userApplicationsLoaded,
    TResult? Function(_PlanApplicationsLoaded value)? planApplicationsLoaded,
    TResult? Function(_ApplicationActionSuccess value)?
        applicationActionSuccess,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_UserApplicationsLoaded value)? userApplicationsLoaded,
    TResult Function(_PlanApplicationsLoaded value)? planApplicationsLoaded,
    TResult Function(_ApplicationActionSuccess value)? applicationActionSuccess,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements MatchingState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;

  /// Create a copy of MatchingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
