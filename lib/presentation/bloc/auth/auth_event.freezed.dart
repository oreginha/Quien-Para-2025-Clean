// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkAuthStatus,
    required TResult Function() signInWithGoogle,
    required TResult Function() signOut,
    required TResult Function() deleteAccount,
    required TResult Function() completeOnboarding,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkAuthStatus,
    TResult? Function()? signInWithGoogle,
    TResult? Function()? signOut,
    TResult? Function()? deleteAccount,
    TResult? Function()? completeOnboarding,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkAuthStatus,
    TResult Function()? signInWithGoogle,
    TResult Function()? signOut,
    TResult Function()? deleteAccount,
    TResult Function()? completeOnboarding,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CheckAuthStatus value) checkAuthStatus,
    required TResult Function(SignInWithGoogle value) signInWithGoogle,
    required TResult Function(SignOut value) signOut,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(CompleteOnboarding value) completeOnboarding,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CheckAuthStatus value)? checkAuthStatus,
    TResult? Function(SignInWithGoogle value)? signInWithGoogle,
    TResult? Function(SignOut value)? signOut,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(CompleteOnboarding value)? completeOnboarding,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CheckAuthStatus value)? checkAuthStatus,
    TResult Function(SignInWithGoogle value)? signInWithGoogle,
    TResult Function(SignOut value)? signOut,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(CompleteOnboarding value)? completeOnboarding,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthEventCopyWith<$Res> {
  factory $AuthEventCopyWith(AuthEvent value, $Res Function(AuthEvent) then) =
      _$AuthEventCopyWithImpl<$Res, AuthEvent>;
}

/// @nodoc
class _$AuthEventCopyWithImpl<$Res, $Val extends AuthEvent>
    implements $AuthEventCopyWith<$Res> {
  _$AuthEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CheckAuthStatusImplCopyWith<$Res> {
  factory _$$CheckAuthStatusImplCopyWith(
    _$CheckAuthStatusImpl value,
    $Res Function(_$CheckAuthStatusImpl) then,
  ) = __$$CheckAuthStatusImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CheckAuthStatusImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$CheckAuthStatusImpl>
    implements _$$CheckAuthStatusImplCopyWith<$Res> {
  __$$CheckAuthStatusImplCopyWithImpl(
    _$CheckAuthStatusImpl _value,
    $Res Function(_$CheckAuthStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CheckAuthStatusImpl extends CheckAuthStatus {
  const _$CheckAuthStatusImpl() : super._();

  @override
  String toString() {
    return 'AuthEvent.checkAuthStatus()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CheckAuthStatusImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkAuthStatus,
    required TResult Function() signInWithGoogle,
    required TResult Function() signOut,
    required TResult Function() deleteAccount,
    required TResult Function() completeOnboarding,
  }) {
    return checkAuthStatus();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkAuthStatus,
    TResult? Function()? signInWithGoogle,
    TResult? Function()? signOut,
    TResult? Function()? deleteAccount,
    TResult? Function()? completeOnboarding,
  }) {
    return checkAuthStatus?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkAuthStatus,
    TResult Function()? signInWithGoogle,
    TResult Function()? signOut,
    TResult Function()? deleteAccount,
    TResult Function()? completeOnboarding,
    required TResult orElse(),
  }) {
    if (checkAuthStatus != null) {
      return checkAuthStatus();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CheckAuthStatus value) checkAuthStatus,
    required TResult Function(SignInWithGoogle value) signInWithGoogle,
    required TResult Function(SignOut value) signOut,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(CompleteOnboarding value) completeOnboarding,
  }) {
    return checkAuthStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CheckAuthStatus value)? checkAuthStatus,
    TResult? Function(SignInWithGoogle value)? signInWithGoogle,
    TResult? Function(SignOut value)? signOut,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(CompleteOnboarding value)? completeOnboarding,
  }) {
    return checkAuthStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CheckAuthStatus value)? checkAuthStatus,
    TResult Function(SignInWithGoogle value)? signInWithGoogle,
    TResult Function(SignOut value)? signOut,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(CompleteOnboarding value)? completeOnboarding,
    required TResult orElse(),
  }) {
    if (checkAuthStatus != null) {
      return checkAuthStatus(this);
    }
    return orElse();
  }
}

abstract class CheckAuthStatus extends AuthEvent {
  const factory CheckAuthStatus() = _$CheckAuthStatusImpl;
  const CheckAuthStatus._() : super._();
}

/// @nodoc
abstract class _$$SignInWithGoogleImplCopyWith<$Res> {
  factory _$$SignInWithGoogleImplCopyWith(
    _$SignInWithGoogleImpl value,
    $Res Function(_$SignInWithGoogleImpl) then,
  ) = __$$SignInWithGoogleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignInWithGoogleImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$SignInWithGoogleImpl>
    implements _$$SignInWithGoogleImplCopyWith<$Res> {
  __$$SignInWithGoogleImplCopyWithImpl(
    _$SignInWithGoogleImpl _value,
    $Res Function(_$SignInWithGoogleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SignInWithGoogleImpl extends SignInWithGoogle {
  const _$SignInWithGoogleImpl() : super._();

  @override
  String toString() {
    return 'AuthEvent.signInWithGoogle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SignInWithGoogleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkAuthStatus,
    required TResult Function() signInWithGoogle,
    required TResult Function() signOut,
    required TResult Function() deleteAccount,
    required TResult Function() completeOnboarding,
  }) {
    return signInWithGoogle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkAuthStatus,
    TResult? Function()? signInWithGoogle,
    TResult? Function()? signOut,
    TResult? Function()? deleteAccount,
    TResult? Function()? completeOnboarding,
  }) {
    return signInWithGoogle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkAuthStatus,
    TResult Function()? signInWithGoogle,
    TResult Function()? signOut,
    TResult Function()? deleteAccount,
    TResult Function()? completeOnboarding,
    required TResult orElse(),
  }) {
    if (signInWithGoogle != null) {
      return signInWithGoogle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CheckAuthStatus value) checkAuthStatus,
    required TResult Function(SignInWithGoogle value) signInWithGoogle,
    required TResult Function(SignOut value) signOut,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(CompleteOnboarding value) completeOnboarding,
  }) {
    return signInWithGoogle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CheckAuthStatus value)? checkAuthStatus,
    TResult? Function(SignInWithGoogle value)? signInWithGoogle,
    TResult? Function(SignOut value)? signOut,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(CompleteOnboarding value)? completeOnboarding,
  }) {
    return signInWithGoogle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CheckAuthStatus value)? checkAuthStatus,
    TResult Function(SignInWithGoogle value)? signInWithGoogle,
    TResult Function(SignOut value)? signOut,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(CompleteOnboarding value)? completeOnboarding,
    required TResult orElse(),
  }) {
    if (signInWithGoogle != null) {
      return signInWithGoogle(this);
    }
    return orElse();
  }
}

abstract class SignInWithGoogle extends AuthEvent {
  const factory SignInWithGoogle() = _$SignInWithGoogleImpl;
  const SignInWithGoogle._() : super._();
}

/// @nodoc
abstract class _$$SignOutImplCopyWith<$Res> {
  factory _$$SignOutImplCopyWith(
    _$SignOutImpl value,
    $Res Function(_$SignOutImpl) then,
  ) = __$$SignOutImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignOutImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$SignOutImpl>
    implements _$$SignOutImplCopyWith<$Res> {
  __$$SignOutImplCopyWithImpl(
    _$SignOutImpl _value,
    $Res Function(_$SignOutImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SignOutImpl extends SignOut {
  const _$SignOutImpl() : super._();

  @override
  String toString() {
    return 'AuthEvent.signOut()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SignOutImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkAuthStatus,
    required TResult Function() signInWithGoogle,
    required TResult Function() signOut,
    required TResult Function() deleteAccount,
    required TResult Function() completeOnboarding,
  }) {
    return signOut();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkAuthStatus,
    TResult? Function()? signInWithGoogle,
    TResult? Function()? signOut,
    TResult? Function()? deleteAccount,
    TResult? Function()? completeOnboarding,
  }) {
    return signOut?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkAuthStatus,
    TResult Function()? signInWithGoogle,
    TResult Function()? signOut,
    TResult Function()? deleteAccount,
    TResult Function()? completeOnboarding,
    required TResult orElse(),
  }) {
    if (signOut != null) {
      return signOut();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CheckAuthStatus value) checkAuthStatus,
    required TResult Function(SignInWithGoogle value) signInWithGoogle,
    required TResult Function(SignOut value) signOut,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(CompleteOnboarding value) completeOnboarding,
  }) {
    return signOut(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CheckAuthStatus value)? checkAuthStatus,
    TResult? Function(SignInWithGoogle value)? signInWithGoogle,
    TResult? Function(SignOut value)? signOut,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(CompleteOnboarding value)? completeOnboarding,
  }) {
    return signOut?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CheckAuthStatus value)? checkAuthStatus,
    TResult Function(SignInWithGoogle value)? signInWithGoogle,
    TResult Function(SignOut value)? signOut,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(CompleteOnboarding value)? completeOnboarding,
    required TResult orElse(),
  }) {
    if (signOut != null) {
      return signOut(this);
    }
    return orElse();
  }
}

abstract class SignOut extends AuthEvent {
  const factory SignOut() = _$SignOutImpl;
  const SignOut._() : super._();
}

/// @nodoc
abstract class _$$DeleteAccountImplCopyWith<$Res> {
  factory _$$DeleteAccountImplCopyWith(
    _$DeleteAccountImpl value,
    $Res Function(_$DeleteAccountImpl) then,
  ) = __$$DeleteAccountImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeleteAccountImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$DeleteAccountImpl>
    implements _$$DeleteAccountImplCopyWith<$Res> {
  __$$DeleteAccountImplCopyWithImpl(
    _$DeleteAccountImpl _value,
    $Res Function(_$DeleteAccountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DeleteAccountImpl extends DeleteAccount {
  const _$DeleteAccountImpl() : super._();

  @override
  String toString() {
    return 'AuthEvent.deleteAccount()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DeleteAccountImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkAuthStatus,
    required TResult Function() signInWithGoogle,
    required TResult Function() signOut,
    required TResult Function() deleteAccount,
    required TResult Function() completeOnboarding,
  }) {
    return deleteAccount();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkAuthStatus,
    TResult? Function()? signInWithGoogle,
    TResult? Function()? signOut,
    TResult? Function()? deleteAccount,
    TResult? Function()? completeOnboarding,
  }) {
    return deleteAccount?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkAuthStatus,
    TResult Function()? signInWithGoogle,
    TResult Function()? signOut,
    TResult Function()? deleteAccount,
    TResult Function()? completeOnboarding,
    required TResult orElse(),
  }) {
    if (deleteAccount != null) {
      return deleteAccount();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CheckAuthStatus value) checkAuthStatus,
    required TResult Function(SignInWithGoogle value) signInWithGoogle,
    required TResult Function(SignOut value) signOut,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(CompleteOnboarding value) completeOnboarding,
  }) {
    return deleteAccount(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CheckAuthStatus value)? checkAuthStatus,
    TResult? Function(SignInWithGoogle value)? signInWithGoogle,
    TResult? Function(SignOut value)? signOut,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(CompleteOnboarding value)? completeOnboarding,
  }) {
    return deleteAccount?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CheckAuthStatus value)? checkAuthStatus,
    TResult Function(SignInWithGoogle value)? signInWithGoogle,
    TResult Function(SignOut value)? signOut,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(CompleteOnboarding value)? completeOnboarding,
    required TResult orElse(),
  }) {
    if (deleteAccount != null) {
      return deleteAccount(this);
    }
    return orElse();
  }
}

abstract class DeleteAccount extends AuthEvent {
  const factory DeleteAccount() = _$DeleteAccountImpl;
  const DeleteAccount._() : super._();
}

/// @nodoc
abstract class _$$CompleteOnboardingImplCopyWith<$Res> {
  factory _$$CompleteOnboardingImplCopyWith(
    _$CompleteOnboardingImpl value,
    $Res Function(_$CompleteOnboardingImpl) then,
  ) = __$$CompleteOnboardingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CompleteOnboardingImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$CompleteOnboardingImpl>
    implements _$$CompleteOnboardingImplCopyWith<$Res> {
  __$$CompleteOnboardingImplCopyWithImpl(
    _$CompleteOnboardingImpl _value,
    $Res Function(_$CompleteOnboardingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CompleteOnboardingImpl extends CompleteOnboarding {
  const _$CompleteOnboardingImpl() : super._();

  @override
  String toString() {
    return 'AuthEvent.completeOnboarding()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CompleteOnboardingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() checkAuthStatus,
    required TResult Function() signInWithGoogle,
    required TResult Function() signOut,
    required TResult Function() deleteAccount,
    required TResult Function() completeOnboarding,
  }) {
    return completeOnboarding();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? checkAuthStatus,
    TResult? Function()? signInWithGoogle,
    TResult? Function()? signOut,
    TResult? Function()? deleteAccount,
    TResult? Function()? completeOnboarding,
  }) {
    return completeOnboarding?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? checkAuthStatus,
    TResult Function()? signInWithGoogle,
    TResult Function()? signOut,
    TResult Function()? deleteAccount,
    TResult Function()? completeOnboarding,
    required TResult orElse(),
  }) {
    if (completeOnboarding != null) {
      return completeOnboarding();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CheckAuthStatus value) checkAuthStatus,
    required TResult Function(SignInWithGoogle value) signInWithGoogle,
    required TResult Function(SignOut value) signOut,
    required TResult Function(DeleteAccount value) deleteAccount,
    required TResult Function(CompleteOnboarding value) completeOnboarding,
  }) {
    return completeOnboarding(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CheckAuthStatus value)? checkAuthStatus,
    TResult? Function(SignInWithGoogle value)? signInWithGoogle,
    TResult? Function(SignOut value)? signOut,
    TResult? Function(DeleteAccount value)? deleteAccount,
    TResult? Function(CompleteOnboarding value)? completeOnboarding,
  }) {
    return completeOnboarding?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CheckAuthStatus value)? checkAuthStatus,
    TResult Function(SignInWithGoogle value)? signInWithGoogle,
    TResult Function(SignOut value)? signOut,
    TResult Function(DeleteAccount value)? deleteAccount,
    TResult Function(CompleteOnboarding value)? completeOnboarding,
    required TResult orElse(),
  }) {
    if (completeOnboarding != null) {
      return completeOnboarding(this);
    }
    return orElse();
  }
}

abstract class CompleteOnboarding extends AuthEvent {
  const factory CompleteOnboarding() = _$CompleteOnboardingImpl;
  const CompleteOnboarding._() : super._();
}
