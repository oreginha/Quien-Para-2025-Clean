// lib/core/di/modules/maps_module.dart

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:quien_para/core/di/modules/di_module.dart';

import 'package:quien_para/data/repositories/maps/maps_repository_impl.dart';
import 'package:quien_para/domain/repositories/maps/maps_repository.dart';
import 'package:quien_para/domain/usecases/maps/geocode_address_usecase.dart';
import 'package:quien_para/domain/usecases/maps/get_current_location_usecase.dart';
import 'package:quien_para/domain/usecases/maps/get_directions_usecase.dart';
import 'package:quien_para/domain/usecases/maps/reverse_geocode_usecase.dart';

/// Módulo de inyección de dependencias para servicios de mapas
class MapsModule implements DIModule {
  /// Registra todas las dependencias relacionadas con mapas
  @override
  Future<void> register(GetIt sl) async {
    if (kDebugMode) {
      print(
          '🗺️ Registrando módulo de mapas con implementación Clean Architecture');
    }

    // Repositorio
    _registerMapsRepository(sl);

    // Casos de uso
    _registerUseCases(sl);
  }

  /// Registra el repositorio de mapas
  void _registerMapsRepository(GetIt sl) {
    if (!sl.isRegistered<MapsRepository>()) {
      // NOTA: En una implementación real, obtendríamos la API Key desde
      // un archivo de configuración seguro o variables de entorno
      sl.registerLazySingleton<MapsRepository>(
        () => MapsRepositoryImpl(apiKey: 'YOUR_API_KEY'),
      );
    }
  }

  /// Registra los casos de uso relacionados con mapas
  void _registerUseCases(GetIt sl) {
    // Caso de uso para obtener la ubicación actual
    if (!sl.isRegistered<GetCurrentLocationUseCase>()) {
      sl.registerLazySingleton<GetCurrentLocationUseCase>(
        () => GetCurrentLocationUseCase(sl<MapsRepository>()),
      );
    }

    // Caso de uso para geocoding
    if (!sl.isRegistered<GeocodeAddressUseCase>()) {
      sl.registerLazySingleton<GeocodeAddressUseCase>(
        () => GeocodeAddressUseCase(sl<MapsRepository>()),
      );
    }

    // Caso de uso para reverse geocoding
    if (!sl.isRegistered<ReverseGeocodeUseCase>()) {
      sl.registerLazySingleton<ReverseGeocodeUseCase>(
        () => ReverseGeocodeUseCase(sl<MapsRepository>()),
      );
    }

    // Caso de uso para obtener direcciones
    if (!sl.isRegistered<GetDirectionsUseCase>()) {
      sl.registerLazySingleton<GetDirectionsUseCase>(
        () => GetDirectionsUseCase(sl<MapsRepository>()),
      );
    }
  }

  @override
  Future<void> dispose(GetIt container) async {
    if (kDebugMode) {
      print('📬 Liberando recursos del módulo de mapas');
    }

    // Desregistrar casos de uso si es necesario
    if (container.isRegistered<GetCurrentLocationUseCase>()) {
      await container.unregister<GetCurrentLocationUseCase>();
    }

    if (container.isRegistered<GeocodeAddressUseCase>()) {
      await container.unregister<GeocodeAddressUseCase>();
    }

    if (container.isRegistered<ReverseGeocodeUseCase>()) {
      await container.unregister<ReverseGeocodeUseCase>();
    }

    if (container.isRegistered<GetDirectionsUseCase>()) {
      await container.unregister<GetDirectionsUseCase>();
    }

    // Desregistrar el repositorio al final
    if (container.isRegistered<MapsRepository>()) {
      await container.unregister<MapsRepository>();
    }
  }

  @override
  Future<void> registerTestDependencies(GetIt container) async {
    if (kDebugMode) {
      print('🚨 Registrando dependencias de prueba para el módulo de mapas');
    }

    // Registrar mocks para pruebas
    // Ejemplo: si tuvieras un mock del repositorio de mapas:
    // Si ya hay una implementación registrada, la reemplazamos
    if (container.isRegistered<MapsRepository>()) {
      await container.unregister<MapsRepository>();
    }

    // Registrar la implementación mock
    // container.registerLazySingleton<MapsRepository>(
    //   () => MockMapsRepository(),
    // );

    // Para la implementación real del proyecto, puedes usar una implementación
    // que devuelva datos ficticios para pruebas
    container.registerLazySingleton<MapsRepository>(
      () => MapsRepositoryImpl(apiKey: 'TEST_API_KEY'),
    );

    // Re-registrar los casos de uso con la implementación mock
    _registerUseCases(container);
  }
}
