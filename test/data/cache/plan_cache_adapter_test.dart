// test/data/cache/plan_cache_adapter_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quien_para/data/datasources/local/cache/plan_cache_adapter.dart';
import 'package:quien_para/data/datasources/local/cache/generic_compressed_cache.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';

// Mock del GenericCompressedCache
class MockGenericCompressedCache extends Mock
    implements GenericCompressedCache<PlanEntity> {}

void main() {
  late PlanCacheAdapter planCacheAdapter;
  late MockGenericCompressedCache mockCache;

  setUp(() {
    mockCache = MockGenericCompressedCache();
    // No podemos inyectar directamente el mock debido a cómo está estructurado el adaptador,
    // pero podemos probar los métodos públicos
    planCacheAdapter = PlanCacheAdapter();
  });

  group('PlanCacheAdapter', () {
    test('isAvailable should delegate to the underlying cache', () {
      // Esta prueba es limitada porque no podemos inyectar el mock
      // Solo verificamos que el método exista y no falle
      expect(planCacheAdapter.isAvailable,
          isFalse); // Porque el caché no se inicializó
    });

    test('hitRate should return a value between 0 and 1', () {
      // Esta prueba es limitada por la misma razón
      final hitRate = planCacheAdapter.hitRate;
      expect(hitRate, greaterThanOrEqualTo(0.0));
      expect(hitRate, lessThanOrEqualTo(1.0));
    });

    // El resto de métodos requieren una inicialización real de Hive,
    // lo cual es complicado en un entorno de prueba. Para pruebas más completas,
    // se requeriría una configuración más elaborada con mocks de Hive.
  });
}
