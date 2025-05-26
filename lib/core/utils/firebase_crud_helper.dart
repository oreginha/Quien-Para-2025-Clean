// lib/core/utils/firebase_crud_helper.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quien_para/core/utils/web/firestore_web_fix.dart';
import 'package:logger/logger.dart';

/// Clase de utilidad para mejorar el manejo de operaciones CRUD de Firebase
/// principalmente para evitar problemas comunes en entorno web
class FirebaseCrudHelper {
  static final Logger _logger = Logger();

  /// Obtiene un documento de manera segura, manejando errores y optimizando para web
  static Future<DocumentSnapshot<Map<String, dynamic>>?> getDocumentSafely(
    FirebaseFirestore firestore,
    String collection,
    String documentId,
  ) async {
    try {
      // Optimización para web: implementar un sistema de reintentos
      int maxRetries = kIsWeb ? 3 : 1;
      int retryCount = 0;

      while (retryCount < maxRetries) {
        try {
          final docSnapshot = await firestore
              .collection(collection)
              .doc(documentId)
              .get();
          return docSnapshot;
        } catch (e) {
          retryCount++;
          _logger.e('Error obteniendo documento (intento $retryCount): $e');

          // Si estamos en el último intento, propagar el error
          if (retryCount >= maxRetries) {
            rethrow;
          }

          // Esperar antes de reintentar
          await Future.delayed(Duration(milliseconds: 300 * retryCount));
        }
      }

      return null;
    } catch (e) {
      _logger.e('Error fatal obteniendo documento $documentId: $e');
      // Solo propagamos en modo debug para evitar errores en producción
      if (kDebugMode) {
        rethrow;
      }
      return null;
    }
  }

  /// Obtiene una colección de documentos de manera segura
  static Future<List<DocumentSnapshot<Map<String, dynamic>>>>
  getCollectionSafely(
    FirebaseFirestore firestore,
    String collection, {
    Query<Map<String, dynamic>> Function(
      CollectionReference<Map<String, dynamic>>,
    )?
    queryBuilder,
    int batchSize = 10,
  }) async {
    try {
      // Aplicar el modificador a la consulta si se proporciona
      Query<Map<String, dynamic>> query = firestore.collection(collection);
      if (queryBuilder != null) {
        query = queryBuilder(firestore.collection(collection));
      }

      // Obtener los documentos
      final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

      // En web, si hay muchos documentos, procesarlos por lotes
      if (kIsWeb && snapshot.docs.length > batchSize) {
        _logger.d(
          'Procesando ${snapshot.docs.length} documentos en lotes de $batchSize',
        );

        List<DocumentSnapshot<Map<String, dynamic>>> result = [];

        for (int i = 0; i < snapshot.docs.length; i += batchSize) {
          final int end = (i + batchSize < snapshot.docs.length)
              ? i + batchSize
              : snapshot.docs.length;

          result.addAll(snapshot.docs.sublist(i, end));

          // Esperar un momento para no sobrecargar el hilo principal en web
          if (kIsWeb && i + batchSize < snapshot.docs.length) {
            await Future.delayed(const Duration(milliseconds: 50));
          }
        }

        return result;
      }

      return snapshot.docs;
    } catch (e) {
      _logger.e('Error obteniendo colección $collection: $e');
      // Retornar lista vacía en caso de error para evitar errores en cascada
      return [];
    }
  }

  /// Crea un stream de consulta a Firestore que es seguro para web
  static Stream<QuerySnapshot<Map<String, dynamic>>> createSafeQueryStream(
    FirebaseFirestore firestore,
    String collection, {
    Query<Map<String, dynamic>> Function(
      CollectionReference<Map<String, dynamic>>,
    )?
    queryBuilder,
  }) {
    try {
      // Aplicar el modificador a la consulta si se proporciona
      Query<Map<String, dynamic>> query = firestore.collection(collection);
      if (queryBuilder != null) {
        query = queryBuilder(firestore.collection(collection));
      }

      // Crear el stream de la consulta
      final queryStream = query.snapshots();

      // Aplicar el fix para web si estamos en entorno web
      if (kIsWeb) {
        _logger.d(
          'Aplicando FirestoreWebFix para stream de consulta de $collection',
        );
        return FirestoreWebFix.safeQueryStream(queryStream);
      }

      return queryStream;
    } catch (e) {
      _logger.e('Error creando stream de consulta para $collection: $e');
      // Retornar un stream vacío en caso de error
      return Stream.fromIterable([]);
    }
  }

  /// Crea un stream de documento que es seguro para web
  static Stream<DocumentSnapshot<Map<String, dynamic>>>
  createSafeDocumentStream(
    FirebaseFirestore firestore,
    String collection,
    String documentId,
  ) {
    try {
      // Crear el stream del documento
      final documentStream = firestore
          .collection(collection)
          .doc(documentId)
          .snapshots();

      // Aplicar el fix para web si estamos en entorno web
      if (kIsWeb) {
        _logger.d(
          'Aplicando FirestoreWebFix para stream de documento $documentId',
        );
        return FirestoreWebFix.safeDocumentStream(documentStream);
      }

      return documentStream;
    } catch (e) {
      _logger.e('Error creando stream de documento para $documentId: $e');
      // Retornar un stream vacío en caso de error
      return Stream.fromIterable([]);
    }
  }

  /// Actualiza un documento de manera segura
  static Future<bool> updateDocumentSafely(
    FirebaseFirestore firestore,
    String collection,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    try {
      // Optimización para web: implementar un sistema de reintentos
      int maxRetries = kIsWeb ? 3 : 1;
      int retryCount = 0;

      while (retryCount < maxRetries) {
        try {
          await firestore.collection(collection).doc(documentId).update(data);
          return true;
        } catch (e) {
          retryCount++;
          _logger.e('Error actualizando documento (intento $retryCount): $e');

          // Si estamos en el último intento, propagar el error
          if (retryCount >= maxRetries) {
            return false;
          }

          // Esperar antes de reintentar
          await Future.delayed(Duration(milliseconds: 300 * retryCount));
        }
      }

      return false;
    } catch (e) {
      _logger.e('Error fatal actualizando documento $documentId: $e');
      return false;
    }
  }

  /// Crea un documento de manera segura
  static Future<String?> createDocumentSafely(
    FirebaseFirestore firestore,
    String collection,
    Map<String, dynamic> data, {
    String? documentId,
  }) async {
    try {
      if (documentId != null) {
        // Si se proporciona un ID, usar set
        await firestore.collection(collection).doc(documentId).set(data);
        return documentId;
      } else {
        // Si no se proporciona un ID, usar add
        final docRef = await firestore.collection(collection).add(data);
        return docRef.id;
      }
    } catch (e) {
      _logger.e('Error creando documento en $collection: $e');
      return null;
    }
  }

  /// Elimina un documento de manera segura
  static Future<bool> deleteDocumentSafely(
    FirebaseFirestore firestore,
    String collection,
    String documentId,
  ) async {
    try {
      await firestore.collection(collection).doc(documentId).delete();
      return true;
    } catch (e) {
      _logger.e('Error eliminando documento $documentId: $e');
      return false;
    }
  }
}
