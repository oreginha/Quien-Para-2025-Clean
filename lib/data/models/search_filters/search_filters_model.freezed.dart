// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_filters_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SearchFiltersModel _$SearchFiltersModelFromJson(Map<String, dynamic> json) {
  return _SearchFiltersModel.fromJson(json);
}

/// @nodoc
mixin _$SearchFiltersModel {
  double get distanceValue => throw _privateConstructorUsedError;
  double get minDistance => throw _privateConstructorUsedError;
  double get maxDistance => throw _privateConstructorUsedError;
  Map<String, bool> get conditions => throw _privateConstructorUsedError;
  Map<String, bool> get additionalServices =>
      throw _privateConstructorUsedError;

  /// Serializes this SearchFiltersModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchFiltersModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchFiltersModelCopyWith<SearchFiltersModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchFiltersModelCopyWith<$Res> {
  factory $SearchFiltersModelCopyWith(
          SearchFiltersModel value, $Res Function(SearchFiltersModel) then) =
      _$SearchFiltersModelCopyWithImpl<$Res, SearchFiltersModel>;
  @useResult
  $Res call(
      {double distanceValue,
      double minDistance,
      double maxDistance,
      Map<String, bool> conditions,
      Map<String, bool> additionalServices});
}

/// @nodoc
class _$SearchFiltersModelCopyWithImpl<$Res, $Val extends SearchFiltersModel>
    implements $SearchFiltersModelCopyWith<$Res> {
  _$SearchFiltersModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchFiltersModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? distanceValue = null,
    Object? minDistance = null,
    Object? maxDistance = null,
    Object? conditions = null,
    Object? additionalServices = null,
  }) {
    return _then(_value.copyWith(
      distanceValue: null == distanceValue
          ? _value.distanceValue
          : distanceValue // ignore: cast_nullable_to_non_nullable
              as double,
      minDistance: null == minDistance
          ? _value.minDistance
          : minDistance // ignore: cast_nullable_to_non_nullable
              as double,
      maxDistance: null == maxDistance
          ? _value.maxDistance
          : maxDistance // ignore: cast_nullable_to_non_nullable
              as double,
      conditions: null == conditions
          ? _value.conditions
          : conditions // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      additionalServices: null == additionalServices
          ? _value.additionalServices
          : additionalServices // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchFiltersModelImplCopyWith<$Res>
    implements $SearchFiltersModelCopyWith<$Res> {
  factory _$$SearchFiltersModelImplCopyWith(_$SearchFiltersModelImpl value,
          $Res Function(_$SearchFiltersModelImpl) then) =
      __$$SearchFiltersModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double distanceValue,
      double minDistance,
      double maxDistance,
      Map<String, bool> conditions,
      Map<String, bool> additionalServices});
}

/// @nodoc
class __$$SearchFiltersModelImplCopyWithImpl<$Res>
    extends _$SearchFiltersModelCopyWithImpl<$Res, _$SearchFiltersModelImpl>
    implements _$$SearchFiltersModelImplCopyWith<$Res> {
  __$$SearchFiltersModelImplCopyWithImpl(_$SearchFiltersModelImpl _value,
      $Res Function(_$SearchFiltersModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchFiltersModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? distanceValue = null,
    Object? minDistance = null,
    Object? maxDistance = null,
    Object? conditions = null,
    Object? additionalServices = null,
  }) {
    return _then(_$SearchFiltersModelImpl(
      distanceValue: null == distanceValue
          ? _value.distanceValue
          : distanceValue // ignore: cast_nullable_to_non_nullable
              as double,
      minDistance: null == minDistance
          ? _value.minDistance
          : minDistance // ignore: cast_nullable_to_non_nullable
              as double,
      maxDistance: null == maxDistance
          ? _value.maxDistance
          : maxDistance // ignore: cast_nullable_to_non_nullable
              as double,
      conditions: null == conditions
          ? _value._conditions
          : conditions // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      additionalServices: null == additionalServices
          ? _value._additionalServices
          : additionalServices // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchFiltersModelImpl implements _SearchFiltersModel {
  _$SearchFiltersModelImpl(
      {required this.distanceValue,
      required this.minDistance,
      required this.maxDistance,
      required final Map<String, bool> conditions,
      required final Map<String, bool> additionalServices})
      : _conditions = conditions,
        _additionalServices = additionalServices;

  factory _$SearchFiltersModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchFiltersModelImplFromJson(json);

  @override
  final double distanceValue;
  @override
  final double minDistance;
  @override
  final double maxDistance;
  final Map<String, bool> _conditions;
  @override
  Map<String, bool> get conditions {
    if (_conditions is EqualUnmodifiableMapView) return _conditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_conditions);
  }

  final Map<String, bool> _additionalServices;
  @override
  Map<String, bool> get additionalServices {
    if (_additionalServices is EqualUnmodifiableMapView)
      return _additionalServices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_additionalServices);
  }

  @override
  String toString() {
    return 'SearchFiltersModel(distanceValue: $distanceValue, minDistance: $minDistance, maxDistance: $maxDistance, conditions: $conditions, additionalServices: $additionalServices)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchFiltersModelImpl &&
            (identical(other.distanceValue, distanceValue) ||
                other.distanceValue == distanceValue) &&
            (identical(other.minDistance, minDistance) ||
                other.minDistance == minDistance) &&
            (identical(other.maxDistance, maxDistance) ||
                other.maxDistance == maxDistance) &&
            const DeepCollectionEquality()
                .equals(other._conditions, _conditions) &&
            const DeepCollectionEquality()
                .equals(other._additionalServices, _additionalServices));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      distanceValue,
      minDistance,
      maxDistance,
      const DeepCollectionEquality().hash(_conditions),
      const DeepCollectionEquality().hash(_additionalServices));

  /// Create a copy of SearchFiltersModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchFiltersModelImplCopyWith<_$SearchFiltersModelImpl> get copyWith =>
      __$$SearchFiltersModelImplCopyWithImpl<_$SearchFiltersModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchFiltersModelImplToJson(
      this,
    );
  }
}

abstract class _SearchFiltersModel implements SearchFiltersModel {
  factory _SearchFiltersModel(
          {required final double distanceValue,
          required final double minDistance,
          required final double maxDistance,
          required final Map<String, bool> conditions,
          required final Map<String, bool> additionalServices}) =
      _$SearchFiltersModelImpl;

  factory _SearchFiltersModel.fromJson(Map<String, dynamic> json) =
      _$SearchFiltersModelImpl.fromJson;

  @override
  double get distanceValue;
  @override
  double get minDistance;
  @override
  double get maxDistance;
  @override
  Map<String, bool> get conditions;
  @override
  Map<String, bool> get additionalServices;

  /// Create a copy of SearchFiltersModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchFiltersModelImplCopyWith<_$SearchFiltersModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
