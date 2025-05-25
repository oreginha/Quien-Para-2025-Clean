import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_model.freezed.dart';
part 'chat_message_model.g.dart';

@JsonEnum()
enum MessageType { 
  @JsonValue('text')
  text, 
  @JsonValue('image')
  image, 
  @JsonValue('system')
  system, 
  @JsonValue('voiceNote')
  voiceNote 
}

// Extensión para añadir método toJson a MessageType
extension MessageTypeExtension on MessageType {
  String toJson() {
    switch (this) {
      case MessageType.text:
        return 'text';
      case MessageType.image:
        return 'image';
      case MessageType.system:
        return 'system';
      case MessageType.voiceNote:
        return 'voiceNote';
    }
  }
}

@freezed
class ChatMessageModel with _$ChatMessageModel {
  const factory ChatMessageModel({
    @Default('') String id,
    required String chatId,
    required String senderId,
    required String content,
    required DateTime timestamp,
    @Default(false) bool isRead,
    @Default(MessageType.text) MessageType type,
    String? mediaUrl,
    @Default(false) bool isSystemMessage,
  }) = _ChatMessageModel;

  // Constructor privado para métodos personalizados
  const ChatMessageModel._();

  // Método de conversión a JSON
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => 
      _$ChatMessageModelFromJson(json);

  // Método de conversión desde Firestore
  factory ChatMessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return ChatMessageModel(
      id: doc.id,
      chatId: data['chatId'] ?? '',
      senderId: data['senderId'] ?? '',
      content: data['content'] ?? data['text'] ?? '',
      timestamp: _parseTimestamp(data['timestamp']),
      isRead: data['isRead'] ?? data['read'] ?? false,
      type: _parseMessageType(data['type']),
      mediaUrl: data['mediaUrl'],
      isSystemMessage: data['isSystemMessage'] ?? false,
    );
  }

  // Método de conversión a Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
      'type': type.toJson(),
      'mediaUrl': mediaUrl,
      'isSystemMessage': isSystemMessage,
    };
  }

  // Método auxiliar para parsear timestamp
  static DateTime _parseTimestamp(dynamic timestampData) {
    if (timestampData == null) return DateTime.now();
    if (timestampData is Timestamp) return timestampData.toDate();
    if (timestampData is String) return DateTime.parse(timestampData);
    return DateTime.now();
  }

  // Método para parsear el tipo de mensaje
  static MessageType _parseMessageType(dynamic typeData) {
    if (typeData == null) return MessageType.text;
    
    try {
      return MessageType.values.firstWhere(
        (type) => type.toJson() == typeData,
        orElse: () => MessageType.text
      );
    } catch (e) {
      return MessageType.text;
    }
  }
}
