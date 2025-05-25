// lib/scripts/initialize_firebase_collections.dart
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quien_para/data/models/chat/chat_model.dart';

import 'package:quien_para/data/models/plan/plan_model.dart';
import 'package:quien_para/data/models/user/user_model.dart';
import 'package:quien_para/data/models/application/application_model.dart';
import 'package:quien_para/data/models/notificacions/notification_model.dart';

/// Clase para inicializar y gestionar la estructura de Firebase
class FirebaseInitializer {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Inicializa todas las colecciones en Firebase si no existen
  Future<void> initializeCollections() async {
    try {
      print('Iniciando creación de colecciones en Firebase...');

      // Crear colecciones principales
      await _createUsersCollection();
      await _createPlansCollection();
      await _createChatsCollection();
      await _createApplicationsCollection();
      await _createNotificationsCollection();

      print('Todas las colecciones han sido inicializadas correctamente.');

      // Exportar la estructura para verificación
      await exportCollectionsStructure();
    } catch (e) {
      print('Error al inicializar colecciones: $e');
    }
  }

  /// Crea la colección de usuarios con un documento de ejemplo
  Future<void> _createUsersCollection() async {
    final collectionRef = _firestore.collection('users');
    final snapshot = await collectionRef.limit(1).get();

    if (snapshot.docs.isEmpty) {
      print('Creando colección de usuarios...');

      // Crear usuario de ejemplo
      final UserModel exampleUser = UserModel(
        id: 'example_user_id',
        name: 'Usuario Ejemplo',
        age: 25,
        email: 'ejemplo@mail.com',
        photoUrls: ['https://example.com/photo.jpg'],
        interests: ['deportes', 'música', 'viajes'],
        bio: 'Perfil de ejemplo para la aplicación',
        isVisible: true,
        hasCompletedOnboarding: true,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );

      // Guardar en Firestore
      await collectionRef.doc(exampleUser.id).set(exampleUser.toFirestore());

      // Crear subcolección de intereses
      final interestsRef =
          collectionRef.doc(exampleUser.id).collection('interests');
      for (final interest in exampleUser.interests) {
        await interestsRef.add({
          'name': interest,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      print('Colección de usuarios creada con éxito.');
    } else {
      print('La colección de usuarios ya existe.');
    }
  }

  /// Crea la colección de planes con un documento de ejemplo
  Future<void> _createPlansCollection() async {
    final collectionRef = _firestore.collection('plans');
    final snapshot = await collectionRef.limit(1).get();

    if (snapshot.docs.isEmpty) {
      print('Creando colección de planes...');

      // Crear plan de ejemplo
      final String planId = 'example_plan_id';
      final PlanModel examplePlan = PlanModel(
        id: planId,
        title: 'Plan de ejemplo',
        description:
            'Descripción del plan de ejemplo para probar la aplicación',
        imageUrl: 'https://example.com/plan.jpg',
        creatorId: 'example_user_id',
        date: DateTime.now().add(const Duration(days: 3)),
        likes: 5,
        category: 'social',
        location: 'Madrid, España',
        conditions: {'edad': '18+', 'requisitos': 'Ninguno'},
        selectedThemes: ['fiesta', 'comida', 'música'],
        createdAt: DateTime.now().toIso8601String(),
      );

      // Guardar en Firestore
      await collectionRef.doc(planId).set({
        'title': examplePlan.title,
        'description': examplePlan.description,
        'imageUrl': examplePlan.imageUrl,
        'creatorId': examplePlan.creatorId,
        'date': Timestamp.fromDate(examplePlan.date),
        'likes': examplePlan.likes,
        'category': examplePlan.category,
        'location': examplePlan.location,
        'conditions': examplePlan.conditions,
        'selectedThemes': examplePlan.selectedThemes,
        'createdAt': Timestamp.now(),
        'esVisible': examplePlan.esVisible,
      });

      // Crear subcolección de comentarios
      final commentsRef = collectionRef.doc(planId).collection('comments');
      await commentsRef.add({
        'userId': 'example_user_id',
        'text': 'Este plan se ve genial!',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Crear subcolección de participantes
      final participantsRef =
          collectionRef.doc(planId).collection('participants');
      await participantsRef.add({
        'userId': 'example_user_id',
        'joinedAt': FieldValue.serverTimestamp(),
        'status': 'confirmed',
      });

      print('Colección de planes creada con éxito.');
    } else {
      print('La colección de planes ya existe.');
    }
  }

  /// Crea la colección de chats con un documento de ejemplo
  Future<void> _createChatsCollection() async {
    final collectionRef = _firestore.collection('chats');
    final snapshot = await collectionRef.limit(1).get();

    if (snapshot.docs.isEmpty) {
      print('Creando colección de chats...');

      // Crear chat de ejemplo
      final String chatId = 'example_chat_id';
      final ChatModel exampleChat = ChatModel(
        id: chatId,
        participants: ['example_user_id', 'another_user_id'],
        createdAt: DateTime.now(),
        lastMessageTimestamp: DateTime.now(),
        lastMessage: 'Hola, ¿cómo estás?',
        lastMessageSenderId: 'example_user_id',
        unreadCount: 0,
        isGroupChat: false,
        active: true,
      );

      // Guardar en Firestore
      await collectionRef.doc(chatId).set({
        'participants': exampleChat.participants,
        'createdAt': Timestamp.fromDate(exampleChat.createdAt),
        'lastMessageTimestamp':
            Timestamp.fromDate(exampleChat.lastMessageTimestamp!),
        'lastMessage': exampleChat.lastMessage,
        'lastMessageSenderId': exampleChat.lastMessageSenderId,
        'unreadCount': exampleChat.unreadCount,
        'isGroupChat': exampleChat.isGroupChat,
        'active': exampleChat.active,
      });

      // Crear subcolección de mensajes
      final messagesRef = collectionRef.doc(chatId).collection('messages');
      await messagesRef.add({
        'senderId': 'example_user_id',
        'content': 'Hola, ¿cómo estás?',
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      });

      print('Colección de chats creada con éxito.');
    } else {
      print('La colección de chats ya existe.');
    }
  }

  /// Crea la colección de aplicaciones con un documento de ejemplo
  Future<void> _createApplicationsCollection() async {
    final collectionRef = _firestore.collection('applications');
    final snapshot = await collectionRef.limit(1).get();

    if (snapshot.docs.isEmpty) {
      print('Creando colección de aplicaciones...');

      // Crear aplicación de ejemplo
      final String applicationId = 'example_application_id';
      final ApplicationModel exampleApplication = ApplicationModel(
        id: applicationId,
        planId: 'example_plan_id',
        applicantId: 'another_user_id',
        status: 'pending',
        appliedAt: DateTime.now(),
        message: 'Me gustaría unirme a este plan',
        planTitle: 'Plan de ejemplo',
        planImageUrl: 'https://example.com/plan.jpg',
        applicantName: 'Otro Usuario',
        applicantPhotoUrl: 'https://example.com/another_user.jpg',
      );

      // Guardar en Firestore
      await collectionRef.doc(applicationId).set({
        'planId': exampleApplication.planId,
        'applicantId': exampleApplication.applicantId,
        'status': exampleApplication.status,
        'appliedAt': Timestamp.fromDate(exampleApplication.appliedAt),
        'message': exampleApplication.message,
        'planTitle': exampleApplication.planTitle,
        'planImageUrl': exampleApplication.planImageUrl,
        'applicantName': exampleApplication.applicantName,
        'applicantPhotoUrl': exampleApplication.applicantPhotoUrl,
      });

      // Crear subcolección de mensajes
      final messagesRef =
          collectionRef.doc(applicationId).collection('messages');
      await messagesRef.add({
        'senderId': 'another_user_id',
        'text': 'Estoy interesado en este plan',
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Colección de aplicaciones creada con éxito.');
    } else {
      print('La colección de aplicaciones ya existe.');
    }
  }

  /// Crea la colección de notificaciones con un documento de ejemplo
  Future<void> _createNotificationsCollection() async {
    final collectionRef = _firestore.collection('notifications');
    final snapshot = await collectionRef.limit(1).get();

    if (snapshot.docs.isEmpty) {
      print('Creando colección de notificaciones...');

      // Crear notificación de ejemplo
      final String notificationId = 'example_notification_id';
      final NotificationModel exampleNotification = NotificationModel(
        id: notificationId,
        userId: 'example_user_id',
        planId: 'example_plan_id',
        applicationId: 'example_application_id',
        title: 'Nueva solicitud',
        message: 'Tienes una nueva solicitud para tu plan',
        read: false,
        createdAt: DateTime.now(),
        type: 'plan_application',
        data: {
          'planId': 'example_plan_id',
          'applicationId': 'example_application_id',
        },
      );

      // Guardar en Firestore
      await collectionRef.doc(notificationId).set({
        'userId': exampleNotification.userId,
        'planId': exampleNotification.planId,
        'applicationId': exampleNotification.applicationId,
        'title': exampleNotification.title,
        'message': exampleNotification.message,
        'read': exampleNotification.read,
        'createdAt': Timestamp.fromDate(exampleNotification.createdAt),
        'type': exampleNotification.type,
        'data': exampleNotification.data,
      });

      print('Colección de notificaciones creada con éxito.');
    } else {
      print('La colección de notificaciones ya existe.');
    }
  }

  /// Exporta la estructura de colecciones a un archivo JSON
  Future<Map<String, dynamic>> exportCollectionsStructure() async {
    final Map<String, dynamic> structure = {};

    try {
      // Definimos todas las colecciones principales según los modelos
      final List<String> knownCollections = [
        'plans',
        'users',
        'chats',
        'applications',
        'notifications',
      ];

      // Mapa de subcolecciones conocidas por colección principal
      final Map<String, List<String>> knownSubcollections = {
        'plans': ['comments', 'participants', 'likes'],
        'users': ['saved_plans', 'interests', 'notifications'],
        'chats': ['messages', 'participants'],
        'applications': ['messages'],
      };

      // Procesar cada colección principal
      for (final collectionName in knownCollections) {
        final CollectionReference collection =
            _firestore.collection(collectionName);
        structure[collectionName] = {
          'schema': {},
          'subcollections': {},
          'sample_documents': [],
        };

        // Obtener documentos de muestra
        final QuerySnapshot snapshot = await collection.limit(3).get();

        if (snapshot.docs.isNotEmpty) {
          // Analizar la estructura de los documentos
          final Map<String, String> fieldTypes = {};

          // Procesar cada documento de muestra
          for (final doc in snapshot.docs) {
            final Map<String, dynamic> docData =
                doc.data() as Map<String, dynamic>;
            final Map<String, dynamic> sampleDoc = {
              'id': doc.id,
              'data': docData,
            };

            // Añadir a la lista de documentos de muestra
            (structure[collectionName]['sample_documents'] as List)
                .add(sampleDoc);

            // Detectar tipos de campos
            docData.forEach((key, value) {
              String type = _getFieldType(value);
              fieldTypes[key] = type;
            });
          }

          // Guardar el esquema detectado
          structure[collectionName]['schema'] = fieldTypes;

          // Verificar subcolecciones conocidas
          if (knownSubcollections.containsKey(collectionName)) {
            final sampleDoc = snapshot.docs.first;

            for (final subName in knownSubcollections[collectionName]!) {
              try {
                final subQuery = await sampleDoc.reference
                    .collection(subName)
                    .limit(2)
                    .get();

                if (subQuery.docs.isNotEmpty) {
                  // Analizar estructura de la subcolección
                  final Map<String, String> subFieldTypes = {};
                  final List<Map<String, dynamic>> subSamples = [];

                  for (final subDoc in subQuery.docs) {
                    final Map<String, dynamic> subDocData = subDoc.data();
                    subSamples.add({
                      'id': subDoc.id,
                      'data': subDocData,
                    });

                    // Detectar tipos de campos en la subcolección
                    subDocData.forEach((key, value) {
                      String type = _getFieldType(value);
                      subFieldTypes[key] = type;
                    });
                  }

                  // Guardar información de la subcolección
                  structure[collectionName]['subcollections'][subName] = {
                    'schema': subFieldTypes,
                    'sample_documents': subSamples,
                  };
                }
              } catch (e) {
                // Ignorar errores, simplemente significa que la subcolección no existe
                if (kDebugMode) {
                  print('Error al acceder a subcolección $subName: $e');
                }
              }
            }
          }
        } else {
          structure[collectionName]['status'] = 'empty_collection';
        }
      }

      // Guardar como JSON en un archivo con fecha y hora
      final String timestamp =
          DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final String fileName = 'firebase_structure_$timestamp.json';

      // Guardar en directorio de documentos
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String outputPath = '${appDocDir.path}/$fileName';
      final File outputFile = File(outputPath);
      await outputFile
          .writeAsString(JsonEncoder.withIndent('  ').convert(structure));

      // También guardar en directorio del proyecto
      final String projectOutputPath = 'firebase_export/$fileName';
      final Directory projectDir = Directory('.');
      final String fullProjectPath =
          '${projectDir.absolute.path}/$projectOutputPath';
      final File projectOutputFile = File(fullProjectPath);
      await projectOutputFile
          .writeAsString(JsonEncoder.withIndent('  ').convert(structure));

      print('Estructura exportada a: $outputPath');
      print('Copia guardada en: $fullProjectPath');

      return structure;
    } catch (e) {
      print('Error al exportar estructura: $e');
      return {'error': e.toString()};
    }
  }
}

/// Función auxiliar para determinar el tipo de un campo
String _getFieldType(dynamic value) {
  if (value == null) return 'null';
  if (value is String) return 'string';
  if (value is int) return 'integer';
  if (value is double) return 'double';
  if (value is bool) return 'boolean';
  if (value is List) {
    return 'array<${value.isNotEmpty ? _getFieldType(value.first) : 'any'}>';
  }
  if (value is Map) return 'map<string, any>';
  if (value is Timestamp) return 'timestamp';
  if (value is GeoPoint) return 'geopoint';
  if (value is DocumentReference) return 'reference';
  return value.runtimeType.toString();
}

/// Función principal para inicializar Firebase desde la aplicación
Future<void> initializeFirebaseCollections() async {
  final initializer = FirebaseInitializer();
  await initializer.initializeCollections();
}
