// test/core/di/di_module_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:quien_para/core/di/di.dart'; // Contiene initializeDependencies y initializeApp
import 'package:quien_para/domain/interfaces/image_service_interface.dart';
import 'package:quien_para/domain/usecases/plan/get_plan_by_id_usecase.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/domain/usecases/plan/get_plans_usecase.dart';

import '../../helpers/di_test_helper.dart';

void main() {
  final GetIt sl = GetIt.instance;

  setUp(() async {
    // Inicializar el sistema de DI para pruebas
    await DITestHelper.initializeDIForTesting();
  });

  tearDown(() async {
    // Limpiar el sistema de DI después de cada prueba
    await DITestHelper.resetDI();
  });

  group('Sistema de inyección de dependencias modular', () {
    test(
        'initializeDependencies registra correctamente las dependencias esenciales',
        () async {
      // Inicializar con el nuevo método consolidado
      await initializeDependencies();

      // Verificar que los servicios esenciales estén registrados
      expect(sl.isRegistered<ImageServiceInterface>(), isTrue,
          reason: 'ImageServiceInterface debería estar registrado');

      // Verificar que el ThemeProvider esté registrado
      expect(sl.isRegistered<ThemeProvider>(), isTrue,
          reason: 'ThemeProvider debería estar registrado');
    });

    test('El método global initializeApp inicializa correctamente', () async {
      // Inicializar con el método global
      await initializeApp();

      // Verificar que las dependencias estén registradas
      expect(sl.isRegistered<ImageServiceInterface>(), isTrue,
          reason:
              'ImageServiceInterface debería estar registrado después de initializeApp');
    });

    test('Los casos de uso se registran correctamente', () async {
      // Inicializar el sistema completo
      await initializeDependencies();

      // Verificar casos de uso
      expect(sl.isRegistered<GetPlansUseCase>(), isTrue,
          reason: 'GetPlansUseCase debería estar registrado');

      expect(sl.isRegistered<GetPlanByIdUseCase>(), isTrue,
          reason: 'GetPlanByIdUseCase debería estar registrado');
    });

    test('El sistema respeta la sobrescritura de dependencias para pruebas',
        () async {
      // Inicializar
      await initializeDependencies();

      // Crear un mock de ImageServiceInterface
      final mockImageService = MockImageService();

      // Registrar el mock
      DITestHelper.registerMock<ImageServiceInterface>(mockImageService);

      // Verificar que se haya sobrescrito correctamente
      final resolvedService = sl<ImageServiceInterface>();
      expect(resolvedService, same(mockImageService),
          reason:
              'El sistema debería permitir sobrescribir dependencias con mocks');
    });
  });
}

// Mock simple para pruebas
class MockImageService implements ImageServiceInterface {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
