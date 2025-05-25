import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:quien_para/core/performance/compression_utils.dart';

void main() {
  group('CompressionUtils', () {
    group('compressString', () {
      test('debería comprimir una cadena correctamente', () {
        // Arrange
        const String original =
            'Este es un texto de prueba que debería ser comprimido';

        // Act
        final String compressed = CompressionUtils.compressString(original);

        // Assert
        expect(compressed, isNot(equals(original)));
        expect(base64Decode(compressed).isNotEmpty, isTrue);

        // Para cadenas cortas es normal que la compresión aumente el tamaño
        // debido al overhead de compresion y la codificación base64
        final double ratio =
            CompressionUtils.measureCompressionRatio(original, compressed);

        // Solo verificamos que el cálculo de ratio es correcto
        expect(ratio, equals((compressed.length / original.length) * 100));
      });

      test('debería comprimir incluso cadenas vacías', () {
        // Aunque podría parecer contraintuitivo, incluso una cadena vacía se puede comprimir,
        // ya que el formato de compresión GZip y la codificación Base64 añaden metadatos

        // Arrange
        const String original = '';

        // Act
        final String compressed = CompressionUtils.compressString(original);

        // Assert - para una cadena vacía, debería retornar una representación comprimida válida
        expect(compressed, isNot(equals(original)));
        expect(base64Decode(compressed).isNotEmpty, isTrue);
      });

      // Nota: El caso de error real es difícil de probar directamente, pues requiere
      // forzar una excepción en la codificación/compresión
    });

    group('decompressString', () {
      test('debería descomprimir una cadena comprimida correctamente', () {
        // Arrange
        const String original =
            'Este es un texto que será comprimido y luego descomprimido';
        final String compressed = CompressionUtils.compressString(original);

        // Act
        final String decompressed =
            CompressionUtils.decompressString(compressed);

        // Assert
        expect(decompressed, equals(original));
      });

      test('debería manejar cadenas no comprimidas', () {
        // Arrange
        const String nonCompressed = 'Esta cadena no está comprimida';

        // Act
        final String result =
            CompressionUtils.decompressString(nonCompressed);

        // Assert
        expect(result, equals(nonCompressed));
      });
    });

    group('compressMap y decompressToMap', () {
      test('debería comprimir y descomprimir un mapa correctamente', () {
        // Arrange
        final Map<String, dynamic> original = {
          'id': '123',
          'title': 'Test Title',
          'description': 'Esta es una descripción de prueba',
          'values': [1, 2, 3, 4, 5],
          'nested': {'key1': 'value1', 'key2': 'value2'}
        };

        // Act
        final String compressed = CompressionUtils.compressMap(original);
        final Map<String, dynamic>? decompressed =
            CompressionUtils.decompressToMap(compressed);

        // Assert
        expect(decompressed, isNotNull);
        expect(decompressed, equals(original));
      });
    });

    group('compressList y decompressToList', () {
      test('debería comprimir y descomprimir una lista correctamente', () {
        // Arrange
        final List<dynamic> original = [
          'item1',
          'item2',
          {'key': 'value'},
          [1, 2, 3],
          42
        ];

        // Act
        final String compressed = CompressionUtils.compressList(original);
        final List<dynamic>? decompressed =
            CompressionUtils.decompressToList(compressed);

        // Assert
        expect(decompressed, isNotNull);
        expect(decompressed, equals(original));
      });
    });

    group('measureCompressionRatio', () {
      test('debería calcular la tasa de compresión correctamente', () {
        // Arrange
        const String original = 'Este es un texto de prueba';
        const String compressed = 'TextoMásPequeño';

        // Act
        final double ratio =
            CompressionUtils.measureCompressionRatio(original, compressed);

        // Assert
        expect(ratio, equals((compressed.length / original.length) * 100));
      });

      test('debería retornar 0 para una cadena original vacía', () {
        // Arrange
        const String original = '';
        const String compressed = 'cualquier cosa';

        // Act
        final double ratio =
            CompressionUtils.measureCompressionRatio(original, compressed);

        // Assert
        expect(ratio, equals(0.0));
      });
    });
  });
}
