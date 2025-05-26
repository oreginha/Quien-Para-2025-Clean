// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'application_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ApplicationModel _$ApplicationModelFromJson(Map<String, dynamic> json) {
  return _ApplicationModel.fromJson(json);
}

/// @nodoc
mixin _$ApplicationModel {
  String get id => throw _privateConstructorUsedError;
  String get planId => throw _privateConstructorUsedError;
  String get applicantId => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // pending, accepted, rejected, cancelled
  DateTime get appliedAt => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  DateTime? get processedAt => throw _privateConstructorUsedError;
  String? get planTitle =>
      throw _privateConstructorUsedError; // Para mostrar info adicional en la UI
  String? get planImageUrl =>
      throw _privateConstructorUsedError; // Para mostrar info adicional en la UI
  String? get applicantName =>
      throw _privateConstructorUsedError; // Para mostrar info adicional en la UI
  String? get applicantPhotoUrl =>
      throw _privateConstructorUsedError; // Para mostrar info adicional en la UI
  String? get responsibleMessage => throw _privateConstructorUsedError;

  /// Serializes this ApplicationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApplicationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApplicationModelCopyWith<ApplicationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicationModelCopyWith<$Res> {
  factory $ApplicationModelCopyWith(
    ApplicationModel value,
    $Res Function(ApplicationModel) then,
  ) = _$ApplicationModelCopyWithImpl<$Res, ApplicationModel>;
  @useResult
  $Res call({
    String id,
    String planId,
    String applicantId,
    String status,
    DateTime appliedAt,
    String? message,
    DateTime? processedAt,
    String? planTitle,
    String? planImageUrl,
    String? applicantName,
    String? applicantPhotoUrl,
    String? responsibleMessage,
  });
}

/// @nodoc
class _$ApplicationModelCopyWithImpl<$Res, $Val extends ApplicationModel>
    implements $ApplicationModelCopyWith<$Res> {
  _$ApplicationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApplicationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? planId = null,
    Object? applicantId = null,
    Object? status = null,
    Object? appliedAt = null,
    Object? message = freezed,
    Object? processedAt = freezed,
    Object? planTitle = freezed,
    Object? planImageUrl = freezed,
    Object? applicantName = freezed,
    Object? applicantPhotoUrl = freezed,
    Object? responsibleMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            planId: null == planId
                ? _value.planId
                : planId // ignore: cast_nullable_to_non_nullable
                      as String,
            applicantId: null == applicantId
                ? _value.applicantId
                : applicantId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            appliedAt: null == appliedAt
                ? _value.appliedAt
                : appliedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
            processedAt: freezed == processedAt
                ? _value.processedAt
                : processedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            planTitle: freezed == planTitle
                ? _value.planTitle
                : planTitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            planImageUrl: freezed == planImageUrl
                ? _value.planImageUrl
                : planImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            applicantName: freezed == applicantName
                ? _value.applicantName
                : applicantName // ignore: cast_nullable_to_non_nullable
                      as String?,
            applicantPhotoUrl: freezed == applicantPhotoUrl
                ? _value.applicantPhotoUrl
                : applicantPhotoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            responsibleMessage: freezed == responsibleMessage
                ? _value.responsibleMessage
                : responsibleMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApplicationModelImplCopyWith<$Res>
    implements $ApplicationModelCopyWith<$Res> {
  factory _$$ApplicationModelImplCopyWith(
    _$ApplicationModelImpl value,
    $Res Function(_$ApplicationModelImpl) then,
  ) = __$$ApplicationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String planId,
    String applicantId,
    String status,
    DateTime appliedAt,
    String? message,
    DateTime? processedAt,
    String? planTitle,
    String? planImageUrl,
    String? applicantName,
    String? applicantPhotoUrl,
    String? responsibleMessage,
  });
}

/// @nodoc
class __$$ApplicationModelImplCopyWithImpl<$Res>
    extends _$ApplicationModelCopyWithImpl<$Res, _$ApplicationModelImpl>
    implements _$$ApplicationModelImplCopyWith<$Res> {
  __$$ApplicationModelImplCopyWithImpl(
    _$ApplicationModelImpl _value,
    $Res Function(_$ApplicationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApplicationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? planId = null,
    Object? applicantId = null,
    Object? status = null,
    Object? appliedAt = null,
    Object? message = freezed,
    Object? processedAt = freezed,
    Object? planTitle = freezed,
    Object? planImageUrl = freezed,
    Object? applicantName = freezed,
    Object? applicantPhotoUrl = freezed,
    Object? responsibleMessage = freezed,
  }) {
    return _then(
      _$ApplicationModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        planId: null == planId
            ? _value.planId
            : planId // ignore: cast_nullable_to_non_nullable
                  as String,
        applicantId: null == applicantId
            ? _value.applicantId
            : applicantId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        appliedAt: null == appliedAt
            ? _value.appliedAt
            : appliedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        processedAt: freezed == processedAt
            ? _value.processedAt
            : processedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        planTitle: freezed == planTitle
            ? _value.planTitle
            : planTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        planImageUrl: freezed == planImageUrl
            ? _value.planImageUrl
            : planImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        applicantName: freezed == applicantName
            ? _value.applicantName
            : applicantName // ignore: cast_nullable_to_non_nullable
                  as String?,
        applicantPhotoUrl: freezed == applicantPhotoUrl
            ? _value.applicantPhotoUrl
            : applicantPhotoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        responsibleMessage: freezed == responsibleMessage
            ? _value.responsibleMessage
            : responsibleMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApplicationModelImpl extends _ApplicationModel {
  const _$ApplicationModelImpl({
    required this.id,
    required this.planId,
    required this.applicantId,
    required this.status,
    required this.appliedAt,
    this.message,
    this.processedAt,
    this.planTitle,
    this.planImageUrl,
    this.applicantName,
    this.applicantPhotoUrl,
    this.responsibleMessage,
  }) : super._();

  factory _$ApplicationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplicationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String planId;
  @override
  final String applicantId;
  @override
  final String status;
  // pending, accepted, rejected, cancelled
  @override
  final DateTime appliedAt;
  @override
  final String? message;
  @override
  final DateTime? processedAt;
  @override
  final String? planTitle;
  // Para mostrar info adicional en la UI
  @override
  final String? planImageUrl;
  // Para mostrar info adicional en la UI
  @override
  final String? applicantName;
  // Para mostrar info adicional en la UI
  @override
  final String? applicantPhotoUrl;
  // Para mostrar info adicional en la UI
  @override
  final String? responsibleMessage;

  @override
  String toString() {
    return 'ApplicationModel(id: $id, planId: $planId, applicantId: $applicantId, status: $status, appliedAt: $appliedAt, message: $message, processedAt: $processedAt, planTitle: $planTitle, planImageUrl: $planImageUrl, applicantName: $applicantName, applicantPhotoUrl: $applicantPhotoUrl, responsibleMessage: $responsibleMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.applicantId, applicantId) ||
                other.applicantId == applicantId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.appliedAt, appliedAt) ||
                other.appliedAt == appliedAt) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.processedAt, processedAt) ||
                other.processedAt == processedAt) &&
            (identical(other.planTitle, planTitle) ||
                other.planTitle == planTitle) &&
            (identical(other.planImageUrl, planImageUrl) ||
                other.planImageUrl == planImageUrl) &&
            (identical(other.applicantName, applicantName) ||
                other.applicantName == applicantName) &&
            (identical(other.applicantPhotoUrl, applicantPhotoUrl) ||
                other.applicantPhotoUrl == applicantPhotoUrl) &&
            (identical(other.responsibleMessage, responsibleMessage) ||
                other.responsibleMessage == responsibleMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    planId,
    applicantId,
    status,
    appliedAt,
    message,
    processedAt,
    planTitle,
    planImageUrl,
    applicantName,
    applicantPhotoUrl,
    responsibleMessage,
  );

  /// Create a copy of ApplicationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicationModelImplCopyWith<_$ApplicationModelImpl> get copyWith =>
      __$$ApplicationModelImplCopyWithImpl<_$ApplicationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplicationModelImplToJson(this);
  }
}

abstract class _ApplicationModel extends ApplicationModel {
  const factory _ApplicationModel({
    required final String id,
    required final String planId,
    required final String applicantId,
    required final String status,
    required final DateTime appliedAt,
    final String? message,
    final DateTime? processedAt,
    final String? planTitle,
    final String? planImageUrl,
    final String? applicantName,
    final String? applicantPhotoUrl,
    final String? responsibleMessage,
  }) = _$ApplicationModelImpl;
  const _ApplicationModel._() : super._();

  factory _ApplicationModel.fromJson(Map<String, dynamic> json) =
      _$ApplicationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get planId;
  @override
  String get applicantId;
  @override
  String get status; // pending, accepted, rejected, cancelled
  @override
  DateTime get appliedAt;
  @override
  String? get message;
  @override
  DateTime? get processedAt;
  @override
  String? get planTitle; // Para mostrar info adicional en la UI
  @override
  String? get planImageUrl; // Para mostrar info adicional en la UI
  @override
  String? get applicantName; // Para mostrar info adicional en la UI
  @override
  String? get applicantPhotoUrl; // Para mostrar info adicional en la UI
  @override
  String? get responsibleMessage;

  /// Create a copy of ApplicationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplicationModelImplCopyWith<_$ApplicationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
