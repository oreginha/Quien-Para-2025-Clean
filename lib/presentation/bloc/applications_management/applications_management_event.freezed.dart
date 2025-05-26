// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'applications_management_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ApplicationsManagementEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String planId) initialize,
    required TResult Function(String planId) loadApplications,
    required TResult Function() loadUserProfiles,
    required TResult Function(String applicationId) acceptApplication,
    required TResult Function(String applicationId) rejectApplication,
    required TResult Function(String filterType) filterApplications,
    required TResult Function(String query) searchApplications,
    required TResult Function(String viewType) changeView,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String planId)? initialize,
    TResult? Function(String planId)? loadApplications,
    TResult? Function()? loadUserProfiles,
    TResult? Function(String applicationId)? acceptApplication,
    TResult? Function(String applicationId)? rejectApplication,
    TResult? Function(String filterType)? filterApplications,
    TResult? Function(String query)? searchApplications,
    TResult? Function(String viewType)? changeView,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String planId)? initialize,
    TResult Function(String planId)? loadApplications,
    TResult Function()? loadUserProfiles,
    TResult Function(String applicationId)? acceptApplication,
    TResult Function(String applicationId)? rejectApplication,
    TResult Function(String filterType)? filterApplications,
    TResult Function(String query)? searchApplications,
    TResult Function(String viewType)? changeView,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_LoadApplications value) loadApplications,
    required TResult Function(_LoadUserProfiles value) loadUserProfiles,
    required TResult Function(_AcceptApplication value) acceptApplication,
    required TResult Function(_RejectApplication value) rejectApplication,
    required TResult Function(_FilterApplications value) filterApplications,
    required TResult Function(_SearchApplications value) searchApplications,
    required TResult Function(_ChangeView value) changeView,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_LoadApplications value)? loadApplications,
    TResult? Function(_LoadUserProfiles value)? loadUserProfiles,
    TResult? Function(_AcceptApplication value)? acceptApplication,
    TResult? Function(_RejectApplication value)? rejectApplication,
    TResult? Function(_FilterApplications value)? filterApplications,
    TResult? Function(_SearchApplications value)? searchApplications,
    TResult? Function(_ChangeView value)? changeView,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_LoadApplications value)? loadApplications,
    TResult Function(_LoadUserProfiles value)? loadUserProfiles,
    TResult Function(_AcceptApplication value)? acceptApplication,
    TResult Function(_RejectApplication value)? rejectApplication,
    TResult Function(_FilterApplications value)? filterApplications,
    TResult Function(_SearchApplications value)? searchApplications,
    TResult Function(_ChangeView value)? changeView,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicationsManagementEventCopyWith<$Res> {
  factory $ApplicationsManagementEventCopyWith(
    ApplicationsManagementEvent value,
    $Res Function(ApplicationsManagementEvent) then,
  ) =
      _$ApplicationsManagementEventCopyWithImpl<
        $Res,
        ApplicationsManagementEvent
      >;
}

/// @nodoc
class _$ApplicationsManagementEventCopyWithImpl<
  $Res,
  $Val extends ApplicationsManagementEvent
>
    implements $ApplicationsManagementEventCopyWith<$Res> {
  _$ApplicationsManagementEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitializeImplCopyWith<$Res> {
  factory _$$InitializeImplCopyWith(
    _$InitializeImpl value,
    $Res Function(_$InitializeImpl) then,
  ) = __$$InitializeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String planId});
}

/// @nodoc
class __$$InitializeImplCopyWithImpl<$Res>
    extends _$ApplicationsManagementEventCopyWithImpl<$Res, _$InitializeImpl>
    implements _$$InitializeImplCopyWith<$Res> {
  __$$InitializeImplCopyWithImpl(
    _$InitializeImpl _value,
    $Res Function(_$InitializeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? planId = null}) {
    return _then(
      _$InitializeImpl(
        null == planId
            ? _value.planId
            : planId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$InitializeImpl implements _Initialize {
  const _$InitializeImpl(this.planId);

  @override
  final String planId;

  @override
  String toString() {
    return 'ApplicationsManagementEvent.initialize(planId: $planId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitializeImpl &&
            (identical(other.planId, planId) || other.planId == planId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, planId);

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InitializeImplCopyWith<_$InitializeImpl> get copyWith =>
      __$$InitializeImplCopyWithImpl<_$InitializeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String planId) initialize,
    required TResult Function(String planId) loadApplications,
    required TResult Function() loadUserProfiles,
    required TResult Function(String applicationId) acceptApplication,
    required TResult Function(String applicationId) rejectApplication,
    required TResult Function(String filterType) filterApplications,
    required TResult Function(String query) searchApplications,
    required TResult Function(String viewType) changeView,
  }) {
    return initialize(planId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String planId)? initialize,
    TResult? Function(String planId)? loadApplications,
    TResult? Function()? loadUserProfiles,
    TResult? Function(String applicationId)? acceptApplication,
    TResult? Function(String applicationId)? rejectApplication,
    TResult? Function(String filterType)? filterApplications,
    TResult? Function(String query)? searchApplications,
    TResult? Function(String viewType)? changeView,
  }) {
    return initialize?.call(planId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String planId)? initialize,
    TResult Function(String planId)? loadApplications,
    TResult Function()? loadUserProfiles,
    TResult Function(String applicationId)? acceptApplication,
    TResult Function(String applicationId)? rejectApplication,
    TResult Function(String filterType)? filterApplications,
    TResult Function(String query)? searchApplications,
    TResult Function(String viewType)? changeView,
    required TResult orElse(),
  }) {
    if (initialize != null) {
      return initialize(planId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_LoadApplications value) loadApplications,
    required TResult Function(_LoadUserProfiles value) loadUserProfiles,
    required TResult Function(_AcceptApplication value) acceptApplication,
    required TResult Function(_RejectApplication value) rejectApplication,
    required TResult Function(_FilterApplications value) filterApplications,
    required TResult Function(_SearchApplications value) searchApplications,
    required TResult Function(_ChangeView value) changeView,
  }) {
    return initialize(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_LoadApplications value)? loadApplications,
    TResult? Function(_LoadUserProfiles value)? loadUserProfiles,
    TResult? Function(_AcceptApplication value)? acceptApplication,
    TResult? Function(_RejectApplication value)? rejectApplication,
    TResult? Function(_FilterApplications value)? filterApplications,
    TResult? Function(_SearchApplications value)? searchApplications,
    TResult? Function(_ChangeView value)? changeView,
  }) {
    return initialize?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_LoadApplications value)? loadApplications,
    TResult Function(_LoadUserProfiles value)? loadUserProfiles,
    TResult Function(_AcceptApplication value)? acceptApplication,
    TResult Function(_RejectApplication value)? rejectApplication,
    TResult Function(_FilterApplications value)? filterApplications,
    TResult Function(_SearchApplications value)? searchApplications,
    TResult Function(_ChangeView value)? changeView,
    required TResult orElse(),
  }) {
    if (initialize != null) {
      return initialize(this);
    }
    return orElse();
  }
}

abstract class _Initialize implements ApplicationsManagementEvent {
  const factory _Initialize(final String planId) = _$InitializeImpl;

  String get planId;

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InitializeImplCopyWith<_$InitializeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadApplicationsImplCopyWith<$Res> {
  factory _$$LoadApplicationsImplCopyWith(
    _$LoadApplicationsImpl value,
    $Res Function(_$LoadApplicationsImpl) then,
  ) = __$$LoadApplicationsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String planId});
}

/// @nodoc
class __$$LoadApplicationsImplCopyWithImpl<$Res>
    extends
        _$ApplicationsManagementEventCopyWithImpl<$Res, _$LoadApplicationsImpl>
    implements _$$LoadApplicationsImplCopyWith<$Res> {
  __$$LoadApplicationsImplCopyWithImpl(
    _$LoadApplicationsImpl _value,
    $Res Function(_$LoadApplicationsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? planId = null}) {
    return _then(
      _$LoadApplicationsImpl(
        null == planId
            ? _value.planId
            : planId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$LoadApplicationsImpl implements _LoadApplications {
  const _$LoadApplicationsImpl(this.planId);

  @override
  final String planId;

  @override
  String toString() {
    return 'ApplicationsManagementEvent.loadApplications(planId: $planId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadApplicationsImpl &&
            (identical(other.planId, planId) || other.planId == planId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, planId);

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadApplicationsImplCopyWith<_$LoadApplicationsImpl> get copyWith =>
      __$$LoadApplicationsImplCopyWithImpl<_$LoadApplicationsImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String planId) initialize,
    required TResult Function(String planId) loadApplications,
    required TResult Function() loadUserProfiles,
    required TResult Function(String applicationId) acceptApplication,
    required TResult Function(String applicationId) rejectApplication,
    required TResult Function(String filterType) filterApplications,
    required TResult Function(String query) searchApplications,
    required TResult Function(String viewType) changeView,
  }) {
    return loadApplications(planId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String planId)? initialize,
    TResult? Function(String planId)? loadApplications,
    TResult? Function()? loadUserProfiles,
    TResult? Function(String applicationId)? acceptApplication,
    TResult? Function(String applicationId)? rejectApplication,
    TResult? Function(String filterType)? filterApplications,
    TResult? Function(String query)? searchApplications,
    TResult? Function(String viewType)? changeView,
  }) {
    return loadApplications?.call(planId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String planId)? initialize,
    TResult Function(String planId)? loadApplications,
    TResult Function()? loadUserProfiles,
    TResult Function(String applicationId)? acceptApplication,
    TResult Function(String applicationId)? rejectApplication,
    TResult Function(String filterType)? filterApplications,
    TResult Function(String query)? searchApplications,
    TResult Function(String viewType)? changeView,
    required TResult orElse(),
  }) {
    if (loadApplications != null) {
      return loadApplications(planId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_LoadApplications value) loadApplications,
    required TResult Function(_LoadUserProfiles value) loadUserProfiles,
    required TResult Function(_AcceptApplication value) acceptApplication,
    required TResult Function(_RejectApplication value) rejectApplication,
    required TResult Function(_FilterApplications value) filterApplications,
    required TResult Function(_SearchApplications value) searchApplications,
    required TResult Function(_ChangeView value) changeView,
  }) {
    return loadApplications(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_LoadApplications value)? loadApplications,
    TResult? Function(_LoadUserProfiles value)? loadUserProfiles,
    TResult? Function(_AcceptApplication value)? acceptApplication,
    TResult? Function(_RejectApplication value)? rejectApplication,
    TResult? Function(_FilterApplications value)? filterApplications,
    TResult? Function(_SearchApplications value)? searchApplications,
    TResult? Function(_ChangeView value)? changeView,
  }) {
    return loadApplications?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_LoadApplications value)? loadApplications,
    TResult Function(_LoadUserProfiles value)? loadUserProfiles,
    TResult Function(_AcceptApplication value)? acceptApplication,
    TResult Function(_RejectApplication value)? rejectApplication,
    TResult Function(_FilterApplications value)? filterApplications,
    TResult Function(_SearchApplications value)? searchApplications,
    TResult Function(_ChangeView value)? changeView,
    required TResult orElse(),
  }) {
    if (loadApplications != null) {
      return loadApplications(this);
    }
    return orElse();
  }
}

abstract class _LoadApplications implements ApplicationsManagementEvent {
  const factory _LoadApplications(final String planId) = _$LoadApplicationsImpl;

  String get planId;

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadApplicationsImplCopyWith<_$LoadApplicationsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadUserProfilesImplCopyWith<$Res> {
  factory _$$LoadUserProfilesImplCopyWith(
    _$LoadUserProfilesImpl value,
    $Res Function(_$LoadUserProfilesImpl) then,
  ) = __$$LoadUserProfilesImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadUserProfilesImplCopyWithImpl<$Res>
    extends
        _$ApplicationsManagementEventCopyWithImpl<$Res, _$LoadUserProfilesImpl>
    implements _$$LoadUserProfilesImplCopyWith<$Res> {
  __$$LoadUserProfilesImplCopyWithImpl(
    _$LoadUserProfilesImpl _value,
    $Res Function(_$LoadUserProfilesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadUserProfilesImpl implements _LoadUserProfiles {
  const _$LoadUserProfilesImpl();

  @override
  String toString() {
    return 'ApplicationsManagementEvent.loadUserProfiles()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadUserProfilesImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String planId) initialize,
    required TResult Function(String planId) loadApplications,
    required TResult Function() loadUserProfiles,
    required TResult Function(String applicationId) acceptApplication,
    required TResult Function(String applicationId) rejectApplication,
    required TResult Function(String filterType) filterApplications,
    required TResult Function(String query) searchApplications,
    required TResult Function(String viewType) changeView,
  }) {
    return loadUserProfiles();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String planId)? initialize,
    TResult? Function(String planId)? loadApplications,
    TResult? Function()? loadUserProfiles,
    TResult? Function(String applicationId)? acceptApplication,
    TResult? Function(String applicationId)? rejectApplication,
    TResult? Function(String filterType)? filterApplications,
    TResult? Function(String query)? searchApplications,
    TResult? Function(String viewType)? changeView,
  }) {
    return loadUserProfiles?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String planId)? initialize,
    TResult Function(String planId)? loadApplications,
    TResult Function()? loadUserProfiles,
    TResult Function(String applicationId)? acceptApplication,
    TResult Function(String applicationId)? rejectApplication,
    TResult Function(String filterType)? filterApplications,
    TResult Function(String query)? searchApplications,
    TResult Function(String viewType)? changeView,
    required TResult orElse(),
  }) {
    if (loadUserProfiles != null) {
      return loadUserProfiles();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_LoadApplications value) loadApplications,
    required TResult Function(_LoadUserProfiles value) loadUserProfiles,
    required TResult Function(_AcceptApplication value) acceptApplication,
    required TResult Function(_RejectApplication value) rejectApplication,
    required TResult Function(_FilterApplications value) filterApplications,
    required TResult Function(_SearchApplications value) searchApplications,
    required TResult Function(_ChangeView value) changeView,
  }) {
    return loadUserProfiles(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_LoadApplications value)? loadApplications,
    TResult? Function(_LoadUserProfiles value)? loadUserProfiles,
    TResult? Function(_AcceptApplication value)? acceptApplication,
    TResult? Function(_RejectApplication value)? rejectApplication,
    TResult? Function(_FilterApplications value)? filterApplications,
    TResult? Function(_SearchApplications value)? searchApplications,
    TResult? Function(_ChangeView value)? changeView,
  }) {
    return loadUserProfiles?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_LoadApplications value)? loadApplications,
    TResult Function(_LoadUserProfiles value)? loadUserProfiles,
    TResult Function(_AcceptApplication value)? acceptApplication,
    TResult Function(_RejectApplication value)? rejectApplication,
    TResult Function(_FilterApplications value)? filterApplications,
    TResult Function(_SearchApplications value)? searchApplications,
    TResult Function(_ChangeView value)? changeView,
    required TResult orElse(),
  }) {
    if (loadUserProfiles != null) {
      return loadUserProfiles(this);
    }
    return orElse();
  }
}

abstract class _LoadUserProfiles implements ApplicationsManagementEvent {
  const factory _LoadUserProfiles() = _$LoadUserProfilesImpl;
}

/// @nodoc
abstract class _$$AcceptApplicationImplCopyWith<$Res> {
  factory _$$AcceptApplicationImplCopyWith(
    _$AcceptApplicationImpl value,
    $Res Function(_$AcceptApplicationImpl) then,
  ) = __$$AcceptApplicationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String applicationId});
}

/// @nodoc
class __$$AcceptApplicationImplCopyWithImpl<$Res>
    extends
        _$ApplicationsManagementEventCopyWithImpl<$Res, _$AcceptApplicationImpl>
    implements _$$AcceptApplicationImplCopyWith<$Res> {
  __$$AcceptApplicationImplCopyWithImpl(
    _$AcceptApplicationImpl _value,
    $Res Function(_$AcceptApplicationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? applicationId = null}) {
    return _then(
      _$AcceptApplicationImpl(
        null == applicationId
            ? _value.applicationId
            : applicationId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AcceptApplicationImpl implements _AcceptApplication {
  const _$AcceptApplicationImpl(this.applicationId);

  @override
  final String applicationId;

  @override
  String toString() {
    return 'ApplicationsManagementEvent.acceptApplication(applicationId: $applicationId)';
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

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AcceptApplicationImplCopyWith<_$AcceptApplicationImpl> get copyWith =>
      __$$AcceptApplicationImplCopyWithImpl<_$AcceptApplicationImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String planId) initialize,
    required TResult Function(String planId) loadApplications,
    required TResult Function() loadUserProfiles,
    required TResult Function(String applicationId) acceptApplication,
    required TResult Function(String applicationId) rejectApplication,
    required TResult Function(String filterType) filterApplications,
    required TResult Function(String query) searchApplications,
    required TResult Function(String viewType) changeView,
  }) {
    return acceptApplication(applicationId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String planId)? initialize,
    TResult? Function(String planId)? loadApplications,
    TResult? Function()? loadUserProfiles,
    TResult? Function(String applicationId)? acceptApplication,
    TResult? Function(String applicationId)? rejectApplication,
    TResult? Function(String filterType)? filterApplications,
    TResult? Function(String query)? searchApplications,
    TResult? Function(String viewType)? changeView,
  }) {
    return acceptApplication?.call(applicationId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String planId)? initialize,
    TResult Function(String planId)? loadApplications,
    TResult Function()? loadUserProfiles,
    TResult Function(String applicationId)? acceptApplication,
    TResult Function(String applicationId)? rejectApplication,
    TResult Function(String filterType)? filterApplications,
    TResult Function(String query)? searchApplications,
    TResult Function(String viewType)? changeView,
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
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_LoadApplications value) loadApplications,
    required TResult Function(_LoadUserProfiles value) loadUserProfiles,
    required TResult Function(_AcceptApplication value) acceptApplication,
    required TResult Function(_RejectApplication value) rejectApplication,
    required TResult Function(_FilterApplications value) filterApplications,
    required TResult Function(_SearchApplications value) searchApplications,
    required TResult Function(_ChangeView value) changeView,
  }) {
    return acceptApplication(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_LoadApplications value)? loadApplications,
    TResult? Function(_LoadUserProfiles value)? loadUserProfiles,
    TResult? Function(_AcceptApplication value)? acceptApplication,
    TResult? Function(_RejectApplication value)? rejectApplication,
    TResult? Function(_FilterApplications value)? filterApplications,
    TResult? Function(_SearchApplications value)? searchApplications,
    TResult? Function(_ChangeView value)? changeView,
  }) {
    return acceptApplication?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_LoadApplications value)? loadApplications,
    TResult Function(_LoadUserProfiles value)? loadUserProfiles,
    TResult Function(_AcceptApplication value)? acceptApplication,
    TResult Function(_RejectApplication value)? rejectApplication,
    TResult Function(_FilterApplications value)? filterApplications,
    TResult Function(_SearchApplications value)? searchApplications,
    TResult Function(_ChangeView value)? changeView,
    required TResult orElse(),
  }) {
    if (acceptApplication != null) {
      return acceptApplication(this);
    }
    return orElse();
  }
}

abstract class _AcceptApplication implements ApplicationsManagementEvent {
  const factory _AcceptApplication(final String applicationId) =
      _$AcceptApplicationImpl;

  String get applicationId;

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AcceptApplicationImplCopyWith<_$AcceptApplicationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RejectApplicationImplCopyWith<$Res> {
  factory _$$RejectApplicationImplCopyWith(
    _$RejectApplicationImpl value,
    $Res Function(_$RejectApplicationImpl) then,
  ) = __$$RejectApplicationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String applicationId});
}

/// @nodoc
class __$$RejectApplicationImplCopyWithImpl<$Res>
    extends
        _$ApplicationsManagementEventCopyWithImpl<$Res, _$RejectApplicationImpl>
    implements _$$RejectApplicationImplCopyWith<$Res> {
  __$$RejectApplicationImplCopyWithImpl(
    _$RejectApplicationImpl _value,
    $Res Function(_$RejectApplicationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? applicationId = null}) {
    return _then(
      _$RejectApplicationImpl(
        null == applicationId
            ? _value.applicationId
            : applicationId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$RejectApplicationImpl implements _RejectApplication {
  const _$RejectApplicationImpl(this.applicationId);

  @override
  final String applicationId;

  @override
  String toString() {
    return 'ApplicationsManagementEvent.rejectApplication(applicationId: $applicationId)';
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

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RejectApplicationImplCopyWith<_$RejectApplicationImpl> get copyWith =>
      __$$RejectApplicationImplCopyWithImpl<_$RejectApplicationImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String planId) initialize,
    required TResult Function(String planId) loadApplications,
    required TResult Function() loadUserProfiles,
    required TResult Function(String applicationId) acceptApplication,
    required TResult Function(String applicationId) rejectApplication,
    required TResult Function(String filterType) filterApplications,
    required TResult Function(String query) searchApplications,
    required TResult Function(String viewType) changeView,
  }) {
    return rejectApplication(applicationId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String planId)? initialize,
    TResult? Function(String planId)? loadApplications,
    TResult? Function()? loadUserProfiles,
    TResult? Function(String applicationId)? acceptApplication,
    TResult? Function(String applicationId)? rejectApplication,
    TResult? Function(String filterType)? filterApplications,
    TResult? Function(String query)? searchApplications,
    TResult? Function(String viewType)? changeView,
  }) {
    return rejectApplication?.call(applicationId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String planId)? initialize,
    TResult Function(String planId)? loadApplications,
    TResult Function()? loadUserProfiles,
    TResult Function(String applicationId)? acceptApplication,
    TResult Function(String applicationId)? rejectApplication,
    TResult Function(String filterType)? filterApplications,
    TResult Function(String query)? searchApplications,
    TResult Function(String viewType)? changeView,
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
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_LoadApplications value) loadApplications,
    required TResult Function(_LoadUserProfiles value) loadUserProfiles,
    required TResult Function(_AcceptApplication value) acceptApplication,
    required TResult Function(_RejectApplication value) rejectApplication,
    required TResult Function(_FilterApplications value) filterApplications,
    required TResult Function(_SearchApplications value) searchApplications,
    required TResult Function(_ChangeView value) changeView,
  }) {
    return rejectApplication(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_LoadApplications value)? loadApplications,
    TResult? Function(_LoadUserProfiles value)? loadUserProfiles,
    TResult? Function(_AcceptApplication value)? acceptApplication,
    TResult? Function(_RejectApplication value)? rejectApplication,
    TResult? Function(_FilterApplications value)? filterApplications,
    TResult? Function(_SearchApplications value)? searchApplications,
    TResult? Function(_ChangeView value)? changeView,
  }) {
    return rejectApplication?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_LoadApplications value)? loadApplications,
    TResult Function(_LoadUserProfiles value)? loadUserProfiles,
    TResult Function(_AcceptApplication value)? acceptApplication,
    TResult Function(_RejectApplication value)? rejectApplication,
    TResult Function(_FilterApplications value)? filterApplications,
    TResult Function(_SearchApplications value)? searchApplications,
    TResult Function(_ChangeView value)? changeView,
    required TResult orElse(),
  }) {
    if (rejectApplication != null) {
      return rejectApplication(this);
    }
    return orElse();
  }
}

abstract class _RejectApplication implements ApplicationsManagementEvent {
  const factory _RejectApplication(final String applicationId) =
      _$RejectApplicationImpl;

  String get applicationId;

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RejectApplicationImplCopyWith<_$RejectApplicationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FilterApplicationsImplCopyWith<$Res> {
  factory _$$FilterApplicationsImplCopyWith(
    _$FilterApplicationsImpl value,
    $Res Function(_$FilterApplicationsImpl) then,
  ) = __$$FilterApplicationsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String filterType});
}

/// @nodoc
class __$$FilterApplicationsImplCopyWithImpl<$Res>
    extends
        _$ApplicationsManagementEventCopyWithImpl<
          $Res,
          _$FilterApplicationsImpl
        >
    implements _$$FilterApplicationsImplCopyWith<$Res> {
  __$$FilterApplicationsImplCopyWithImpl(
    _$FilterApplicationsImpl _value,
    $Res Function(_$FilterApplicationsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? filterType = null}) {
    return _then(
      _$FilterApplicationsImpl(
        null == filterType
            ? _value.filterType
            : filterType // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$FilterApplicationsImpl implements _FilterApplications {
  const _$FilterApplicationsImpl(this.filterType);

  @override
  final String filterType;

  @override
  String toString() {
    return 'ApplicationsManagementEvent.filterApplications(filterType: $filterType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterApplicationsImpl &&
            (identical(other.filterType, filterType) ||
                other.filterType == filterType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, filterType);

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterApplicationsImplCopyWith<_$FilterApplicationsImpl> get copyWith =>
      __$$FilterApplicationsImplCopyWithImpl<_$FilterApplicationsImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String planId) initialize,
    required TResult Function(String planId) loadApplications,
    required TResult Function() loadUserProfiles,
    required TResult Function(String applicationId) acceptApplication,
    required TResult Function(String applicationId) rejectApplication,
    required TResult Function(String filterType) filterApplications,
    required TResult Function(String query) searchApplications,
    required TResult Function(String viewType) changeView,
  }) {
    return filterApplications(filterType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String planId)? initialize,
    TResult? Function(String planId)? loadApplications,
    TResult? Function()? loadUserProfiles,
    TResult? Function(String applicationId)? acceptApplication,
    TResult? Function(String applicationId)? rejectApplication,
    TResult? Function(String filterType)? filterApplications,
    TResult? Function(String query)? searchApplications,
    TResult? Function(String viewType)? changeView,
  }) {
    return filterApplications?.call(filterType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String planId)? initialize,
    TResult Function(String planId)? loadApplications,
    TResult Function()? loadUserProfiles,
    TResult Function(String applicationId)? acceptApplication,
    TResult Function(String applicationId)? rejectApplication,
    TResult Function(String filterType)? filterApplications,
    TResult Function(String query)? searchApplications,
    TResult Function(String viewType)? changeView,
    required TResult orElse(),
  }) {
    if (filterApplications != null) {
      return filterApplications(filterType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_LoadApplications value) loadApplications,
    required TResult Function(_LoadUserProfiles value) loadUserProfiles,
    required TResult Function(_AcceptApplication value) acceptApplication,
    required TResult Function(_RejectApplication value) rejectApplication,
    required TResult Function(_FilterApplications value) filterApplications,
    required TResult Function(_SearchApplications value) searchApplications,
    required TResult Function(_ChangeView value) changeView,
  }) {
    return filterApplications(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_LoadApplications value)? loadApplications,
    TResult? Function(_LoadUserProfiles value)? loadUserProfiles,
    TResult? Function(_AcceptApplication value)? acceptApplication,
    TResult? Function(_RejectApplication value)? rejectApplication,
    TResult? Function(_FilterApplications value)? filterApplications,
    TResult? Function(_SearchApplications value)? searchApplications,
    TResult? Function(_ChangeView value)? changeView,
  }) {
    return filterApplications?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_LoadApplications value)? loadApplications,
    TResult Function(_LoadUserProfiles value)? loadUserProfiles,
    TResult Function(_AcceptApplication value)? acceptApplication,
    TResult Function(_RejectApplication value)? rejectApplication,
    TResult Function(_FilterApplications value)? filterApplications,
    TResult Function(_SearchApplications value)? searchApplications,
    TResult Function(_ChangeView value)? changeView,
    required TResult orElse(),
  }) {
    if (filterApplications != null) {
      return filterApplications(this);
    }
    return orElse();
  }
}

abstract class _FilterApplications implements ApplicationsManagementEvent {
  const factory _FilterApplications(final String filterType) =
      _$FilterApplicationsImpl;

  String get filterType;

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilterApplicationsImplCopyWith<_$FilterApplicationsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SearchApplicationsImplCopyWith<$Res> {
  factory _$$SearchApplicationsImplCopyWith(
    _$SearchApplicationsImpl value,
    $Res Function(_$SearchApplicationsImpl) then,
  ) = __$$SearchApplicationsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String query});
}

/// @nodoc
class __$$SearchApplicationsImplCopyWithImpl<$Res>
    extends
        _$ApplicationsManagementEventCopyWithImpl<
          $Res,
          _$SearchApplicationsImpl
        >
    implements _$$SearchApplicationsImplCopyWith<$Res> {
  __$$SearchApplicationsImplCopyWithImpl(
    _$SearchApplicationsImpl _value,
    $Res Function(_$SearchApplicationsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? query = null}) {
    return _then(
      _$SearchApplicationsImpl(
        null == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SearchApplicationsImpl implements _SearchApplications {
  const _$SearchApplicationsImpl(this.query);

  @override
  final String query;

  @override
  String toString() {
    return 'ApplicationsManagementEvent.searchApplications(query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchApplicationsImpl &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query);

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchApplicationsImplCopyWith<_$SearchApplicationsImpl> get copyWith =>
      __$$SearchApplicationsImplCopyWithImpl<_$SearchApplicationsImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String planId) initialize,
    required TResult Function(String planId) loadApplications,
    required TResult Function() loadUserProfiles,
    required TResult Function(String applicationId) acceptApplication,
    required TResult Function(String applicationId) rejectApplication,
    required TResult Function(String filterType) filterApplications,
    required TResult Function(String query) searchApplications,
    required TResult Function(String viewType) changeView,
  }) {
    return searchApplications(query);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String planId)? initialize,
    TResult? Function(String planId)? loadApplications,
    TResult? Function()? loadUserProfiles,
    TResult? Function(String applicationId)? acceptApplication,
    TResult? Function(String applicationId)? rejectApplication,
    TResult? Function(String filterType)? filterApplications,
    TResult? Function(String query)? searchApplications,
    TResult? Function(String viewType)? changeView,
  }) {
    return searchApplications?.call(query);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String planId)? initialize,
    TResult Function(String planId)? loadApplications,
    TResult Function()? loadUserProfiles,
    TResult Function(String applicationId)? acceptApplication,
    TResult Function(String applicationId)? rejectApplication,
    TResult Function(String filterType)? filterApplications,
    TResult Function(String query)? searchApplications,
    TResult Function(String viewType)? changeView,
    required TResult orElse(),
  }) {
    if (searchApplications != null) {
      return searchApplications(query);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_LoadApplications value) loadApplications,
    required TResult Function(_LoadUserProfiles value) loadUserProfiles,
    required TResult Function(_AcceptApplication value) acceptApplication,
    required TResult Function(_RejectApplication value) rejectApplication,
    required TResult Function(_FilterApplications value) filterApplications,
    required TResult Function(_SearchApplications value) searchApplications,
    required TResult Function(_ChangeView value) changeView,
  }) {
    return searchApplications(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_LoadApplications value)? loadApplications,
    TResult? Function(_LoadUserProfiles value)? loadUserProfiles,
    TResult? Function(_AcceptApplication value)? acceptApplication,
    TResult? Function(_RejectApplication value)? rejectApplication,
    TResult? Function(_FilterApplications value)? filterApplications,
    TResult? Function(_SearchApplications value)? searchApplications,
    TResult? Function(_ChangeView value)? changeView,
  }) {
    return searchApplications?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_LoadApplications value)? loadApplications,
    TResult Function(_LoadUserProfiles value)? loadUserProfiles,
    TResult Function(_AcceptApplication value)? acceptApplication,
    TResult Function(_RejectApplication value)? rejectApplication,
    TResult Function(_FilterApplications value)? filterApplications,
    TResult Function(_SearchApplications value)? searchApplications,
    TResult Function(_ChangeView value)? changeView,
    required TResult orElse(),
  }) {
    if (searchApplications != null) {
      return searchApplications(this);
    }
    return orElse();
  }
}

abstract class _SearchApplications implements ApplicationsManagementEvent {
  const factory _SearchApplications(final String query) =
      _$SearchApplicationsImpl;

  String get query;

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchApplicationsImplCopyWith<_$SearchApplicationsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ChangeViewImplCopyWith<$Res> {
  factory _$$ChangeViewImplCopyWith(
    _$ChangeViewImpl value,
    $Res Function(_$ChangeViewImpl) then,
  ) = __$$ChangeViewImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String viewType});
}

/// @nodoc
class __$$ChangeViewImplCopyWithImpl<$Res>
    extends _$ApplicationsManagementEventCopyWithImpl<$Res, _$ChangeViewImpl>
    implements _$$ChangeViewImplCopyWith<$Res> {
  __$$ChangeViewImplCopyWithImpl(
    _$ChangeViewImpl _value,
    $Res Function(_$ChangeViewImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? viewType = null}) {
    return _then(
      _$ChangeViewImpl(
        null == viewType
            ? _value.viewType
            : viewType // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ChangeViewImpl implements _ChangeView {
  const _$ChangeViewImpl(this.viewType);

  @override
  final String viewType;

  @override
  String toString() {
    return 'ApplicationsManagementEvent.changeView(viewType: $viewType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangeViewImpl &&
            (identical(other.viewType, viewType) ||
                other.viewType == viewType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, viewType);

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangeViewImplCopyWith<_$ChangeViewImpl> get copyWith =>
      __$$ChangeViewImplCopyWithImpl<_$ChangeViewImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String planId) initialize,
    required TResult Function(String planId) loadApplications,
    required TResult Function() loadUserProfiles,
    required TResult Function(String applicationId) acceptApplication,
    required TResult Function(String applicationId) rejectApplication,
    required TResult Function(String filterType) filterApplications,
    required TResult Function(String query) searchApplications,
    required TResult Function(String viewType) changeView,
  }) {
    return changeView(viewType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String planId)? initialize,
    TResult? Function(String planId)? loadApplications,
    TResult? Function()? loadUserProfiles,
    TResult? Function(String applicationId)? acceptApplication,
    TResult? Function(String applicationId)? rejectApplication,
    TResult? Function(String filterType)? filterApplications,
    TResult? Function(String query)? searchApplications,
    TResult? Function(String viewType)? changeView,
  }) {
    return changeView?.call(viewType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String planId)? initialize,
    TResult Function(String planId)? loadApplications,
    TResult Function()? loadUserProfiles,
    TResult Function(String applicationId)? acceptApplication,
    TResult Function(String applicationId)? rejectApplication,
    TResult Function(String filterType)? filterApplications,
    TResult Function(String query)? searchApplications,
    TResult Function(String viewType)? changeView,
    required TResult orElse(),
  }) {
    if (changeView != null) {
      return changeView(viewType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_LoadApplications value) loadApplications,
    required TResult Function(_LoadUserProfiles value) loadUserProfiles,
    required TResult Function(_AcceptApplication value) acceptApplication,
    required TResult Function(_RejectApplication value) rejectApplication,
    required TResult Function(_FilterApplications value) filterApplications,
    required TResult Function(_SearchApplications value) searchApplications,
    required TResult Function(_ChangeView value) changeView,
  }) {
    return changeView(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_LoadApplications value)? loadApplications,
    TResult? Function(_LoadUserProfiles value)? loadUserProfiles,
    TResult? Function(_AcceptApplication value)? acceptApplication,
    TResult? Function(_RejectApplication value)? rejectApplication,
    TResult? Function(_FilterApplications value)? filterApplications,
    TResult? Function(_SearchApplications value)? searchApplications,
    TResult? Function(_ChangeView value)? changeView,
  }) {
    return changeView?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_LoadApplications value)? loadApplications,
    TResult Function(_LoadUserProfiles value)? loadUserProfiles,
    TResult Function(_AcceptApplication value)? acceptApplication,
    TResult Function(_RejectApplication value)? rejectApplication,
    TResult Function(_FilterApplications value)? filterApplications,
    TResult Function(_SearchApplications value)? searchApplications,
    TResult Function(_ChangeView value)? changeView,
    required TResult orElse(),
  }) {
    if (changeView != null) {
      return changeView(this);
    }
    return orElse();
  }
}

abstract class _ChangeView implements ApplicationsManagementEvent {
  const factory _ChangeView(final String viewType) = _$ChangeViewImpl;

  String get viewType;

  /// Create a copy of ApplicationsManagementEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChangeViewImplCopyWith<_$ChangeViewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
