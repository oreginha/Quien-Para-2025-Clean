// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatModelImpl _$$ChatModelImplFromJson(Map<String, dynamic> json) =>
    _$ChatModelImpl(
      id: json['id'] as String? ?? '',
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastMessageTimestamp: json['lastMessageTimestamp'] == null
          ? null
          : DateTime.parse(json['lastMessageTimestamp'] as String),
      lastMessage: json['lastMessage'] as String?,
      lastMessageSenderId: json['lastMessageSenderId'] as String?,
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      isGroupChat: json['isGroupChat'] as bool? ?? false,
      name: json['name'] as String?,
      planId: json['planId'] as String?,
      active: json['active'] as bool? ?? true,
    );

Map<String, dynamic> _$$ChatModelImplToJson(_$ChatModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participants': instance.participants,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastMessageTimestamp': instance.lastMessageTimestamp?.toIso8601String(),
      'lastMessage': instance.lastMessage,
      'lastMessageSenderId': instance.lastMessageSenderId,
      'unreadCount': instance.unreadCount,
      'isGroupChat': instance.isGroupChat,
      'name': instance.name,
      'planId': instance.planId,
      'active': instance.active,
    };
