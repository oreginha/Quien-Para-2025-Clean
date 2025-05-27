// lib/scripts/export_collections.dart
// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

/// Ejecuta esta función desde tu aplicación para exportar la estructura
/// de colecciones a un archivo JSON.
Future<Map<String, dynamic>> exportCollectionsStructure() async {
  final Map<String, dynamic> structure = {};
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Definimos todas las colecciones principales según los diagramas
    final List<String> knownCollections = [
      'plans',
      'users',
      'chats',
      'applications',
      'notifications',
      'events', // Colección adicional detectada en el código
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
      final CollectionReference collection = firestore.collection(
        collectionName,
      );
      structure[collectionName] = {
        'schema': {},
        'subcollections': {},
        'sample_documents': [],
      };

      // Intentar obtener documentos de muestra
      try {
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
            (structure[collectionName]['sample_documents'] as List).add(
              sampleDoc,
            );

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
                    subSamples.add({'id': subDoc.id, 'data': subDocData});

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
      } catch (e) {
        structure[collectionName]['status'] = 'error';
        structure[collectionName]['error_message'] = e.toString();
        if (kDebugMode) {
          print('Error al procesar colección $collectionName: $e');
        }
      }
    }

    // Guardar como JSON en un archivo con fecha y hora
    final String timestamp = DateFormat(
      'yyyyMMdd_HHmmss',
    ).format(DateTime.now());
    final String fileName = 'firebase_structure_$timestamp.json';

    // Guardar en directorio de documentos
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String outputPath = '${appDocDir.path}/$fileName';
    final File outputFile = File(outputPath);
    await outputFile.writeAsString(
      JsonEncoder.withIndent('  ').convert(structure),
    );

    // También guardar en directorio temporal para compatibilidad
    final String tempOutputPath = '${Directory.systemTemp.path}/$fileName';
    final File tempOutputFile = File(tempOutputPath);
    await tempOutputFile.writeAsString(
      JsonEncoder.withIndent('  ').convert(structure),
    );

    if (kDebugMode) {
      print('Estructura exportada a: $outputPath');
      print('Copia guardada en: $tempOutputPath');
    }

    return structure;
  } catch (e) {
    if (kDebugMode) {
      print('Error al exportar estructura: $e');
    }
    return {'error': e.toString()};
  }
}

/// Widget para mostrar la estructura en la app
class CollectionStructureViewer extends StatefulWidget {
  const CollectionStructureViewer({super.key});

  @override
  _CollectionStructureViewerState createState() =>
      _CollectionStructureViewerState();
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

/// Función para crear colecciones y documentos de ejemplo si no existen
Future<void> createExampleCollectionsIfNotExist() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Map<String, Map<String, dynamic>> exampleData = {
    'plans': {
      'title': 'Plan de ejemplo',
      'description': 'Descripción del plan de ejemplo',
      'location': 'Madrid, España',
      'date': Timestamp.now(),
      'category': 'social',
      'tags': ['ejemplo', 'test'],
      'imageUrl': 'https://example.com/image.jpg',
      'creatorId': 'user123',
      'conditions': {'edad': '18+', 'requisitos': 'Ninguno'},
      'selectedThemes': ['fiesta', 'comida'],
      'likes': 0,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
      'status': 'active',
    },
    'users': {
      'name': 'Usuario Ejemplo',
      'age': 25,
      'email': 'ejemplo@mail.com',
      'photoUrls': ['https://example.com/photo.jpg'],
      'interests': ['deportes', 'música'],
      'bio': 'Perfil de ejemplo para la aplicación',
      'isVisible': true,
      'hasCompletedOnboarding': true,
      'createdAt': Timestamp.now(),
      'lastLogin': Timestamp.now(),
      'gender': 'no especificado',
      'location': 'Barcelona, España',
    },
    'chats': {
      'participants': ['user123', 'user456'],
      'createdAt': Timestamp.now(),
      'lastMessageTimestamp': Timestamp.now(),
      'lastMessage': 'Hola, ¿cómo estás?',
      'lastMessageSenderId': 'user123',
      'unreadCount': 0,
      'isGroupChat': false,
      'active': true,
    },
    'applications': {
      'planId': 'plan123',
      'applicantId': 'user456',
      'status': 'pending',
      'appliedAt': Timestamp.now(),
      'message': 'Me gustaría unirme a este plan',
    },
    'notifications': {
      'userId': 'user123',
      'message': 'Tienes una nueva solicitud para tu plan',
      'read': false,
      'createdAt': Timestamp.now(),
      'type': 'plan_application',
      'data': {'planId': 'plan123', 'applicationId': 'app123'},
      'actionType': 'open_plan',
    },
  };

  try {
    // Verificar y crear colecciones de ejemplo
    for (final entry in exampleData.entries) {
      final collectionName = entry.key;
      final exampleDocData = entry.value;

      // Verificar si la colección está vacía
      final snapshot =
          await firestore.collection(collectionName).limit(1).get();

      if (snapshot.docs.isEmpty) {
        // Crear documento de ejemplo
        await firestore.collection(collectionName).add(exampleDocData);
        if (kDebugMode) {
          print('Creado documento de ejemplo en colección: $collectionName');
        }

        // Crear subcolecciones de ejemplo si es necesario
        if (collectionName == 'chats') {
          final chatDoc =
              await firestore.collection('chats').add(exampleDocData);
          await chatDoc.collection('messages').add({
            'senderId': 'user123',
            'text': 'Hola, este es un mensaje de ejemplo',
            'timestamp': Timestamp.now(),
            'read': false,
          });
        } else if (collectionName == 'applications') {
          final appDoc =
              await firestore.collection('applications').add(exampleDocData);
          await appDoc.collection('messages').add({
            'senderId': 'user123',
            'text': 'Mensaje relacionado con la aplicación',
            'timestamp': Timestamp.now(),
          });
        }
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error al crear colecciones de ejemplo: $e');
    }
  }
}

class _CollectionStructureViewerState extends State<CollectionStructureViewer> {
  bool _loading = true;
  Map<String, dynamic> _structure = {};
  String _error = '';
  String _exportPath = '';

  @override
  void initState() {
    super.initState();
    _loadStructure();
  }

  Future<void> _loadStructure() async {
    try {
      // Primero intentar crear colecciones de ejemplo si no existen
      await createExampleCollectionsIfNotExist();

      // Luego exportar la estructura
      final structure = await exportCollectionsStructure();

      setState(() {
        _structure = structure;
        _loading = false;

        // Obtener la ruta del archivo exportado
        final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
        _exportPath =
            '${Directory.systemTemp.path}/firebase_structure_$timestamp.json';
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text('Exportando Colecciones')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Exportando estructura de Firebase...'),
            ],
          ),
        ),
      );
    }

    if (_error.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 48),
                SizedBox(height: 16),
                Text('Error: $_error', style: TextStyle(color: Colors.red)),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _loadStructure,
                  child: Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Estructura de Firebase')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estructura exportada correctamente',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Archivo guardado en: $_exportPath'),
            SizedBox(height: 16),
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Text(
                      JsonEncoder.withIndent('  ').convert(_structure),
                      style: TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadStructure,
        tooltip: 'Actualizar',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
