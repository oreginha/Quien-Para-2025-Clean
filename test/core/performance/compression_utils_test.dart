import 'package:flutter_test/flutter_test.dart';
import 'package:quien_para/core/performance/compression_utils.dart';

void main() {
  group('CompressionUtils', () {
    test('should compress and decompress string correctly', () {
      const originalString = 'Hello, World! This is a test string.';

      final compressed = CompressionUtils.compressString(originalString);
      expect(compressed, isNotNull);
      expect(compressed.length, lessThan(originalString.length));

      final decompressed = CompressionUtils.decompressString(compressed);
      expect(decompressed, equals(originalString));
    });

    test('should handle empty string', () {
      const emptyString = '';

      final compressed = CompressionUtils.compressString(emptyString);
      expect(compressed, isNotNull);

      final decompressed = CompressionUtils.decompressString(compressed);
      expect(decompressed, equals(emptyString));
    });

    test('should handle unicode characters', () {
      const unicodeString = '🎯 Hello, 世界! Café ñoño 🚀';

      final compressed = CompressionUtils.compressString(unicodeString);
      expect(compressed, isNotNull);

      final decompressed = CompressionUtils.decompressString(compressed);
      expect(decompressed, equals(unicodeString));
    });

    test('should compress large text efficiently', () {
      final largeText = 'This is a large text. ' * 1000;

      final compressed = CompressionUtils.compressString(largeText);
      expect(compressed, isNotNull);
      expect(compressed.length, lessThan(largeText.length));

      final decompressed = CompressionUtils.decompressString(compressed);
      expect(decompressed, equals(largeText));

      final compressionRatio = compressed.length / largeText.length;
      expect(compressionRatio, lessThan(0.5)); // At least 50% compression
    });
  });
}
