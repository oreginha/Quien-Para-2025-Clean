// lib/core/performance/compression_utils.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:archive/archive.dart';
import '../logger/logger.dart';

/// Clase de utilidades para compresión y descompresión de datos
/// Utiliza algoritmos de compresión para reducir el tamaño de los datos almacenados en caché
class CompressionUtils {
  /// Comprime una cadena de texto usando el algoritmo GZip
  ///
  /// Retorna una representación Base64 de los datos comprimidos
  /// Si ocurre un error, retorna la cadena original
  static String compressString(String data) {
    try {
      // Convertir string a bytes
      final List<int> stringBytes = utf8.encode(data);

      // Comprimir usando GZip
      final List<int> gzipBytes = GZipEncoder().encode(stringBytes);

      // Convertir a Base64 para almacenamiento seguro
      final String compressedData = base64Encode(gzipBytes);

      if (kDebugMode) {
        final compressionRatio = (compressedData.length / data.length) * 100;
        print(
          'Compresión: ${compressionRatio.toStringAsFixed(2)}% del tamaño original',
        );
      }

      return compressedData;
    } catch (e) {
      logger.e('Error al comprimir datos', error: e);
      return data; // Retornar datos originales en caso de error
    }
  }

  /// Descomprime una cadena previamente comprimida con compressString
  ///
  /// Si ocurre un error, retorna la cadena de entrada
  static String decompressString(String compressedData) {
    try {
      // Comprobar si los datos están comprimidos (verificación básica)
      if (!_looksCompressed(compressedData)) {
        return compressedData;
      }

      // Decodificar Base64
      final List<int> compressedBytes = base64Decode(compressedData);

      // Descomprimir GZip
      final List<int> decompressedBytes = GZipDecoder().decodeBytes(
        compressedBytes,
      );

      // Convertir bytes a String
      return utf8.decode(decompressedBytes);
    } catch (e) {
      logger.e('Error al descomprimir datos', error: e);
      return compressedData; // Retornar datos comprimidos en caso de error
    }
  }

  /// Verifica si una cadena parece estar comprimida (en Base64)
  static bool _looksCompressed(String data) {
    // Verificación simple: las cadenas Base64 tienen caracteres específicos
    final RegExp base64Pattern = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');

    return base64Pattern.hasMatch(data) &&
        data.length > 20 && // Evitar falsos positivos con cadenas cortas
        !data.contains(' '); // Las cadenas Base64 no tienen espacios
  }

  /// Comprime un mapa a formato JSON y luego comprime la cadena resultante
  static String compressMap(Map<String, dynamic> map) {
    try {
      final String jsonString = jsonEncode(map);
      return compressString(jsonString);
    } catch (e) {
      logger.e('Error al comprimir mapa', error: e);
      return jsonEncode(map); // Retornar JSON sin comprimir en caso de error
    }
  }

  /// Descomprime y convierte de nuevo a Map
  static Map<String, dynamic>? decompressToMap(String compressedData) {
    try {
      final String jsonString = decompressString(compressedData);
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      logger.e('Error al descomprimir a mapa', error: e);
      return null;
    }
  }

  /// Comprime una lista de objetos
  static String compressList(List<dynamic> list) {
    try {
      final String jsonString = jsonEncode(list);
      return compressString(jsonString);
    } catch (e) {
      logger.e('Error al comprimir lista', error: e);
      return jsonEncode(list); // Retornar JSON sin comprimir en caso de error
    }
  }

  /// Descomprime y convierte de nuevo a List
  static List<dynamic>? decompressToList(String compressedData) {
    try {
      final String jsonString = decompressString(compressedData);
      return jsonDecode(jsonString) as List<dynamic>;
    } catch (e) {
      logger.e('Error al descomprimir a lista', error: e);
      return null;
    }
  }

  /// Mide la tasa de compresión (cuánto más pequeños son los datos comprimidos)
  static double measureCompressionRatio(String original, String compressed) {
    if (original.isEmpty) return 0.0;
    return (compressed.length / original.length) * 100;
  }
}
