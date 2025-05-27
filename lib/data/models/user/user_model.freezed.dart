// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get age => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  List<String> get photoUrls => throw _privateConstructorUsedError;
  List<String> get interests => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  bool get isVisible => throw _privateConstructorUsedError;
  bool get hasCompletedOnboarding => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastLogin => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    String id,
    String name,
    int age,
    String email,
    List<String> photoUrls,
    List<String> interests,
    String? bio,
    bool isVisible,
    bool hasCompletedOnboarding,
    DateTime? createdAt,
    DateTime? lastLogin,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? age = null,
    Object? email = null,
    Object? photoUrls = null,
    Object? interests = null,
    Object? bio = freezed,
    Object? isVisible = null,
    Object? hasCompletedOnboarding = null,
    Object? createdAt = freezed,
    Object? lastLogin = freezed,
  }) {
    return _then(
      _value.copyWith(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                as String,
        age: null == age
            ? _value.age
            : age // ignore: cast_nullable_to_non_nullable
                as int,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                as String,
        photoUrls: null == photoUrls
            ? _value.photoUrls
            : photoUrls // ignore: cast_nullable_to_non_nullable
                as List<String>,
        interests: null == interests
            ? _value.interests
            : interests // ignore: cast_nullable_to_non_nullable
                as List<String>,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                as String?,
        isVisible: null == isVisible
            ? _value.isVisible
            : isVisible // ignore: cast_nullable_to_non_nullable
                as bool,
        hasCompletedOnboarding: null == hasCompletedOnboarding
            ? _value.hasCompletedOnboarding
            : hasCompletedOnboarding // ignore: cast_nullable_to_non_nullable
                as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                as DateTime?,
        lastLogin: freezed == lastLogin
            ? _value.lastLogin
            : lastLogin // ignore: cast_nullable_to_non_nullable
                as DateTime?,
      ) as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    int age,
    String email,
    List<String> photoUrls,
    List<String> interests,
    String? bio,
    bool isVisible,
    bool hasCompletedOnboarding,
    DateTime? createdAt,
    DateTime? lastLogin,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? age = null,
    Object? email = null,
    Object? photoUrls = null,
    Object? interests = null,
    Object? bio = freezed,
    Object? isVisible = null,
    Object? hasCompletedOnboarding = null,
    Object? createdAt = freezed,
    Object? lastLogin = freezed,
  }) {
    return _then(
      _$UserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                as String,
        age: null == age
            ? _value.age
            : age // ignore: cast_nullable_to_non_nullable
                as int,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                as String,
        photoUrls: null == photoUrls
            ? _value._photoUrls
            : photoUrls // ignore: cast_nullable_to_non_nullable
                as List<String>,
        interests: null == interests
            ? _value._interests
            : interests // ignore: cast_nullable_to_non_nullable
                as List<String>,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                as String?,
        isVisible: null == isVisible
            ? _value.isVisible
            : isVisible // ignore: cast_nullable_to_non_nullable
                as bool,
        hasCompletedOnboarding: null == hasCompletedOnboarding
            ? _value.hasCompletedOnboarding
            : hasCompletedOnboarding // ignore: cast_nullable_to_non_nullable
                as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                as DateTime?,
        lastLogin: freezed == lastLogin
            ? _value.lastLogin
            : lastLogin // ignore: cast_nullable_to_non_nullable
                as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl({
    required this.id,
    required this.name,
    required this.age,
    required this.email,
    final List<String> photoUrls = const [],
    final List<String> interests = const [],
    this.bio,
    this.isVisible = true,
    this.hasCompletedOnboarding = false,
    this.createdAt,
    this.lastLogin,
  })  : _photoUrls = photoUrls,
        _interests = interests;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int age;
  @override
  final String email;
  final List<String> _photoUrls;
  @override
  @JsonKey()
  List<String> get photoUrls {
    if (_photoUrls is EqualUnmodifiableListView) return _photoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photoUrls);
  }

  final List<String> _interests;
  @override
  @JsonKey()
  List<String> get interests {
    if (_interests is EqualUnmodifiableListView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interests);
  }

  @override
  final String? bio;
  @override
  @JsonKey()
  final bool isVisible;
  @override
  @JsonKey()
  final bool hasCompletedOnboarding;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? lastLogin;

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, age: $age, email: $email, photoUrls: $photoUrls, interests: $interests, bio: $bio, isVisible: $isVisible, hasCompletedOnboarding: $hasCompletedOnboarding, createdAt: $createdAt, lastLogin: $lastLogin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.email, email) || other.email == email) &&
            const DeepCollectionEquality().equals(
              other._photoUrls,
              _photoUrls,
            ) &&
            const DeepCollectionEquality().equals(
              other._interests,
              _interests,
            ) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible) &&
            (identical(other.hasCompletedOnboarding, hasCompletedOnboarding) ||
                other.hasCompletedOnboarding == hasCompletedOnboarding) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastLogin, lastLogin) ||
                other.lastLogin == lastLogin));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
        runtimeType,
        id,
        name,
        age,
        email,
        const DeepCollectionEquality().hash(_photoUrls),
        const DeepCollectionEquality().hash(_interests),
        bio,
        isVisible,
        hasCompletedOnboarding,
        createdAt,
        lastLogin,
      );

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel({
    required final String id,
    required final String name,
    required final int age,
    required final String email,
    final List<String> photoUrls,
    final List<String> interests,
    final String? bio,
    final bool isVisible,
    final bool hasCompletedOnboarding,
    final DateTime? createdAt,
    final DateTime? lastLogin,
  }) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get age;
  @override
  String get email;
  @override
  List<String> get photoUrls;
  @override
  List<String> get interests;
  @override
  String? get bio;
  @override
  bool get isVisible;
  @override
  bool get hasCompletedOnboarding;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get lastLogin;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
