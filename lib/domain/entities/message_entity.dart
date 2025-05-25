/// Entidad de dominio que representa un mensaje en una conversación
class MessageEntity {
  /// Identificador único del mensaje
  final String id;
  
  /// Identificador del remitente del mensaje
  final String senderId;
  
  /// Contenido del mensaje
  final String content;
  
  /// Momento en que se envió el mensaje
  final DateTime timestamp;
  
  /// Indica si el mensaje ha sido leído
  final bool read;
  
  /// Constructor
  MessageEntity({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.read,
  });
  
  /// Crear una copia de esta entidad con campos específicos modificados
  MessageEntity copyWith({
    String? id,
    String? senderId,
    String? content,
    DateTime? timestamp,
    bool? read,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      read: read ?? this.read,
    );
  }
}
