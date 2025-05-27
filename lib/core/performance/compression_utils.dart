import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

class CompressionUtils {
  /// Compresses a string using GZIP compression
  static Uint8List compressString(String input) {
    final bytes = utf8.encode(input);
    final compressed = gzip.encode(bytes);
    return Uint8List.fromList(compressed);
  }

  /// Decompresses GZIP compressed data back to a string
  static String decompressString(Uint8List compressed) {
    final decompressed = gzip.decode(compressed);
    return utf8.decode(decompressed);
  }

  /// Compresses bytes using GZIP compression
  static Uint8List compressBytes(Uint8List input) {
    final compressed = gzip.encode(input);
    return Uint8List.fromList(compressed);
  }

  /// Decompresses GZIP compressed bytes
  static Uint8List decompressBytes(Uint8List compressed) {
    final decompressed = gzip.decode(compressed);
    return Uint8List.fromList(decompressed);
  }

  /// Compresses a list to bytes
  static Uint8List compressList<T>(List<T> input) {
    final jsonString = jsonEncode(input);
    return compressString(jsonString);
  }

  /// Decompresses bytes back to a list
  static List<T> decompressToList<T>(Uint8List compressed) {
    final jsonString = decompressString(compressed);
    final decoded = jsonDecode(jsonString);
    return List<T>.from(decoded);
  }

  /// Compresses a map to bytes
  static Uint8List compressMap<K, V>(Map<K, V> input) {
    final jsonString = jsonEncode(input);
    return compressString(jsonString);
  }

  /// Decompresses bytes back to a map
  static Map<K, V> decompressToMap<K, V>(Uint8List compressed) {
    final jsonString = decompressString(compressed);
    final decoded = jsonDecode(jsonString);
    return Map<K, V>.from(decoded);
  }

  /// Gets the compression ratio (compressed size / original size)
  static double getCompressionRatio(int originalSize, int compressedSize) {
    if (originalSize == 0) return 0.0;
    return compressedSize / originalSize;
  }

  /// Checks if compression would be beneficial for the given data
  static bool shouldCompress(String data, {int threshold = 100}) {
    return data.length > threshold;
  }
}
