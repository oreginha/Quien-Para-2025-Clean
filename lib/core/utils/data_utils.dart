// lib/core/utils/data_utils.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Clase utilitaria para operaciones comunes de transformación y mapeo de datos.
///
/// Proporciona métodos para:
/// - Convertir tipos de datos
/// - Mapear documentos de Firestore
/// - Transformar estructuras de datos
/// - Validar datos
class DataUtils {
  /// Convierte un valor en un tipo específico de manera segura
  static T? safeCast<T>(dynamic value) {
    if (value == null) return null;
    if (value is T) return value;

    // Conversiones específicas
    if (T == String && value != null) {
      return value.toString() as T;
    } else if (T == int && value is num) {
      return value.toInt() as T;
    } else if (T == double && value is num) {
      return value.toDouble() as T;
    } else if (T == bool && (value is String || value is num)) {
      if (value is String) {
        return (value.toLowerCase() == 'true') as T;
      } else if (value is num) {
        return (value != 0) as T;
      }
    } else if (T == DateTime) {
      if (value is Timestamp) {
        return value.toDate() as T;
      } else if (value is String) {
        try {
          return DateTime.parse(value) as T;
        } catch (_) {
          return null;
        }
      }
    }

    if (kDebugMode) {
      print('Warning: Failed to cast $value to $T');
    }
    return null;
  }

  /// Extrae un valor de un mapa de manera segura, con conversión de tipo
  static T? getValueFromMap<T>(Map<String, dynamic>? map, String key) {
    if (map == null || !map.containsKey(key)) return null;
    return safeCast<T>(map[key]);
  }

  /// Convierte una lista de documentos de Firestore a una lista de objetos
  static List<T> mapQuerySnapshot<T>(
    QuerySnapshot snapshot,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return snapshot.docs
        .map((doc) => fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Convierte un documento de Firestore a un objeto
  static T? mapDocumentSnapshot<T>(
    DocumentSnapshot? snapshot,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (snapshot == null || !snapshot.exists) return null;
    return fromJson(snapshot.data() as Map<String, dynamic>);
  }

  /// Convierte un Timestamp a DateTime de manera segura
  static DateTime? timestampToDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is Timestamp) return value.toDate();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Filtra las claves nulas o vacías de un mapa
  static Map<String, dynamic> filterNullOrEmpty(Map<String, dynamic> map) {
    return Map.fromEntries(
      map.entries.where(
        (entry) =>
            entry.value != null &&
            (entry.value is! String || (entry.value as String).isNotEmpty),
      ),
    );
  }

  /// Comprueba si un string es null, vacío o solo espacios en blanco
  static bool isNullOrBlank(String? str) {
    return str == null || str.trim().isEmpty;
  }

  /// Actualiza un mapa con nuevos valores, omitiendo nulos
  static Map<String, dynamic> updateMapSkipNull(
    Map<String, dynamic> original,
    Map<String, dynamic> updates,
  ) {
    final result = Map<String, dynamic>.from(original);
    updates.forEach((key, value) {
      if (value != null) {
        result[key] = value;
      }
    });
    return result;
  }

  /// Convierte los valores nulos en un mapa a valores por defecto
  static Map<String, dynamic> setDefaultsForNullValues<T>(
    Map<String, dynamic> map,
    Map<String, T> defaults,
  ) {
    final result = Map<String, dynamic>.from(map);
    defaults.forEach((key, defaultValue) {
      if (result[key] == null) {
        result[key] = defaultValue;
      }
    });
    return result;
  }
}
