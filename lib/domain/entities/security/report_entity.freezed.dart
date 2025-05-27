// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReportEntity _$ReportEntityFromJson(Map<String, dynamic> json) {
  return _ReportEntity.fromJson(json);
}

/// @nodoc
mixin _$ReportEntity {
  String get id => throw _privateConstructorUsedError;
  String get reporterId => throw _privateConstructorUsedError;
  String get reportedUserId => throw _privateConstructorUsedError;
  String? get reportedPlanId => throw _privateConstructorUsedError;
  ReportType get type => throw _privateConstructorUsedError;
  ReportReason get reason => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  ReportStatus get status => throw _privateConstructorUsedError;
  String? get moderatorId => throw _privateConstructorUsedError;
  String? get moderatorNotes => throw _privateConstructorUsedError;
  DateTime? get resolvedAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get evidence => throw _privateConstructorUsedError;

  /// Serializes this ReportEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportEntityCopyWith<ReportEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportEntityCopyWith<$Res> {
  factory $ReportEntityCopyWith(
    ReportEntity value,
    $Res Function(ReportEntity) then,
  ) = _$ReportEntityCopyWithImpl<$Res, ReportEntity>;
  @useResult
  $Res call({
    String id,
    String reporterId,
    String reportedUserId,
    String? reportedPlanId,
    ReportType type,
    ReportReason reason,
    String description,
    DateTime createdAt,
    ReportStatus status,
    String? moderatorId,
    String? moderatorNotes,
    DateTime? resolvedAt,
    Map<String, dynamic>? evidence,
  });
}

/// @nodoc
class _$ReportEntityCopyWithImpl<$Res, $Val extends ReportEntity>
    implements $ReportEntityCopyWith<$Res> {
  _$ReportEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reporterId = null,
    Object? reportedUserId = null,
    Object? reportedPlanId = freezed,
    Object? type = null,
    Object? reason = null,
    Object? description = null,
    Object? createdAt = null,
    Object? status = null,
    Object? moderatorId = freezed,
    Object? moderatorNotes = freezed,
    Object? resolvedAt = freezed,
    Object? evidence = freezed,
  }) {
    return _then(
      _value.copyWith(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                as String,
        reporterId: null == reporterId
            ? _value.reporterId
            : reporterId // ignore: cast_nullable_to_non_nullable
                as String,
        reportedUserId: null == reportedUserId
            ? _value.reportedUserId
            : reportedUserId // ignore: cast_nullable_to_non_nullable
                as String,
        reportedPlanId: freezed == reportedPlanId
            ? _value.reportedPlanId
            : reportedPlanId // ignore: cast_nullable_to_non_nullable
                as String?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                as ReportType,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                as ReportReason,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                as ReportStatus,
        moderatorId: freezed == moderatorId
            ? _value.moderatorId
            : moderatorId // ignore: cast_nullable_to_non_nullable
                as String?,
        moderatorNotes: freezed == moderatorNotes
            ? _value.moderatorNotes
            : moderatorNotes // ignore: cast_nullable_to_non_nullable
                as String?,
        resolvedAt: freezed == resolvedAt
            ? _value.resolvedAt
            : resolvedAt // ignore: cast_nullable_to_non_nullable
                as DateTime?,
        evidence: freezed == evidence
            ? _value.evidence
            : evidence // ignore: cast_nullable_to_non_nullable
                as Map<String, dynamic>?,
      ) as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportEntityImplCopyWith<$Res>
    implements $ReportEntityCopyWith<$Res> {
  factory _$$ReportEntityImplCopyWith(
    _$ReportEntityImpl value,
    $Res Function(_$ReportEntityImpl) then,
  ) = __$$ReportEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String reporterId,
    String reportedUserId,
    String? reportedPlanId,
    ReportType type,
    ReportReason reason,
    String description,
    DateTime createdAt,
    ReportStatus status,
    String? moderatorId,
    String? moderatorNotes,
    DateTime? resolvedAt,
    Map<String, dynamic>? evidence,
  });
}

/// @nodoc
class __$$ReportEntityImplCopyWithImpl<$Res>
    extends _$ReportEntityCopyWithImpl<$Res, _$ReportEntityImpl>
    implements _$$ReportEntityImplCopyWith<$Res> {
  __$$ReportEntityImplCopyWithImpl(
    _$ReportEntityImpl _value,
    $Res Function(_$ReportEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reporterId = null,
    Object? reportedUserId = null,
    Object? reportedPlanId = freezed,
    Object? type = null,
    Object? reason = null,
    Object? description = null,
    Object? createdAt = null,
    Object? status = null,
    Object? moderatorId = freezed,
    Object? moderatorNotes = freezed,
    Object? resolvedAt = freezed,
    Object? evidence = freezed,
  }) {
    return _then(
      _$ReportEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                as String,
        reporterId: null == reporterId
            ? _value.reporterId
            : reporterId // ignore: cast_nullable_to_non_nullable
                as String,
        reportedUserId: null == reportedUserId
            ? _value.reportedUserId
            : reportedUserId // ignore: cast_nullable_to_non_nullable
                as String,
        reportedPlanId: freezed == reportedPlanId
            ? _value.reportedPlanId
            : reportedPlanId // ignore: cast_nullable_to_non_nullable
                as String?,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                as ReportType,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                as ReportReason,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                as ReportStatus,
        moderatorId: freezed == moderatorId
            ? _value.moderatorId
            : moderatorId // ignore: cast_nullable_to_non_nullable
                as String?,
        moderatorNotes: freezed == moderatorNotes
            ? _value.moderatorNotes
            : moderatorNotes // ignore: cast_nullable_to_non_nullable
                as String?,
        resolvedAt: freezed == resolvedAt
            ? _value.resolvedAt
            : resolvedAt // ignore: cast_nullable_to_non_nullable
                as DateTime?,
        evidence: freezed == evidence
            ? _value._evidence
            : evidence // ignore: cast_nullable_to_non_nullable
                as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportEntityImpl implements _ReportEntity {
  const _$ReportEntityImpl({
    required this.id,
    required this.reporterId,
    required this.reportedUserId,
    this.reportedPlanId,
    required this.type,
    required this.reason,
    required this.description,
    required this.createdAt,
    this.status = ReportStatus.pending,
    this.moderatorId,
    this.moderatorNotes,
    this.resolvedAt,
    final Map<String, dynamic>? evidence,
  }) : _evidence = evidence;

  factory _$ReportEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String reporterId;
  @override
  final String reportedUserId;
  @override
  final String? reportedPlanId;
  @override
  final ReportType type;
  @override
  final ReportReason reason;
  @override
  final String description;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final ReportStatus status;
  @override
  final String? moderatorId;
  @override
  final String? moderatorNotes;
  @override
  final DateTime? resolvedAt;
  final Map<String, dynamic>? _evidence;
  @override
  Map<String, dynamic>? get evidence {
    final value = _evidence;
    if (value == null) return null;
    if (_evidence is EqualUnmodifiableMapView) return _evidence;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ReportEntity(id: $id, reporterId: $reporterId, reportedUserId: $reportedUserId, reportedPlanId: $reportedPlanId, type: $type, reason: $reason, description: $description, createdAt: $createdAt, status: $status, moderatorId: $moderatorId, moderatorNotes: $moderatorNotes, resolvedAt: $resolvedAt, evidence: $evidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reporterId, reporterId) ||
                other.reporterId == reporterId) &&
            (identical(other.reportedUserId, reportedUserId) ||
                other.reportedUserId == reportedUserId) &&
            (identical(other.reportedPlanId, reportedPlanId) ||
                other.reportedPlanId == reportedPlanId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.moderatorId, moderatorId) ||
                other.moderatorId == moderatorId) &&
            (identical(other.moderatorNotes, moderatorNotes) ||
                other.moderatorNotes == moderatorNotes) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt) &&
            const DeepCollectionEquality().equals(other._evidence, _evidence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
        runtimeType,
        id,
        reporterId,
        reportedUserId,
        reportedPlanId,
        type,
        reason,
        description,
        createdAt,
        status,
        moderatorId,
        moderatorNotes,
        resolvedAt,
        const DeepCollectionEquality().hash(_evidence),
      );

  /// Create a copy of ReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportEntityImplCopyWith<_$ReportEntityImpl> get copyWith =>
      __$$ReportEntityImplCopyWithImpl<_$ReportEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportEntityImplToJson(this);
  }
}

abstract class _ReportEntity implements ReportEntity {
  const factory _ReportEntity({
    required final String id,
    required final String reporterId,
    required final String reportedUserId,
    final String? reportedPlanId,
    required final ReportType type,
    required final ReportReason reason,
    required final String description,
    required final DateTime createdAt,
    final ReportStatus status,
    final String? moderatorId,
    final String? moderatorNotes,
    final DateTime? resolvedAt,
    final Map<String, dynamic>? evidence,
  }) = _$ReportEntityImpl;

  factory _ReportEntity.fromJson(Map<String, dynamic> json) =
      _$ReportEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get reporterId;
  @override
  String get reportedUserId;
  @override
  String? get reportedPlanId;
  @override
  ReportType get type;
  @override
  ReportReason get reason;
  @override
  String get description;
  @override
  DateTime get createdAt;
  @override
  ReportStatus get status;
  @override
  String? get moderatorId;
  @override
  String? get moderatorNotes;
  @override
  DateTime? get resolvedAt;
  @override
  Map<String, dynamic>? get evidence;

  /// Create a copy of ReportEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportEntityImplCopyWith<_$ReportEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
