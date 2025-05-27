// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) {
  return _ChatModel.fromJson(json);
}

/// @nodoc
mixin _$ChatModel {
  String get id => throw _privateConstructorUsedError;
  List<String> get participants => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get lastMessageTimestamp => throw _privateConstructorUsedError;
  String? get lastMessage => throw _privateConstructorUsedError;
  String? get lastMessageSenderId => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;
  bool get isGroupChat => throw _privateConstructorUsedError;
  String? get name =>
      throw _privateConstructorUsedError; // Name for group chats
  String? get planId =>
      throw _privateConstructorUsedError; // Optional plan association
  bool get active => throw _privateConstructorUsedError;

  /// Serializes this ChatModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatModelCopyWith<ChatModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatModelCopyWith<$Res> {
  factory $ChatModelCopyWith(ChatModel value, $Res Function(ChatModel) then) =
      _$ChatModelCopyWithImpl<$Res, ChatModel>;
  @useResult
  $Res call({
    String id,
    List<String> participants,
    DateTime createdAt,
    DateTime? lastMessageTimestamp,
    String? lastMessage,
    String? lastMessageSenderId,
    int unreadCount,
    bool isGroupChat,
    String? name,
    String? planId,
    bool active,
  });
}

/// @nodoc
class _$ChatModelCopyWithImpl<$Res, $Val extends ChatModel>
    implements $ChatModelCopyWith<$Res> {
  _$ChatModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? participants = null,
    Object? createdAt = null,
    Object? lastMessageTimestamp = freezed,
    Object? lastMessage = freezed,
    Object? lastMessageSenderId = freezed,
    Object? unreadCount = null,
    Object? isGroupChat = null,
    Object? name = freezed,
    Object? planId = freezed,
    Object? active = null,
  }) {
    return _then(
      _value.copyWith(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                as String,
        participants: null == participants
            ? _value.participants
            : participants // ignore: cast_nullable_to_non_nullable
                as List<String>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                as DateTime,
        lastMessageTimestamp: freezed == lastMessageTimestamp
            ? _value.lastMessageTimestamp
            : lastMessageTimestamp // ignore: cast_nullable_to_non_nullable
                as DateTime?,
        lastMessage: freezed == lastMessage
            ? _value.lastMessage
            : lastMessage // ignore: cast_nullable_to_non_nullable
                as String?,
        lastMessageSenderId: freezed == lastMessageSenderId
            ? _value.lastMessageSenderId
            : lastMessageSenderId // ignore: cast_nullable_to_non_nullable
                as String?,
        unreadCount: null == unreadCount
            ? _value.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                as int,
        isGroupChat: null == isGroupChat
            ? _value.isGroupChat
            : isGroupChat // ignore: cast_nullable_to_non_nullable
                as bool,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                as String?,
        planId: freezed == planId
            ? _value.planId
            : planId // ignore: cast_nullable_to_non_nullable
                as String?,
        active: null == active
            ? _value.active
            : active // ignore: cast_nullable_to_non_nullable
                as bool,
      ) as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatModelImplCopyWith<$Res>
    implements $ChatModelCopyWith<$Res> {
  factory _$$ChatModelImplCopyWith(
    _$ChatModelImpl value,
    $Res Function(_$ChatModelImpl) then,
  ) = __$$ChatModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    List<String> participants,
    DateTime createdAt,
    DateTime? lastMessageTimestamp,
    String? lastMessage,
    String? lastMessageSenderId,
    int unreadCount,
    bool isGroupChat,
    String? name,
    String? planId,
    bool active,
  });
}

/// @nodoc
class __$$ChatModelImplCopyWithImpl<$Res>
    extends _$ChatModelCopyWithImpl<$Res, _$ChatModelImpl>
    implements _$$ChatModelImplCopyWith<$Res> {
  __$$ChatModelImplCopyWithImpl(
    _$ChatModelImpl _value,
    $Res Function(_$ChatModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? participants = null,
    Object? createdAt = null,
    Object? lastMessageTimestamp = freezed,
    Object? lastMessage = freezed,
    Object? lastMessageSenderId = freezed,
    Object? unreadCount = null,
    Object? isGroupChat = null,
    Object? name = freezed,
    Object? planId = freezed,
    Object? active = null,
  }) {
    return _then(
      _$ChatModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                as String,
        participants: null == participants
            ? _value._participants
            : participants // ignore: cast_nullable_to_non_nullable
                as List<String>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                as DateTime,
        lastMessageTimestamp: freezed == lastMessageTimestamp
            ? _value.lastMessageTimestamp
            : lastMessageTimestamp // ignore: cast_nullable_to_non_nullable
                as DateTime?,
        lastMessage: freezed == lastMessage
            ? _value.lastMessage
            : lastMessage // ignore: cast_nullable_to_non_nullable
                as String?,
        lastMessageSenderId: freezed == lastMessageSenderId
            ? _value.lastMessageSenderId
            : lastMessageSenderId // ignore: cast_nullable_to_non_nullable
                as String?,
        unreadCount: null == unreadCount
            ? _value.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                as int,
        isGroupChat: null == isGroupChat
            ? _value.isGroupChat
            : isGroupChat // ignore: cast_nullable_to_non_nullable
                as bool,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                as String?,
        planId: freezed == planId
            ? _value.planId
            : planId // ignore: cast_nullable_to_non_nullable
                as String?,
        active: null == active
            ? _value.active
            : active // ignore: cast_nullable_to_non_nullable
                as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatModelImpl extends _ChatModel {
  _$ChatModelImpl({
    this.id = '',
    required final List<String> participants,
    required this.createdAt,
    this.lastMessageTimestamp,
    this.lastMessage,
    this.lastMessageSenderId,
    this.unreadCount = 0,
    this.isGroupChat = false,
    this.name,
    this.planId,
    this.active = true,
  })  : _participants = participants,
        super._();

  factory _$ChatModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatModelImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  final List<String> _participants;
  @override
  List<String> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? lastMessageTimestamp;
  @override
  final String? lastMessage;
  @override
  final String? lastMessageSenderId;
  @override
  @JsonKey()
  final int unreadCount;
  @override
  @JsonKey()
  final bool isGroupChat;
  @override
  final String? name;
  // Name for group chats
  @override
  final String? planId;
  // Optional plan association
  @override
  @JsonKey()
  final bool active;

  @override
  String toString() {
    return 'ChatModel(id: $id, participants: $participants, createdAt: $createdAt, lastMessageTimestamp: $lastMessageTimestamp, lastMessage: $lastMessage, lastMessageSenderId: $lastMessageSenderId, unreadCount: $unreadCount, isGroupChat: $isGroupChat, name: $name, planId: $planId, active: $active)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(
              other._participants,
              _participants,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastMessageTimestamp, lastMessageTimestamp) ||
                other.lastMessageTimestamp == lastMessageTimestamp) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageSenderId, lastMessageSenderId) ||
                other.lastMessageSenderId == lastMessageSenderId) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.isGroupChat, isGroupChat) ||
                other.isGroupChat == isGroupChat) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.active, active) || other.active == active));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
        runtimeType,
        id,
        const DeepCollectionEquality().hash(_participants),
        createdAt,
        lastMessageTimestamp,
        lastMessage,
        lastMessageSenderId,
        unreadCount,
        isGroupChat,
        name,
        planId,
        active,
      );

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatModelImplCopyWith<_$ChatModelImpl> get copyWith =>
      __$$ChatModelImplCopyWithImpl<_$ChatModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatModelImplToJson(this);
  }
}

abstract class _ChatModel extends ChatModel {
  factory _ChatModel({
    final String id,
    required final List<String> participants,
    required final DateTime createdAt,
    final DateTime? lastMessageTimestamp,
    final String? lastMessage,
    final String? lastMessageSenderId,
    final int unreadCount,
    final bool isGroupChat,
    final String? name,
    final String? planId,
    final bool active,
  }) = _$ChatModelImpl;
  _ChatModel._() : super._();

  factory _ChatModel.fromJson(Map<String, dynamic> json) =
      _$ChatModelImpl.fromJson;

  @override
  String get id;
  @override
  List<String> get participants;
  @override
  DateTime get createdAt;
  @override
  DateTime? get lastMessageTimestamp;
  @override
  String? get lastMessage;
  @override
  String? get lastMessageSenderId;
  @override
  int get unreadCount;
  @override
  bool get isGroupChat;
  @override
  String? get name; // Name for group chats
  @override
  String? get planId; // Optional plan association
  @override
  bool get active;

  /// Create a copy of ChatModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatModelImplCopyWith<_$ChatModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
