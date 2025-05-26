// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'security_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SecurityEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reportedUserId,
      String? reportedPlanId,
      ReportType type,
      ReportReason reason,
      String description,
      Map<String, dynamic>? evidence,
    )
    createReport,
    required TResult Function(
      String blockedUserId,
      ReportReason? reason,
      String? description,
    )
    blockUser,
    required TResult Function() loadPendingReports,
    required TResult Function(String userId) loadReportsByUser,
    required TResult Function(
      String reportId,
      ReportStatus status,
      String? moderatorNotes,
    )
    updateReportStatus,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reportedUserId,
      String? reportedPlanId,
      ReportType type,
      ReportReason reason,
      String description,
      Map<String, dynamic>? evidence,
    )?
    createReport,
    TResult? Function(
      String blockedUserId,
      ReportReason? reason,
      String? description,
    )?
    blockUser,
    TResult? Function()? loadPendingReports,
    TResult? Function(String userId)? loadReportsByUser,
    TResult? Function(
      String reportId,
      ReportStatus status,
      String? moderatorNotes,
    )?
    updateReportStatus,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reportedUserId,
      String? reportedPlanId,
      ReportType type,
      ReportReason reason,
      String description,
      Map<String, dynamic>? evidence,
    )?
    createReport,
    TResult Function(
      String blockedUserId,
      ReportReason? reason,
      String? description,
    )?
    blockUser,
    TResult Function()? loadPendingReports,
    TResult Function(String userId)? loadReportsByUser,
    TResult Function(
      String reportId,
      ReportStatus status,
      String? moderatorNotes,
    )?
    updateReportStatus,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReportEvent value) createReport,
    required TResult Function(BlockUserEvent value) blockUser,
    required TResult Function(LoadPendingReportsEvent value) loadPendingReports,
    required TResult Function(LoadReportsByUserEvent value) loadReportsByUser,
    required TResult Function(UpdateReportStatusEvent value) updateReportStatus,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReportEvent value)? createReport,
    TResult? Function(BlockUserEvent value)? blockUser,
    TResult? Function(LoadPendingReportsEvent value)? loadPendingReports,
    TResult? Function(LoadReportsByUserEvent value)? loadReportsByUser,
    TResult? Function(UpdateReportStatusEvent value)? updateReportStatus,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReportEvent value)? createReport,
    TResult Function(BlockUserEvent value)? blockUser,
    TResult Function(LoadPendingReportsEvent value)? loadPendingReports,
    TResult Function(LoadReportsByUserEvent value)? loadReportsByUser,
    TResult Function(UpdateReportStatusEvent value)? updateReportStatus,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SecurityEventCopyWith<$Res> {
  factory $SecurityEventCopyWith(
    SecurityEvent value,
    $Res Function(SecurityEvent) then,
  ) = _$SecurityEventCopyWithImpl<$Res, SecurityEvent>;
}

/// @nodoc
class _$SecurityEventCopyWithImpl<$Res, $Val extends SecurityEvent>
    implements $SecurityEventCopyWith<$Res> {
  _$SecurityEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SecurityEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CreateReportEventImplCopyWith<$Res> {
  factory _$$CreateReportEventImplCopyWith(
    _$CreateReportEventImpl value,
    $Res Function(_$CreateReportEventImpl) then,
  ) = __$$CreateReportEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String reportedUserId,
    String? reportedPlanId,
    ReportType type,
    ReportReason reason,
    String description,
    Map<String, dynamic>? evidence,
  });
}

/// @nodoc
class __$$CreateReportEventImplCopyWithImpl<$Res>
    extends _$SecurityEventCopyWithImpl<$Res, _$CreateReportEventImpl>
    implements _$$CreateReportEventImplCopyWith<$Res> {
  __$$CreateReportEventImplCopyWithImpl(
    _$CreateReportEventImpl _value,
    $Res Function(_$CreateReportEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SecurityEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reportedUserId = null,
    Object? reportedPlanId = freezed,
    Object? type = null,
    Object? reason = null,
    Object? description = null,
    Object? evidence = freezed,
  }) {
    return _then(
      _$CreateReportEventImpl(
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
        evidence: freezed == evidence
            ? _value._evidence
            : evidence // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc

class _$CreateReportEventImpl implements CreateReportEvent {
  const _$CreateReportEventImpl({
    required this.reportedUserId,
    this.reportedPlanId,
    required this.type,
    required this.reason,
    required this.description,
    final Map<String, dynamic>? evidence,
  }) : _evidence = evidence;

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
    return 'SecurityEvent.createReport(reportedUserId: $reportedUserId, reportedPlanId: $reportedPlanId, type: $type, reason: $reason, description: $description, evidence: $evidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateReportEventImpl &&
            (identical(other.reportedUserId, reportedUserId) ||
                other.reportedUserId == reportedUserId) &&
            (identical(other.reportedPlanId, reportedPlanId) ||
                other.reportedPlanId == reportedPlanId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._evidence, _evidence));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    reportedUserId,
    reportedPlanId,
    type,
    reason,
    description,
    const DeepCollectionEquality().hash(_evidence),
  );

  /// Create a copy of SecurityEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateReportEventImplCopyWith<_$CreateReportEventImpl> get copyWith =>
      __$$CreateReportEventImplCopyWithImpl<_$CreateReportEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reportedUserId,
      String? reportedPlanId,
      ReportType type,
      ReportReason reason,
      String description,
      Map<String, dynamic>? evidence,
    )
    createReport,
    required TResult Function(
      String blockedUserId,
      ReportReason? reason,
      String? description,
    )
    blockUser,
    required TResult Function() loadPendingReports,
    required TResult Function(String userId) loadReportsByUser,
    required TResult Function(
      String reportId,
      ReportStatus status,
      String? moderatorNotes,
    )
    updateReportStatus,
  }) {
    return createReport(
      reportedUserId,
      reportedPlanId,
      type,
      reason,
      description,
      evidence,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reportedUserId,
      String? reportedPlanId,
      ReportType type,
      ReportReason reason,
      String description,
      Map<String, dynamic>? evidence,
    )?
    createReport,
    TResult? Function(
      String blockedUserId,
      ReportReason? reason,
      String? description,
    )?
    blockUser,
    TResult? Function()? loadPendingReports,
    TResult? Function(String userId)? loadReportsByUser,
    TResult? Function(
      String reportId,
      ReportStatus status,
      String? moderatorNotes,
    )?
    updateReportStatus,
  }) {
    return createReport?.call(
      reportedUserId,
      reportedPlanId,
      type,
      reason,
      description,
      evidence,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reportedUserId,
      String? reportedPlanId,
      ReportType type,
      ReportReason reason,
      String description,
      Map<String, dynamic>? evidence,
    )?
    createReport,
    TResult Function(
      String blockedUserId,
      ReportReason? reason,
      String? description,
    )?
    blockUser,
    TResult Function()? loadPendingReports,
    TResult Function(String userId)? loadReportsByUser,
    TResult Function(
      String reportId,
      ReportStatus status,
      String? moderatorNotes,
    )?
    updateReportStatus,
    required TResult orElse(),
  }) {
    if (createReport != null) {
      return createReport(
        reportedUserId,
        reportedPlanId,
        type,
        reason,
        description,
        evidence,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReportEvent value) createReport,
    required TResult Function(BlockUserEvent value) blockUser,
    required TResult Function(LoadPendingReportsEvent value) loadPendingReports,
    required TResult Function(LoadReportsByUserEvent value) loadReportsByUser,
    required TResult Function(UpdateReportStatusEvent value) updateReportStatus,
  }) {
    return createReport(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReportEvent value)? createReport,
    TResult? Function(BlockUserEvent value)? blockUser,
    TResult? Function(LoadPendingReportsEvent value)? loadPendingReports,
    TResult? Function(LoadReportsByUserEvent value)? loadReportsByUser,
    TResult? Function(UpdateReportStatusEvent value)? updateReportStatus,
  }) {
    return createReport?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReportEvent value)? createReport,
    TResult Function(BlockUserEvent value)? blockUser,
    TResult Function(LoadPendingReportsEvent value)? loadPendingReports,
    TResult Function(LoadReportsByUserEvent value)? loadReportsByUser,
    TResult Function(UpdateReportStatusEvent value)? updateReportStatus,
    required TResult orElse(),
  }) {
    if (createReport != null) {
      return createReport(this);
    }
    return orElse();
  }
}

abstract class CreateReportEvent implements SecurityEvent {
  const factory CreateReportEvent({
    required final String reportedUserId,
    final String? reportedPlanId,
    required final ReportType type,
    required final ReportReason reason,
    required final String description,
    final Map<String, dynamic>? evidence,
  }) = _$CreateReportEventImpl;

  String get reportedUserId;
  String? get reportedPlanId;
  ReportType get type;
  ReportReason get reason;
  String get description;
  Map<String, dynamic>? get evidence;

  /// Create a copy of SecurityEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateReportEventImplCopyWith<_$CreateReportEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BlockUserEventImplCopyWith<$Res> {
  factory _$$BlockUserEventImplCopyWith(
    _$BlockUserEventImpl value,
    $Res Function(_$BlockUserEventImpl) then,
  ) = __$$BlockUserEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String blockedUserId, ReportReason? reason, String? description});
}

/// @nodoc
class __$$BlockUserEventImplCopyWithImpl<$Res>
    extends _$SecurityEventCopyWithImpl<$Res, _$BlockUserEventImpl>
    implements _$$BlockUserEventImplCopyWith<$Res> {
  __$$BlockUserEventImplCopyWithImpl(
    _$BlockUserEventImpl _value,
    $Res Function(_$BlockUserEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SecurityEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blockedUserId = null,
    Object? reason = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _$BlockUserEventImpl(
        blockedUserId: null == blockedUserId
            ? _value.blockedUserId
            : blockedUserId // ignore: cast_nullable_to_non_nullable
                  as String,
        reason: freezed == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as ReportReason?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$BlockUserEventImpl implements BlockUserEvent {
  const _$BlockUserEventImpl({
    required this.blockedUserId,
    this.reason,
    this.description,
  });

  @override
  final String blockedUserId;
  @override
  final ReportReason? reason;
  @override
  final String? description;

  @override
  String toString() {
    return 'SecurityEvent.blockUser(blockedUserId: $blockedUserId, reason: $reason, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlockUserEventImpl &&
            (identical(other.blockedUserId, blockedUserId) ||
                other.blockedUserId == blockedUserId) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, blockedUserId, reason, description);

  /// Create a copy of SecurityEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BlockUserEventImplCopyWith<_$BlockUserEventImpl> get copyWith =>
      __$$BlockUserEventImplCopyWithImpl<_$BlockUserEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reportedUserId,
      String? reportedPlanId,
      ReportType type,
      ReportReason reason,
      String description,
      Map<String, dynamic>? evidence,
    )
    createReport,
    required TResult Function(
      String blockedUserId,
      ReportReason? reason,
      String? description,
    )
    blockUser,
    required TResult Function() loadPendingReports,
    required TResult Function(String userId) loadReportsByUser,
    required TResult Function(
      String reportId,
      ReportStatus status,
      String? moderatorNotes,
    )
    updateReportStatus,
  }) {
    return blockUser(blockedUserId, reason, description);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reportedUserId,
      String? reportedPlanId,
      ReportType type,
      ReportReason reason,
      String description,
      Map<String, dynamic>? evidence,
    )?
    createReport,
    TResult? Function(
      String blockedUserId,
      ReportReason? reason,
      String? description,
    )?
    blockUser,
    TResult? Function()? loadPendingReports,
    TResult? Function(String userId)? loadReportsByUser,
    TResult? Function(
      String reportId,
      ReportStatus status,
      String? moderatorNotes,
    )?
    updateReportStatus,
  }) {
    return blockUser?.call(blockedUserId, reason, description);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reportedUserId,
      String? reportedPlanId,
      ReportType type,
      ReportReason reason,
      String description,
      Map<String, dynamic>? evidence,
    )?
    createReport,
    TResult Function(
      String blockedUserId,
      ReportReason? reason,
      String? description,
    )?
    blockUser,
    TResult Function()? loadPendingReports,
    TResult Function(String userId)? loadReportsByUser,
    TResult Function(
      String reportId,
      ReportStatus status,
      String? moderatorNotes,
    )?
    updateReportStatus,
    required TResult orElse(),
  }) {
    if (blockUser != null) {
      return blockUser(blockedUserId, reason, description);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReportEvent value) createReport,
    required TResult Function(BlockUserEvent value) blockUser,
    required TResult Function(LoadPendingReportsEvent value) loadPendingReports,
    required TResult Function(LoadReportsByUserEvent value) loadReportsByUser,
    required TResult Function(UpdateReportStatusEvent value) updateReportStatus,
  }) {
    return blockUser(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReportEvent value)? createReport,
    TResult? Function(BlockUserEvent value)? blockUser,
    TResult? Function(LoadPendingReportsEvent value)? loadPendingReports,
    TResult? Function(LoadReportsByUserEvent value)? loadReportsByUser,
    TResult? Function(UpdateReportStatusEvent value)? updateReportStatus,
  }) {
    return blockUser?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReportEvent value)? createReport,
    TResult Function(BlockUserEvent value)? blockUser,
    TResult Function(LoadPendingReportsEvent value)? loadPendingReports,
    TResult Function(LoadReportsByUserEvent value)? loadReportsByUser,
    TResult Function(UpdateReportStatusEvent value)? updateReportStatus,
    required TResult orElse(),
  }) {
    if (blockUser != null) {
      return blockUser(this);
    }
    return orElse();
  }
}

abstract class BlockUserEvent implements SecurityEvent {
  const factory BlockUserEvent({
    required final String blockedUserId,
    final ReportReason? reason,
    final String? description,
  }) = _$BlockUserEventImpl;

  String get blockedUserId;
  ReportReason? get reason;
  String? get description;

  /// Create a copy of SecurityEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BlockUserEventImplCopyWith<_$BlockUserEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadPendingReportsEventImplCopyWith<$Res> {
  factory _$$LoadPendingReportsEventImplCopyWith(
    _$LoadPendingReportsEventImpl value,
    $Res Function(_$LoadPendingReportsEventImpl) then,
  ) = __$$LoadPendingReportsEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadPendingReportsEventImplCopyWithImpl<$Res>
    extends _$SecurityEventCopyWithImpl<$Res, _$LoadPendingReportsEventImpl>
    implements _$$LoadPendingReportsEventImplCopyWith<$Res> {
  __$$LoadPendingReportsEventImplCopyWithImpl(
    _$LoadPendingReportsEventImpl _value,
    $Res Function(_$LoadPendingReportsEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SecurityEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadPendingReportsEventImpl implements LoadPendingReportsEvent {
  const _$LoadPendingReportsEventImpl();

  @override
  String toString() {
    return 'SecurityEvent.loadPendingReports()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadPendingReportsEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reportedUserId,
      String? reportedPlanId,
      ReportType type,
      ReportReason reason,
      String description,
      Map<String, dynamic>? evidence,
    )
    createReport,
    required TResult Function(
      String blockedUserId,
      ReportReason? reason,
      String? description,
    )
    blockUser,
    required TResult Function() loadPendingReports,
    required TResult Function(String userId) loadReportsByUser,
    required TResult Function(
      String reportId,
      ReportStatus status,
      String? moderatorNotes,
    )
    updateReportStatus,
  }) {
    return loadPendingReports();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reportedUserId,
      String? reportedPlanId,
      ReportType type,
      ReportReason reason,
      String description,
      Map<String, dynamic>? evidence,
    )?
    createReport,
    TResult? Function(
      String blockedUserId,
      ReportReason? reason,
      String? description,
    )?
    blockUser,
    TResult? Function()? loadPendingReports,
    TResult? Function(String userId)? loadReportsByUser,
    TResult? Function(
      String reportId,
      ReportStatus status,
      String? moderatorNotes,
    )?
    updateReportStatus,
  }) {
    return loadPendingReports?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reportedUserId,
      String? reportedPlanId,
      ReportType type,
      ReportReason reason,
      String description,
      Map<String, dynamic>? evidence,
    )?
    createReport,
    TResult Function(
      String blockedUserId,
      ReportReason? reason,
      String? description,
    )?
    blockUser,
    TResult Function()? loadPendingReports,
    TResult Function(String userId)? loadReportsByUser,
    TResult Function(
      String reportId,
      ReportStatus status,
      String? moderatorNotes,
    )?
    updateReportStatus,
    required TResult orElse(),
  }) {
    if (loadPendingReports != null) {
      return loadPendingReports();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReportEvent value) createReport,
    required TResult Function(BlockUserEvent value) blockUser,
    required TResult Function(LoadPendingReportsEvent value) loadPendingReports,
    required TResult Function(LoadReportsByUserEvent value) loadReportsByUser,
    required TResult Function(UpdateReportStatusEvent value) updateReportStatus,
  }) {
    return loadPendingReports(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReportEvent value)? createReport,
    TResult? Function(BlockUserEvent value)? blockUser,
    TResult? Function(LoadPendingReportsEvent value)? loadPendingReports,
    TResult? Function(LoadReportsByUserEvent value)? loadReportsByUser,
    TResult? Function(UpdateReportStatusEvent value)? updateReportStatus,
  }) {
    return loadPendingReports?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReportEvent value)? createReport,
    TResult Function(BlockUserEvent value)? blockUser,
    TResult Function(LoadPendingReportsEvent value)? loadPendingReports,
    TResult Function(LoadReportsByUserEvent value)? loadReportsByUser,
    TResult Function(UpdateReportStatusEvent value)? updateReportStatus,
    required TResult orElse(),
  }) {
    if (loadPendingReports != null) {
      return loadPendingReports(this);
    }
    return orElse();
  }
}

abstract class LoadPendingReportsEvent implements SecurityEvent {
  const factory LoadPendingReportsEvent() = _$LoadPendingReportsEventImpl;
}

/// @nodoc
abstract class _$$LoadReportsByUserEventImplCopyWith<$Res> {
  factory _$$LoadReportsByUserEventImplCopyWith(
    _$LoadReportsByUserEventImpl value,
    $Res Function(_$LoadReportsByUserEventImpl) then,
  ) = __$$LoadReportsByUserEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String userId});
}

/// @nodoc
class __$$LoadReportsByUserEventImplCopyWithImpl<$Res>
    extends _$SecurityEventCopyWithImpl<$Res, _$LoadReportsByUserEventImpl>
    implements _$$LoadReportsByUserEventImplCopyWith<$Res> {
  __$$LoadReportsByUserEventImplCopyWithImpl(
    _$LoadReportsByUserEventImpl _value,
    $Res Function(_$LoadReportsByUserEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SecurityEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userId = null}) {
    return _then(
      _$LoadReportsByUserEventImpl(
        null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$LoadReportsByUserEventImpl implements LoadReportsByUserEvent {
  const _$LoadReportsByUserEventImpl(this.userId);

  @override
  final String userId;

  @override
  String toString() {
    return 'SecurityEvent.loadReportsByUser(userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadReportsByUserEventImpl &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId);

  /// Create a copy of SecurityEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadReportsByUserEventImplCopyWith<_$LoadReportsByUserEventImpl>
  get copyWith =>
      __$$LoadReportsByUserEventImplCopyWithImpl<_$LoadReportsByUserEventImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reportedUserId,
      String? reportedPlanId,
      ReportType type,
      ReportReason reason,
      String description,
      Map<String, dynamic>? evidence,
    )
    createReport,
    required TResult Function(
      String blockedUserId,
      ReportReason? reason,
      String? description,
    )
    blockUser,
    required TResult Function() loadPendingReports,
    required TResult Function(String userId) loadReportsByUser,
    required TResult Function(
      String reportId,
      ReportStatus status,
      String? moderatorNotes,
    )
    updateReportStatus,
  }) {
    return loadReportsByUser(userId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reportedUserId,
      String? reportedPlanId,
      ReportType type,
      ReportReason reason,
      String description,
      Map<String, dynamic>? evidence,
    )?
    createReport,
    TResult? Function(
      String blockedUserId,
      ReportReason? reason,
      String? description,
    )?
    blockUser,
    TResult? Function()? loadPendingReports,
    TResult? Function(String userId)? loadReportsByUser,
    TResult? Function(
      String reportId,
      ReportStatus status,
      String? moderatorNotes,
    )?
    updateReportStatus,
  }) {
    return loadReportsByUser?.call(userId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reportedUserId,
      String? reportedPlanId,
      ReportType type,
      ReportReason reason,
      String description,
      Map<String, dynamic>? evidence,
    )?
    createReport,
    TResult Function(
      String blockedUserId,
      ReportReason? reason,
      String? description,
    )?
    blockUser,
    TResult Function()? loadPendingReports,
    TResult Function(String userId)? loadReportsByUser,
    TResult Function(
      String reportId,
      ReportStatus status,
      String? moderatorNotes,
    )?
    updateReportStatus,
    required TResult orElse(),
  }) {
    if (loadReportsByUser != null) {
      return loadReportsByUser(userId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReportEvent value) createReport,
    required TResult Function(BlockUserEvent value) blockUser,
    required TResult Function(LoadPendingReportsEvent value) loadPendingReports,
    required TResult Function(LoadReportsByUserEvent value) loadReportsByUser,
    required TResult Function(UpdateReportStatusEvent value) updateReportStatus,
  }) {
    return loadReportsByUser(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReportEvent value)? createReport,
    TResult? Function(BlockUserEvent value)? blockUser,
    TResult? Function(LoadPendingReportsEvent value)? loadPendingReports,
    TResult? Function(LoadReportsByUserEvent value)? loadReportsByUser,
    TResult? Function(UpdateReportStatusEvent value)? updateReportStatus,
  }) {
    return loadReportsByUser?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReportEvent value)? createReport,
    TResult Function(BlockUserEvent value)? blockUser,
    TResult Function(LoadPendingReportsEvent value)? loadPendingReports,
    TResult Function(LoadReportsByUserEvent value)? loadReportsByUser,
    TResult Function(UpdateReportStatusEvent value)? updateReportStatus,
    required TResult orElse(),
  }) {
    if (loadReportsByUser != null) {
      return loadReportsByUser(this);
    }
    return orElse();
  }
}

abstract class LoadReportsByUserEvent implements SecurityEvent {
  const factory LoadReportsByUserEvent(final String userId) =
      _$LoadReportsByUserEventImpl;

  String get userId;

  /// Create a copy of SecurityEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadReportsByUserEventImplCopyWith<_$LoadReportsByUserEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateReportStatusEventImplCopyWith<$Res> {
  factory _$$UpdateReportStatusEventImplCopyWith(
    _$UpdateReportStatusEventImpl value,
    $Res Function(_$UpdateReportStatusEventImpl) then,
  ) = __$$UpdateReportStatusEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String reportId, ReportStatus status, String? moderatorNotes});
}

/// @nodoc
class __$$UpdateReportStatusEventImplCopyWithImpl<$Res>
    extends _$SecurityEventCopyWithImpl<$Res, _$UpdateReportStatusEventImpl>
    implements _$$UpdateReportStatusEventImplCopyWith<$Res> {
  __$$UpdateReportStatusEventImplCopyWithImpl(
    _$UpdateReportStatusEventImpl _value,
    $Res Function(_$UpdateReportStatusEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SecurityEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reportId = null,
    Object? status = null,
    Object? moderatorNotes = freezed,
  }) {
    return _then(
      _$UpdateReportStatusEventImpl(
        reportId: null == reportId
            ? _value.reportId
            : reportId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ReportStatus,
        moderatorNotes: freezed == moderatorNotes
            ? _value.moderatorNotes
            : moderatorNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$UpdateReportStatusEventImpl implements UpdateReportStatusEvent {
  const _$UpdateReportStatusEventImpl({
    required this.reportId,
    required this.status,
    this.moderatorNotes,
  });

  @override
  final String reportId;
  @override
  final ReportStatus status;
  @override
  final String? moderatorNotes;

  @override
  String toString() {
    return 'SecurityEvent.updateReportStatus(reportId: $reportId, status: $status, moderatorNotes: $moderatorNotes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateReportStatusEventImpl &&
            (identical(other.reportId, reportId) ||
                other.reportId == reportId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.moderatorNotes, moderatorNotes) ||
                other.moderatorNotes == moderatorNotes));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, reportId, status, moderatorNotes);

  /// Create a copy of SecurityEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateReportStatusEventImplCopyWith<_$UpdateReportStatusEventImpl>
  get copyWith =>
      __$$UpdateReportStatusEventImplCopyWithImpl<
        _$UpdateReportStatusEventImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String reportedUserId,
      String? reportedPlanId,
      ReportType type,
      ReportReason reason,
      String description,
      Map<String, dynamic>? evidence,
    )
    createReport,
    required TResult Function(
      String blockedUserId,
      ReportReason? reason,
      String? description,
    )
    blockUser,
    required TResult Function() loadPendingReports,
    required TResult Function(String userId) loadReportsByUser,
    required TResult Function(
      String reportId,
      ReportStatus status,
      String? moderatorNotes,
    )
    updateReportStatus,
  }) {
    return updateReportStatus(reportId, status, moderatorNotes);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      String reportedUserId,
      String? reportedPlanId,
      ReportType type,
      ReportReason reason,
      String description,
      Map<String, dynamic>? evidence,
    )?
    createReport,
    TResult? Function(
      String blockedUserId,
      ReportReason? reason,
      String? description,
    )?
    blockUser,
    TResult? Function()? loadPendingReports,
    TResult? Function(String userId)? loadReportsByUser,
    TResult? Function(
      String reportId,
      ReportStatus status,
      String? moderatorNotes,
    )?
    updateReportStatus,
  }) {
    return updateReportStatus?.call(reportId, status, moderatorNotes);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      String reportedUserId,
      String? reportedPlanId,
      ReportType type,
      ReportReason reason,
      String description,
      Map<String, dynamic>? evidence,
    )?
    createReport,
    TResult Function(
      String blockedUserId,
      ReportReason? reason,
      String? description,
    )?
    blockUser,
    TResult Function()? loadPendingReports,
    TResult Function(String userId)? loadReportsByUser,
    TResult Function(
      String reportId,
      ReportStatus status,
      String? moderatorNotes,
    )?
    updateReportStatus,
    required TResult orElse(),
  }) {
    if (updateReportStatus != null) {
      return updateReportStatus(reportId, status, moderatorNotes);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CreateReportEvent value) createReport,
    required TResult Function(BlockUserEvent value) blockUser,
    required TResult Function(LoadPendingReportsEvent value) loadPendingReports,
    required TResult Function(LoadReportsByUserEvent value) loadReportsByUser,
    required TResult Function(UpdateReportStatusEvent value) updateReportStatus,
  }) {
    return updateReportStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CreateReportEvent value)? createReport,
    TResult? Function(BlockUserEvent value)? blockUser,
    TResult? Function(LoadPendingReportsEvent value)? loadPendingReports,
    TResult? Function(LoadReportsByUserEvent value)? loadReportsByUser,
    TResult? Function(UpdateReportStatusEvent value)? updateReportStatus,
  }) {
    return updateReportStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CreateReportEvent value)? createReport,
    TResult Function(BlockUserEvent value)? blockUser,
    TResult Function(LoadPendingReportsEvent value)? loadPendingReports,
    TResult Function(LoadReportsByUserEvent value)? loadReportsByUser,
    TResult Function(UpdateReportStatusEvent value)? updateReportStatus,
    required TResult orElse(),
  }) {
    if (updateReportStatus != null) {
      return updateReportStatus(this);
    }
    return orElse();
  }
}

abstract class UpdateReportStatusEvent implements SecurityEvent {
  const factory UpdateReportStatusEvent({
    required final String reportId,
    required final ReportStatus status,
    final String? moderatorNotes,
  }) = _$UpdateReportStatusEventImpl;

  String get reportId;
  ReportStatus get status;
  String? get moderatorNotes;

  /// Create a copy of SecurityEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateReportStatusEventImplCopyWith<_$UpdateReportStatusEventImpl>
  get copyWith => throw _privateConstructorUsedError;
}
