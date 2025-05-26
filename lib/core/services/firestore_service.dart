// lib/services/implementations/firestore_service_impl.dart
// ignore_for_file: always_specify_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/core/utils/firebase_crud_helper.dart';
import '../../domain/interfaces/firestore_interface.dart';

class FirestoreServiceImpl implements FirestoreInterface {
  final FirebaseFirestore _firestore;
  static final Logger _logger = Logger();

  FirestoreServiceImpl(this._firestore);

  @override
  Future<List<Map<String, dynamic>>> getSuggestedPlans(
    final List<String> categories,
  ) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('events')
          .where('categoria', whereIn: categories)
          .get();

      return snapshot.docs
          .map(
            (final QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                <String, String>{
                  'title': doc['nombre_evento'] as String,
                  'category': doc['categoria'] as String,
                  'imageUrl': doc['image_url_png'] as String,
                },
          )
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting suggested plans: $e');
      }
      return <Map<String, dynamic>>[];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> searchPlans(final String query) async {
    try {
      // Implementar búsqueda por nombre similar usando helper
      final docs = await FirebaseCrudHelper.getCollectionSafely(
        _firestore,
        'events',
        queryBuilder: (collectionRef) => collectionRef
            .orderBy('nombre_evento')
            .startAt(<Object?>[query])
            .endAt(<Object?>['$query\uf8ff']),
      );

      return docs
          .map(
            (final doc) => <String, String>{
              'title': doc['nombre_evento'] as String,
              'category': doc['categoria'] as String,
              'imageUrl': doc['image_url_png'] as String,
            },
          )
          .toList();
    } catch (e) {
      _logger.e('Error searching plans: $e');
      return <Map<String, dynamic>>[];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCollectionData(
    final String collectionPath, {
    final Map<String, dynamic>? whereConditions,
    final String? orderByField,
    final bool descending = false,
  }) async {
    try {
      // Usar el helper para obtener la colección
      final docs = await FirebaseCrudHelper.getCollectionSafely(
        _firestore,
        collectionPath,
        queryBuilder: (collectionRef) {
          Query<Map<String, dynamic>> query = collectionRef;

          // Aplicar condiciones where si existen
          if (whereConditions != null) {
            whereConditions.forEach((final String field, final value) {
              query = query.where(field, isEqualTo: value);
            });
          }

          // Aplicar ordenamiento si se especifica
          if (orderByField != null) {
            query = query.orderBy(orderByField, descending: descending);
          }

          return query;
        },
      );

      return docs
          .map(
            (final doc) => <String, dynamic>{
              ...?doc.data(),
              'id': doc.id, // Incluir el ID del documento
            },
          )
          .toList();
    } catch (e) {
      _logger.e('Error getting collection data: $e');
      return <Map<String, dynamic>>[];
    }
  }

  @override
  Future<void> updateDocument(
    final String collectionPath,
    final String documentId,
    final Map<String, dynamic> data,
  ) async {
    try {
      final success = await FirebaseCrudHelper.updateDocumentSafely(
        _firestore,
        collectionPath,
        documentId,
        data,
      );

      if (!success) {
        throw Exception('Error al actualizar el documento');
      }
    } catch (e) {
      _logger.e('Error updating document: $e');
      rethrow;
    }
  }

  @override
  String getCurrentUserId() {
    // Implementar la lógica para obtener el ID del usuario actual
    // Esto generalmente implica usar FirebaseAuth.instance.currentUser?.uid
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    return userId ?? '';
  }
}
