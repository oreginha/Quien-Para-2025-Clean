/// Entidad de dominio que representa una conversación entre dos o más usuarios
class ConversationEntity {
  /// Identificador único de la conversación
  final String id;

  /// Lista de participantes de la conversación
  /// Cada participante es un Map con 'id', 'name' y 'photoUrl'
  final List<Map<String, dynamic>> participants;

  /// Último mensaje enviado en la conversación
  final String? lastMessage;

  /// Momento en que se envió el último mensaje
  final DateTime? lastMessageTime;

  /// Número de mensajes no leídos
  final int unreadCount;

  /// Constructor
  ConversationEntity({
    required this.id,
    required this.participants,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
  });

  /// Crear una copia de esta entidad con campos específicos modificados
  ConversationEntity copyWith({
    String? id,
    List<Map<String, dynamic>>? participants,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
  }) {
    return ConversationEntity(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  /// Obtener el ID de otro participante (asumiendo conversación de dos personas)
  String? getOtherParticipantId(String currentUserId) {
    final otherParticipants = participants
        .where((participant) => participant['id'] != currentUserId)
        .toList();

    return otherParticipants.isNotEmpty
        ? otherParticipants.first['id'] as String?
        : null;
  }

  /// Obtener el nombre de otro participante (asumiendo conversación de dos personas)
  String? getOtherParticipantName(String currentUserId) {
    final otherParticipants = participants
        .where((participant) => participant['id'] != currentUserId)
        .toList();

    return otherParticipants.isNotEmpty
        ? otherParticipants.first['name'] as String?
        : null;
  }

  /// Obtener la URL de la foto de otro participante (asumiendo conversación de dos personas)
  String? getOtherParticipantPhotoUrl(String currentUserId) {
    final otherParticipants = participants
        .where((participant) => participant['id'] != currentUserId)
        .toList();

    return otherParticipants.isNotEmpty
        ? otherParticipants.first['photoUrl'] as String?
        : null;
  }
}
