// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_applications_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MyApplicationsData {
  List<ApplicationEntity> get applications =>
      throw _privateConstructorUsedError;
  Map<String, PlanEntity?> get plansCache => throw _privateConstructorUsedError;
  String? get selectedFilter => throw _privateConstructorUsedError;
  bool get isRefreshing => throw _privateConstructorUsedError;

  /// Create a copy of MyApplicationsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MyApplicationsDataCopyWith<MyApplicationsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyApplicationsDataCopyWith<$Res> {
  factory $MyApplicationsDataCopyWith(
          MyApplicationsData value, $Res Function(MyApplicationsData) then) =
      _$MyApplicationsDataCopyWithImpl<$Res, MyApplicationsData>;
  @useResult
  $Res call(
      {List<ApplicationEntity> applications,
      Map<String, PlanEntity?> plansCache,
      String? selectedFilter,
      bool isRefreshing});
}

/// @nodoc
class _$MyApplicationsDataCopyWithImpl<$Res, $Val extends MyApplicationsData>
    implements $MyApplicationsDataCopyWith<$Res> {
  _$MyApplicationsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MyApplicationsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applications = null,
    Object? plansCache = null,
    Object? selectedFilter = freezed,
    Object? isRefreshing = null,
  }) {
    return _then(_value.copyWith(
      applications: null == applications
          ? _value.applications
          : applications // ignore: cast_nullable_to_non_nullable
              as List<ApplicationEntity>,
      plansCache: null == plansCache
          ? _value.plansCache
          : plansCache // ignore: cast_nullable_to_non_nullable
              as Map<String, PlanEntity?>,
      selectedFilter: freezed == selectedFilter
          ? _value.selectedFilter
          : selectedFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MyApplicationsDataImplCopyWith<$Res>
    implements $MyApplicationsDataCopyWith<$Res> {
  factory _$$MyApplicationsDataImplCopyWith(_$MyApplicationsDataImpl value,
          $Res Function(_$MyApplicationsDataImpl) then) =
      __$$MyApplicationsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ApplicationEntity> applications,
      Map<String, PlanEntity?> plansCache,
      String? selectedFilter,
      bool isRefreshing});
}

/// @nodoc
class __$$MyApplicationsDataImplCopyWithImpl<$Res>
    extends _$MyApplicationsDataCopyWithImpl<$Res, _$MyApplicationsDataImpl>
    implements _$$MyApplicationsDataImplCopyWith<$Res> {
  __$$MyApplicationsDataImplCopyWithImpl(_$MyApplicationsDataImpl _value,
      $Res Function(_$MyApplicationsDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of MyApplicationsData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applications = null,
    Object? plansCache = null,
    Object? selectedFilter = freezed,
    Object? isRefreshing = null,
  }) {
    return _then(_$MyApplicationsDataImpl(
      applications: null == applications
          ? _value._applications
          : applications // ignore: cast_nullable_to_non_nullable
              as List<ApplicationEntity>,
      plansCache: null == plansCache
          ? _value._plansCache
          : plansCache // ignore: cast_nullable_to_non_nullable
              as Map<String, PlanEntity?>,
      selectedFilter: freezed == selectedFilter
          ? _value.selectedFilter
          : selectedFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$MyApplicationsDataImpl
    with DiagnosticableTreeMixin
    implements _MyApplicationsData {
  const _$MyApplicationsDataImpl(
      {required final List<ApplicationEntity> applications,
      required final Map<String, PlanEntity?> plansCache,
      required this.selectedFilter,
      required this.isRefreshing})
      : _applications = applications,
        _plansCache = plansCache;

  final List<ApplicationEntity> _applications;
  @override
  List<ApplicationEntity> get applications {
    if (_applications is EqualUnmodifiableListView) return _applications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_applications);
  }

  final Map<String, PlanEntity?> _plansCache;
  @override
  Map<String, PlanEntity?> get plansCache {
    if (_plansCache is EqualUnmodifiableMapView) return _plansCache;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_plansCache);
  }

  @override
  final String? selectedFilter;
  @override
  final bool isRefreshing;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MyApplicationsData(applications: $applications, plansCache: $plansCache, selectedFilter: $selectedFilter, isRefreshing: $isRefreshing)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'MyApplicationsData'))
      ..add(DiagnosticsProperty('applications', applications))
      ..add(DiagnosticsProperty('plansCache', plansCache))
      ..add(DiagnosticsProperty('selectedFilter', selectedFilter))
      ..add(DiagnosticsProperty('isRefreshing', isRefreshing));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MyApplicationsDataImpl &&
            const DeepCollectionEquality()
                .equals(other._applications, _applications) &&
            const DeepCollectionEquality()
                .equals(other._plansCache, _plansCache) &&
            (identical(other.selectedFilter, selectedFilter) ||
                other.selectedFilter == selectedFilter) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_applications),
      const DeepCollectionEquality().hash(_plansCache),
      selectedFilter,
      isRefreshing);

  /// Create a copy of MyApplicationsData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MyApplicationsDataImplCopyWith<_$MyApplicationsDataImpl> get copyWith =>
      __$$MyApplicationsDataImplCopyWithImpl<_$MyApplicationsDataImpl>(
          this, _$identity);
}

abstract class _MyApplicationsData implements MyApplicationsData {
  const factory _MyApplicationsData(
      {required final List<ApplicationEntity> applications,
      required final Map<String, PlanEntity?> plansCache,
      required final String? selectedFilter,
      required final bool isRefreshing}) = _$MyApplicationsDataImpl;

  @override
  List<ApplicationEntity> get applications;
  @override
  Map<String, PlanEntity?> get plansCache;
  @override
  String? get selectedFilter;
  @override
  bool get isRefreshing;

  /// Create a copy of MyApplicationsData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MyApplicationsDataImplCopyWith<_$MyApplicationsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
