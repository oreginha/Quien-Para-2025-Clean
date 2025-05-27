// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ReviewState {
  // ==================== ESTADO GENERAL ====================
  ReviewStatus get status => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  bool? get isLoading =>
      throw _privateConstructorUsedError; // ==================== RESEÑAS ====================
  List<ReviewEntity> get userReviews => throw _privateConstructorUsedError;
  List<ReviewEntity> get planReviews => throw _privateConstructorUsedError;
  List<ReviewEntity> get reviewsByUser => throw _privateConstructorUsedError;
  List<ReviewEntity> get pendingReviews =>
      throw _privateConstructorUsedError; // ==================== PAGINACIÓN ====================
  bool get hasMoreUserReviews => throw _privateConstructorUsedError;
  bool get hasMorePlanReviews => throw _privateConstructorUsedError;
  bool get hasMoreReviewsByUser => throw _privateConstructorUsedError;
  bool get hasMorePendingReviews => throw _privateConstructorUsedError;
  String? get lastUserReviewDocumentId => throw _privateConstructorUsedError;
  String? get lastPlanReviewDocumentId => throw _privateConstructorUsedError;
  String? get lastReviewsByUserDocumentId => throw _privateConstructorUsedError;
  String? get lastPendingReviewDocumentId =>
      throw _privateConstructorUsedError; // ==================== RATING DE USUARIO ====================
  UserRatingEntity? get currentUserRating => throw _privateConstructorUsedError;
  List<UserRatingEntity> get topRatedUsers =>
      throw _privateConstructorUsedError;
  UserRatingCalculationResult? get lastCalculationResult =>
      throw _privateConstructorUsedError;
  UserReviewsResult? get lastUserReviewsResult =>
      throw _privateConstructorUsedError;
  List<UserRatingComparison> get userRatingComparisons =>
      throw _privateConstructorUsedError; // ==================== ACCIONES ====================
  String? get lastCreatedReviewId => throw _privateConstructorUsedError;
  String? get lastUpdatedReviewId => throw _privateConstructorUsedError;
  String? get lastDeletedReviewId => throw _privateConstructorUsedError;
  List<String> get helpfulReviewIds =>
      throw _privateConstructorUsedError; // ==================== MODERACIÓN ====================
  String? get lastApprovedReviewId => throw _privateConstructorUsedError;
  String? get lastRejectedReviewId => throw _privateConstructorUsedError;
  String? get lastFlaggedReviewId =>
      throw _privateConstructorUsedError; // ==================== ANALYTICS ====================
  Map<String, dynamic>? get reviewMetrics => throw _privateConstructorUsedError;
  Map<int, int>? get ratingDistribution => throw _privateConstructorUsedError;
  Map<String, dynamic>? get reviewTrends =>
      throw _privateConstructorUsedError; // ==================== PERMISOS ====================
  Map<String, bool> get canReviewPermissions =>
      throw _privateConstructorUsedError; // planId + targetUserId -> bool
  // ==================== CACHE Y PERFORMANCE ====================
  DateTime? get lastRefreshTime => throw _privateConstructorUsedError;
  Map<String, DateTime> get lastDataFetchTimes =>
      throw _privateConstructorUsedError;
  bool get isRefreshing => throw _privateConstructorUsedError;

  /// Create a copy of ReviewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewStateCopyWith<ReviewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewStateCopyWith<$Res> {
  factory $ReviewStateCopyWith(
    ReviewState value,
    $Res Function(ReviewState) then,
  ) = _$ReviewStateCopyWithImpl<$Res, ReviewState>;
  @useResult
  $Res call({
    ReviewStatus status,
    String? error,
    bool? isLoading,
    List<ReviewEntity> userReviews,
    List<ReviewEntity> planReviews,
    List<ReviewEntity> reviewsByUser,
    List<ReviewEntity> pendingReviews,
    bool hasMoreUserReviews,
    bool hasMorePlanReviews,
    bool hasMoreReviewsByUser,
    bool hasMorePendingReviews,
    String? lastUserReviewDocumentId,
    String? lastPlanReviewDocumentId,
    String? lastReviewsByUserDocumentId,
    String? lastPendingReviewDocumentId,
    UserRatingEntity? currentUserRating,
    List<UserRatingEntity> topRatedUsers,
    UserRatingCalculationResult? lastCalculationResult,
    UserReviewsResult? lastUserReviewsResult,
    List<UserRatingComparison> userRatingComparisons,
    String? lastCreatedReviewId,
    String? lastUpdatedReviewId,
    String? lastDeletedReviewId,
    List<String> helpfulReviewIds,
    String? lastApprovedReviewId,
    String? lastRejectedReviewId,
    String? lastFlaggedReviewId,
    Map<String, dynamic>? reviewMetrics,
    Map<int, int>? ratingDistribution,
    Map<String, dynamic>? reviewTrends,
    Map<String, bool> canReviewPermissions,
    DateTime? lastRefreshTime,
    Map<String, DateTime> lastDataFetchTimes,
    bool isRefreshing,
  });

  $UserRatingEntityCopyWith<$Res>? get currentUserRating;
}

/// @nodoc
class _$ReviewStateCopyWithImpl<$Res, $Val extends ReviewState>
    implements $ReviewStateCopyWith<$Res> {
  _$ReviewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? error = freezed,
    Object? isLoading = freezed,
    Object? userReviews = null,
    Object? planReviews = null,
    Object? reviewsByUser = null,
    Object? pendingReviews = null,
    Object? hasMoreUserReviews = null,
    Object? hasMorePlanReviews = null,
    Object? hasMoreReviewsByUser = null,
    Object? hasMorePendingReviews = null,
    Object? lastUserReviewDocumentId = freezed,
    Object? lastPlanReviewDocumentId = freezed,
    Object? lastReviewsByUserDocumentId = freezed,
    Object? lastPendingReviewDocumentId = freezed,
    Object? currentUserRating = freezed,
    Object? topRatedUsers = null,
    Object? lastCalculationResult = freezed,
    Object? lastUserReviewsResult = freezed,
    Object? userRatingComparisons = null,
    Object? lastCreatedReviewId = freezed,
    Object? lastUpdatedReviewId = freezed,
    Object? lastDeletedReviewId = freezed,
    Object? helpfulReviewIds = null,
    Object? lastApprovedReviewId = freezed,
    Object? lastRejectedReviewId = freezed,
    Object? lastFlaggedReviewId = freezed,
    Object? reviewMetrics = freezed,
    Object? ratingDistribution = freezed,
    Object? reviewTrends = freezed,
    Object? canReviewPermissions = null,
    Object? lastRefreshTime = freezed,
    Object? lastDataFetchTimes = null,
    Object? isRefreshing = null,
  }) {
    return _then(
      _value.copyWith(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                as ReviewStatus,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                as String?,
        isLoading: freezed == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                as bool?,
        userReviews: null == userReviews
            ? _value.userReviews
            : userReviews // ignore: cast_nullable_to_non_nullable
                as List<ReviewEntity>,
        planReviews: null == planReviews
            ? _value.planReviews
            : planReviews // ignore: cast_nullable_to_non_nullable
                as List<ReviewEntity>,
        reviewsByUser: null == reviewsByUser
            ? _value.reviewsByUser
            : reviewsByUser // ignore: cast_nullable_to_non_nullable
                as List<ReviewEntity>,
        pendingReviews: null == pendingReviews
            ? _value.pendingReviews
            : pendingReviews // ignore: cast_nullable_to_non_nullable
                as List<ReviewEntity>,
        hasMoreUserReviews: null == hasMoreUserReviews
            ? _value.hasMoreUserReviews
            : hasMoreUserReviews // ignore: cast_nullable_to_non_nullable
                as bool,
        hasMorePlanReviews: null == hasMorePlanReviews
            ? _value.hasMorePlanReviews
            : hasMorePlanReviews // ignore: cast_nullable_to_non_nullable
                as bool,
        hasMoreReviewsByUser: null == hasMoreReviewsByUser
            ? _value.hasMoreReviewsByUser
            : hasMoreReviewsByUser // ignore: cast_nullable_to_non_nullable
                as bool,
        hasMorePendingReviews: null == hasMorePendingReviews
            ? _value.hasMorePendingReviews
            : hasMorePendingReviews // ignore: cast_nullable_to_non_nullable
                as bool,
        lastUserReviewDocumentId: freezed == lastUserReviewDocumentId
            ? _value.lastUserReviewDocumentId
            : lastUserReviewDocumentId // ignore: cast_nullable_to_non_nullable
                as String?,
        lastPlanReviewDocumentId: freezed == lastPlanReviewDocumentId
            ? _value.lastPlanReviewDocumentId
            : lastPlanReviewDocumentId // ignore: cast_nullable_to_non_nullable
                as String?,
        lastReviewsByUserDocumentId: freezed == lastReviewsByUserDocumentId
            ? _value.lastReviewsByUserDocumentId
            : lastReviewsByUserDocumentId // ignore: cast_nullable_to_non_nullable
                as String?,
        lastPendingReviewDocumentId: freezed == lastPendingReviewDocumentId
            ? _value.lastPendingReviewDocumentId
            : lastPendingReviewDocumentId // ignore: cast_nullable_to_non_nullable
                as String?,
        currentUserRating: freezed == currentUserRating
            ? _value.currentUserRating
            : currentUserRating // ignore: cast_nullable_to_non_nullable
                as UserRatingEntity?,
        topRatedUsers: null == topRatedUsers
            ? _value.topRatedUsers
            : topRatedUsers // ignore: cast_nullable_to_non_nullable
                as List<UserRatingEntity>,
        lastCalculationResult: freezed == lastCalculationResult
            ? _value.lastCalculationResult
            : lastCalculationResult // ignore: cast_nullable_to_non_nullable
                as UserRatingCalculationResult?,
        lastUserReviewsResult: freezed == lastUserReviewsResult
            ? _value.lastUserReviewsResult
            : lastUserReviewsResult // ignore: cast_nullable_to_non_nullable
                as UserReviewsResult?,
        userRatingComparisons: null == userRatingComparisons
            ? _value.userRatingComparisons
            : userRatingComparisons // ignore: cast_nullable_to_non_nullable
                as List<UserRatingComparison>,
        lastCreatedReviewId: freezed == lastCreatedReviewId
            ? _value.lastCreatedReviewId
            : lastCreatedReviewId // ignore: cast_nullable_to_non_nullable
                as String?,
        lastUpdatedReviewId: freezed == lastUpdatedReviewId
            ? _value.lastUpdatedReviewId
            : lastUpdatedReviewId // ignore: cast_nullable_to_non_nullable
                as String?,
        lastDeletedReviewId: freezed == lastDeletedReviewId
            ? _value.lastDeletedReviewId
            : lastDeletedReviewId // ignore: cast_nullable_to_non_nullable
                as String?,
        helpfulReviewIds: null == helpfulReviewIds
            ? _value.helpfulReviewIds
            : helpfulReviewIds // ignore: cast_nullable_to_non_nullable
                as List<String>,
        lastApprovedReviewId: freezed == lastApprovedReviewId
            ? _value.lastApprovedReviewId
            : lastApprovedReviewId // ignore: cast_nullable_to_non_nullable
                as String?,
        lastRejectedReviewId: freezed == lastRejectedReviewId
            ? _value.lastRejectedReviewId
            : lastRejectedReviewId // ignore: cast_nullable_to_non_nullable
                as String?,
        lastFlaggedReviewId: freezed == lastFlaggedReviewId
            ? _value.lastFlaggedReviewId
            : lastFlaggedReviewId // ignore: cast_nullable_to_non_nullable
                as String?,
        reviewMetrics: freezed == reviewMetrics
            ? _value.reviewMetrics
            : reviewMetrics // ignore: cast_nullable_to_non_nullable
                as Map<String, dynamic>?,
        ratingDistribution: freezed == ratingDistribution
            ? _value.ratingDistribution
            : ratingDistribution // ignore: cast_nullable_to_non_nullable
                as Map<int, int>?,
        reviewTrends: freezed == reviewTrends
            ? _value.reviewTrends
            : reviewTrends // ignore: cast_nullable_to_non_nullable
                as Map<String, dynamic>?,
        canReviewPermissions: null == canReviewPermissions
            ? _value.canReviewPermissions
            : canReviewPermissions // ignore: cast_nullable_to_non_nullable
                as Map<String, bool>,
        lastRefreshTime: freezed == lastRefreshTime
            ? _value.lastRefreshTime
            : lastRefreshTime // ignore: cast_nullable_to_non_nullable
                as DateTime?,
        lastDataFetchTimes: null == lastDataFetchTimes
            ? _value.lastDataFetchTimes
            : lastDataFetchTimes // ignore: cast_nullable_to_non_nullable
                as Map<String, DateTime>,
        isRefreshing: null == isRefreshing
            ? _value.isRefreshing
            : isRefreshing // ignore: cast_nullable_to_non_nullable
                as bool,
      ) as $Val,
    );
  }

  /// Create a copy of ReviewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserRatingEntityCopyWith<$Res>? get currentUserRating {
    if (_value.currentUserRating == null) {
      return null;
    }

    return $UserRatingEntityCopyWith<$Res>(_value.currentUserRating!, (value) {
      return _then(_value.copyWith(currentUserRating: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReviewStateImplCopyWith<$Res>
    implements $ReviewStateCopyWith<$Res> {
  factory _$$ReviewStateImplCopyWith(
    _$ReviewStateImpl value,
    $Res Function(_$ReviewStateImpl) then,
  ) = __$$ReviewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ReviewStatus status,
    String? error,
    bool? isLoading,
    List<ReviewEntity> userReviews,
    List<ReviewEntity> planReviews,
    List<ReviewEntity> reviewsByUser,
    List<ReviewEntity> pendingReviews,
    bool hasMoreUserReviews,
    bool hasMorePlanReviews,
    bool hasMoreReviewsByUser,
    bool hasMorePendingReviews,
    String? lastUserReviewDocumentId,
    String? lastPlanReviewDocumentId,
    String? lastReviewsByUserDocumentId,
    String? lastPendingReviewDocumentId,
    UserRatingEntity? currentUserRating,
    List<UserRatingEntity> topRatedUsers,
    UserRatingCalculationResult? lastCalculationResult,
    UserReviewsResult? lastUserReviewsResult,
    List<UserRatingComparison> userRatingComparisons,
    String? lastCreatedReviewId,
    String? lastUpdatedReviewId,
    String? lastDeletedReviewId,
    List<String> helpfulReviewIds,
    String? lastApprovedReviewId,
    String? lastRejectedReviewId,
    String? lastFlaggedReviewId,
    Map<String, dynamic>? reviewMetrics,
    Map<int, int>? ratingDistribution,
    Map<String, dynamic>? reviewTrends,
    Map<String, bool> canReviewPermissions,
    DateTime? lastRefreshTime,
    Map<String, DateTime> lastDataFetchTimes,
    bool isRefreshing,
  });

  @override
  $UserRatingEntityCopyWith<$Res>? get currentUserRating;
}

/// @nodoc
class __$$ReviewStateImplCopyWithImpl<$Res>
    extends _$ReviewStateCopyWithImpl<$Res, _$ReviewStateImpl>
    implements _$$ReviewStateImplCopyWith<$Res> {
  __$$ReviewStateImplCopyWithImpl(
    _$ReviewStateImpl _value,
    $Res Function(_$ReviewStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? error = freezed,
    Object? isLoading = freezed,
    Object? userReviews = null,
    Object? planReviews = null,
    Object? reviewsByUser = null,
    Object? pendingReviews = null,
    Object? hasMoreUserReviews = null,
    Object? hasMorePlanReviews = null,
    Object? hasMoreReviewsByUser = null,
    Object? hasMorePendingReviews = null,
    Object? lastUserReviewDocumentId = freezed,
    Object? lastPlanReviewDocumentId = freezed,
    Object? lastReviewsByUserDocumentId = freezed,
    Object? lastPendingReviewDocumentId = freezed,
    Object? currentUserRating = freezed,
    Object? topRatedUsers = null,
    Object? lastCalculationResult = freezed,
    Object? lastUserReviewsResult = freezed,
    Object? userRatingComparisons = null,
    Object? lastCreatedReviewId = freezed,
    Object? lastUpdatedReviewId = freezed,
    Object? lastDeletedReviewId = freezed,
    Object? helpfulReviewIds = null,
    Object? lastApprovedReviewId = freezed,
    Object? lastRejectedReviewId = freezed,
    Object? lastFlaggedReviewId = freezed,
    Object? reviewMetrics = freezed,
    Object? ratingDistribution = freezed,
    Object? reviewTrends = freezed,
    Object? canReviewPermissions = null,
    Object? lastRefreshTime = freezed,
    Object? lastDataFetchTimes = null,
    Object? isRefreshing = null,
  }) {
    return _then(
      _$ReviewStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                as ReviewStatus,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                as String?,
        isLoading: freezed == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                as bool?,
        userReviews: null == userReviews
            ? _value._userReviews
            : userReviews // ignore: cast_nullable_to_non_nullable
                as List<ReviewEntity>,
        planReviews: null == planReviews
            ? _value._planReviews
            : planReviews // ignore: cast_nullable_to_non_nullable
                as List<ReviewEntity>,
        reviewsByUser: null == reviewsByUser
            ? _value._reviewsByUser
            : reviewsByUser // ignore: cast_nullable_to_non_nullable
                as List<ReviewEntity>,
        pendingReviews: null == pendingReviews
            ? _value._pendingReviews
            : pendingReviews // ignore: cast_nullable_to_non_nullable
                as List<ReviewEntity>,
        hasMoreUserReviews: null == hasMoreUserReviews
            ? _value.hasMoreUserReviews
            : hasMoreUserReviews // ignore: cast_nullable_to_non_nullable
                as bool,
        hasMorePlanReviews: null == hasMorePlanReviews
            ? _value.hasMorePlanReviews
            : hasMorePlanReviews // ignore: cast_nullable_to_non_nullable
                as bool,
        hasMoreReviewsByUser: null == hasMoreReviewsByUser
            ? _value.hasMoreReviewsByUser
            : hasMoreReviewsByUser // ignore: cast_nullable_to_non_nullable
                as bool,
        hasMorePendingReviews: null == hasMorePendingReviews
            ? _value.hasMorePendingReviews
            : hasMorePendingReviews // ignore: cast_nullable_to_non_nullable
                as bool,
        lastUserReviewDocumentId: freezed == lastUserReviewDocumentId
            ? _value.lastUserReviewDocumentId
            : lastUserReviewDocumentId // ignore: cast_nullable_to_non_nullable
                as String?,
        lastPlanReviewDocumentId: freezed == lastPlanReviewDocumentId
            ? _value.lastPlanReviewDocumentId
            : lastPlanReviewDocumentId // ignore: cast_nullable_to_non_nullable
                as String?,
        lastReviewsByUserDocumentId: freezed == lastReviewsByUserDocumentId
            ? _value.lastReviewsByUserDocumentId
            : lastReviewsByUserDocumentId // ignore: cast_nullable_to_non_nullable
                as String?,
        lastPendingReviewDocumentId: freezed == lastPendingReviewDocumentId
            ? _value.lastPendingReviewDocumentId
            : lastPendingReviewDocumentId // ignore: cast_nullable_to_non_nullable
                as String?,
        currentUserRating: freezed == currentUserRating
            ? _value.currentUserRating
            : currentUserRating // ignore: cast_nullable_to_non_nullable
                as UserRatingEntity?,
        topRatedUsers: null == topRatedUsers
            ? _value._topRatedUsers
            : topRatedUsers // ignore: cast_nullable_to_non_nullable
                as List<UserRatingEntity>,
        lastCalculationResult: freezed == lastCalculationResult
            ? _value.lastCalculationResult
            : lastCalculationResult // ignore: cast_nullable_to_non_nullable
                as UserRatingCalculationResult?,
        lastUserReviewsResult: freezed == lastUserReviewsResult
            ? _value.lastUserReviewsResult
            : lastUserReviewsResult // ignore: cast_nullable_to_non_nullable
                as UserReviewsResult?,
        userRatingComparisons: null == userRatingComparisons
            ? _value._userRatingComparisons
            : userRatingComparisons // ignore: cast_nullable_to_non_nullable
                as List<UserRatingComparison>,
        lastCreatedReviewId: freezed == lastCreatedReviewId
            ? _value.lastCreatedReviewId
            : lastCreatedReviewId // ignore: cast_nullable_to_non_nullable
                as String?,
        lastUpdatedReviewId: freezed == lastUpdatedReviewId
            ? _value.lastUpdatedReviewId
            : lastUpdatedReviewId // ignore: cast_nullable_to_non_nullable
                as String?,
        lastDeletedReviewId: freezed == lastDeletedReviewId
            ? _value.lastDeletedReviewId
            : lastDeletedReviewId // ignore: cast_nullable_to_non_nullable
                as String?,
        helpfulReviewIds: null == helpfulReviewIds
            ? _value._helpfulReviewIds
            : helpfulReviewIds // ignore: cast_nullable_to_non_nullable
                as List<String>,
        lastApprovedReviewId: freezed == lastApprovedReviewId
            ? _value.lastApprovedReviewId
            : lastApprovedReviewId // ignore: cast_nullable_to_non_nullable
                as String?,
        lastRejectedReviewId: freezed == lastRejectedReviewId
            ? _value.lastRejectedReviewId
            : lastRejectedReviewId // ignore: cast_nullable_to_non_nullable
                as String?,
        lastFlaggedReviewId: freezed == lastFlaggedReviewId
            ? _value.lastFlaggedReviewId
            : lastFlaggedReviewId // ignore: cast_nullable_to_non_nullable
                as String?,
        reviewMetrics: freezed == reviewMetrics
            ? _value._reviewMetrics
            : reviewMetrics // ignore: cast_nullable_to_non_nullable
                as Map<String, dynamic>?,
        ratingDistribution: freezed == ratingDistribution
            ? _value._ratingDistribution
            : ratingDistribution // ignore: cast_nullable_to_non_nullable
                as Map<int, int>?,
        reviewTrends: freezed == reviewTrends
            ? _value._reviewTrends
            : reviewTrends // ignore: cast_nullable_to_non_nullable
                as Map<String, dynamic>?,
        canReviewPermissions: null == canReviewPermissions
            ? _value._canReviewPermissions
            : canReviewPermissions // ignore: cast_nullable_to_non_nullable
                as Map<String, bool>,
        lastRefreshTime: freezed == lastRefreshTime
            ? _value.lastRefreshTime
            : lastRefreshTime // ignore: cast_nullable_to_non_nullable
                as DateTime?,
        lastDataFetchTimes: null == lastDataFetchTimes
            ? _value._lastDataFetchTimes
            : lastDataFetchTimes // ignore: cast_nullable_to_non_nullable
                as Map<String, DateTime>,
        isRefreshing: null == isRefreshing
            ? _value.isRefreshing
            : isRefreshing // ignore: cast_nullable_to_non_nullable
                as bool,
      ),
    );
  }
}

/// @nodoc

class _$ReviewStateImpl implements _ReviewState {
  const _$ReviewStateImpl({
    this.status = ReviewStatus.initial,
    this.error,
    this.isLoading,
    final List<ReviewEntity> userReviews = const [],
    final List<ReviewEntity> planReviews = const [],
    final List<ReviewEntity> reviewsByUser = const [],
    final List<ReviewEntity> pendingReviews = const [],
    this.hasMoreUserReviews = false,
    this.hasMorePlanReviews = false,
    this.hasMoreReviewsByUser = false,
    this.hasMorePendingReviews = false,
    this.lastUserReviewDocumentId,
    this.lastPlanReviewDocumentId,
    this.lastReviewsByUserDocumentId,
    this.lastPendingReviewDocumentId,
    this.currentUserRating,
    final List<UserRatingEntity> topRatedUsers = const [],
    this.lastCalculationResult,
    this.lastUserReviewsResult,
    final List<UserRatingComparison> userRatingComparisons = const [],
    this.lastCreatedReviewId,
    this.lastUpdatedReviewId,
    this.lastDeletedReviewId,
    final List<String> helpfulReviewIds = const [],
    this.lastApprovedReviewId,
    this.lastRejectedReviewId,
    this.lastFlaggedReviewId,
    final Map<String, dynamic>? reviewMetrics,
    final Map<int, int>? ratingDistribution,
    final Map<String, dynamic>? reviewTrends,
    final Map<String, bool> canReviewPermissions = const {},
    this.lastRefreshTime,
    final Map<String, DateTime> lastDataFetchTimes = const {},
    this.isRefreshing = false,
  })  : _userReviews = userReviews,
        _planReviews = planReviews,
        _reviewsByUser = reviewsByUser,
        _pendingReviews = pendingReviews,
        _topRatedUsers = topRatedUsers,
        _userRatingComparisons = userRatingComparisons,
        _helpfulReviewIds = helpfulReviewIds,
        _reviewMetrics = reviewMetrics,
        _ratingDistribution = ratingDistribution,
        _reviewTrends = reviewTrends,
        _canReviewPermissions = canReviewPermissions,
        _lastDataFetchTimes = lastDataFetchTimes;

  // ==================== ESTADO GENERAL ====================
  @override
  @JsonKey()
  final ReviewStatus status;
  @override
  final String? error;
  @override
  final bool? isLoading;
  // ==================== RESEÑAS ====================
  final List<ReviewEntity> _userReviews;
  // ==================== RESEÑAS ====================
  @override
  @JsonKey()
  List<ReviewEntity> get userReviews {
    if (_userReviews is EqualUnmodifiableListView) return _userReviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userReviews);
  }

  final List<ReviewEntity> _planReviews;
  @override
  @JsonKey()
  List<ReviewEntity> get planReviews {
    if (_planReviews is EqualUnmodifiableListView) return _planReviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_planReviews);
  }

  final List<ReviewEntity> _reviewsByUser;
  @override
  @JsonKey()
  List<ReviewEntity> get reviewsByUser {
    if (_reviewsByUser is EqualUnmodifiableListView) return _reviewsByUser;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reviewsByUser);
  }

  final List<ReviewEntity> _pendingReviews;
  @override
  @JsonKey()
  List<ReviewEntity> get pendingReviews {
    if (_pendingReviews is EqualUnmodifiableListView) return _pendingReviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pendingReviews);
  }

  // ==================== PAGINACIÓN ====================
  @override
  @JsonKey()
  final bool hasMoreUserReviews;
  @override
  @JsonKey()
  final bool hasMorePlanReviews;
  @override
  @JsonKey()
  final bool hasMoreReviewsByUser;
  @override
  @JsonKey()
  final bool hasMorePendingReviews;
  @override
  final String? lastUserReviewDocumentId;
  @override
  final String? lastPlanReviewDocumentId;
  @override
  final String? lastReviewsByUserDocumentId;
  @override
  final String? lastPendingReviewDocumentId;
  // ==================== RATING DE USUARIO ====================
  @override
  final UserRatingEntity? currentUserRating;
  final List<UserRatingEntity> _topRatedUsers;
  @override
  @JsonKey()
  List<UserRatingEntity> get topRatedUsers {
    if (_topRatedUsers is EqualUnmodifiableListView) return _topRatedUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topRatedUsers);
  }

  @override
  final UserRatingCalculationResult? lastCalculationResult;
  @override
  final UserReviewsResult? lastUserReviewsResult;
  final List<UserRatingComparison> _userRatingComparisons;
  @override
  @JsonKey()
  List<UserRatingComparison> get userRatingComparisons {
    if (_userRatingComparisons is EqualUnmodifiableListView)
      return _userRatingComparisons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userRatingComparisons);
  }

  // ==================== ACCIONES ====================
  @override
  final String? lastCreatedReviewId;
  @override
  final String? lastUpdatedReviewId;
  @override
  final String? lastDeletedReviewId;
  final List<String> _helpfulReviewIds;
  @override
  @JsonKey()
  List<String> get helpfulReviewIds {
    if (_helpfulReviewIds is EqualUnmodifiableListView)
      return _helpfulReviewIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_helpfulReviewIds);
  }

  // ==================== MODERACIÓN ====================
  @override
  final String? lastApprovedReviewId;
  @override
  final String? lastRejectedReviewId;
  @override
  final String? lastFlaggedReviewId;
  // ==================== ANALYTICS ====================
  final Map<String, dynamic>? _reviewMetrics;
  // ==================== ANALYTICS ====================
  @override
  Map<String, dynamic>? get reviewMetrics {
    final value = _reviewMetrics;
    if (value == null) return null;
    if (_reviewMetrics is EqualUnmodifiableMapView) return _reviewMetrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<int, int>? _ratingDistribution;
  @override
  Map<int, int>? get ratingDistribution {
    final value = _ratingDistribution;
    if (value == null) return null;
    if (_ratingDistribution is EqualUnmodifiableMapView)
      return _ratingDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _reviewTrends;
  @override
  Map<String, dynamic>? get reviewTrends {
    final value = _reviewTrends;
    if (value == null) return null;
    if (_reviewTrends is EqualUnmodifiableMapView) return _reviewTrends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // ==================== PERMISOS ====================
  final Map<String, bool> _canReviewPermissions;
  // ==================== PERMISOS ====================
  @override
  @JsonKey()
  Map<String, bool> get canReviewPermissions {
    if (_canReviewPermissions is EqualUnmodifiableMapView)
      return _canReviewPermissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_canReviewPermissions);
  }

  // planId + targetUserId -> bool
  // ==================== CACHE Y PERFORMANCE ====================
  @override
  final DateTime? lastRefreshTime;
  final Map<String, DateTime> _lastDataFetchTimes;
  @override
  @JsonKey()
  Map<String, DateTime> get lastDataFetchTimes {
    if (_lastDataFetchTimes is EqualUnmodifiableMapView)
      return _lastDataFetchTimes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_lastDataFetchTimes);
  }

  @override
  @JsonKey()
  final bool isRefreshing;

  @override
  String toString() {
    return 'ReviewState(status: $status, error: $error, isLoading: $isLoading, userReviews: $userReviews, planReviews: $planReviews, reviewsByUser: $reviewsByUser, pendingReviews: $pendingReviews, hasMoreUserReviews: $hasMoreUserReviews, hasMorePlanReviews: $hasMorePlanReviews, hasMoreReviewsByUser: $hasMoreReviewsByUser, hasMorePendingReviews: $hasMorePendingReviews, lastUserReviewDocumentId: $lastUserReviewDocumentId, lastPlanReviewDocumentId: $lastPlanReviewDocumentId, lastReviewsByUserDocumentId: $lastReviewsByUserDocumentId, lastPendingReviewDocumentId: $lastPendingReviewDocumentId, currentUserRating: $currentUserRating, topRatedUsers: $topRatedUsers, lastCalculationResult: $lastCalculationResult, lastUserReviewsResult: $lastUserReviewsResult, userRatingComparisons: $userRatingComparisons, lastCreatedReviewId: $lastCreatedReviewId, lastUpdatedReviewId: $lastUpdatedReviewId, lastDeletedReviewId: $lastDeletedReviewId, helpfulReviewIds: $helpfulReviewIds, lastApprovedReviewId: $lastApprovedReviewId, lastRejectedReviewId: $lastRejectedReviewId, lastFlaggedReviewId: $lastFlaggedReviewId, reviewMetrics: $reviewMetrics, ratingDistribution: $ratingDistribution, reviewTrends: $reviewTrends, canReviewPermissions: $canReviewPermissions, lastRefreshTime: $lastRefreshTime, lastDataFetchTimes: $lastDataFetchTimes, isRefreshing: $isRefreshing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(
              other._userReviews,
              _userReviews,
            ) &&
            const DeepCollectionEquality().equals(
              other._planReviews,
              _planReviews,
            ) &&
            const DeepCollectionEquality().equals(
              other._reviewsByUser,
              _reviewsByUser,
            ) &&
            const DeepCollectionEquality().equals(
              other._pendingReviews,
              _pendingReviews,
            ) &&
            (identical(other.hasMoreUserReviews, hasMoreUserReviews) ||
                other.hasMoreUserReviews == hasMoreUserReviews) &&
            (identical(other.hasMorePlanReviews, hasMorePlanReviews) ||
                other.hasMorePlanReviews == hasMorePlanReviews) &&
            (identical(other.hasMoreReviewsByUser, hasMoreReviewsByUser) ||
                other.hasMoreReviewsByUser == hasMoreReviewsByUser) &&
            (identical(other.hasMorePendingReviews, hasMorePendingReviews) ||
                other.hasMorePendingReviews == hasMorePendingReviews) &&
            (identical(
                  other.lastUserReviewDocumentId,
                  lastUserReviewDocumentId,
                ) ||
                other.lastUserReviewDocumentId == lastUserReviewDocumentId) &&
            (identical(
                  other.lastPlanReviewDocumentId,
                  lastPlanReviewDocumentId,
                ) ||
                other.lastPlanReviewDocumentId == lastPlanReviewDocumentId) &&
            (identical(
                  other.lastReviewsByUserDocumentId,
                  lastReviewsByUserDocumentId,
                ) ||
                other.lastReviewsByUserDocumentId ==
                    lastReviewsByUserDocumentId) &&
            (identical(
                  other.lastPendingReviewDocumentId,
                  lastPendingReviewDocumentId,
                ) ||
                other.lastPendingReviewDocumentId ==
                    lastPendingReviewDocumentId) &&
            (identical(other.currentUserRating, currentUserRating) ||
                other.currentUserRating == currentUserRating) &&
            const DeepCollectionEquality().equals(
              other._topRatedUsers,
              _topRatedUsers,
            ) &&
            (identical(other.lastCalculationResult, lastCalculationResult) ||
                other.lastCalculationResult == lastCalculationResult) &&
            (identical(other.lastUserReviewsResult, lastUserReviewsResult) ||
                other.lastUserReviewsResult == lastUserReviewsResult) &&
            const DeepCollectionEquality().equals(
              other._userRatingComparisons,
              _userRatingComparisons,
            ) &&
            (identical(other.lastCreatedReviewId, lastCreatedReviewId) ||
                other.lastCreatedReviewId == lastCreatedReviewId) &&
            (identical(other.lastUpdatedReviewId, lastUpdatedReviewId) ||
                other.lastUpdatedReviewId == lastUpdatedReviewId) &&
            (identical(other.lastDeletedReviewId, lastDeletedReviewId) ||
                other.lastDeletedReviewId == lastDeletedReviewId) &&
            const DeepCollectionEquality().equals(
              other._helpfulReviewIds,
              _helpfulReviewIds,
            ) &&
            (identical(other.lastApprovedReviewId, lastApprovedReviewId) ||
                other.lastApprovedReviewId == lastApprovedReviewId) &&
            (identical(other.lastRejectedReviewId, lastRejectedReviewId) ||
                other.lastRejectedReviewId == lastRejectedReviewId) &&
            (identical(other.lastFlaggedReviewId, lastFlaggedReviewId) ||
                other.lastFlaggedReviewId == lastFlaggedReviewId) &&
            const DeepCollectionEquality().equals(
              other._reviewMetrics,
              _reviewMetrics,
            ) &&
            const DeepCollectionEquality().equals(
              other._ratingDistribution,
              _ratingDistribution,
            ) &&
            const DeepCollectionEquality().equals(
              other._reviewTrends,
              _reviewTrends,
            ) &&
            const DeepCollectionEquality().equals(
              other._canReviewPermissions,
              _canReviewPermissions,
            ) &&
            (identical(other.lastRefreshTime, lastRefreshTime) ||
                other.lastRefreshTime == lastRefreshTime) &&
            const DeepCollectionEquality().equals(
              other._lastDataFetchTimes,
              _lastDataFetchTimes,
            ) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        status,
        error,
        isLoading,
        const DeepCollectionEquality().hash(_userReviews),
        const DeepCollectionEquality().hash(_planReviews),
        const DeepCollectionEquality().hash(_reviewsByUser),
        const DeepCollectionEquality().hash(_pendingReviews),
        hasMoreUserReviews,
        hasMorePlanReviews,
        hasMoreReviewsByUser,
        hasMorePendingReviews,
        lastUserReviewDocumentId,
        lastPlanReviewDocumentId,
        lastReviewsByUserDocumentId,
        lastPendingReviewDocumentId,
        currentUserRating,
        const DeepCollectionEquality().hash(_topRatedUsers),
        lastCalculationResult,
        lastUserReviewsResult,
        const DeepCollectionEquality().hash(_userRatingComparisons),
        lastCreatedReviewId,
        lastUpdatedReviewId,
        lastDeletedReviewId,
        const DeepCollectionEquality().hash(_helpfulReviewIds),
        lastApprovedReviewId,
        lastRejectedReviewId,
        lastFlaggedReviewId,
        const DeepCollectionEquality().hash(_reviewMetrics),
        const DeepCollectionEquality().hash(_ratingDistribution),
        const DeepCollectionEquality().hash(_reviewTrends),
        const DeepCollectionEquality().hash(_canReviewPermissions),
        lastRefreshTime,
        const DeepCollectionEquality().hash(_lastDataFetchTimes),
        isRefreshing,
      ]);

  /// Create a copy of ReviewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewStateImplCopyWith<_$ReviewStateImpl> get copyWith =>
      __$$ReviewStateImplCopyWithImpl<_$ReviewStateImpl>(this, _$identity);
}

abstract class _ReviewState implements ReviewState {
  const factory _ReviewState({
    final ReviewStatus status,
    final String? error,
    final bool? isLoading,
    final List<ReviewEntity> userReviews,
    final List<ReviewEntity> planReviews,
    final List<ReviewEntity> reviewsByUser,
    final List<ReviewEntity> pendingReviews,
    final bool hasMoreUserReviews,
    final bool hasMorePlanReviews,
    final bool hasMoreReviewsByUser,
    final bool hasMorePendingReviews,
    final String? lastUserReviewDocumentId,
    final String? lastPlanReviewDocumentId,
    final String? lastReviewsByUserDocumentId,
    final String? lastPendingReviewDocumentId,
    final UserRatingEntity? currentUserRating,
    final List<UserRatingEntity> topRatedUsers,
    final UserRatingCalculationResult? lastCalculationResult,
    final UserReviewsResult? lastUserReviewsResult,
    final List<UserRatingComparison> userRatingComparisons,
    final String? lastCreatedReviewId,
    final String? lastUpdatedReviewId,
    final String? lastDeletedReviewId,
    final List<String> helpfulReviewIds,
    final String? lastApprovedReviewId,
    final String? lastRejectedReviewId,
    final String? lastFlaggedReviewId,
    final Map<String, dynamic>? reviewMetrics,
    final Map<int, int>? ratingDistribution,
    final Map<String, dynamic>? reviewTrends,
    final Map<String, bool> canReviewPermissions,
    final DateTime? lastRefreshTime,
    final Map<String, DateTime> lastDataFetchTimes,
    final bool isRefreshing,
  }) = _$ReviewStateImpl;

  // ==================== ESTADO GENERAL ====================
  @override
  ReviewStatus get status;
  @override
  String? get error;
  @override
  bool? get isLoading; // ==================== RESEÑAS ====================
  @override
  List<ReviewEntity> get userReviews;
  @override
  List<ReviewEntity> get planReviews;
  @override
  List<ReviewEntity> get reviewsByUser;
  @override
  List<ReviewEntity>
      get pendingReviews; // ==================== PAGINACIÓN ====================
  @override
  bool get hasMoreUserReviews;
  @override
  bool get hasMorePlanReviews;
  @override
  bool get hasMoreReviewsByUser;
  @override
  bool get hasMorePendingReviews;
  @override
  String? get lastUserReviewDocumentId;
  @override
  String? get lastPlanReviewDocumentId;
  @override
  String? get lastReviewsByUserDocumentId;
  @override
  String?
      get lastPendingReviewDocumentId; // ==================== RATING DE USUARIO ====================
  @override
  UserRatingEntity? get currentUserRating;
  @override
  List<UserRatingEntity> get topRatedUsers;
  @override
  UserRatingCalculationResult? get lastCalculationResult;
  @override
  UserReviewsResult? get lastUserReviewsResult;
  @override
  List<UserRatingComparison>
      get userRatingComparisons; // ==================== ACCIONES ====================
  @override
  String? get lastCreatedReviewId;
  @override
  String? get lastUpdatedReviewId;
  @override
  String? get lastDeletedReviewId;
  @override
  List<String>
      get helpfulReviewIds; // ==================== MODERACIÓN ====================
  @override
  String? get lastApprovedReviewId;
  @override
  String? get lastRejectedReviewId;
  @override
  String?
      get lastFlaggedReviewId; // ==================== ANALYTICS ====================
  @override
  Map<String, dynamic>? get reviewMetrics;
  @override
  Map<int, int>? get ratingDistribution;
  @override
  Map<String, dynamic>?
      get reviewTrends; // ==================== PERMISOS ====================
  @override
  Map<String, bool> get canReviewPermissions; // planId + targetUserId -> bool
  // ==================== CACHE Y PERFORMANCE ====================
  @override
  DateTime? get lastRefreshTime;
  @override
  Map<String, DateTime> get lastDataFetchTimes;
  @override
  bool get isRefreshing;

  /// Create a copy of ReviewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewStateImplCopyWith<_$ReviewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
