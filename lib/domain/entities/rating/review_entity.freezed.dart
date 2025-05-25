// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReviewEntity _$ReviewEntityFromJson(Map<String, dynamic> json) {
  return _ReviewEntity.fromJson(json);
}

/// @nodoc
mixin _$ReviewEntity {
  String get id => throw _privateConstructorUsedError;
  String get reviewerId => throw _privateConstructorUsedError;
  String get reviewedUserId => throw _privateConstructorUsedError;
  String get planId => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError; // 1.0 - 5.0
  String get comment => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get isAnonymous => throw _privateConstructorUsedError;
  List<String> get helpfulVotes => throw _privateConstructorUsedError;
  String? get reviewerName => throw _privateConstructorUsedError;
  String? get reviewerProfileImage => throw _privateConstructorUsedError;

  /// Serializes this ReviewEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewEntityCopyWith<ReviewEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewEntityCopyWith<$Res> {
  factory $ReviewEntityCopyWith(
          ReviewEntity value, $Res Function(ReviewEntity) then) =
      _$ReviewEntityCopyWithImpl<$Res, ReviewEntity>;
  @useResult
  $Res call(
      {String id,
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      DateTime createdAt,
      bool isAnonymous,
      List<String> helpfulVotes,
      String? reviewerName,
      String? reviewerProfileImage});
}

/// @nodoc
class _$ReviewEntityCopyWithImpl<$Res, $Val extends ReviewEntity>
    implements $ReviewEntityCopyWith<$Res> {
  _$ReviewEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reviewerId = null,
    Object? reviewedUserId = null,
    Object? planId = null,
    Object? rating = null,
    Object? comment = null,
    Object? createdAt = null,
    Object? isAnonymous = null,
    Object? helpfulVotes = null,
    Object? reviewerName = freezed,
    Object? reviewerProfileImage = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerId: null == reviewerId
          ? _value.reviewerId
          : reviewerId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewedUserId: null == reviewedUserId
          ? _value.reviewedUserId
          : reviewedUserId // ignore: cast_nullable_to_non_nullable
              as String,
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isAnonymous: null == isAnonymous
          ? _value.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      helpfulVotes: null == helpfulVotes
          ? _value.helpfulVotes
          : helpfulVotes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reviewerName: freezed == reviewerName
          ? _value.reviewerName
          : reviewerName // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewerProfileImage: freezed == reviewerProfileImage
          ? _value.reviewerProfileImage
          : reviewerProfileImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewEntityImplCopyWith<$Res>
    implements $ReviewEntityCopyWith<$Res> {
  factory _$$ReviewEntityImplCopyWith(
          _$ReviewEntityImpl value, $Res Function(_$ReviewEntityImpl) then) =
      __$$ReviewEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String reviewerId,
      String reviewedUserId,
      String planId,
      double rating,
      String comment,
      DateTime createdAt,
      bool isAnonymous,
      List<String> helpfulVotes,
      String? reviewerName,
      String? reviewerProfileImage});
}

/// @nodoc
class __$$ReviewEntityImplCopyWithImpl<$Res>
    extends _$ReviewEntityCopyWithImpl<$Res, _$ReviewEntityImpl>
    implements _$$ReviewEntityImplCopyWith<$Res> {
  __$$ReviewEntityImplCopyWithImpl(
      _$ReviewEntityImpl _value, $Res Function(_$ReviewEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReviewEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reviewerId = null,
    Object? reviewedUserId = null,
    Object? planId = null,
    Object? rating = null,
    Object? comment = null,
    Object? createdAt = null,
    Object? isAnonymous = null,
    Object? helpfulVotes = null,
    Object? reviewerName = freezed,
    Object? reviewerProfileImage = freezed,
  }) {
    return _then(_$ReviewEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerId: null == reviewerId
          ? _value.reviewerId
          : reviewerId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewedUserId: null == reviewedUserId
          ? _value.reviewedUserId
          : reviewedUserId // ignore: cast_nullable_to_non_nullable
              as String,
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isAnonymous: null == isAnonymous
          ? _value.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      helpfulVotes: null == helpfulVotes
          ? _value._helpfulVotes
          : helpfulVotes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reviewerName: freezed == reviewerName
          ? _value.reviewerName
          : reviewerName // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewerProfileImage: freezed == reviewerProfileImage
          ? _value.reviewerProfileImage
          : reviewerProfileImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewEntityImpl implements _ReviewEntity {
  const _$ReviewEntityImpl(
      {required this.id,
      required this.reviewerId,
      required this.reviewedUserId,
      required this.planId,
      required this.rating,
      required this.comment,
      required this.createdAt,
      this.isAnonymous = false,
      final List<String> helpfulVotes = const [],
      this.reviewerName,
      this.reviewerProfileImage})
      : _helpfulVotes = helpfulVotes;

  factory _$ReviewEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String reviewerId;
  @override
  final String reviewedUserId;
  @override
  final String planId;
  @override
  final double rating;
// 1.0 - 5.0
  @override
  final String comment;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final bool isAnonymous;
  final List<String> _helpfulVotes;
  @override
  @JsonKey()
  List<String> get helpfulVotes {
    if (_helpfulVotes is EqualUnmodifiableListView) return _helpfulVotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_helpfulVotes);
  }

  @override
  final String? reviewerName;
  @override
  final String? reviewerProfileImage;

  @override
  String toString() {
    return 'ReviewEntity(id: $id, reviewerId: $reviewerId, reviewedUserId: $reviewedUserId, planId: $planId, rating: $rating, comment: $comment, createdAt: $createdAt, isAnonymous: $isAnonymous, helpfulVotes: $helpfulVotes, reviewerName: $reviewerName, reviewerProfileImage: $reviewerProfileImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reviewerId, reviewerId) ||
                other.reviewerId == reviewerId) &&
            (identical(other.reviewedUserId, reviewedUserId) ||
                other.reviewedUserId == reviewedUserId) &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isAnonymous, isAnonymous) ||
                other.isAnonymous == isAnonymous) &&
            const DeepCollectionEquality()
                .equals(other._helpfulVotes, _helpfulVotes) &&
            (identical(other.reviewerName, reviewerName) ||
                other.reviewerName == reviewerName) &&
            (identical(other.reviewerProfileImage, reviewerProfileImage) ||
                other.reviewerProfileImage == reviewerProfileImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      reviewerId,
      reviewedUserId,
      planId,
      rating,
      comment,
      createdAt,
      isAnonymous,
      const DeepCollectionEquality().hash(_helpfulVotes),
      reviewerName,
      reviewerProfileImage);

  /// Create a copy of ReviewEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewEntityImplCopyWith<_$ReviewEntityImpl> get copyWith =>
      __$$ReviewEntityImplCopyWithImpl<_$ReviewEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewEntityImplToJson(
      this,
    );
  }
}

abstract class _ReviewEntity implements ReviewEntity {
  const factory _ReviewEntity(
      {required final String id,
      required final String reviewerId,
      required final String reviewedUserId,
      required final String planId,
      required final double rating,
      required final String comment,
      required final DateTime createdAt,
      final bool isAnonymous,
      final List<String> helpfulVotes,
      final String? reviewerName,
      final String? reviewerProfileImage}) = _$ReviewEntityImpl;

  factory _ReviewEntity.fromJson(Map<String, dynamic> json) =
      _$ReviewEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get reviewerId;
  @override
  String get reviewedUserId;
  @override
  String get planId;
  @override
  double get rating; // 1.0 - 5.0
  @override
  String get comment;
  @override
  DateTime get createdAt;
  @override
  bool get isAnonymous;
  @override
  List<String> get helpfulVotes;
  @override
  String? get reviewerName;
  @override
  String? get reviewerProfileImage;

  /// Create a copy of ReviewEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewEntityImplCopyWith<_$ReviewEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserRatingEntity _$UserRatingEntityFromJson(Map<String, dynamic> json) {
  return _UserRatingEntity.fromJson(json);
}

/// @nodoc
mixin _$UserRatingEntity {
  String get userId => throw _privateConstructorUsedError;
  double get averageRating => throw _privateConstructorUsedError;
  int get totalReviews => throw _privateConstructorUsedError;
  Map<int, int> get ratingDistribution =>
      throw _privateConstructorUsedError; // star -> count
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this UserRatingEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserRatingEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserRatingEntityCopyWith<UserRatingEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserRatingEntityCopyWith<$Res> {
  factory $UserRatingEntityCopyWith(
          UserRatingEntity value, $Res Function(UserRatingEntity) then) =
      _$UserRatingEntityCopyWithImpl<$Res, UserRatingEntity>;
  @useResult
  $Res call(
      {String userId,
      double averageRating,
      int totalReviews,
      Map<int, int> ratingDistribution,
      DateTime lastUpdated});
}

/// @nodoc
class _$UserRatingEntityCopyWithImpl<$Res, $Val extends UserRatingEntity>
    implements $UserRatingEntityCopyWith<$Res> {
  _$UserRatingEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserRatingEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? ratingDistribution = null,
    Object? lastUpdated = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      ratingDistribution: null == ratingDistribution
          ? _value.ratingDistribution
          : ratingDistribution // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserRatingEntityImplCopyWith<$Res>
    implements $UserRatingEntityCopyWith<$Res> {
  factory _$$UserRatingEntityImplCopyWith(_$UserRatingEntityImpl value,
          $Res Function(_$UserRatingEntityImpl) then) =
      __$$UserRatingEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      double averageRating,
      int totalReviews,
      Map<int, int> ratingDistribution,
      DateTime lastUpdated});
}

/// @nodoc
class __$$UserRatingEntityImplCopyWithImpl<$Res>
    extends _$UserRatingEntityCopyWithImpl<$Res, _$UserRatingEntityImpl>
    implements _$$UserRatingEntityImplCopyWith<$Res> {
  __$$UserRatingEntityImplCopyWithImpl(_$UserRatingEntityImpl _value,
      $Res Function(_$UserRatingEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserRatingEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? ratingDistribution = null,
    Object? lastUpdated = null,
  }) {
    return _then(_$UserRatingEntityImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      ratingDistribution: null == ratingDistribution
          ? _value._ratingDistribution
          : ratingDistribution // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserRatingEntityImpl implements _UserRatingEntity {
  const _$UserRatingEntityImpl(
      {required this.userId,
      required this.averageRating,
      required this.totalReviews,
      required final Map<int, int> ratingDistribution,
      required this.lastUpdated})
      : _ratingDistribution = ratingDistribution;

  factory _$UserRatingEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserRatingEntityImplFromJson(json);

  @override
  final String userId;
  @override
  final double averageRating;
  @override
  final int totalReviews;
  final Map<int, int> _ratingDistribution;
  @override
  Map<int, int> get ratingDistribution {
    if (_ratingDistribution is EqualUnmodifiableMapView)
      return _ratingDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_ratingDistribution);
  }

// star -> count
  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'UserRatingEntity(userId: $userId, averageRating: $averageRating, totalReviews: $totalReviews, ratingDistribution: $ratingDistribution, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserRatingEntityImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            const DeepCollectionEquality()
                .equals(other._ratingDistribution, _ratingDistribution) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      averageRating,
      totalReviews,
      const DeepCollectionEquality().hash(_ratingDistribution),
      lastUpdated);

  /// Create a copy of UserRatingEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserRatingEntityImplCopyWith<_$UserRatingEntityImpl> get copyWith =>
      __$$UserRatingEntityImplCopyWithImpl<_$UserRatingEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserRatingEntityImplToJson(
      this,
    );
  }
}

abstract class _UserRatingEntity implements UserRatingEntity {
  const factory _UserRatingEntity(
      {required final String userId,
      required final double averageRating,
      required final int totalReviews,
      required final Map<int, int> ratingDistribution,
      required final DateTime lastUpdated}) = _$UserRatingEntityImpl;

  factory _UserRatingEntity.fromJson(Map<String, dynamic> json) =
      _$UserRatingEntityImpl.fromJson;

  @override
  String get userId;
  @override
  double get averageRating;
  @override
  int get totalReviews;
  @override
  Map<int, int> get ratingDistribution; // star -> count
  @override
  DateTime get lastUpdated;

  /// Create a copy of UserRatingEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserRatingEntityImplCopyWith<_$UserRatingEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
