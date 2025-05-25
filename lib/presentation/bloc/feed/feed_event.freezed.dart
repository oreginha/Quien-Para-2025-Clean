// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FeedEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchPlans,
    required TResult Function() refreshPlans,
    required TResult Function() loadMorePlans,
    required TResult Function(String category) filterPlansByCategory,
    required TResult Function() clearFilters,
    required TResult Function(String planId) likePlan,
    required TResult Function(String planId) unlikePlan,
    required TResult Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)
        createPlan,
    required TResult Function(String planId) deletePlan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchPlans,
    TResult? Function()? refreshPlans,
    TResult? Function()? loadMorePlans,
    TResult? Function(String category)? filterPlansByCategory,
    TResult? Function()? clearFilters,
    TResult? Function(String planId)? likePlan,
    TResult? Function(String planId)? unlikePlan,
    TResult? Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)?
        createPlan,
    TResult? Function(String planId)? deletePlan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchPlans,
    TResult Function()? refreshPlans,
    TResult Function()? loadMorePlans,
    TResult Function(String category)? filterPlansByCategory,
    TResult Function()? clearFilters,
    TResult Function(String planId)? likePlan,
    TResult Function(String planId)? unlikePlan,
    TResult Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)?
        createPlan,
    TResult Function(String planId)? deletePlan,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchPlans value) fetchPlans,
    required TResult Function(RefreshPlans value) refreshPlans,
    required TResult Function(LoadMorePlans value) loadMorePlans,
    required TResult Function(FilterPlansByCategory value)
        filterPlansByCategory,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(LikePlan value) likePlan,
    required TResult Function(UnlikePlan value) unlikePlan,
    required TResult Function(CreatePlan value) createPlan,
    required TResult Function(DeletePlan value) deletePlan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchPlans value)? fetchPlans,
    TResult? Function(RefreshPlans value)? refreshPlans,
    TResult? Function(LoadMorePlans value)? loadMorePlans,
    TResult? Function(FilterPlansByCategory value)? filterPlansByCategory,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(LikePlan value)? likePlan,
    TResult? Function(UnlikePlan value)? unlikePlan,
    TResult? Function(CreatePlan value)? createPlan,
    TResult? Function(DeletePlan value)? deletePlan,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchPlans value)? fetchPlans,
    TResult Function(RefreshPlans value)? refreshPlans,
    TResult Function(LoadMorePlans value)? loadMorePlans,
    TResult Function(FilterPlansByCategory value)? filterPlansByCategory,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(LikePlan value)? likePlan,
    TResult Function(UnlikePlan value)? unlikePlan,
    TResult Function(CreatePlan value)? createPlan,
    TResult Function(DeletePlan value)? deletePlan,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedEventCopyWith<$Res> {
  factory $FeedEventCopyWith(FeedEvent value, $Res Function(FeedEvent) then) =
      _$FeedEventCopyWithImpl<$Res, FeedEvent>;
}

/// @nodoc
class _$FeedEventCopyWithImpl<$Res, $Val extends FeedEvent>
    implements $FeedEventCopyWith<$Res> {
  _$FeedEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$FetchPlansImplCopyWith<$Res> {
  factory _$$FetchPlansImplCopyWith(
          _$FetchPlansImpl value, $Res Function(_$FetchPlansImpl) then) =
      __$$FetchPlansImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FetchPlansImplCopyWithImpl<$Res>
    extends _$FeedEventCopyWithImpl<$Res, _$FetchPlansImpl>
    implements _$$FetchPlansImplCopyWith<$Res> {
  __$$FetchPlansImplCopyWithImpl(
      _$FetchPlansImpl _value, $Res Function(_$FetchPlansImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FetchPlansImpl extends FetchPlans {
  const _$FetchPlansImpl() : super._();

  @override
  String toString() {
    return 'FeedEvent.fetchPlans()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FetchPlansImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchPlans,
    required TResult Function() refreshPlans,
    required TResult Function() loadMorePlans,
    required TResult Function(String category) filterPlansByCategory,
    required TResult Function() clearFilters,
    required TResult Function(String planId) likePlan,
    required TResult Function(String planId) unlikePlan,
    required TResult Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)
        createPlan,
    required TResult Function(String planId) deletePlan,
  }) {
    return fetchPlans();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchPlans,
    TResult? Function()? refreshPlans,
    TResult? Function()? loadMorePlans,
    TResult? Function(String category)? filterPlansByCategory,
    TResult? Function()? clearFilters,
    TResult? Function(String planId)? likePlan,
    TResult? Function(String planId)? unlikePlan,
    TResult? Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)?
        createPlan,
    TResult? Function(String planId)? deletePlan,
  }) {
    return fetchPlans?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchPlans,
    TResult Function()? refreshPlans,
    TResult Function()? loadMorePlans,
    TResult Function(String category)? filterPlansByCategory,
    TResult Function()? clearFilters,
    TResult Function(String planId)? likePlan,
    TResult Function(String planId)? unlikePlan,
    TResult Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)?
        createPlan,
    TResult Function(String planId)? deletePlan,
    required TResult orElse(),
  }) {
    if (fetchPlans != null) {
      return fetchPlans();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchPlans value) fetchPlans,
    required TResult Function(RefreshPlans value) refreshPlans,
    required TResult Function(LoadMorePlans value) loadMorePlans,
    required TResult Function(FilterPlansByCategory value)
        filterPlansByCategory,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(LikePlan value) likePlan,
    required TResult Function(UnlikePlan value) unlikePlan,
    required TResult Function(CreatePlan value) createPlan,
    required TResult Function(DeletePlan value) deletePlan,
  }) {
    return fetchPlans(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchPlans value)? fetchPlans,
    TResult? Function(RefreshPlans value)? refreshPlans,
    TResult? Function(LoadMorePlans value)? loadMorePlans,
    TResult? Function(FilterPlansByCategory value)? filterPlansByCategory,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(LikePlan value)? likePlan,
    TResult? Function(UnlikePlan value)? unlikePlan,
    TResult? Function(CreatePlan value)? createPlan,
    TResult? Function(DeletePlan value)? deletePlan,
  }) {
    return fetchPlans?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchPlans value)? fetchPlans,
    TResult Function(RefreshPlans value)? refreshPlans,
    TResult Function(LoadMorePlans value)? loadMorePlans,
    TResult Function(FilterPlansByCategory value)? filterPlansByCategory,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(LikePlan value)? likePlan,
    TResult Function(UnlikePlan value)? unlikePlan,
    TResult Function(CreatePlan value)? createPlan,
    TResult Function(DeletePlan value)? deletePlan,
    required TResult orElse(),
  }) {
    if (fetchPlans != null) {
      return fetchPlans(this);
    }
    return orElse();
  }
}

abstract class FetchPlans extends FeedEvent {
  const factory FetchPlans() = _$FetchPlansImpl;
  const FetchPlans._() : super._();
}

/// @nodoc
abstract class _$$RefreshPlansImplCopyWith<$Res> {
  factory _$$RefreshPlansImplCopyWith(
          _$RefreshPlansImpl value, $Res Function(_$RefreshPlansImpl) then) =
      __$$RefreshPlansImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RefreshPlansImplCopyWithImpl<$Res>
    extends _$FeedEventCopyWithImpl<$Res, _$RefreshPlansImpl>
    implements _$$RefreshPlansImplCopyWith<$Res> {
  __$$RefreshPlansImplCopyWithImpl(
      _$RefreshPlansImpl _value, $Res Function(_$RefreshPlansImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RefreshPlansImpl extends RefreshPlans {
  const _$RefreshPlansImpl() : super._();

  @override
  String toString() {
    return 'FeedEvent.refreshPlans()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RefreshPlansImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchPlans,
    required TResult Function() refreshPlans,
    required TResult Function() loadMorePlans,
    required TResult Function(String category) filterPlansByCategory,
    required TResult Function() clearFilters,
    required TResult Function(String planId) likePlan,
    required TResult Function(String planId) unlikePlan,
    required TResult Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)
        createPlan,
    required TResult Function(String planId) deletePlan,
  }) {
    return refreshPlans();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchPlans,
    TResult? Function()? refreshPlans,
    TResult? Function()? loadMorePlans,
    TResult? Function(String category)? filterPlansByCategory,
    TResult? Function()? clearFilters,
    TResult? Function(String planId)? likePlan,
    TResult? Function(String planId)? unlikePlan,
    TResult? Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)?
        createPlan,
    TResult? Function(String planId)? deletePlan,
  }) {
    return refreshPlans?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchPlans,
    TResult Function()? refreshPlans,
    TResult Function()? loadMorePlans,
    TResult Function(String category)? filterPlansByCategory,
    TResult Function()? clearFilters,
    TResult Function(String planId)? likePlan,
    TResult Function(String planId)? unlikePlan,
    TResult Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)?
        createPlan,
    TResult Function(String planId)? deletePlan,
    required TResult orElse(),
  }) {
    if (refreshPlans != null) {
      return refreshPlans();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchPlans value) fetchPlans,
    required TResult Function(RefreshPlans value) refreshPlans,
    required TResult Function(LoadMorePlans value) loadMorePlans,
    required TResult Function(FilterPlansByCategory value)
        filterPlansByCategory,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(LikePlan value) likePlan,
    required TResult Function(UnlikePlan value) unlikePlan,
    required TResult Function(CreatePlan value) createPlan,
    required TResult Function(DeletePlan value) deletePlan,
  }) {
    return refreshPlans(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchPlans value)? fetchPlans,
    TResult? Function(RefreshPlans value)? refreshPlans,
    TResult? Function(LoadMorePlans value)? loadMorePlans,
    TResult? Function(FilterPlansByCategory value)? filterPlansByCategory,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(LikePlan value)? likePlan,
    TResult? Function(UnlikePlan value)? unlikePlan,
    TResult? Function(CreatePlan value)? createPlan,
    TResult? Function(DeletePlan value)? deletePlan,
  }) {
    return refreshPlans?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchPlans value)? fetchPlans,
    TResult Function(RefreshPlans value)? refreshPlans,
    TResult Function(LoadMorePlans value)? loadMorePlans,
    TResult Function(FilterPlansByCategory value)? filterPlansByCategory,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(LikePlan value)? likePlan,
    TResult Function(UnlikePlan value)? unlikePlan,
    TResult Function(CreatePlan value)? createPlan,
    TResult Function(DeletePlan value)? deletePlan,
    required TResult orElse(),
  }) {
    if (refreshPlans != null) {
      return refreshPlans(this);
    }
    return orElse();
  }
}

abstract class RefreshPlans extends FeedEvent {
  const factory RefreshPlans() = _$RefreshPlansImpl;
  const RefreshPlans._() : super._();
}

/// @nodoc
abstract class _$$LoadMorePlansImplCopyWith<$Res> {
  factory _$$LoadMorePlansImplCopyWith(
          _$LoadMorePlansImpl value, $Res Function(_$LoadMorePlansImpl) then) =
      __$$LoadMorePlansImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadMorePlansImplCopyWithImpl<$Res>
    extends _$FeedEventCopyWithImpl<$Res, _$LoadMorePlansImpl>
    implements _$$LoadMorePlansImplCopyWith<$Res> {
  __$$LoadMorePlansImplCopyWithImpl(
      _$LoadMorePlansImpl _value, $Res Function(_$LoadMorePlansImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadMorePlansImpl extends LoadMorePlans {
  const _$LoadMorePlansImpl() : super._();

  @override
  String toString() {
    return 'FeedEvent.loadMorePlans()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadMorePlansImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchPlans,
    required TResult Function() refreshPlans,
    required TResult Function() loadMorePlans,
    required TResult Function(String category) filterPlansByCategory,
    required TResult Function() clearFilters,
    required TResult Function(String planId) likePlan,
    required TResult Function(String planId) unlikePlan,
    required TResult Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)
        createPlan,
    required TResult Function(String planId) deletePlan,
  }) {
    return loadMorePlans();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchPlans,
    TResult? Function()? refreshPlans,
    TResult? Function()? loadMorePlans,
    TResult? Function(String category)? filterPlansByCategory,
    TResult? Function()? clearFilters,
    TResult? Function(String planId)? likePlan,
    TResult? Function(String planId)? unlikePlan,
    TResult? Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)?
        createPlan,
    TResult? Function(String planId)? deletePlan,
  }) {
    return loadMorePlans?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchPlans,
    TResult Function()? refreshPlans,
    TResult Function()? loadMorePlans,
    TResult Function(String category)? filterPlansByCategory,
    TResult Function()? clearFilters,
    TResult Function(String planId)? likePlan,
    TResult Function(String planId)? unlikePlan,
    TResult Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)?
        createPlan,
    TResult Function(String planId)? deletePlan,
    required TResult orElse(),
  }) {
    if (loadMorePlans != null) {
      return loadMorePlans();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchPlans value) fetchPlans,
    required TResult Function(RefreshPlans value) refreshPlans,
    required TResult Function(LoadMorePlans value) loadMorePlans,
    required TResult Function(FilterPlansByCategory value)
        filterPlansByCategory,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(LikePlan value) likePlan,
    required TResult Function(UnlikePlan value) unlikePlan,
    required TResult Function(CreatePlan value) createPlan,
    required TResult Function(DeletePlan value) deletePlan,
  }) {
    return loadMorePlans(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchPlans value)? fetchPlans,
    TResult? Function(RefreshPlans value)? refreshPlans,
    TResult? Function(LoadMorePlans value)? loadMorePlans,
    TResult? Function(FilterPlansByCategory value)? filterPlansByCategory,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(LikePlan value)? likePlan,
    TResult? Function(UnlikePlan value)? unlikePlan,
    TResult? Function(CreatePlan value)? createPlan,
    TResult? Function(DeletePlan value)? deletePlan,
  }) {
    return loadMorePlans?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchPlans value)? fetchPlans,
    TResult Function(RefreshPlans value)? refreshPlans,
    TResult Function(LoadMorePlans value)? loadMorePlans,
    TResult Function(FilterPlansByCategory value)? filterPlansByCategory,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(LikePlan value)? likePlan,
    TResult Function(UnlikePlan value)? unlikePlan,
    TResult Function(CreatePlan value)? createPlan,
    TResult Function(DeletePlan value)? deletePlan,
    required TResult orElse(),
  }) {
    if (loadMorePlans != null) {
      return loadMorePlans(this);
    }
    return orElse();
  }
}

abstract class LoadMorePlans extends FeedEvent {
  const factory LoadMorePlans() = _$LoadMorePlansImpl;
  const LoadMorePlans._() : super._();
}

/// @nodoc
abstract class _$$FilterPlansByCategoryImplCopyWith<$Res> {
  factory _$$FilterPlansByCategoryImplCopyWith(
          _$FilterPlansByCategoryImpl value,
          $Res Function(_$FilterPlansByCategoryImpl) then) =
      __$$FilterPlansByCategoryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String category});
}

/// @nodoc
class __$$FilterPlansByCategoryImplCopyWithImpl<$Res>
    extends _$FeedEventCopyWithImpl<$Res, _$FilterPlansByCategoryImpl>
    implements _$$FilterPlansByCategoryImplCopyWith<$Res> {
  __$$FilterPlansByCategoryImplCopyWithImpl(_$FilterPlansByCategoryImpl _value,
      $Res Function(_$FilterPlansByCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
  }) {
    return _then(_$FilterPlansByCategoryImpl(
      null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FilterPlansByCategoryImpl extends FilterPlansByCategory {
  const _$FilterPlansByCategoryImpl(this.category) : super._();

  @override
  final String category;

  @override
  String toString() {
    return 'FeedEvent.filterPlansByCategory(category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterPlansByCategoryImpl &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @override
  int get hashCode => Object.hash(runtimeType, category);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterPlansByCategoryImplCopyWith<_$FilterPlansByCategoryImpl>
      get copyWith => __$$FilterPlansByCategoryImplCopyWithImpl<
          _$FilterPlansByCategoryImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchPlans,
    required TResult Function() refreshPlans,
    required TResult Function() loadMorePlans,
    required TResult Function(String category) filterPlansByCategory,
    required TResult Function() clearFilters,
    required TResult Function(String planId) likePlan,
    required TResult Function(String planId) unlikePlan,
    required TResult Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)
        createPlan,
    required TResult Function(String planId) deletePlan,
  }) {
    return filterPlansByCategory(category);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchPlans,
    TResult? Function()? refreshPlans,
    TResult? Function()? loadMorePlans,
    TResult? Function(String category)? filterPlansByCategory,
    TResult? Function()? clearFilters,
    TResult? Function(String planId)? likePlan,
    TResult? Function(String planId)? unlikePlan,
    TResult? Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)?
        createPlan,
    TResult? Function(String planId)? deletePlan,
  }) {
    return filterPlansByCategory?.call(category);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchPlans,
    TResult Function()? refreshPlans,
    TResult Function()? loadMorePlans,
    TResult Function(String category)? filterPlansByCategory,
    TResult Function()? clearFilters,
    TResult Function(String planId)? likePlan,
    TResult Function(String planId)? unlikePlan,
    TResult Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)?
        createPlan,
    TResult Function(String planId)? deletePlan,
    required TResult orElse(),
  }) {
    if (filterPlansByCategory != null) {
      return filterPlansByCategory(category);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchPlans value) fetchPlans,
    required TResult Function(RefreshPlans value) refreshPlans,
    required TResult Function(LoadMorePlans value) loadMorePlans,
    required TResult Function(FilterPlansByCategory value)
        filterPlansByCategory,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(LikePlan value) likePlan,
    required TResult Function(UnlikePlan value) unlikePlan,
    required TResult Function(CreatePlan value) createPlan,
    required TResult Function(DeletePlan value) deletePlan,
  }) {
    return filterPlansByCategory(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchPlans value)? fetchPlans,
    TResult? Function(RefreshPlans value)? refreshPlans,
    TResult? Function(LoadMorePlans value)? loadMorePlans,
    TResult? Function(FilterPlansByCategory value)? filterPlansByCategory,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(LikePlan value)? likePlan,
    TResult? Function(UnlikePlan value)? unlikePlan,
    TResult? Function(CreatePlan value)? createPlan,
    TResult? Function(DeletePlan value)? deletePlan,
  }) {
    return filterPlansByCategory?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchPlans value)? fetchPlans,
    TResult Function(RefreshPlans value)? refreshPlans,
    TResult Function(LoadMorePlans value)? loadMorePlans,
    TResult Function(FilterPlansByCategory value)? filterPlansByCategory,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(LikePlan value)? likePlan,
    TResult Function(UnlikePlan value)? unlikePlan,
    TResult Function(CreatePlan value)? createPlan,
    TResult Function(DeletePlan value)? deletePlan,
    required TResult orElse(),
  }) {
    if (filterPlansByCategory != null) {
      return filterPlansByCategory(this);
    }
    return orElse();
  }
}

abstract class FilterPlansByCategory extends FeedEvent {
  const factory FilterPlansByCategory(final String category) =
      _$FilterPlansByCategoryImpl;
  const FilterPlansByCategory._() : super._();

  String get category;

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FilterPlansByCategoryImplCopyWith<_$FilterPlansByCategoryImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ClearFiltersImplCopyWith<$Res> {
  factory _$$ClearFiltersImplCopyWith(
          _$ClearFiltersImpl value, $Res Function(_$ClearFiltersImpl) then) =
      __$$ClearFiltersImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearFiltersImplCopyWithImpl<$Res>
    extends _$FeedEventCopyWithImpl<$Res, _$ClearFiltersImpl>
    implements _$$ClearFiltersImplCopyWith<$Res> {
  __$$ClearFiltersImplCopyWithImpl(
      _$ClearFiltersImpl _value, $Res Function(_$ClearFiltersImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ClearFiltersImpl extends ClearFilters {
  const _$ClearFiltersImpl() : super._();

  @override
  String toString() {
    return 'FeedEvent.clearFilters()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClearFiltersImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchPlans,
    required TResult Function() refreshPlans,
    required TResult Function() loadMorePlans,
    required TResult Function(String category) filterPlansByCategory,
    required TResult Function() clearFilters,
    required TResult Function(String planId) likePlan,
    required TResult Function(String planId) unlikePlan,
    required TResult Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)
        createPlan,
    required TResult Function(String planId) deletePlan,
  }) {
    return clearFilters();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchPlans,
    TResult? Function()? refreshPlans,
    TResult? Function()? loadMorePlans,
    TResult? Function(String category)? filterPlansByCategory,
    TResult? Function()? clearFilters,
    TResult? Function(String planId)? likePlan,
    TResult? Function(String planId)? unlikePlan,
    TResult? Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)?
        createPlan,
    TResult? Function(String planId)? deletePlan,
  }) {
    return clearFilters?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchPlans,
    TResult Function()? refreshPlans,
    TResult Function()? loadMorePlans,
    TResult Function(String category)? filterPlansByCategory,
    TResult Function()? clearFilters,
    TResult Function(String planId)? likePlan,
    TResult Function(String planId)? unlikePlan,
    TResult Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)?
        createPlan,
    TResult Function(String planId)? deletePlan,
    required TResult orElse(),
  }) {
    if (clearFilters != null) {
      return clearFilters();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchPlans value) fetchPlans,
    required TResult Function(RefreshPlans value) refreshPlans,
    required TResult Function(LoadMorePlans value) loadMorePlans,
    required TResult Function(FilterPlansByCategory value)
        filterPlansByCategory,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(LikePlan value) likePlan,
    required TResult Function(UnlikePlan value) unlikePlan,
    required TResult Function(CreatePlan value) createPlan,
    required TResult Function(DeletePlan value) deletePlan,
  }) {
    return clearFilters(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchPlans value)? fetchPlans,
    TResult? Function(RefreshPlans value)? refreshPlans,
    TResult? Function(LoadMorePlans value)? loadMorePlans,
    TResult? Function(FilterPlansByCategory value)? filterPlansByCategory,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(LikePlan value)? likePlan,
    TResult? Function(UnlikePlan value)? unlikePlan,
    TResult? Function(CreatePlan value)? createPlan,
    TResult? Function(DeletePlan value)? deletePlan,
  }) {
    return clearFilters?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchPlans value)? fetchPlans,
    TResult Function(RefreshPlans value)? refreshPlans,
    TResult Function(LoadMorePlans value)? loadMorePlans,
    TResult Function(FilterPlansByCategory value)? filterPlansByCategory,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(LikePlan value)? likePlan,
    TResult Function(UnlikePlan value)? unlikePlan,
    TResult Function(CreatePlan value)? createPlan,
    TResult Function(DeletePlan value)? deletePlan,
    required TResult orElse(),
  }) {
    if (clearFilters != null) {
      return clearFilters(this);
    }
    return orElse();
  }
}

abstract class ClearFilters extends FeedEvent {
  const factory ClearFilters() = _$ClearFiltersImpl;
  const ClearFilters._() : super._();
}

/// @nodoc
abstract class _$$LikePlanImplCopyWith<$Res> {
  factory _$$LikePlanImplCopyWith(
          _$LikePlanImpl value, $Res Function(_$LikePlanImpl) then) =
      __$$LikePlanImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String planId});
}

/// @nodoc
class __$$LikePlanImplCopyWithImpl<$Res>
    extends _$FeedEventCopyWithImpl<$Res, _$LikePlanImpl>
    implements _$$LikePlanImplCopyWith<$Res> {
  __$$LikePlanImplCopyWithImpl(
      _$LikePlanImpl _value, $Res Function(_$LikePlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? planId = null,
  }) {
    return _then(_$LikePlanImpl(
      null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LikePlanImpl extends LikePlan {
  const _$LikePlanImpl(this.planId) : super._();

  @override
  final String planId;

  @override
  String toString() {
    return 'FeedEvent.likePlan(planId: $planId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LikePlanImpl &&
            (identical(other.planId, planId) || other.planId == planId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, planId);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LikePlanImplCopyWith<_$LikePlanImpl> get copyWith =>
      __$$LikePlanImplCopyWithImpl<_$LikePlanImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchPlans,
    required TResult Function() refreshPlans,
    required TResult Function() loadMorePlans,
    required TResult Function(String category) filterPlansByCategory,
    required TResult Function() clearFilters,
    required TResult Function(String planId) likePlan,
    required TResult Function(String planId) unlikePlan,
    required TResult Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)
        createPlan,
    required TResult Function(String planId) deletePlan,
  }) {
    return likePlan(planId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchPlans,
    TResult? Function()? refreshPlans,
    TResult? Function()? loadMorePlans,
    TResult? Function(String category)? filterPlansByCategory,
    TResult? Function()? clearFilters,
    TResult? Function(String planId)? likePlan,
    TResult? Function(String planId)? unlikePlan,
    TResult? Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)?
        createPlan,
    TResult? Function(String planId)? deletePlan,
  }) {
    return likePlan?.call(planId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchPlans,
    TResult Function()? refreshPlans,
    TResult Function()? loadMorePlans,
    TResult Function(String category)? filterPlansByCategory,
    TResult Function()? clearFilters,
    TResult Function(String planId)? likePlan,
    TResult Function(String planId)? unlikePlan,
    TResult Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)?
        createPlan,
    TResult Function(String planId)? deletePlan,
    required TResult orElse(),
  }) {
    if (likePlan != null) {
      return likePlan(planId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchPlans value) fetchPlans,
    required TResult Function(RefreshPlans value) refreshPlans,
    required TResult Function(LoadMorePlans value) loadMorePlans,
    required TResult Function(FilterPlansByCategory value)
        filterPlansByCategory,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(LikePlan value) likePlan,
    required TResult Function(UnlikePlan value) unlikePlan,
    required TResult Function(CreatePlan value) createPlan,
    required TResult Function(DeletePlan value) deletePlan,
  }) {
    return likePlan(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchPlans value)? fetchPlans,
    TResult? Function(RefreshPlans value)? refreshPlans,
    TResult? Function(LoadMorePlans value)? loadMorePlans,
    TResult? Function(FilterPlansByCategory value)? filterPlansByCategory,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(LikePlan value)? likePlan,
    TResult? Function(UnlikePlan value)? unlikePlan,
    TResult? Function(CreatePlan value)? createPlan,
    TResult? Function(DeletePlan value)? deletePlan,
  }) {
    return likePlan?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchPlans value)? fetchPlans,
    TResult Function(RefreshPlans value)? refreshPlans,
    TResult Function(LoadMorePlans value)? loadMorePlans,
    TResult Function(FilterPlansByCategory value)? filterPlansByCategory,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(LikePlan value)? likePlan,
    TResult Function(UnlikePlan value)? unlikePlan,
    TResult Function(CreatePlan value)? createPlan,
    TResult Function(DeletePlan value)? deletePlan,
    required TResult orElse(),
  }) {
    if (likePlan != null) {
      return likePlan(this);
    }
    return orElse();
  }
}

abstract class LikePlan extends FeedEvent {
  const factory LikePlan(final String planId) = _$LikePlanImpl;
  const LikePlan._() : super._();

  String get planId;

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LikePlanImplCopyWith<_$LikePlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnlikePlanImplCopyWith<$Res> {
  factory _$$UnlikePlanImplCopyWith(
          _$UnlikePlanImpl value, $Res Function(_$UnlikePlanImpl) then) =
      __$$UnlikePlanImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String planId});
}

/// @nodoc
class __$$UnlikePlanImplCopyWithImpl<$Res>
    extends _$FeedEventCopyWithImpl<$Res, _$UnlikePlanImpl>
    implements _$$UnlikePlanImplCopyWith<$Res> {
  __$$UnlikePlanImplCopyWithImpl(
      _$UnlikePlanImpl _value, $Res Function(_$UnlikePlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? planId = null,
  }) {
    return _then(_$UnlikePlanImpl(
      null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$UnlikePlanImpl extends UnlikePlan {
  const _$UnlikePlanImpl(this.planId) : super._();

  @override
  final String planId;

  @override
  String toString() {
    return 'FeedEvent.unlikePlan(planId: $planId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnlikePlanImpl &&
            (identical(other.planId, planId) || other.planId == planId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, planId);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnlikePlanImplCopyWith<_$UnlikePlanImpl> get copyWith =>
      __$$UnlikePlanImplCopyWithImpl<_$UnlikePlanImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchPlans,
    required TResult Function() refreshPlans,
    required TResult Function() loadMorePlans,
    required TResult Function(String category) filterPlansByCategory,
    required TResult Function() clearFilters,
    required TResult Function(String planId) likePlan,
    required TResult Function(String planId) unlikePlan,
    required TResult Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)
        createPlan,
    required TResult Function(String planId) deletePlan,
  }) {
    return unlikePlan(planId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchPlans,
    TResult? Function()? refreshPlans,
    TResult? Function()? loadMorePlans,
    TResult? Function(String category)? filterPlansByCategory,
    TResult? Function()? clearFilters,
    TResult? Function(String planId)? likePlan,
    TResult? Function(String planId)? unlikePlan,
    TResult? Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)?
        createPlan,
    TResult? Function(String planId)? deletePlan,
  }) {
    return unlikePlan?.call(planId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchPlans,
    TResult Function()? refreshPlans,
    TResult Function()? loadMorePlans,
    TResult Function(String category)? filterPlansByCategory,
    TResult Function()? clearFilters,
    TResult Function(String planId)? likePlan,
    TResult Function(String planId)? unlikePlan,
    TResult Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)?
        createPlan,
    TResult Function(String planId)? deletePlan,
    required TResult orElse(),
  }) {
    if (unlikePlan != null) {
      return unlikePlan(planId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchPlans value) fetchPlans,
    required TResult Function(RefreshPlans value) refreshPlans,
    required TResult Function(LoadMorePlans value) loadMorePlans,
    required TResult Function(FilterPlansByCategory value)
        filterPlansByCategory,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(LikePlan value) likePlan,
    required TResult Function(UnlikePlan value) unlikePlan,
    required TResult Function(CreatePlan value) createPlan,
    required TResult Function(DeletePlan value) deletePlan,
  }) {
    return unlikePlan(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchPlans value)? fetchPlans,
    TResult? Function(RefreshPlans value)? refreshPlans,
    TResult? Function(LoadMorePlans value)? loadMorePlans,
    TResult? Function(FilterPlansByCategory value)? filterPlansByCategory,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(LikePlan value)? likePlan,
    TResult? Function(UnlikePlan value)? unlikePlan,
    TResult? Function(CreatePlan value)? createPlan,
    TResult? Function(DeletePlan value)? deletePlan,
  }) {
    return unlikePlan?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchPlans value)? fetchPlans,
    TResult Function(RefreshPlans value)? refreshPlans,
    TResult Function(LoadMorePlans value)? loadMorePlans,
    TResult Function(FilterPlansByCategory value)? filterPlansByCategory,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(LikePlan value)? likePlan,
    TResult Function(UnlikePlan value)? unlikePlan,
    TResult Function(CreatePlan value)? createPlan,
    TResult Function(DeletePlan value)? deletePlan,
    required TResult orElse(),
  }) {
    if (unlikePlan != null) {
      return unlikePlan(this);
    }
    return orElse();
  }
}

abstract class UnlikePlan extends FeedEvent {
  const factory UnlikePlan(final String planId) = _$UnlikePlanImpl;
  const UnlikePlan._() : super._();

  String get planId;

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnlikePlanImplCopyWith<_$UnlikePlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CreatePlanImplCopyWith<$Res> {
  factory _$$CreatePlanImplCopyWith(
          _$CreatePlanImpl value, $Res Function(_$CreatePlanImpl) then) =
      __$$CreatePlanImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String title,
      String description,
      String imageUrl,
      String category,
      String location,
      DateTime? date,
      Map<String, String> conditions,
      List<String> selectedThemes});
}

/// @nodoc
class __$$CreatePlanImplCopyWithImpl<$Res>
    extends _$FeedEventCopyWithImpl<$Res, _$CreatePlanImpl>
    implements _$$CreatePlanImplCopyWith<$Res> {
  __$$CreatePlanImplCopyWithImpl(
      _$CreatePlanImpl _value, $Res Function(_$CreatePlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? category = null,
    Object? location = null,
    Object? date = freezed,
    Object? conditions = null,
    Object? selectedThemes = null,
  }) {
    return _then(_$CreatePlanImpl(
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
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      conditions: null == conditions
          ? _value._conditions
          : conditions // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      selectedThemes: null == selectedThemes
          ? _value._selectedThemes
          : selectedThemes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$CreatePlanImpl extends CreatePlan {
  const _$CreatePlanImpl(
      {required this.title,
      required this.description,
      required this.imageUrl,
      required this.category,
      required this.location,
      this.date,
      required final Map<String, String> conditions,
      required final List<String> selectedThemes})
      : _conditions = conditions,
        _selectedThemes = selectedThemes,
        super._();

  @override
  final String title;
  @override
  final String description;
  @override
  final String imageUrl;
  @override
  final String category;
  @override
  final String location;
  @override
  final DateTime? date;
  final Map<String, String> _conditions;
  @override
  Map<String, String> get conditions {
    if (_conditions is EqualUnmodifiableMapView) return _conditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_conditions);
  }

  final List<String> _selectedThemes;
  @override
  List<String> get selectedThemes {
    if (_selectedThemes is EqualUnmodifiableListView) return _selectedThemes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedThemes);
  }

  @override
  String toString() {
    return 'FeedEvent.createPlan(title: $title, description: $description, imageUrl: $imageUrl, category: $category, location: $location, date: $date, conditions: $conditions, selectedThemes: $selectedThemes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePlanImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality()
                .equals(other._conditions, _conditions) &&
            const DeepCollectionEquality()
                .equals(other._selectedThemes, _selectedThemes));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      description,
      imageUrl,
      category,
      location,
      date,
      const DeepCollectionEquality().hash(_conditions),
      const DeepCollectionEquality().hash(_selectedThemes));

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePlanImplCopyWith<_$CreatePlanImpl> get copyWith =>
      __$$CreatePlanImplCopyWithImpl<_$CreatePlanImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchPlans,
    required TResult Function() refreshPlans,
    required TResult Function() loadMorePlans,
    required TResult Function(String category) filterPlansByCategory,
    required TResult Function() clearFilters,
    required TResult Function(String planId) likePlan,
    required TResult Function(String planId) unlikePlan,
    required TResult Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)
        createPlan,
    required TResult Function(String planId) deletePlan,
  }) {
    return createPlan(title, description, imageUrl, category, location, date,
        conditions, selectedThemes);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchPlans,
    TResult? Function()? refreshPlans,
    TResult? Function()? loadMorePlans,
    TResult? Function(String category)? filterPlansByCategory,
    TResult? Function()? clearFilters,
    TResult? Function(String planId)? likePlan,
    TResult? Function(String planId)? unlikePlan,
    TResult? Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)?
        createPlan,
    TResult? Function(String planId)? deletePlan,
  }) {
    return createPlan?.call(title, description, imageUrl, category, location,
        date, conditions, selectedThemes);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchPlans,
    TResult Function()? refreshPlans,
    TResult Function()? loadMorePlans,
    TResult Function(String category)? filterPlansByCategory,
    TResult Function()? clearFilters,
    TResult Function(String planId)? likePlan,
    TResult Function(String planId)? unlikePlan,
    TResult Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)?
        createPlan,
    TResult Function(String planId)? deletePlan,
    required TResult orElse(),
  }) {
    if (createPlan != null) {
      return createPlan(title, description, imageUrl, category, location, date,
          conditions, selectedThemes);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchPlans value) fetchPlans,
    required TResult Function(RefreshPlans value) refreshPlans,
    required TResult Function(LoadMorePlans value) loadMorePlans,
    required TResult Function(FilterPlansByCategory value)
        filterPlansByCategory,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(LikePlan value) likePlan,
    required TResult Function(UnlikePlan value) unlikePlan,
    required TResult Function(CreatePlan value) createPlan,
    required TResult Function(DeletePlan value) deletePlan,
  }) {
    return createPlan(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchPlans value)? fetchPlans,
    TResult? Function(RefreshPlans value)? refreshPlans,
    TResult? Function(LoadMorePlans value)? loadMorePlans,
    TResult? Function(FilterPlansByCategory value)? filterPlansByCategory,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(LikePlan value)? likePlan,
    TResult? Function(UnlikePlan value)? unlikePlan,
    TResult? Function(CreatePlan value)? createPlan,
    TResult? Function(DeletePlan value)? deletePlan,
  }) {
    return createPlan?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchPlans value)? fetchPlans,
    TResult Function(RefreshPlans value)? refreshPlans,
    TResult Function(LoadMorePlans value)? loadMorePlans,
    TResult Function(FilterPlansByCategory value)? filterPlansByCategory,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(LikePlan value)? likePlan,
    TResult Function(UnlikePlan value)? unlikePlan,
    TResult Function(CreatePlan value)? createPlan,
    TResult Function(DeletePlan value)? deletePlan,
    required TResult orElse(),
  }) {
    if (createPlan != null) {
      return createPlan(this);
    }
    return orElse();
  }
}

abstract class CreatePlan extends FeedEvent {
  const factory CreatePlan(
      {required final String title,
      required final String description,
      required final String imageUrl,
      required final String category,
      required final String location,
      final DateTime? date,
      required final Map<String, String> conditions,
      required final List<String> selectedThemes}) = _$CreatePlanImpl;
  const CreatePlan._() : super._();

  String get title;
  String get description;
  String get imageUrl;
  String get category;
  String get location;
  DateTime? get date;
  Map<String, String> get conditions;
  List<String> get selectedThemes;

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatePlanImplCopyWith<_$CreatePlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeletePlanImplCopyWith<$Res> {
  factory _$$DeletePlanImplCopyWith(
          _$DeletePlanImpl value, $Res Function(_$DeletePlanImpl) then) =
      __$$DeletePlanImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String planId});
}

/// @nodoc
class __$$DeletePlanImplCopyWithImpl<$Res>
    extends _$FeedEventCopyWithImpl<$Res, _$DeletePlanImpl>
    implements _$$DeletePlanImplCopyWith<$Res> {
  __$$DeletePlanImplCopyWithImpl(
      _$DeletePlanImpl _value, $Res Function(_$DeletePlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? planId = null,
  }) {
    return _then(_$DeletePlanImpl(
      null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DeletePlanImpl extends DeletePlan {
  const _$DeletePlanImpl(this.planId) : super._();

  @override
  final String planId;

  @override
  String toString() {
    return 'FeedEvent.deletePlan(planId: $planId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeletePlanImpl &&
            (identical(other.planId, planId) || other.planId == planId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, planId);

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeletePlanImplCopyWith<_$DeletePlanImpl> get copyWith =>
      __$$DeletePlanImplCopyWithImpl<_$DeletePlanImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() fetchPlans,
    required TResult Function() refreshPlans,
    required TResult Function() loadMorePlans,
    required TResult Function(String category) filterPlansByCategory,
    required TResult Function() clearFilters,
    required TResult Function(String planId) likePlan,
    required TResult Function(String planId) unlikePlan,
    required TResult Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)
        createPlan,
    required TResult Function(String planId) deletePlan,
  }) {
    return deletePlan(planId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? fetchPlans,
    TResult? Function()? refreshPlans,
    TResult? Function()? loadMorePlans,
    TResult? Function(String category)? filterPlansByCategory,
    TResult? Function()? clearFilters,
    TResult? Function(String planId)? likePlan,
    TResult? Function(String planId)? unlikePlan,
    TResult? Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)?
        createPlan,
    TResult? Function(String planId)? deletePlan,
  }) {
    return deletePlan?.call(planId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? fetchPlans,
    TResult Function()? refreshPlans,
    TResult Function()? loadMorePlans,
    TResult Function(String category)? filterPlansByCategory,
    TResult Function()? clearFilters,
    TResult Function(String planId)? likePlan,
    TResult Function(String planId)? unlikePlan,
    TResult Function(
            String title,
            String description,
            String imageUrl,
            String category,
            String location,
            DateTime? date,
            Map<String, String> conditions,
            List<String> selectedThemes)?
        createPlan,
    TResult Function(String planId)? deletePlan,
    required TResult orElse(),
  }) {
    if (deletePlan != null) {
      return deletePlan(planId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchPlans value) fetchPlans,
    required TResult Function(RefreshPlans value) refreshPlans,
    required TResult Function(LoadMorePlans value) loadMorePlans,
    required TResult Function(FilterPlansByCategory value)
        filterPlansByCategory,
    required TResult Function(ClearFilters value) clearFilters,
    required TResult Function(LikePlan value) likePlan,
    required TResult Function(UnlikePlan value) unlikePlan,
    required TResult Function(CreatePlan value) createPlan,
    required TResult Function(DeletePlan value) deletePlan,
  }) {
    return deletePlan(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchPlans value)? fetchPlans,
    TResult? Function(RefreshPlans value)? refreshPlans,
    TResult? Function(LoadMorePlans value)? loadMorePlans,
    TResult? Function(FilterPlansByCategory value)? filterPlansByCategory,
    TResult? Function(ClearFilters value)? clearFilters,
    TResult? Function(LikePlan value)? likePlan,
    TResult? Function(UnlikePlan value)? unlikePlan,
    TResult? Function(CreatePlan value)? createPlan,
    TResult? Function(DeletePlan value)? deletePlan,
  }) {
    return deletePlan?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchPlans value)? fetchPlans,
    TResult Function(RefreshPlans value)? refreshPlans,
    TResult Function(LoadMorePlans value)? loadMorePlans,
    TResult Function(FilterPlansByCategory value)? filterPlansByCategory,
    TResult Function(ClearFilters value)? clearFilters,
    TResult Function(LikePlan value)? likePlan,
    TResult Function(UnlikePlan value)? unlikePlan,
    TResult Function(CreatePlan value)? createPlan,
    TResult Function(DeletePlan value)? deletePlan,
    required TResult orElse(),
  }) {
    if (deletePlan != null) {
      return deletePlan(this);
    }
    return orElse();
  }
}

abstract class DeletePlan extends FeedEvent {
  const factory DeletePlan(final String planId) = _$DeletePlanImpl;
  const DeletePlan._() : super._();

  String get planId;

  /// Create a copy of FeedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeletePlanImplCopyWith<_$DeletePlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
