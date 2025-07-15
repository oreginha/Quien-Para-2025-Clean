import 'package:equatable/equatable.dart';

/// Representa un participante de chat con su información y estado
class ChatParticipantEntity extends Equatable {
  final String userId;
  final String chatId;
  final ParticipantRole role;
  final DateTime joinedAt;
  final DateTime? leftAt;
  final bool isActive;
  final DateTime? lastSeenAt;
  final bool isTyping;
  final DateTime? lastTypingAt;
  final ParticipantStatus status;
  final Map<String, dynamic>? customData;

  const ChatParticipantEntity({
    required this.userId,
    required this.chatId,
    this.role = ParticipantRole.member,
    required this.joinedAt,
    this.leftAt,
    this.isActive = true,
    this.lastSeenAt,
    this.isTyping = false,
    this.lastTypingAt,
    this.status = ParticipantStatus.active,
    this.customData,
  });

  /// Crea una copia del participante con valores actualizados
  ChatParticipantEntity copyWith({
    String? userId,
    String? chatId,
    ParticipantRole? role,
    DateTime? joinedAt,
    DateTime? leftAt,
    bool? isActive,
    DateTime? lastSeenAt,
    bool? isTyping,
    DateTime? lastTypingAt,
    ParticipantStatus? status,
    Map<String, dynamic>? customData,
  }) {
    return ChatParticipantEntity(
      userId: userId ?? this.userId,
      chatId: chatId ?? this.chatId,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      leftAt: leftAt ?? this.leftAt,
      isActive: isActive ?? this.isActive,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      isTyping: isTyping ?? this.isTyping,
      lastTypingAt: lastTypingAt ?? this.lastTypingAt,
      status: status ?? this.status,
      customData: customData ?? this.customData,
    );
  }

  /// Marca al participante como escribiendo
  ChatParticipantEntity startTyping() {
    return copyWith(
      isTyping: true,
      lastTypingAt: DateTime.now(),
    );
  }

  /// Marca al participante como que dejó de escribir
  ChatParticipantEntity stopTyping() {
    return copyWith(
      isTyping: false,
    );
  }

  /// Actualiza la última vez que se vio al participante
  ChatParticipantEntity updateLastSeen() {
    return copyWith(
      lastSeenAt: DateTime.now(),
    );
  }

  /// Abandona el chat
  ChatParticipantEntity leaveChat() {
    return copyWith(
      isActive: false,
      leftAt: DateTime.now(),
      status: ParticipantStatus.left,
    );
  }

  /// Se reincorpora al chat
  ChatParticipantEntity rejoinChat() {
    return copyWith(
      isActive: true,
      leftAt: null,
      status: ParticipantStatus.active,
      joinedAt: DateTime.now(),
    );
  }

  /// Verifica si el participante es administrador
  bool get isAdmin => role == ParticipantRole.admin;

  /// Verifica si el participante es moderador
  bool get isModerator => role == ParticipantRole.moderator;

  /// Verifica si el participante tiene permisos de administración
  bool get hasAdminPermissions => [ParticipantRole.admin, ParticipantRole.moderator].contains(role);

  /// Verifica si el participante está online (activo en los últimos 5 minutos)
  bool get isOnline {
    if (lastSeenAt == null) return false;
    return DateTime.now().difference(lastSeenAt!).inMinutes < 5;
  }

  /// Obtiene el tiempo desde la última actividad
  Duration? get timeSinceLastSeen {
    if (lastSeenAt == null) return null;
    return DateTime.now().difference(lastSeenAt!);
  }

  /// Obtiene el estado de presencia formateado
  String get presenceStatus {
    if (!isActive) return 'Inactivo';
    if (isOnline) return 'En línea';
    
    final timeSince = timeSinceLastSeen;
    if (timeSince == null) return 'Desconocido';
    
    if (timeSince.inMinutes < 60) {
      return 'Hace ${timeSince.inMinutes} min';
    } else if (timeSince.inHours < 24) {
      return 'Hace ${timeSince.inHours} h';
    } else {
      return 'Hace ${timeSince.inDays} días';
    }
  }

  @override
  List<Object?> get props => [
        userId,
        chatId,
        role,
        joinedAt,
        leftAt,
        isActive,
        lastSeenAt,
        isTyping,
        lastTypingAt,
        status,
        customData,
      ];

  @override
  String toString() {
    return 'ChatParticipantEntity{userId: $userId, chatId: $chatId, role: $role, isActive: $isActive, isOnline: $isOnline}';
  }
}

/// Roles disponibles para participantes de chat
enum ParticipantRole {
  admin,
  moderator,
  member;

  String get displayName {
    switch (this) {
      case ParticipantRole.admin:
        return 'Administrador';
      case ParticipantRole.moderator:
        return 'Moderador';
      case ParticipantRole.member:
        return 'Miembro';
    }
  }

  bool get canAddParticipants => [ParticipantRole.admin, ParticipantRole.moderator].contains(this);
  bool get canRemoveParticipants => this == ParticipantRole.admin;
  bool get canDeleteMessages => [ParticipantRole.admin, ParticipantRole.moderator].contains(this);
  bool get canEditGroupInfo => this == ParticipantRole.admin;
}

/// Estados posibles de un participante
enum ParticipantStatus {
  active,
  muted,
  blocked,
  left,
  kicked,
  banned;

  String get displayName {
    switch (this) {
      case ParticipantStatus.active:
        return 'Activo';
      case ParticipantStatus.muted:
        return 'Silenciado';
      case ParticipantStatus.blocked:
        return 'Bloqueado';
      case ParticipantStatus.left:
        return 'Abandonó';
      case ParticipantStatus.kicked:
        return 'Expulsado';
      case ParticipantStatus.banned:
        return 'Baneado';
    }
  }

  bool get canSendMessages => this == ParticipantStatus.active;
  bool get canReceiveMessages => [ParticipantStatus.active, ParticipantStatus.muted].contains(this);
  bool get isInChat => [ParticipantStatus.active, ParticipantStatus.muted].contains(this);
}

/// Información extendida del participante con datos del usuario
class ChatParticipantWithUserInfo extends ChatParticipantEntity {
  final String userName;
  final String? userPhotoUrl;
  final String? userEmail;
  final bool isUserVerified;

  const ChatParticipantWithUserInfo({
    required super.userId,
    required super.chatId,
    super.role,
    required super.joinedAt,
    super.leftAt,
    super.isActive,
    super.lastSeenAt,
    super.isTyping,
    super.lastTypingAt,
    super.status,
    super.customData,
    required this.userName,
    this.userPhotoUrl,
    this.userEmail,
    this.isUserVerified = false,
  });

  @override
  ChatParticipantWithUserInfo copyWith({
    String? userId,
    String? chatId,
    ParticipantRole? role,
    DateTime? joinedAt,
    DateTime? leftAt,
    bool? isActive,
    DateTime? lastSeenAt,
    bool? isTyping,
    DateTime? lastTypingAt,
    ParticipantStatus? status,
    Map<String, dynamic>? customData,
    String? userName,
    String? userPhotoUrl,
    String? userEmail,
    bool? isUserVerified,
  }) {
    return ChatParticipantWithUserInfo(
      userId: userId ?? this.userId,
      chatId: chatId ?? this.chatId,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      leftAt: leftAt ?? this.leftAt,
      isActive: isActive ?? this.isActive,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      isTyping: isTyping ?? this.isTyping,
      lastTypingAt: lastTypingAt ?? this.lastTypingAt,
      status: status ?? this.status,
      customData: customData ?? this.customData,
      userName: userName ?? this.userName,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      userEmail: userEmail ?? this.userEmail,
      isUserVerified: isUserVerified ?? this.isUserVerified,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        userName,
        userPhotoUrl,
        userEmail,
        isUserVerified,
      ];
}
