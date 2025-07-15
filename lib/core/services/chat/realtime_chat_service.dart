import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/chat/chat_entity.dart';
import '../../domain/entities/chat/message_entity.dart';
import '../../core/error/exceptions.dart';

/// Servicio para manejar chat en tiempo real usando Firebase Realtime Database
class RealtimeChatService {
  final FirebaseDatabase _database;
  final FirebaseAuth _auth;
  
  late final DatabaseReference _chatsRef;
  late final DatabaseReference _messagesRef;
  late final DatabaseReference _typingRef;
  late final DatabaseReference _presenceRef;

  // Stream controllers para manejar múltiples suscripciones
  final Map<String, StreamController<List<MessageEntity>>> _messageControllers = {};
  final Map<String, StreamController<List<String>>> _typingControllers = {};
  final Map<String, StreamController<ChatEntity>> _chatControllers = {};

  // Timers para limpiar indicadores de typing
  final Map<String, Timer> _typingTimers = {};

  RealtimeChatService({
    required FirebaseDatabase database,
    required FirebaseAuth auth,
  }) : _database = database, _auth = auth {
    _initializeReferences();
    _setupPresenceSystem();
  }

  /// Inicializa las referencias de Firebase
  void _initializeReferences() {
    _chatsRef = _database.ref('chats');
    _messagesRef = _database.ref('messages');
    _typingRef = _database.ref('typing');
    _presenceRef = _database.ref('presence');
  }

  /// Configura el sistema de presencia
  void _setupPresenceSystem() {
    final user = _auth.currentUser;
    if (user != null) {
      final userPresenceRef = _presenceRef.child(user.uid);
      
      // Configurar presencia online/offline
      userPresenceRef.onDisconnect().set({
        'online': false,
        'lastSeen': ServerValue.timestamp,
      });

      userPresenceRef.set({
        'online': true,
        'lastSeen': ServerValue.timestamp,
      });
    }
  }

  // =================== OPERACIONES DE MENSAJES ===================

  /// Envía un mensaje en tiempo real
  Future<MessageEntity> sendMessage(MessageEntity message) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw AuthenticationException('Usuario no autenticado');
      }

      // Generar ID único para el mensaje
      final messageRef = _messagesRef.child(message.chatId).push();
      final messageId = messageRef.key!;

      // Crear el mensaje con ID generado
      final messageToSend = message.copyWith(
        id: messageId,
        timestamp: DateTime.now(),
        status: MessageStatus.sending,
      );

      // Preparar datos para Firebase
      final messageData = _messageEntityToMap(messageToSend);

      // Enviar mensaje
      await messageRef.set(messageData);

      // Actualizar último mensaje del chat
      await _updateChatLastMessage(message.chatId, messageToSend);

      // Actualizar estado a enviado
      final sentMessage = messageToSend.copyWith(status: MessageStatus.sent);
      await messageRef.update({'status': sentMessage.status.name});

      return sentMessage;
    } catch (e) {
      throw ServerException('Error enviando mensaje: ${e.toString()}');
    }
  }

  /// Obtiene stream de mensajes en tiempo real
  Stream<List<MessageEntity>> getMessagesStream(String chatId, {int limit = 50}) {
    // Verificar si ya existe un controller para este chat
    if (!_messageControllers.containsKey(chatId)) {
      _messageControllers[chatId] = StreamController<List<MessageEntity>>.broadcast();
      _setupMessageListener(chatId, limit);
    }

    return _messageControllers[chatId]!.stream;
  }

  /// Configura el listener de mensajes para un chat
  void _setupMessageListener(String chatId, int limit) {
    final messagesRef = _messagesRef
        .child(chatId)
        .orderByChild('timestamp')
        .limitToLast(limit);

    messagesRef.onValue.listen(
      (DatabaseEvent event) {
        try {
          final data = event.snapshot.value as Map<dynamic, dynamic>?;
          
          if (data == null) {
            _messageControllers[chatId]?.add([]);
            return;
          }

          final messages = <MessageEntity>[];
          
          data.forEach((key, value) {
            try {
              final messageMap = Map<String, dynamic>.from(value as Map);
              messageMap['id'] = key;
              final message = _mapToMessageEntity(messageMap);
              messages.add(message);
            } catch (e) {
              print('Error parsing message $key: $e');
            }
          });

          // Ordenar mensajes por timestamp
          messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          
          _messageControllers[chatId]?.add(messages);
        } catch (e) {
          _messageControllers[chatId]?.addError(
            ServerException('Error en stream de mensajes: ${e.toString()}')
          );
        }
      },
      onError: (error) {
        _messageControllers[chatId]?.addError(
          ServerException('Error en listener de mensajes: ${error.toString()}')
        );
      },
    );
  }

  /// Marca un mensaje como leído
  Future<void> markMessageAsRead(String chatId, String messageId, String userId) async {
    try {
      final messageRef = _messagesRef.child(chatId).child(messageId);
      
      await messageRef.child('readBy').child(userId).set(ServerValue.timestamp);
      
      // Actualizar estado si es necesario
      final snapshot = await messageRef.child('readBy').get();
      if (snapshot.exists) {
        final readBy = Map<String, dynamic>.from(snapshot.value as Map);
        if (readBy.length > 1) { // Más de una persona lo leyó
          await messageRef.update({'status': MessageStatus.read.name});
        }
      }
    } catch (e) {
      throw ServerException('Error marcando mensaje como leído: ${e.toString()}');
    }
  }

  // =================== OPERACIONES DE TYPING ===================

  /// Indica que un usuario está escribiendo
  Future<void> setUserTyping(String chatId, String userId, bool isTyping) async {
    try {
      final typingRef = _typingRef.child(chatId).child(userId);

      if (isTyping) {
        // Marcar como escribiendo con timestamp
        await typingRef.set(ServerValue.timestamp);
        
        // Configurar auto-limpieza después de 5 segundos
        _typingTimers[chatId]?.cancel();
        _typingTimers[chatId] = Timer(const Duration(seconds: 5), () {
          typingRef.remove();
        });
      } else {
        // Remover indicador de typing
        await typingRef.remove();
        _typingTimers[chatId]?.cancel();
      }
    } catch (e) {
      throw ServerException('Error actualizando estado de typing: ${e.toString()}');
    }
  }

  /// Obtiene stream de usuarios escribiendo
  Stream<List<String>> getTypingUsersStream(String chatId) {
    if (!_typingControllers.containsKey(chatId)) {
      _typingControllers[chatId] = StreamController<List<String>>.broadcast();
      _setupTypingListener(chatId);
    }

    return _typingControllers[chatId]!.stream;
  }

  /// Configura el listener de typing
  void _setupTypingListener(String chatId) {
    final typingRef = _typingRef.child(chatId);

    typingRef.onValue.listen(
      (DatabaseEvent event) {
        try {
          final data = event.snapshot.value as Map<dynamic, dynamic>?;
          
          if (data == null) {
            _typingControllers[chatId]?.add([]);
            return;
          }

          final typingUsers = <String>[];
          final now = DateTime.now().millisecondsSinceEpoch;

          data.forEach((userId, timestamp) {
            // Solo considerar typing si fue en los últimos 5 segundos
            if (timestamp is int && (now - timestamp) < 5000) {
              typingUsers.add(userId.toString());
            }
          });

          _typingControllers[chatId]?.add(typingUsers);
        } catch (e) {
          _typingControllers[chatId]?.addError(
            ServerException('Error en stream de typing: ${e.toString()}')
          );
        }
      },
      onError: (error) {
        _typingControllers[chatId]?.addError(
          ServerException('Error en listener de typing: ${error.toString()}')
        );
      },
    );
  }

  // =================== OPERACIONES DE CHAT ===================

  /// Crea un nuevo chat
  Future<ChatEntity> createChat({
    required List<String> participants,
    required ChatType type,
    GroupInfo? groupInfo,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw AuthenticationException('Usuario no autenticado');
      }

      final chatRef = _chatsRef.push();
      final chatId = chatRef.key!;
      final now = DateTime.now();

      final chat = ChatEntity(
        id: chatId,
        participants: participants,
        type: type,
        groupInfo: groupInfo,
        createdAt: now,
        updatedAt: now,
      );

      final chatData = _chatEntityToMap(chat);
      await chatRef.set(chatData);

      return chat;
    } catch (e) {
      throw ServerException('Error creando chat: ${e.toString()}');
    }
  }

  /// Obtiene stream de chats del usuario
  Stream<List<ChatEntity>> getUserChatsStream(String userId) {
    final chatsQuery = _chatsRef
        .orderByChild('participants/$userId')
        .equalTo(true);

    return chatsQuery.onValue.map((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      
      if (data == null) return <ChatEntity>[];

      final chats = <ChatEntity>[];
      
      data.forEach((key, value) {
        try {
          final chatMap = Map<String, dynamic>.from(value as Map);
          chatMap['id'] = key;
          final chat = _mapToChatEntity(chatMap);
          chats.add(chat);
        } catch (e) {
          print('Error parsing chat $key: $e');
        }
      });

      // Ordenar por último mensaje
      chats.sort((a, b) {
        if (a.lastMessageTime == null && b.lastMessageTime == null) return 0;
        if (a.lastMessageTime == null) return 1;
        if (b.lastMessageTime == null) return -1;
        return b.lastMessageTime!.compareTo(a.lastMessageTime!);
      });

      return chats;
    });
  }

  // =================== MÉTODOS DE CONVERSIÓN ===================

  /// Convierte MessageEntity a Map para Firebase
  Map<String, dynamic> _messageEntityToMap(MessageEntity message) {
    return {
      'chatId': message.chatId,
      'senderId': message.senderId,
      'content': message.content,
      'type': message.type.name,
      'timestamp': message.timestamp.millisecondsSinceEpoch,
      'status': message.status.name,
      'readBy': message.readBy.asMap().map((index, userId) => MapEntry(userId, true)),
      'isDeleted': message.isDeleted,
      if (message.attachment != null) 'attachment': _fileAttachmentToMap(message.attachment!),
      if (message.location != null) 'location': _locationDataToMap(message.location!),
      if (message.replyToMessageId != null) 'replyToMessageId': message.replyToMessageId,
      if (message.metadata != null) 'metadata': message.metadata,
      if (message.editedAt != null) 'editedAt': message.editedAt!.millisecondsSinceEpoch,
    };
  }

  /// Convierte Map de Firebase a MessageEntity
  MessageEntity _mapToMessageEntity(Map<String, dynamic> map) {
    return MessageEntity(
      id: map['id'] ?? '',
      chatId: map['chatId'] ?? '',
      senderId: map['senderId'] ?? '',
      content: map['content'] ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => MessageType.text,
      ),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
      status: MessageStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => MessageStatus.sent,
      ),
      readBy: _parseReadBy(map['readBy']),
      isDeleted: map['isDeleted'] ?? false,
      attachment: map['attachment'] != null ? _mapToFileAttachment(map['attachment']) : null,
      location: map['location'] != null ? _mapToLocationData(map['location']) : null,
      replyToMessageId: map['replyToMessageId'],
      metadata: map['metadata'],
      editedAt: map['editedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['editedAt']) : null,
    );
  }

  /// Convierte ChatEntity a Map para Firebase
  Map<String, dynamic> _chatEntityToMap(ChatEntity chat) {
    final participantsMap = <String, bool>{};
    for (final participant in chat.participants) {
      participantsMap[participant] = true;
    }

    return {
      'participants': participantsMap,
      'type': chat.type.name,
      'createdAt': chat.createdAt.millisecondsSinceEpoch,
      'updatedAt': chat.updatedAt.millisecondsSinceEpoch,
      'isActive': chat.isActive,
      if (chat.lastMessage != null) 'lastMessage': chat.lastMessage,
      if (chat.lastMessageTime != null) 'lastMessageTime': chat.lastMessageTime!.millisecondsSinceEpoch,
      if (chat.groupInfo != null) 'groupInfo': _groupInfoToMap(chat.groupInfo!),
      if (chat.lastReadBy != null) 'lastReadBy': _lastReadByToMap(chat.lastReadBy!),
    };
  }

  /// Convierte Map de Firebase a ChatEntity
  ChatEntity _mapToChatEntity(Map<String, dynamic> map) {
    final participantsMap = Map<String, dynamic>.from(map['participants'] ?? {});
    final participants = participantsMap.keys.toList().cast<String>();

    return ChatEntity(
      id: map['id'] ?? '',
      participants: participants,
      type: ChatType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => ChatType.individual,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? 0),
      isActive: map['isActive'] ?? true,
      lastMessage: map['lastMessage'],
      lastMessageTime: map['lastMessageTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['lastMessageTime'])
          : null,
      groupInfo: map['groupInfo'] != null ? _mapToGroupInfo(map['groupInfo']) : null,
      lastReadBy: map['lastReadBy'] != null ? _mapToLastReadBy(map['lastReadBy']) : null,
    );
  }

  // =================== MÉTODOS AUXILIARES ===================

  /// Actualiza el último mensaje del chat
  Future<void> _updateChatLastMessage(String chatId, MessageEntity message) async {
    final chatRef = _chatsRef.child(chatId);
    await chatRef.update({
      'lastMessage': message.previewText,
      'lastMessageTime': message.timestamp.millisecondsSinceEpoch,
      'updatedAt': ServerValue.timestamp,
    });
  }

  /// Parsea readBy de Firebase
  List<String> _parseReadBy(dynamic readBy) {
    if (readBy == null) return [];
    if (readBy is Map) {
      return readBy.keys.toList().cast<String>();
    }
    return [];
  }

  /// Convierte FileAttachment a Map
  Map<String, dynamic> _fileAttachmentToMap(FileAttachment attachment) {
    return {
      'fileName': attachment.fileName,
      'fileUrl': attachment.fileUrl,
      if (attachment.mimeType != null) 'mimeType': attachment.mimeType,
      if (attachment.fileSize != null) 'fileSize': attachment.fileSize,
      if (attachment.thumbnailUrl != null) 'thumbnailUrl': attachment.thumbnailUrl,
      if (attachment.duration != null) 'duration': attachment.duration!.inMilliseconds,
      if (attachment.metadata != null) 'metadata': attachment.metadata,
    };
  }

  /// Convierte Map a FileAttachment
  FileAttachment _mapToFileAttachment(Map<String, dynamic> map) {
    return FileAttachment(
      fileName: map['fileName'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      mimeType: map['mimeType'],
      fileSize: map['fileSize'],
      thumbnailUrl: map['thumbnailUrl'],
      duration: map['duration'] != null ? Duration(milliseconds: map['duration']) : null,
      metadata: map['metadata'],
    );
  }

  /// Convierte LocationData a Map
  Map<String, dynamic> _locationDataToMap(LocationData location) {
    return {
      'latitude': location.latitude,
      'longitude': location.longitude,
      if (location.address != null) 'address': location.address,
      if (location.name != null) 'name': location.name,
      if (location.accuracy != null) 'accuracy': location.accuracy,
    };
  }

  /// Convierte Map a LocationData
  LocationData _mapToLocationData(Map<String, dynamic> map) {
    return LocationData(
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      address: map['address'],
      name: map['name'],
      accuracy: map['accuracy']?.toDouble(),
    );
  }

  /// Convierte GroupInfo a Map
  Map<String, dynamic> _groupInfoToMap(GroupInfo groupInfo) {
    return {
      'name': groupInfo.name,
      'adminId': groupInfo.adminId,
      'createdAt': groupInfo.createdAt.millisecondsSinceEpoch,
      if (groupInfo.description != null) 'description': groupInfo.description,
      if (groupInfo.photoUrl != null) 'photoUrl': groupInfo.photoUrl,
      if (groupInfo.customData != null) 'customData': groupInfo.customData,
    };
  }

  /// Convierte Map a GroupInfo
  GroupInfo _mapToGroupInfo(Map<String, dynamic> map) {
    return GroupInfo(
      name: map['name'] ?? '',
      adminId: map['adminId'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      description: map['description'],
      photoUrl: map['photoUrl'],
      customData: map['customData']?.cast<String, String>(),
    );
  }

  /// Convierte lastReadBy a Map
  Map<String, dynamic> _lastReadByToMap(Map<String, DateTime> lastReadBy) {
    return lastReadBy.map((key, value) => MapEntry(key, value.millisecondsSinceEpoch));
  }

  /// Convierte Map a lastReadBy
  Map<String, DateTime> _mapToLastReadBy(Map<String, dynamic> map) {
    return map.map((key, value) => MapEntry(key, DateTime.fromMillisecondsSinceEpoch(value)));
  }

  // =================== LIMPIEZA Y DISPOSICIÓN ===================

  /// Limpia los recursos del servicio
  void dispose() {
    // Cancelar timers
    for (final timer in _typingTimers.values) {
      timer.cancel();
    }
    _typingTimers.clear();

    // Cerrar stream controllers
    for (final controller in _messageControllers.values) {
      controller.close();
    }
    _messageControllers.clear();

    for (final controller in _typingControllers.values) {
      controller.close();
    }
    _typingControllers.clear();

    for (final controller in _chatControllers.values) {
      controller.close();
    }
    _chatControllers.clear();
  }

  /// Limpia recursos específicos de un chat
  void disposeChatResources(String chatId) {
    _typingTimers[chatId]?.cancel();
    _typingTimers.remove(chatId);
    
    _messageControllers[chatId]?.close();
    _messageControllers.remove(chatId);
    
    _typingControllers[chatId]?.close();
    _typingControllers.remove(chatId);
    
    _chatControllers[chatId]?.close();
    _chatControllers.remove(chatId);
  }
}
