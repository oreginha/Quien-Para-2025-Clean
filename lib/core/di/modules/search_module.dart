// lib/core/di/modules/search_module.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:quien_para/presentation/bloc/search/search_bloc.dart';
import 'package:quien_para/core/di/modules/di_module.dart';
import 'package:quien_para/data/repositories/search/search_repository_impl.dart';
import 'package:quien_para/domain/interfaces/search_repository_interface.dart';
import 'package:quien_para/domain/usecases/search/recent_searches_usecase.dart';
import 'package:quien_para/domain/usecases/search/search_plans_usecase.dart';
import 'package:quien_para/domain/usecases/search/filter_plans_by_location_usecase.dart';
import 'package:quien_para/domain/usecases/search/filter_plans_by_date_usecase.dart';
import 'package:quien_para/domain/usecases/search/filter_plans_by_category_usecase.dart';

import '../../../domain/repositories/plan/plan_repository.dart';

/// Módulo para registro de componentes relacionados con la búsqueda
class SearchModule implements DIModule {
  @override
  Future<void> register(GetIt container) async {
    // Registra el repositorio
    container.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(container<FirebaseFirestore>()),
    );

    // Registra los casos de uso
    container.registerLazySingleton(
      () => SearchPlansUseCase(container<PlanRepository>()),
    );

    container.registerLazySingleton(
      () => GetRecentSearchesUseCase(container<SearchRepository>()),
    );

    container.registerLazySingleton(
      () => SaveSearchQueryUseCase(container<SearchRepository>()),
    );

    // Registra los casos de uso de filtros
    container.registerLazySingleton(
      () => FilterPlansByLocationUseCase(container<PlanRepository>()),
    );
    container.registerLazySingleton(
      () => FilterPlansByDateUseCase(container<PlanRepository>()),
    );
    container.registerLazySingleton(
      () => FilterPlansByCategoryUseCase(container<PlanRepository>()),
    );

    container.registerFactory(
      () => SearchBloc(
        searchPlansUseCase: container<SearchPlansUseCase>(),
        filterByLocationUseCase: container<FilterPlansByLocationUseCase>(),
        filterByDateUseCase: container<FilterPlansByDateUseCase>(),
        filterByCategoryUseCase: container<FilterPlansByCategoryUseCase>(),
      ),
    );

    @override
    Future<void> registerTestDependencies(GetIt container) async {
      // Por defecto usa la implementación base de DIModule
    }

    @override
    Future<void> dispose(GetIt container) async {
      // Desregistrar los casos de uso
      if (container.isRegistered<SearchPlansUseCase>()) {
        await container.unregister<SearchPlansUseCase>();
      }

      if (container.isRegistered<GetRecentSearchesUseCase>()) {
        await container.unregister<GetRecentSearchesUseCase>();
      }

      if (container.isRegistered<SaveSearchQueryUseCase>()) {
        await container.unregister<SaveSearchQueryUseCase>();
      }

      if (container.isRegistered<ClearRecentSearchesUseCase>()) {
        await container.unregister<ClearRecentSearchesUseCase>();
      }

      // Desregistrar el repositorio
      if (container.isRegistered<SearchRepository>()) {
        await container.unregister<SearchRepository>();
      }

      // No desregistramos el SearchBloc porque es una factoría,
      // se gestionará automáticamente por Flutter
    }
  }

  @override
  Future<void> dispose(GetIt container) {
    // TODO: implement dispose
    throw UnimplementedError();
  }

  @override
  Future<void> registerTestDependencies(GetIt container) {
    // TODO: implement registerTestDependencies
    throw UnimplementedError();
  }
}
