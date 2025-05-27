// lib/presentation/bloc/search/search_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/usecases/search/search_plans_usecase.dart';
import '../../../domain/usecases/search/filter_plans_by_location_usecase.dart';
import '../../../domain/usecases/search/filter_plans_by_date_usecase.dart';
import '../../../domain/usecases/search/filter_plans_by_category_usecase.dart';
import '../../../domain/entities/plan/plan_with_creator_entity.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchPlansUseCase _searchPlansUseCase;
  final FilterPlansByLocationUseCase _filterByLocationUseCase;
  final FilterPlansByDateUseCase _filterByDateUseCase;
  final FilterPlansByCategoryUseCase _filterByCategoryUseCase;

  StreamSubscription? _searchSubscription;
  String? _lastDocumentId;

  SearchBloc({
    required SearchPlansUseCase searchPlansUseCase,
    required FilterPlansByLocationUseCase filterByLocationUseCase,
    required FilterPlansByDateUseCase filterByDateUseCase,
    required FilterPlansByCategoryUseCase filterByCategoryUseCase,
  })  : _searchPlansUseCase = searchPlansUseCase,
        _filterByLocationUseCase = filterByLocationUseCase,
        _filterByDateUseCase = filterByDateUseCase,
        _filterByCategoryUseCase = filterByCategoryUseCase,
        super(const SearchState()) {
    on<InitializeSearch>(_onInitializeSearch);
    on<QueryChanged>(
      _onQueryChanged,
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 300))
          .switchMap(mapper),
    );
    on<SubmitSearch>(_onSubmitSearch);
    on<LoadMoreResults>(_onLoadMoreResults);
    on<ClearSearch>(_onClearSearch);
    on<ClearRecentSearches>(_onClearRecentSearches);
    on<SelectRecentSearch>(_onSelectRecentSearch);
    on<ApplyLocationFilter>(_onApplyLocationFilter);
    on<ApplyDateFilter>(_onApplyDateFilter);
    on<ApplyCategoryFilter>(_onApplyCategoryFilter);
    on<ClearFilters>(_onClearFilters);
  }

  Future<void> _onInitializeSearch(
    InitializeSearch event,
    Emitter<SearchState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SearchStatus.loading));

      // Cargar búsquedas recientes del storage local
      final recentSearches = await _loadRecentSearches();

      emit(
        state.copyWith(
          status: SearchStatus.initial,
          recentSearches: recentSearches,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchStatus.failure,
          error: 'Error al inicializar búsqueda: $e',
        ),
      );
    }
  }

  Future<void> _onQueryChanged(
    QueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();

    // Actualizar query en el estado
    emit(state.copyWith(query: query));

    // Si la query está vacía, solo mostrar búsquedas recientes
    if (query.isEmpty) {
      await _searchSubscription?.cancel();
      emit(state.copyWith(status: SearchStatus.initial, results: []));
      return;
    }

    // No realizar búsqueda automática en onChange (solo en submit)
    // Esto evita demasiadas consultas mientras el usuario escribe
  }

  Future<void> _onSubmitSearch(
    SubmitSearch event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) return;

    try {
      emit(state.copyWith(status: SearchStatus.loading));

      // Cancelar búsquedas anteriores
      await _searchSubscription?.cancel();
      _lastDocumentId = null;

      // Ejecutar búsqueda
      final result = await _searchPlansUseCase.execute(query: query, limit: 20);

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: SearchStatus.failure,
              error: failure.message,
            ),
          );
        },
        (results) async {
          // Guardar query en búsquedas recientes
          await _saveSearchQuery(query);

          // Actualizar estado
          emit(
            state.copyWith(
              status: SearchStatus.success,
              query: query,
              results: results,
              recentSearches: await _loadRecentSearches(),
              hasReachedMax: results.length < 20,
            ),
          );

          // Guardar último documento para paginación
          if (results.isNotEmpty) {
            _lastDocumentId = results.last.plan.id;
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchStatus.failure,
          error: 'Error en la búsqueda: $e',
        ),
      );
    }
  }

  Future<void> _onLoadMoreResults(
    LoadMoreResults event,
    Emitter<SearchState> emit,
  ) async {
    if (state.hasReachedMax || state.query.isEmpty) return;

    try {
      final result = await _searchPlansUseCase.execute(
        query: state.query,
        limit: 20,
        lastDocumentId: _lastDocumentId,
      );

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              error: 'Error al cargar más resultados: ${failure.message}',
            ),
          );
        },
        (moreResults) {
          final updatedResults = List<PlanWithCreatorEntity>.from(state.results)
            ..addAll(moreResults);

          emit(
            state.copyWith(
              status: SearchStatus.success,
              results: updatedResults,
              hasReachedMax: moreResults.length < 20,
            ),
          );

          // Actualizar último documento
          if (moreResults.isNotEmpty) {
            _lastDocumentId = moreResults.last.plan.id;
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(error: 'Error al cargar más resultados: $e'));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    _searchSubscription?.cancel();
    _lastDocumentId = null;
    emit(state.copyWith(status: SearchStatus.initial, query: '', results: []));
  }

  Future<void> _onClearRecentSearches(
    ClearRecentSearches event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('recent_searches');

      emit(state.copyWith(recentSearches: []));
    } catch (e) {
      emit(state.copyWith(error: 'Error al borrar búsquedas recientes: $e'));
    }
  }

  Future<void> _onSelectRecentSearch(
    SelectRecentSearch event,
    Emitter<SearchState> emit,
  ) async {
    // Actualizar query primero
    emit(state.copyWith(query: event.query));

    // Luego activar la búsqueda
    add(SubmitSearch(query: event.query));
  }

  Future<void> _onApplyLocationFilter(
    ApplyLocationFilter event,
    Emitter<SearchState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SearchStatus.loading));

      final result = await _filterByLocationUseCase.execute(
        latitude: event.latitude,
        longitude: event.longitude,
        radiusKm: event.radiusKm,
        limit: 20,
      );

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: SearchStatus.failure,
              error: failure.message,
            ),
          );
        },
        (results) {
          emit(
            state.copyWith(
              status: SearchStatus.success,
              results: results,
              hasReachedMax: results.length < 20,
              activeFilters: state.activeFilters.copyWith(
                hasLocationFilter: true,
                latitude: event.latitude,
                longitude: event.longitude,
                radiusKm: event.radiusKm,
              ),
            ),
          );

          if (results.isNotEmpty) {
            _lastDocumentId = results.last.plan.id;
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchStatus.failure,
          error: 'Error al aplicar filtro de ubicación: $e',
        ),
      );
    }
  }

  Future<void> _onApplyDateFilter(
    ApplyDateFilter event,
    Emitter<SearchState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SearchStatus.loading));

      final result = await _filterByDateUseCase.execute(
        startDate: event.startDate,
        endDate: event.endDate,
        limit: 20,
      );

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: SearchStatus.failure,
              error: failure.message,
            ),
          );
        },
        (results) {
          emit(
            state.copyWith(
              status: SearchStatus.success,
              results: results,
              hasReachedMax: results.length < 20,
              activeFilters: state.activeFilters.copyWith(
                hasDateFilter: true,
                startDate: event.startDate,
                endDate: event.endDate,
              ),
            ),
          );

          if (results.isNotEmpty) {
            _lastDocumentId = results.last.plan.id;
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchStatus.failure,
          error: 'Error al aplicar filtro de fecha: $e',
        ),
      );
    }
  }

  Future<void> _onApplyCategoryFilter(
    ApplyCategoryFilter event,
    Emitter<SearchState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SearchStatus.loading));

      final result = await _filterByCategoryUseCase.execute(
        category: event.category,
        limit: 20,
      );

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: SearchStatus.failure,
              error: failure.message,
            ),
          );
        },
        (results) {
          emit(
            state.copyWith(
              status: SearchStatus.success,
              results: results,
              hasReachedMax: results.length < 20,
              activeFilters: state.activeFilters.copyWith(
                hasCategoryFilter: true,
                category: event.category,
              ),
            ),
          );

          if (results.isNotEmpty) {
            _lastDocumentId = results.last.plan.id;
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SearchStatus.failure,
          error: 'Error al aplicar filtro de categoría: $e',
        ),
      );
    }
  }

  void _onClearFilters(ClearFilters event, Emitter<SearchState> emit) {
    _lastDocumentId = null;
    emit(
      state.copyWith(
        activeFilters: const SearchFilters(),
        results: [],
        status: SearchStatus.initial,
      ),
    );
  }

  // ---- MÉTODOS AUXILIARES ----

  Future<List<String>> _loadRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final searches = prefs.getStringList('recent_searches') ?? [];
      return searches.take(10).toList(); // Máximo 10 búsquedas recientes
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveSearchQuery(String query) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final searches = prefs.getStringList('recent_searches') ?? [];

      // Remover query si ya existe
      searches.remove(query);

      // Agregar al inicio
      searches.insert(0, query);

      // Mantener máximo 10 búsquedas
      if (searches.length > 10) {
        searches.removeRange(10, searches.length);
      }

      await prefs.setStringList('recent_searches', searches);
    } catch (e) {
      // Ignorar errores de guardado
    }
  }

  @override
  Future<void> close() {
    _searchSubscription?.cancel();
    return super.close();
  }
}
