// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loading_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LoadingState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(T data) loaded,
    required TResult Function(String message) error,
    required TResult Function() empty,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(T data)? loaded,
    TResult? Function(String message)? error,
    TResult? Function()? empty,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(T data)? loaded,
    TResult Function(String message)? error,
    TResult Function()? empty,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadingState<T> value) loading,
    required TResult Function(_LoadedState<T> value) loaded,
    required TResult Function(_ErrorState<T> value) error,
    required TResult Function(_EmptyState<T> value) empty,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadingState<T> value)? loading,
    TResult? Function(_LoadedState<T> value)? loaded,
    TResult? Function(_ErrorState<T> value)? error,
    TResult? Function(_EmptyState<T> value)? empty,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadingState<T> value)? loading,
    TResult Function(_LoadedState<T> value)? loaded,
    TResult Function(_ErrorState<T> value)? error,
    TResult Function(_EmptyState<T> value)? empty,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoadingStateCopyWith<T, $Res> {
  factory $LoadingStateCopyWith(
    LoadingState<T> value,
    $Res Function(LoadingState<T>) then,
  ) = _$LoadingStateCopyWithImpl<T, $Res, LoadingState<T>>;
}

/// @nodoc
class _$LoadingStateCopyWithImpl<T, $Res, $Val extends LoadingState<T>>
    implements $LoadingStateCopyWith<T, $Res> {
  _$LoadingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoadingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadingStateImplCopyWith<T, $Res> {
  factory _$$LoadingStateImplCopyWith(
    _$LoadingStateImpl<T> value,
    $Res Function(_$LoadingStateImpl<T>) then,
  ) = __$$LoadingStateImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$LoadingStateImplCopyWithImpl<T, $Res>
    extends _$LoadingStateCopyWithImpl<T, $Res, _$LoadingStateImpl<T>>
    implements _$$LoadingStateImplCopyWith<T, $Res> {
  __$$LoadingStateImplCopyWithImpl(
    _$LoadingStateImpl<T> _value,
    $Res Function(_$LoadingStateImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of LoadingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingStateImpl<T> extends _LoadingState<T>
    with DiagnosticableTreeMixin {
  const _$LoadingStateImpl() : super._();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LoadingState<$T>.loading()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'LoadingState<$T>.loading'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingStateImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(T data) loaded,
    required TResult Function(String message) error,
    required TResult Function() empty,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(T data)? loaded,
    TResult? Function(String message)? error,
    TResult? Function()? empty,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(T data)? loaded,
    TResult Function(String message)? error,
    TResult Function()? empty,
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
    required TResult Function(_LoadingState<T> value) loading,
    required TResult Function(_LoadedState<T> value) loaded,
    required TResult Function(_ErrorState<T> value) error,
    required TResult Function(_EmptyState<T> value) empty,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadingState<T> value)? loading,
    TResult? Function(_LoadedState<T> value)? loaded,
    TResult? Function(_ErrorState<T> value)? error,
    TResult? Function(_EmptyState<T> value)? empty,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadingState<T> value)? loading,
    TResult Function(_LoadedState<T> value)? loaded,
    TResult Function(_ErrorState<T> value)? error,
    TResult Function(_EmptyState<T> value)? empty,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _LoadingState<T> extends LoadingState<T> {
  const factory _LoadingState() = _$LoadingStateImpl<T>;
  const _LoadingState._() : super._();
}

/// @nodoc
abstract class _$$LoadedStateImplCopyWith<T, $Res> {
  factory _$$LoadedStateImplCopyWith(
    _$LoadedStateImpl<T> value,
    $Res Function(_$LoadedStateImpl<T>) then,
  ) = __$$LoadedStateImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T data});
}

/// @nodoc
class __$$LoadedStateImplCopyWithImpl<T, $Res>
    extends _$LoadingStateCopyWithImpl<T, $Res, _$LoadedStateImpl<T>>
    implements _$$LoadedStateImplCopyWith<T, $Res> {
  __$$LoadedStateImplCopyWithImpl(
    _$LoadedStateImpl<T> _value,
    $Res Function(_$LoadedStateImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of LoadingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = freezed}) {
    return _then(
      _$LoadedStateImpl<T>(
        freezed == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as T,
      ),
    );
  }
}

/// @nodoc

class _$LoadedStateImpl<T> extends _LoadedState<T>
    with DiagnosticableTreeMixin {
  const _$LoadedStateImpl(this.data) : super._();

  @override
  final T data;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LoadingState<$T>.loaded(data: $data)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LoadingState<$T>.loaded'))
      ..add(DiagnosticsProperty('data', data));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadedStateImpl<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  /// Create a copy of LoadingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadedStateImplCopyWith<T, _$LoadedStateImpl<T>> get copyWith =>
      __$$LoadedStateImplCopyWithImpl<T, _$LoadedStateImpl<T>>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(T data) loaded,
    required TResult Function(String message) error,
    required TResult Function() empty,
  }) {
    return loaded(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(T data)? loaded,
    TResult? Function(String message)? error,
    TResult? Function()? empty,
  }) {
    return loaded?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(T data)? loaded,
    TResult Function(String message)? error,
    TResult Function()? empty,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadingState<T> value) loading,
    required TResult Function(_LoadedState<T> value) loaded,
    required TResult Function(_ErrorState<T> value) error,
    required TResult Function(_EmptyState<T> value) empty,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadingState<T> value)? loading,
    TResult? Function(_LoadedState<T> value)? loaded,
    TResult? Function(_ErrorState<T> value)? error,
    TResult? Function(_EmptyState<T> value)? empty,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadingState<T> value)? loading,
    TResult Function(_LoadedState<T> value)? loaded,
    TResult Function(_ErrorState<T> value)? error,
    TResult Function(_EmptyState<T> value)? empty,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _LoadedState<T> extends LoadingState<T> {
  const factory _LoadedState(final T data) = _$LoadedStateImpl<T>;
  const _LoadedState._() : super._();

  T get data;

  /// Create a copy of LoadingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadedStateImplCopyWith<T, _$LoadedStateImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorStateImplCopyWith<T, $Res> {
  factory _$$ErrorStateImplCopyWith(
    _$ErrorStateImpl<T> value,
    $Res Function(_$ErrorStateImpl<T>) then,
  ) = __$$ErrorStateImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorStateImplCopyWithImpl<T, $Res>
    extends _$LoadingStateCopyWithImpl<T, $Res, _$ErrorStateImpl<T>>
    implements _$$ErrorStateImplCopyWith<T, $Res> {
  __$$ErrorStateImplCopyWithImpl(
    _$ErrorStateImpl<T> _value,
    $Res Function(_$ErrorStateImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of LoadingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ErrorStateImpl<T>(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ErrorStateImpl<T> extends _ErrorState<T> with DiagnosticableTreeMixin {
  const _$ErrorStateImpl(this.message) : super._();

  @override
  final String message;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LoadingState<$T>.error(message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LoadingState<$T>.error'))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorStateImpl<T> &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of LoadingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorStateImplCopyWith<T, _$ErrorStateImpl<T>> get copyWith =>
      __$$ErrorStateImplCopyWithImpl<T, _$ErrorStateImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(T data) loaded,
    required TResult Function(String message) error,
    required TResult Function() empty,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(T data)? loaded,
    TResult? Function(String message)? error,
    TResult? Function()? empty,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(T data)? loaded,
    TResult Function(String message)? error,
    TResult Function()? empty,
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
    required TResult Function(_LoadingState<T> value) loading,
    required TResult Function(_LoadedState<T> value) loaded,
    required TResult Function(_ErrorState<T> value) error,
    required TResult Function(_EmptyState<T> value) empty,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadingState<T> value)? loading,
    TResult? Function(_LoadedState<T> value)? loaded,
    TResult? Function(_ErrorState<T> value)? error,
    TResult? Function(_EmptyState<T> value)? empty,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadingState<T> value)? loading,
    TResult Function(_LoadedState<T> value)? loaded,
    TResult Function(_ErrorState<T> value)? error,
    TResult Function(_EmptyState<T> value)? empty,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _ErrorState<T> extends LoadingState<T> {
  const factory _ErrorState(final String message) = _$ErrorStateImpl<T>;
  const _ErrorState._() : super._();

  String get message;

  /// Create a copy of LoadingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorStateImplCopyWith<T, _$ErrorStateImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EmptyStateImplCopyWith<T, $Res> {
  factory _$$EmptyStateImplCopyWith(
    _$EmptyStateImpl<T> value,
    $Res Function(_$EmptyStateImpl<T>) then,
  ) = __$$EmptyStateImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$EmptyStateImplCopyWithImpl<T, $Res>
    extends _$LoadingStateCopyWithImpl<T, $Res, _$EmptyStateImpl<T>>
    implements _$$EmptyStateImplCopyWith<T, $Res> {
  __$$EmptyStateImplCopyWithImpl(
    _$EmptyStateImpl<T> _value,
    $Res Function(_$EmptyStateImpl<T>) _then,
  ) : super(_value, _then);

  /// Create a copy of LoadingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$EmptyStateImpl<T> extends _EmptyState<T> with DiagnosticableTreeMixin {
  const _$EmptyStateImpl() : super._();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LoadingState<$T>.empty()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('type', 'LoadingState<$T>.empty'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$EmptyStateImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(T data) loaded,
    required TResult Function(String message) error,
    required TResult Function() empty,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(T data)? loaded,
    TResult? Function(String message)? error,
    TResult? Function()? empty,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(T data)? loaded,
    TResult Function(String message)? error,
    TResult Function()? empty,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadingState<T> value) loading,
    required TResult Function(_LoadedState<T> value) loaded,
    required TResult Function(_ErrorState<T> value) error,
    required TResult Function(_EmptyState<T> value) empty,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadingState<T> value)? loading,
    TResult? Function(_LoadedState<T> value)? loaded,
    TResult? Function(_ErrorState<T> value)? error,
    TResult? Function(_EmptyState<T> value)? empty,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadingState<T> value)? loading,
    TResult Function(_LoadedState<T> value)? loaded,
    TResult Function(_ErrorState<T> value)? error,
    TResult Function(_EmptyState<T> value)? empty,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class _EmptyState<T> extends LoadingState<T> {
  const factory _EmptyState() = _$EmptyStateImpl<T>;
  const _EmptyState._() : super._();
}
