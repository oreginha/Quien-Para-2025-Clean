import 'package:equatable/equatable.dart';

/// Representa una entidad de chat en el dominio
class ChatEntity extends Equatable {
  final String id;
  final List<String> participants;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final ChatType type;
  final GroupInfo? groupInfo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final Map<String, DateTime>? lastReadBy;

  const ChatEntity({
    required this.id,
    required this.participants,
    this.lastMessage,
    this.lastMessageTime,
    required this.type,
    this.groupInfo,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.lastReadBy,
  });

  /// Crea una copia del chat con los valores actualizados
  ChatEntity copyWith({
    String? id,
    List<String>? participants,
    String? lastMessage,
    DateTime? lastMessageTime,
    ChatType? type,
    GroupInfo? groupInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    Map<String, DateTime>? lastReadBy,
  }) {
    return ChatEntity(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      type: type ?? this.type,
      groupInfo: groupInfo ?? this.groupInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      lastReadBy: lastReadBy ?? this.lastReadBy,
    );
  }

  /// Verifica si un usuario es participante del chat
  bool hasParticipant(String userId) {
    return participants.contains(userId);
  }

  /// Obtiene el otro participante en un chat individual
  String? getOtherParticipant(String currentUserId) {
    if (type != ChatType.individual || participants.length != 2) {
      return null;
    }
    return participants.firstWhere(
      (participant) => participant != currentUserId,
      orElse: () => '',
    );
  }

  /// Verifica si un usuario es administrador del grupo
  bool isAdmin(String userId) {
    return groupInfo?.adminId == userId;
  }

  /// Obtiene el número de participantes no leídos
  int getUnreadCount(String userId) {
    if (lastReadBy == null || lastMessageTime == null) return 0;
    
    final userLastRead = lastReadBy![userId];
    if (userLastRead == null) return 1;
    
    return lastMessageTime!.isAfter(userLastRead) ? 1 : 0;
  }

  @override
  List<Object?> get props => [
        id,
        participants,
        lastMessage,
        lastMessageTime,
        type,
        groupInfo,
        createdAt,
        updatedAt,
        isActive,
        lastReadBy,
      ];

  @override
  String toString() {
    return 'ChatEntity{id: $id, type: $type, participants: ${participants.length}, lastMessage: $lastMessage}';
  }
}

/// Información específica para chats grupales
class GroupInfo extends Equatable {
  final String name;
  final String? description;
  final String? photoUrl;
  final String adminId;
  final DateTime createdAt;
  final Map<String, String>? customData;

  const GroupInfo({
    required this.name,
    this.description,
    this.photoUrl,
    required this.adminId,
    required this.createdAt,
    this.customData,
  });

  GroupInfo copyWith({
    String? name,
    String? description,
    String? photoUrl,
    String? adminId,
    DateTime? createdAt,
    Map<String, String>? customData,
  }) {
    return GroupInfo(
      name: name ?? this.name,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      adminId: adminId ?? this.adminId,
      createdAt: createdAt ?? this.createdAt,
      customData: customData ?? this.customData,
    );
  }

  @override
  List<Object?> get props => [
        name,
        description,
        photoUrl,
        adminId,
        createdAt,
        customData,
      ];
}

/// Tipos de chat disponibles
enum ChatType {
  individual,
  group;

  String get displayName {
    switch (this) {
      case ChatType.individual:
        return 'Individual';
      case ChatType.group:
        return 'Grupo';
    }
  }

  bool get isGroup => this == ChatType.group;
  bool get isIndividual => this == ChatType.individual;
}
