import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

@freezed
class ChatModel with _$ChatModel {
  const ChatModel._(); // Constructor privado para métodos de instancia

  factory ChatModel({
    @Default('') String id,
    required List<String> participants,
    required DateTime createdAt,
    DateTime? lastMessageTimestamp,
    String? lastMessage,
    String? lastMessageSenderId,
    @Default(0) int unreadCount,
    @Default(false) bool isGroupChat,
    String? name, // Name for group chats
    String? planId, // Optional plan association
    @Default(true) bool active,
  }) = _ChatModel;

  // Método de conversión a JSON para serialización
  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(_handleTimestampConversion(json));

  // Método de conversión desde Firestore
  factory ChatModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ChatModel(
      id: doc.id,
      participants: List<String>.from(data['participants'] ?? []),
      createdAt: _convertTimestamp(data['createdAt']),
      lastMessageTimestamp: _convertTimestamp(data['lastMessageTimestamp']),
      lastMessage: data['lastMessage'],
      lastMessageSenderId: data['lastMessageSenderId'],
      unreadCount: data['unreadCount'] ?? 0,
      isGroupChat: data['isGroupChat'] ?? false,
      name: data['name'],
      planId: data['planId'],
      active: data['active'] ?? true,
    );
  }

  // Método de conversión a Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'participants': participants,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastMessageTimestamp': lastMessageTimestamp != null
          ? Timestamp.fromDate(lastMessageTimestamp!)
          : null,
      'lastMessage': lastMessage,
      'lastMessageSenderId': lastMessageSenderId,
      'unreadCount': unreadCount,
      'isGroupChat': isGroupChat,
      'name': name,
      'planId': planId,
      'active': active,
    };
  }

  // Método auxiliar para conversión de timestamp
  static DateTime _convertTimestamp(dynamic timestampData) {
    if (timestampData == null) return DateTime.now();

    if (timestampData is Timestamp) {
      return timestampData.toDate();
    }

    try {
      return DateTime.parse(timestampData.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  // Método para preprocesar JSON y manejar formatos de timestamp
  static Map<String, dynamic> _handleTimestampConversion(
    Map<String, dynamic> json,
  ) {
    final newJson = Map<String, dynamic>.from(json);

    final timestampFields = ['createdAt', 'lastMessageTimestamp'];

    for (final field in timestampFields) {
      if (newJson[field] is Timestamp) {
        newJson[field] =
            (newJson[field] as Timestamp).toDate().toIso8601String();
      } else if (newJson[field] == null) {
        newJson[field] = DateTime.now().toIso8601String();
      }
    }

    return newJson;
  }
}
