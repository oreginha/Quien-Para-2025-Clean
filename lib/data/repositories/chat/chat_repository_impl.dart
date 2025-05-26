import 'package:quien_para/core/utils/firebase_crud_helper.dart'; // lib/data/repositories/chat_repository_impl.dart

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import 'package:quien_para/core/utils/web/firestore_web_fix.dart';
import 'package:quien_para/data/mappers/chat_mapper.dart';
import 'package:quien_para/data/mappers/message_mapper.dart';
import 'package:quien_para/domain/entities/conversation/conversation_entity.dart';
import 'package:quien_para/domain/entities/message_entity.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/chat/chat_repository.dart';

/// Implementación mejorada del repositorio de chat que sigue los principios de Clean Architecture
/// y utiliza Either para un manejo de errores consistente.
class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final ChatMapper _chatMapper;
  final MessageMapper _messageMapper;
  final Logger _logger;

  /// Constructor principal con todas las dependencias inyectadas
  ChatRepositoryImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required ChatMapper chatMapper,
    required MessageMapper messageMapper,
    Logger? logger,
  }) : _firestore = firestore,
       _auth = auth,
       _chatMapper = chatMapper,
       _messageMapper = messageMapper,
       _logger = logger ?? Logger();

  @override
  Future<Either<AppFailure, String>> createConversation({
    required List<String> participants,
    String? initialMessage,
  }) async {
    _logger.d(
      '📊 [ChatRepositoryImpl] Creando conversación con ${participants.length} participantes',
    );

    try {
      // Ordenar participantes para consistencia
      final sortedParticipants = [...participants]..sort();

      // 1. Crear el documento de la conversación
      final chatRef = _firestore.collection('chats').doc();

      // 2. Preparar datos iniciales de la conversación
      final chatData = {
        'participants': sortedParticipants,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': initialMessage ?? '',
        'lastMessageTime': FieldValue.serverTimestamp(),
        'unreadCount': 0,
      };

      // 3. Guardar el documento
      await chatRef.set(chatData);

      // 4. Si hay mensaje inicial, añadirlo
      if (initialMessage != null && initialMessage.isNotEmpty) {
        final currentUser = _auth.currentUser;
        final senderId = currentUser?.uid ?? participants.first;

        await chatRef.collection('messages').add({
          'senderId': senderId,
          'content': initialMessage,
          'timestamp': FieldValue.serverTimestamp(),
          'isRead': false,
        });
      }

      return Right(chatRef.id);
    } catch (e) {
      _logger.e('Error creando conversación: $e');
      return Left(
        AppFailure(
          code: 'chat-create-error',
          message: 'Error al crear la conversación: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<AppFailure, ConversationEntity?>> getConversation(
    String conversationId,
  ) async {
    _logger.d(
      '📊 [ChatRepositoryImpl] Obteniendo conversación: $conversationId',
    );

    try {
      // Usar nuestro helper para obtener el documento de forma segura
      final docSnapshot = await FirebaseCrudHelper.getDocumentSafely(
        _firestore,
        'chats',
        conversationId,
      );

      if (docSnapshot == null || !docSnapshot.exists) {
        return const Right(null);
      }

      final conversationEntity = _chatMapper.fromFirestore(docSnapshot);
      return Right(conversationEntity);
    } catch (e) {
      _logger.e('Error obteniendo conversación: $e');
      return Left(
        AppFailure(
          code: 'chat-fetch-error',
          message: 'Error al obtener la conversación: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<AppFailure, ConversationEntity?>> getExistingConversation(
    String userId1,
    String userId2,
  ) async {
    _logger.d(
      '📊 [ChatRepositoryImpl] Buscando conversación existente entre $userId1 y $userId2',
    );

    try {
      // Ordenar los participantes para garantizar consistencia en la consulta
      final sortedParticipants = [userId1, userId2]..sort();

      // Usar nuestro helper para obtener documentos de forma segura
      final docs = await FirebaseCrudHelper.getCollectionSafely(
        _firestore,
        'chats',
        queryBuilder: (collectionRef) => collectionRef.where(
          'participants',
          arrayContainsAny: sortedParticipants,
        ),
        batchSize: 20,
      );

      if (docs.isNotEmpty) {
        // Buscar el documento que contenga exactamente estos dos participantes
        for (final doc in docs) {
          final data = doc.data();
          final List<dynamic> participants = data?['participants'] ?? [];
          if (participants.length == 2 &&
              participants.contains(userId1) &&
              participants.contains(userId2)) {
            final conversationEntity = _chatMapper.fromFirestore(doc);
            return Right(conversationEntity);
          }
        }
      }

      return const Right(null);
    } catch (e) {
      _logger.e('Error buscando conversación existente: $e');
      return Left(
        AppFailure(
          code: 'chat-find-error',
          message: 'Error al buscar conversación existente: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Stream<Either<AppFailure, List<ConversationEntity>>> getConversations(
    String userId,
  ) {
    _logger.d(
      '📊 [ChatRepositoryImpl] Obteniendo stream de conversaciones para usuario $userId',
    );

    try {
      // Usar nuestro helper para crear un stream seguro para web
      final safeStream = FirebaseCrudHelper.createSafeQueryStream(
        _firestore,
        'chats',
        queryBuilder: (collectionRef) =>
            collectionRef.where('participants', arrayContains: userId),
      );

      // Transformar los resultados usando el mapper
      return safeStream
          .map<Either<AppFailure, List<ConversationEntity>>>((snapshot) {
            try {
              final conversations = snapshot.docs
                  .map((doc) => _chatMapper.fromFirestore(doc))
                  .toList();
              return Right(conversations);
            } catch (e) {
              _logger.e('Error procesando conversaciones: $e');
              return Left(
                AppFailure(
                  code: 'chat-stream-process-error',
                  message:
                      'Error al procesar stream de conversaciones: ${e.toString()}',
                ),
              );
            }
          })
          .handleError((error) {
            _logger.e('Error en stream de conversaciones: $error');
            return Left(
              AppFailure(
                code: 'chat-stream-error',
                message:
                    'Error en el stream de conversaciones: ${error.toString()}',
              ),
            );
          });
    } catch (e) {
      _logger.e('Error iniciando stream de conversaciones: $e');
      return Stream.value(
        Left(
          AppFailure(
            code: 'chat-stream-init-error',
            message:
                'Error al iniciar stream de conversaciones: ${e.toString()}',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<AppFailure, Unit>> sendMessage({
    required String conversationId,
    required String content,
    Map<String, dynamic>? metadata,
  }) async {
    _logger.d(
      '💬 [ChatRepositoryImpl] Enviando mensaje a conversación $conversationId',
    );

    try {
      // Obtener el ID del usuario actual
      final senderId = _auth.currentUser?.uid ?? 'unknown-user';

      // Crear documento de mensaje
      final messageData = {
        'senderId': senderId,
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'metadata': metadata,
      };

      // Añadir mensaje a la colección de forma segura
      await FirebaseCrudHelper.createDocumentSafely(
        _firestore,
        'chats/$conversationId/messages',
        messageData,
      );

      // Actualizar la información de la última conversación de forma segura
      await FirebaseCrudHelper.updateDocumentSafely(
        _firestore,
        'chats',
        conversationId,
        {
          'lastMessage': content,
          'lastMessageTime': FieldValue.serverTimestamp(),
          'lastMessageSenderId': senderId,
        },
      );

      return const Right(unit);
    } catch (e) {
      _logger.e('Error enviando mensaje: $e');
      return Left(
        AppFailure(
          code: 'message-send-error',
          message: 'Error al enviar mensaje: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Stream<Either<AppFailure, List<MessageEntity>>> getMessages(
    String conversationId,
  ) {
    _logger.d(
      '📊 [ChatRepositoryImpl] Obteniendo stream de mensajes para: $conversationId',
    );

    try {
      // Usar nuestro helper para crear un stream seguro para web
      final safeStream = FirebaseCrudHelper.createSafeQueryStream(
        _firestore,
        'chats/$conversationId/messages',
        queryBuilder: (collectionRef) =>
            collectionRef.orderBy('timestamp', descending: true),
      );

      // Transformar los resultados usando el mapper
      return safeStream
          .map<Either<AppFailure, List<MessageEntity>>>((snapshot) {
            try {
              final messages = snapshot.docs
                  .map((doc) => _messageMapper.fromFirestore(doc))
                  .toList();
              return Right(messages);
            } catch (e) {
              _logger.e('Error procesando mensajes: $e');
              return Left(
                AppFailure(
                  code: 'message-stream-process-error',
                  message:
                      'Error al procesar stream de mensajes: ${e.toString()}',
                ),
              );
            }
          })
          .handleError((error) {
            _logger.e('Error en stream de mensajes: $error');
            return Left(
              AppFailure(
                code: 'message-stream-error',
                message: 'Error en el stream de mensajes: ${error.toString()}',
              ),
            );
          });
    } catch (e) {
      _logger.e('Error iniciando stream de mensajes: $e');
      return Stream.value(
        Left(
          AppFailure(
            code: 'message-stream-init-error',
            message: 'Error al iniciar stream de mensajes: ${e.toString()}',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<AppFailure, Unit>> markConversationAsRead({
    required String conversationId,
    required String userId,
  }) async {
    _logger.d(
      '📝 [ChatRepositoryImpl] Marcando conversación como leída: $conversationId para usuario: $userId',
    );

    try {
      // Obtener referencia a la conversación
      final conversationRef = _firestore
          .collection('chats')
          .doc(conversationId);
      final conversationDoc = await conversationRef.get();

      if (!conversationDoc.exists) {
        _logger.w('La conversación no existe: $conversationId');
        return Left(
          AppFailure(
            code: 'chat-not-found',
            message: 'La conversación no existe: $conversationId',
          ),
        );
      }

      // Actualizar los mensajes no leídos para el usuario
      final querySnapshot = await conversationRef
          .collection('messages')
          .where('isRead', isEqualTo: false)
          .where('senderId', isNotEqualTo: userId)
          .get();

      // Marcar cada mensaje como leído en un batch
      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      // Actualizar el contador de no leídos de la conversación
      batch.update(conversationRef, {'unreadCount': 0});

      // Ejecutar el batch
      await batch.commit();

      return const Right(unit);
    } catch (e) {
      _logger.e('Error marcando conversación como leída: $e');
      return Left(
        AppFailure(
          code: 'mark-read-error',
          message: 'Error al marcar conversación como leída: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<AppFailure, Unit>> deleteConversation(
    String conversationId,
  ) async {
    _logger.d(
      '📊 [ChatRepositoryImpl] Eliminando conversación $conversationId',
    );

    try {
      // Eliminar todos los datos de la conversación
      // 1. Eliminar los mensajes de la conversación
      final messagesRef = _firestore
          .collection('chats')
          .doc(conversationId)
          .collection('messages');

      final messagesSnapshot = await messagesRef.get();

      // Eliminar todos los mensajes uno por uno
      for (final doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      // 2. Eliminar el documento principal de la conversación
      await _firestore.collection('chats').doc(conversationId).delete();

      _logger.d('Conversación eliminada con éxito: $conversationId');
      return const Right(unit);
    } catch (e) {
      _logger.e('Error eliminando conversación: $e');
      return Left(
        AppFailure(
          code: 'chat-delete-error',
          message: 'Error al eliminar la conversación: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Stream<Either<AppFailure, int>> getUnreadMessagesCount(String userId) {
    _logger.d(
      '📊 [ChatRepositoryImpl] Obteniendo contador de mensajes no leídos para usuario: $userId',
    );

    try {
      // Crear un StreamController para emitir el conteo de mensajes no leídos
      final controller = StreamController<Either<AppFailure, int>>.broadcast();

      // Obtener todas las conversaciones del usuario
      final conversationStream = _firestore
          .collection('chats')
          .where('participants', arrayContains: userId)
          .snapshots();

      // Aplicar el wrapper de seguridad para web
      final safeStream = FirestoreWebFix.safeQueryStream(conversationStream);

      safeStream.listen(
        (conversationsSnapshot) {
          int totalUnread = 0;

          // Si no hay conversaciones, emitir 0
          if (conversationsSnapshot.docs.isEmpty) {
            controller.add(const Right(0));
            return;
          }

          // Contador para realizar un seguimiento de las conversaciones procesadas
          int processedCount = 0;

          // Para cada conversación, contar los mensajes no leídos
          for (final conversationDoc in conversationsSnapshot.docs) {
            final messagesStream = _firestore
                .collection('chats')
                .doc(conversationDoc.id)
                .collection('messages')
                .where('isRead', isEqualTo: false)
                .where(
                  'senderId',
                  isNotEqualTo: userId,
                ) // Solo mensajes de otros usuarios
                .snapshots();

            // Aplicar el wrapper de seguridad para web
            final safeMessagesStream = FirestoreWebFix.safeQueryStream(
              messagesStream,
            );

            safeMessagesStream.listen(
              (messagesSnapshot) {
                // Actualizar el contador total
                totalUnread += messagesSnapshot.docs.length;

                // Incrementar el contador de conversaciones procesadas
                processedCount++;

                // Si se han procesado todas las conversaciones, emitir el total
                if (processedCount >= conversationsSnapshot.docs.length) {
                  controller.add(Right(totalUnread));
                }
              },
              onError: (error) {
                _logger.e('Error en stream de mensajes: $error');
                controller.add(
                  Left(
                    AppFailure(
                      code: 'unread-count-message-error',
                      message:
                          'Error al obtener mensajes no leídos: ${error.toString()}',
                    ),
                  ),
                );
              },
            );
          }
        },
        onError: (error) {
          _logger.e('Error en stream de conversaciones: $error');
          controller.add(
            Left(
              AppFailure(
                code: 'unread-count-conversation-error',
                message:
                    'Error al obtener conversaciones para conteo no leídos: ${error.toString()}',
              ),
            ),
          );
        },
      );

      return controller.stream;
    } catch (e) {
      _logger.e('Error iniciando conteo de mensajes no leídos: $e');
      return Stream.value(
        Left(
          AppFailure(
            code: 'unread-count-init-error',
            message:
                'Error al iniciar conteo de mensajes no leídos: ${e.toString()}',
          ),
        ),
      );
    }
  }

  @override
  Future<Either<AppFailure, Unit>> markMessagesAsRead(
    String conversationId,
    String userId,
  ) async {
    _logger.d(
      '📝 [ChatRepositoryImpl] Marcando mensajes como leídos para usuario: $userId en conversación: $conversationId',
    );

    try {
      // Obtener referencia a la conversación
      final conversationRef = _firestore
          .collection('chats')
          .doc(conversationId);
      final conversationDoc = await conversationRef.get();

      if (!conversationDoc.exists) {
        _logger.w('La conversación no existe: $conversationId');
        return Left(
          AppFailure(
            code: 'chat-not-found',
            message: 'La conversación no existe: $conversationId',
          ),
        );
      }

      // Actualizar los mensajes no leídos para el usuario
      final querySnapshot = await conversationRef
          .collection('messages')
          .where('isRead', isEqualTo: false)
          .where('senderId', isNotEqualTo: userId)
          .get();

      // Marcar cada mensaje como leído en un batch
      final batch = _firestore.batch();
      for (final doc in querySnapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      // Actualizar el contador de no leídos de la conversación
      batch.update(conversationRef, {'unreadCount': 0});

      // Ejecutar el batch
      await batch.commit();

      _logger.d('${querySnapshot.docs.length} mensajes marcados como leídos');
      return const Right(unit);
    } catch (e) {
      _logger.e('Error marcando mensajes como leídos: $e');
      return Left(
        AppFailure(
          code: 'mark-messages-read-error',
          message: 'Error al marcar mensajes como leídos: ${e.toString()}',
        ),
      );
    }
  }
}
