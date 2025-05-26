// lib/core/services/application_chat_service.dart
// Servicio para manejar la creación de chats entre aplicantes y creadores de planes

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/application/application_entity.dart';

/// Servicio que gestiona la creación de conversaciones de chat
/// entre aplicantes y creadores de planes.
class ApplicationChatService {
  final FirebaseFirestore _firestore;

  /// Constructor por defecto que utiliza la instancia de Firestore
  ApplicationChatService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Crea un chat para una aplicación que ha sido aceptada
  ///
  /// Retorna el ID del chat creado o null si hubo un error
  Future<String?> createChatForAcceptedApplication(
    ApplicationEntity application,
  ) async {
    try {
      if (application.status != 'accepted') {
        if (kDebugMode) {
          print(
            '⚠️ No se puede crear chat para una aplicación que no está aceptada',
          );
        }
        return null;
      }

      // Verificar si ya existe un chat para esta aplicación
      final existingChatQuery = await _firestore
          .collection('chats')
          .where('applicationId', isEqualTo: application.id)
          .limit(1)
          .get();

      if (existingChatQuery.docs.isNotEmpty) {
        if (kDebugMode) {
          print('ℹ️ Ya existe un chat para esta aplicación');
        }
        return existingChatQuery.docs.first.id;
      }

      // Crear nuevo chat
      final newChatRef = _firestore.collection('chats').doc();

      await newChatRef.set({
        'applicationId': application.id,
        'planId': application.planId,
        'participants': [
          application.applicantId, // Aplicante
          application.planId, // Creador del plan
        ],
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': null,
        'lastMessageTime': null,
      });

      // Crear el primer mensaje del sistema
      await _firestore.collection('chat_messages').add({
        'chatId': newChatRef.id,
        'senderId': 'system',
        'content':
            '¡Chat iniciado! Ahora pueden coordinar los detalles del plan.',
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
        'type': 'system',
      });

      if (kDebugMode) {
        print(
          '✅ Chat creado exitosamente para la aplicación ${application.id}',
        );
      }

      return newChatRef.id;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error al crear chat para aplicación: $e');
      }
      return null;
    }
  }

  /// Verifica si existe un chat para una aplicación específica
  Future<bool> chatExistsForApplication(String applicationId) async {
    try {
      final chatQuery = await _firestore
          .collection('chats')
          .where('applicationId', isEqualTo: applicationId)
          .limit(1)
          .get();

      return chatQuery.docs.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error al verificar existencia de chat: $e');
      }
      return false;
    }
  }

  /// Obtiene el ID del chat para una aplicación específica
  Future<String?> getChatIdForApplication(String applicationId) async {
    try {
      final chatQuery = await _firestore
          .collection('chats')
          .where('applicationId', isEqualTo: applicationId)
          .limit(1)
          .get();

      if (chatQuery.docs.isEmpty) {
        return null;
      }

      return chatQuery.docs.first.id;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error al obtener ID de chat: $e');
      }
      return null;
    }
  }
}
