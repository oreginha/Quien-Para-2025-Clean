// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlanModel _$PlanModelFromJson(Map<String, dynamic> json) {
  return _PlanModel.fromJson(json);
}

/// @nodoc
mixin _$PlanModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get creatorId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get likes => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  Map<String, String> get conditions => throw _privateConstructorUsedError;
  List<String> get selectedThemes => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  bool get esVisible => throw _privateConstructorUsedError;

  /// Serializes this PlanModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlanModelCopyWith<PlanModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanModelCopyWith<$Res> {
  factory $PlanModelCopyWith(PlanModel value, $Res Function(PlanModel) then) =
      _$PlanModelCopyWithImpl<$Res, PlanModel>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String imageUrl,
    String creatorId,
    DateTime date,
    int likes,
    String category,
    String location,
    Map<String, String> conditions,
    List<String> selectedThemes,
    String? createdAt,
    bool esVisible,
  });
}

/// @nodoc
class _$PlanModelCopyWithImpl<$Res, $Val extends PlanModel>
    implements $PlanModelCopyWith<$Res> {
  _$PlanModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? creatorId = null,
    Object? date = null,
    Object? likes = null,
    Object? category = null,
    Object? location = null,
    Object? conditions = null,
    Object? selectedThemes = null,
    Object? createdAt = freezed,
    Object? esVisible = null,
  }) {
    return _then(
      _value.copyWith(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                as String,
        creatorId: null == creatorId
            ? _value.creatorId
            : creatorId // ignore: cast_nullable_to_non_nullable
                as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                as DateTime,
        likes: null == likes
            ? _value.likes
            : likes // ignore: cast_nullable_to_non_nullable
                as int,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                as String,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                as String,
        conditions: null == conditions
            ? _value.conditions
            : conditions // ignore: cast_nullable_to_non_nullable
                as Map<String, String>,
        selectedThemes: null == selectedThemes
            ? _value.selectedThemes
            : selectedThemes // ignore: cast_nullable_to_non_nullable
                as List<String>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                as String?,
        esVisible: null == esVisible
            ? _value.esVisible
            : esVisible // ignore: cast_nullable_to_non_nullable
                as bool,
      ) as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlanModelImplCopyWith<$Res>
    implements $PlanModelCopyWith<$Res> {
  factory _$$PlanModelImplCopyWith(
    _$PlanModelImpl value,
    $Res Function(_$PlanModelImpl) then,
  ) = __$$PlanModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    String imageUrl,
    String creatorId,
    DateTime date,
    int likes,
    String category,
    String location,
    Map<String, String> conditions,
    List<String> selectedThemes,
    String? createdAt,
    bool esVisible,
  });
}

/// @nodoc
class __$$PlanModelImplCopyWithImpl<$Res>
    extends _$PlanModelCopyWithImpl<$Res, _$PlanModelImpl>
    implements _$$PlanModelImplCopyWith<$Res> {
  __$$PlanModelImplCopyWithImpl(
    _$PlanModelImpl _value,
    $Res Function(_$PlanModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? creatorId = null,
    Object? date = null,
    Object? likes = null,
    Object? category = null,
    Object? location = null,
    Object? conditions = null,
    Object? selectedThemes = null,
    Object? createdAt = freezed,
    Object? esVisible = null,
  }) {
    return _then(
      _$PlanModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                as String,
        creatorId: null == creatorId
            ? _value.creatorId
            : creatorId // ignore: cast_nullable_to_non_nullable
                as String,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                as DateTime,
        likes: null == likes
            ? _value.likes
            : likes // ignore: cast_nullable_to_non_nullable
                as int,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                as String,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                as String,
        conditions: null == conditions
            ? _value._conditions
            : conditions // ignore: cast_nullable_to_non_nullable
                as Map<String, String>,
        selectedThemes: null == selectedThemes
            ? _value._selectedThemes
            : selectedThemes // ignore: cast_nullable_to_non_nullable
                as List<String>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                as String?,
        esVisible: null == esVisible
            ? _value.esVisible
            : esVisible // ignore: cast_nullable_to_non_nullable
                as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlanModelImpl extends _PlanModel {
  const _$PlanModelImpl({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl = '',
    required this.creatorId,
    required this.date,
    this.likes = 0,
    this.category = '',
    this.location = '',
    final Map<String, String> conditions = const {},
    final List<String> selectedThemes = const [],
    this.createdAt,
    this.esVisible = true,
  })  : _conditions = conditions,
        _selectedThemes = selectedThemes,
        super._();

  factory _$PlanModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlanModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  @JsonKey()
  final String imageUrl;
  @override
  final String creatorId;
  @override
  final DateTime date;
  @override
  @JsonKey()
  final int likes;
  @override
  @JsonKey()
  final String category;
  @override
  @JsonKey()
  final String location;
  final Map<String, String> _conditions;
  @override
  @JsonKey()
  Map<String, String> get conditions {
    if (_conditions is EqualUnmodifiableMapView) return _conditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_conditions);
  }

  final List<String> _selectedThemes;
  @override
  @JsonKey()
  List<String> get selectedThemes {
    if (_selectedThemes is EqualUnmodifiableListView) return _selectedThemes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedThemes);
  }

  @override
  final String? createdAt;
  @override
  @JsonKey()
  final bool esVisible;

  @override
  String toString() {
    return 'PlanModel(id: $id, title: $title, description: $description, imageUrl: $imageUrl, creatorId: $creatorId, date: $date, likes: $likes, category: $category, location: $location, conditions: $conditions, selectedThemes: $selectedThemes, createdAt: $createdAt, esVisible: $esVisible)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.likes, likes) || other.likes == likes) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(
              other._conditions,
              _conditions,
            ) &&
            const DeepCollectionEquality().equals(
              other._selectedThemes,
              _selectedThemes,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.esVisible, esVisible) ||
                other.esVisible == esVisible));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
        runtimeType,
        id,
        title,
        description,
        imageUrl,
        creatorId,
        date,
        likes,
        category,
        location,
        const DeepCollectionEquality().hash(_conditions),
        const DeepCollectionEquality().hash(_selectedThemes),
        createdAt,
        esVisible,
      );

  /// Create a copy of PlanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanModelImplCopyWith<_$PlanModelImpl> get copyWith =>
      __$$PlanModelImplCopyWithImpl<_$PlanModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlanModelImplToJson(this);
  }
}

abstract class _PlanModel extends PlanModel {
  const factory _PlanModel({
    required final String id,
    required final String title,
    required final String description,
    final String imageUrl,
    required final String creatorId,
    required final DateTime date,
    final int likes,
    final String category,
    final String location,
    final Map<String, String> conditions,
    final List<String> selectedThemes,
    final String? createdAt,
    final bool esVisible,
  }) = _$PlanModelImpl;
  const _PlanModel._() : super._();

  factory _PlanModel.fromJson(Map<String, dynamic> json) =
      _$PlanModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get imageUrl;
  @override
  String get creatorId;
  @override
  DateTime get date;
  @override
  int get likes;
  @override
  String get category;
  @override
  String get location;
  @override
  Map<String, String> get conditions;
  @override
  List<String> get selectedThemes;
  @override
  String? get createdAt;
  @override
  bool get esVisible;

  /// Create a copy of PlanModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlanModelImplCopyWith<_$PlanModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
