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
  ReviewType get type => throw _privateConstructorUsedError;
  ReviewStatus get status => throw _privateConstructorUsedError;
  String? get response =>
      throw _privateConstructorUsedError; // Respuesta del usuario revisado
  DateTime? get responseDate => throw _privateConstructorUsedError;
  int get helpfulCount => throw _privateConstructorUsedError;
  List<String> get helpfulVotes => throw _privateConstructorUsedError;
  bool get isVerified =>
      throw _privateConstructorUsedError; // Si el revisor realmente participó en el plan
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

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
      ReviewType type,
      ReviewStatus status,
      String? response,
      DateTime? responseDate,
      int helpfulCount,
      List<String> helpfulVotes,
      bool isVerified,
      Map<String, dynamic>? metadata});
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
    Object? type = null,
    Object? status = null,
    Object? response = freezed,
    Object? responseDate = freezed,
    Object? helpfulCount = null,
    Object? helpfulVotes = null,
    Object? isVerified = null,
    Object? metadata = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReviewType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReviewStatus,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String?,
      responseDate: freezed == responseDate
          ? _value.responseDate
          : responseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      helpfulCount: null == helpfulCount
          ? _value.helpfulCount
          : helpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      helpfulVotes: null == helpfulVotes
          ? _value.helpfulVotes
          : helpfulVotes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
      ReviewType type,
      ReviewStatus status,
      String? response,
      DateTime? responseDate,
      int helpfulCount,
      List<String> helpfulVotes,
      bool isVerified,
      Map<String, dynamic>? metadata});
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
    Object? type = null,
    Object? status = null,
    Object? response = freezed,
    Object? responseDate = freezed,
    Object? helpfulCount = null,
    Object? helpfulVotes = null,
    Object? isVerified = null,
    Object? metadata = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReviewType,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReviewStatus,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String?,
      responseDate: freezed == responseDate
          ? _value.responseDate
          : responseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      helpfulCount: null == helpfulCount
          ? _value.helpfulCount
          : helpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      helpfulVotes: null == helpfulVotes
          ? _value._helpfulVotes
          : helpfulVotes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
      required this.type,
      required this.status,
      this.response,
      this.responseDate,
      this.helpfulCount = 0,
      final List<String> helpfulVotes = const [],
      this.isVerified = false,
      final Map<String, dynamic>? metadata})
      : _helpfulVotes = helpfulVotes,
        _metadata = metadata;

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
  final ReviewType type;
  @override
  final ReviewStatus status;
  @override
  final String? response;
// Respuesta del usuario revisado
  @override
  final DateTime? responseDate;
  @override
  @JsonKey()
  final int helpfulCount;
  final List<String> _helpfulVotes;
  @override
  @JsonKey()
  List<String> get helpfulVotes {
    if (_helpfulVotes is EqualUnmodifiableListView) return _helpfulVotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_helpfulVotes);
  }

  @override
  @JsonKey()
  final bool isVerified;
// Si el revisor realmente participó en el plan
  final Map<String, dynamic>? _metadata;
// Si el revisor realmente participó en el plan
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ReviewEntity(id: $id, reviewerId: $reviewerId, reviewedUserId: $reviewedUserId, planId: $planId, rating: $rating, comment: $comment, createdAt: $createdAt, type: $type, status: $status, response: $response, responseDate: $responseDate, helpfulCount: $helpfulCount, helpfulVotes: $helpfulVotes, isVerified: $isVerified, metadata: $metadata)';
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
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.responseDate, responseDate) ||
                other.responseDate == responseDate) &&
            (identical(other.helpfulCount, helpfulCount) ||
                other.helpfulCount == helpfulCount) &&
            const DeepCollectionEquality()
                .equals(other._helpfulVotes, _helpfulVotes) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
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
      type,
      status,
      response,
      responseDate,
      helpfulCount,
      const DeepCollectionEquality().hash(_helpfulVotes),
      isVerified,
      const DeepCollectionEquality().hash(_metadata));

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
      required final ReviewType type,
      required final ReviewStatus status,
      final String? response,
      final DateTime? responseDate,
      final int helpfulCount,
      final List<String> helpfulVotes,
      final bool isVerified,
      final Map<String, dynamic>? metadata}) = _$ReviewEntityImpl;

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
  ReviewType get type;
  @override
  ReviewStatus get status;
  @override
  String? get response; // Respuesta del usuario revisado
  @override
  DateTime? get responseDate;
  @override
  int get helpfulCount;
  @override
  List<String> get helpfulVotes;
  @override
  bool get isVerified; // Si el revisor realmente participó en el plan
  @override
  Map<String, dynamic>? get metadata;

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
  double get averageRating => throw _privateConstructorUsedError; // 0.0 - 5.0
  int get totalReviews => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  int get totalPlansOrganized => throw _privateConstructorUsedError;
  int get totalPlansAttended => throw _privateConstructorUsedError;
  int get reliabilityScore => throw _privateConstructorUsedError; // 0-100
  Map<String, int>? get ratingDistribution =>
      throw _privateConstructorUsedError; // {1: 0, 2: 1, 3: 5, 4: 20, 5: 15}
  Map<String, double>? get categoryRatings =>
      throw _privateConstructorUsedError; // Ratings por categoría de planes
  List<String>? get topPositiveComments => throw _privateConstructorUsedError;
  List<String>? get commonConcerns => throw _privateConstructorUsedError;

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
      DateTime lastUpdated,
      int totalPlansOrganized,
      int totalPlansAttended,
      int reliabilityScore,
      Map<String, int>? ratingDistribution,
      Map<String, double>? categoryRatings,
      List<String>? topPositiveComments,
      List<String>? commonConcerns});
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
    Object? lastUpdated = null,
    Object? totalPlansOrganized = null,
    Object? totalPlansAttended = null,
    Object? reliabilityScore = null,
    Object? ratingDistribution = freezed,
    Object? categoryRatings = freezed,
    Object? topPositiveComments = freezed,
    Object? commonConcerns = freezed,
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
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalPlansOrganized: null == totalPlansOrganized
          ? _value.totalPlansOrganized
          : totalPlansOrganized // ignore: cast_nullable_to_non_nullable
              as int,
      totalPlansAttended: null == totalPlansAttended
          ? _value.totalPlansAttended
          : totalPlansAttended // ignore: cast_nullable_to_non_nullable
              as int,
      reliabilityScore: null == reliabilityScore
          ? _value.reliabilityScore
          : reliabilityScore // ignore: cast_nullable_to_non_nullable
              as int,
      ratingDistribution: freezed == ratingDistribution
          ? _value.ratingDistribution
          : ratingDistribution // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      categoryRatings: freezed == categoryRatings
          ? _value.categoryRatings
          : categoryRatings // ignore: cast_nullable_to_non_nullable
              as Map<String, double>?,
      topPositiveComments: freezed == topPositiveComments
          ? _value.topPositiveComments
          : topPositiveComments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      commonConcerns: freezed == commonConcerns
          ? _value.commonConcerns
          : commonConcerns // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
      DateTime lastUpdated,
      int totalPlansOrganized,
      int totalPlansAttended,
      int reliabilityScore,
      Map<String, int>? ratingDistribution,
      Map<String, double>? categoryRatings,
      List<String>? topPositiveComments,
      List<String>? commonConcerns});
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
    Object? lastUpdated = null,
    Object? totalPlansOrganized = null,
    Object? totalPlansAttended = null,
    Object? reliabilityScore = null,
    Object? ratingDistribution = freezed,
    Object? categoryRatings = freezed,
    Object? topPositiveComments = freezed,
    Object? commonConcerns = freezed,
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
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalPlansOrganized: null == totalPlansOrganized
          ? _value.totalPlansOrganized
          : totalPlansOrganized // ignore: cast_nullable_to_non_nullable
              as int,
      totalPlansAttended: null == totalPlansAttended
          ? _value.totalPlansAttended
          : totalPlansAttended // ignore: cast_nullable_to_non_nullable
              as int,
      reliabilityScore: null == reliabilityScore
          ? _value.reliabilityScore
          : reliabilityScore // ignore: cast_nullable_to_non_nullable
              as int,
      ratingDistribution: freezed == ratingDistribution
          ? _value._ratingDistribution
          : ratingDistribution // ignore: cast_nullable_to_non_nullable
              as Map<String, int>?,
      categoryRatings: freezed == categoryRatings
          ? _value._categoryRatings
          : categoryRatings // ignore: cast_nullable_to_non_nullable
              as Map<String, double>?,
      topPositiveComments: freezed == topPositiveComments
          ? _value._topPositiveComments
          : topPositiveComments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      commonConcerns: freezed == commonConcerns
          ? _value._commonConcerns
          : commonConcerns // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
      required this.lastUpdated,
      this.totalPlansOrganized = 0,
      this.totalPlansAttended = 0,
      this.reliabilityScore = 0,
      final Map<String, int>? ratingDistribution,
      final Map<String, double>? categoryRatings,
      final List<String>? topPositiveComments,
      final List<String>? commonConcerns})
      : _ratingDistribution = ratingDistribution,
        _categoryRatings = categoryRatings,
        _topPositiveComments = topPositiveComments,
        _commonConcerns = commonConcerns;

  factory _$UserRatingEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserRatingEntityImplFromJson(json);

  @override
  final String userId;
  @override
  final double averageRating;
// 0.0 - 5.0
  @override
  final int totalReviews;
  @override
  final DateTime lastUpdated;
  @override
  @JsonKey()
  final int totalPlansOrganized;
  @override
  @JsonKey()
  final int totalPlansAttended;
  @override
  @JsonKey()
  final int reliabilityScore;
// 0-100
  final Map<String, int>? _ratingDistribution;
// 0-100
  @override
  Map<String, int>? get ratingDistribution {
    final value = _ratingDistribution;
    if (value == null) return null;
    if (_ratingDistribution is EqualUnmodifiableMapView)
      return _ratingDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// {1: 0, 2: 1, 3: 5, 4: 20, 5: 15}
  final Map<String, double>? _categoryRatings;
// {1: 0, 2: 1, 3: 5, 4: 20, 5: 15}
  @override
  Map<String, double>? get categoryRatings {
    final value = _categoryRatings;
    if (value == null) return null;
    if (_categoryRatings is EqualUnmodifiableMapView) return _categoryRatings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Ratings por categoría de planes
  final List<String>? _topPositiveComments;
// Ratings por categoría de planes
  @override
  List<String>? get topPositiveComments {
    final value = _topPositiveComments;
    if (value == null) return null;
    if (_topPositiveComments is EqualUnmodifiableListView)
      return _topPositiveComments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _commonConcerns;
  @override
  List<String>? get commonConcerns {
    final value = _commonConcerns;
    if (value == null) return null;
    if (_commonConcerns is EqualUnmodifiableListView) return _commonConcerns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'UserRatingEntity(userId: $userId, averageRating: $averageRating, totalReviews: $totalReviews, lastUpdated: $lastUpdated, totalPlansOrganized: $totalPlansOrganized, totalPlansAttended: $totalPlansAttended, reliabilityScore: $reliabilityScore, ratingDistribution: $ratingDistribution, categoryRatings: $categoryRatings, topPositiveComments: $topPositiveComments, commonConcerns: $commonConcerns)';
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
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.totalPlansOrganized, totalPlansOrganized) ||
                other.totalPlansOrganized == totalPlansOrganized) &&
            (identical(other.totalPlansAttended, totalPlansAttended) ||
                other.totalPlansAttended == totalPlansAttended) &&
            (identical(other.reliabilityScore, reliabilityScore) ||
                other.reliabilityScore == reliabilityScore) &&
            const DeepCollectionEquality()
                .equals(other._ratingDistribution, _ratingDistribution) &&
            const DeepCollectionEquality()
                .equals(other._categoryRatings, _categoryRatings) &&
            const DeepCollectionEquality()
                .equals(other._topPositiveComments, _topPositiveComments) &&
            const DeepCollectionEquality()
                .equals(other._commonConcerns, _commonConcerns));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      averageRating,
      totalReviews,
      lastUpdated,
      totalPlansOrganized,
      totalPlansAttended,
      reliabilityScore,
      const DeepCollectionEquality().hash(_ratingDistribution),
      const DeepCollectionEquality().hash(_categoryRatings),
      const DeepCollectionEquality().hash(_topPositiveComments),
      const DeepCollectionEquality().hash(_commonConcerns));

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
      required final DateTime lastUpdated,
      final int totalPlansOrganized,
      final int totalPlansAttended,
      final int reliabilityScore,
      final Map<String, int>? ratingDistribution,
      final Map<String, double>? categoryRatings,
      final List<String>? topPositiveComments,
      final List<String>? commonConcerns}) = _$UserRatingEntityImpl;

  factory _UserRatingEntity.fromJson(Map<String, dynamic> json) =
      _$UserRatingEntityImpl.fromJson;

  @override
  String get userId;
  @override
  double get averageRating; // 0.0 - 5.0
  @override
  int get totalReviews;
  @override
  DateTime get lastUpdated;
  @override
  int get totalPlansOrganized;
  @override
  int get totalPlansAttended;
  @override
  int get reliabilityScore; // 0-100
  @override
  Map<String, int>? get ratingDistribution; // {1: 0, 2: 1, 3: 5, 4: 20, 5: 15}
  @override
  Map<String, double>? get categoryRatings; // Ratings por categoría de planes
  @override
  List<String>? get topPositiveComments;
  @override
  List<String>? get commonConcerns;

  /// Create a copy of UserRatingEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserRatingEntityImplCopyWith<_$UserRatingEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
