// lib/services/analytics_service.dart
// ignore_for_file: always_specify_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  // Almacenamiento en memoria para métricas
  static final Map<String, Map<String, int>> _metrics =
      <String, Map<String, int>>{};

  Future<void> trackCitySelection(
    final String city,
    final bool isEnabled,
  ) async {
    if (!_metrics.containsKey(city)) {
      _metrics[city] = <String, int>{
        'totalAttempts': 0,
        'successfulSelections': 0,
        'rejectedSelections': 0,
      };
    }

    _metrics[city]!['totalAttempts'] =
        (_metrics[city]!['totalAttempts'] ?? 0) + 1;
    if (isEnabled) {
      _metrics[city]!['successfulSelections'] =
          (_metrics[city]!['successfulSelections'] ?? 0) + 1;
    } else {
      _metrics[city]!['rejectedSelections'] =
          (_metrics[city]!['rejectedSelections'] ?? 0) + 1;
    }
  }

  // Método para obtener métricas (útil para testing y debugging)
  Map<String, Map<String, int>> getMetrics() {
    return Map.from(_metrics);
  }

  // Método para limpiar métricas (útil para testing)
  void clearMetrics() {
    _metrics.clear();
  }
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> trackCitySelection(final String city, final bool isEnabled) async {
  try {
    // Obtenemos la referencia del documento de la ciudad
    final DocumentReference<Map<String, dynamic>> cityRef =
        _firestore.collection('cityMetrics').doc(city);

    // Realizamos una transacción para garantizar la precisión del contador
    await _firestore.runTransaction((final Transaction transaction) async {
      final DocumentSnapshot<Map<String, dynamic>> cityDoc =
          await transaction.get(cityRef);

      if (!cityDoc.exists) {
        // Si el documento no existe, lo creamos con valores iniciales
        transaction.set(cityRef, <String, Object>{
          'totalAttempts': 1,
          'successfulSelections': isEnabled ? 1 : 0,
          'rejectedSelections': isEnabled ? 0 : 1,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        // Si el documento existe, actualizamos los contadores
        transaction.update(cityRef, <String, dynamic>{
          'totalAttempts': FieldValue.increment(1),
          'successfulSelections': FieldValue.increment(isEnabled ? 1 : 0),
          'rejectedSelections': FieldValue.increment(isEnabled ? 0 : 1),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
    });
  } catch (e) {
    if (kDebugMode) {
      print('Error tracking city selection: $e');
    }
  }
}
