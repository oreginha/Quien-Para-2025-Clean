import 'package:flutter_test/flutter_test.dart';
import 'package:quien_para/core/performance/performance_metrics.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PerformanceMetrics', () {
    late PerformanceMetrics metrics;

    setUp(() {
      metrics = PerformanceMetrics();
    });

    test('es un singleton', () {
      final metrics1 = PerformanceMetrics();
      final metrics2 = PerformanceMetrics();

      // Verificar que ambas referencias apuntan a la misma instancia
      expect(identical(metrics1, metrics2), isTrue);
    });

    // NOTE: No podemos probar toda la funcionalidad de PerformanceMetrics
    // en un ambiente de pruebas sin mockear correctamente el sistema de archivos.
    // En su lugar, vamos a probar un subconjunto de funcionalidades básicas
    // que no dependen de la inicialización completa.

    group('startTimer', () {
      test('no debería fallar', () {
        // Simplemente verificamos que se puede llamar sin errores
        expect(() => metrics.startTimer('test_operation'), returnsNormally);
      });
    });

    group('stopTimer', () {
      test('no debería fallar si el timer no existe', () {
        // Intentar detener un timer que no existe no debe lanzar excepcion
        expect(
            () => metrics.stopTimer('nonexistent_timer'), returnsNormally);
      });
    });

    group('measured extension', () {
      test('debería funcionar correctamente', () async {
        // Función a rastrear
        Future<int> slowFunction() async {
          await Future.delayed(const Duration(milliseconds: 50));
          return 42;
        }

        // Ejecutar con rastreo usando la extensión measured
        final result = await slowFunction().measured('slow_operation');

        // Solo verificamos que la función devuelve el resultado correcto
        expect(result, equals(42));
      });
    });
  });
}
