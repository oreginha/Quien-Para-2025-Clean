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

    test('should compress and decompress lists correctly', () {
      final originalList = [1, 2, 3, 'test', true, null];

      final compressed = CompressionUtils.compressList(originalList);
      expect(compressed, isNotNull);

      final decompressed = CompressionUtils.decompressToList(compressed);
      expect(decompressed, equals(originalList));
    });

    test('should compress and decompress maps correctly', () {
      final originalMap = {
        'key1': 'value1',
        'key2': 42,
        'key3': true,
        'key4': null,
      };

      final compressed = CompressionUtils.compressMap(originalMap);
      expect(compressed, isNotNull);

      final decompressed = CompressionUtils.decompressToMap(compressed);
      expect(decompressed, equals(originalMap));
    });

    test('should calculate compression ratio correctly', () {
      const originalSize = 1000;
      const compressedSize = 300;

      final ratio = CompressionUtils.getCompressionRatio(
        originalSize,
        compressedSize,
      );

      expect(ratio, equals(0.3));
    });

    test('should determine when to compress based on threshold', () {
      const shortText = 'Short';
      const longText = 'This is a much longer text that exceeds the threshold';

      expect(
          CompressionUtils.shouldCompress(shortText, threshold: 10), isFalse);
      expect(CompressionUtils.shouldCompress(longText, threshold: 10), isTrue);
    });
  });
}
