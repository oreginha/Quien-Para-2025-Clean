// libcore/blocs/feed/feed_bloc.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/usecases/plan/create_plan_usecase.dart';
import 'package:quien_para/domain/usecases/plan/delete_plan_usecase.dart';
import 'package:quien_para/domain/usecases/plan/get_plans_usecase.dart';
import '../base_bloc.dart';
import '../../../core/logger/logger.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import '../../../domain/usecases/plan/match_plan_usecase.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends BaseBloc<FeedEvent, FeedState> {
  final GetPlansUseCase _getPlansUseCase;
  final MatchPlanUseCase _matchPlanUseCase;
  final CreatePlanUseCase _createPlanUseCase;
  final DeletePlanUseCase _deletePlanUseCase;

  // Límite de planes por página
  static const int _plansPerPage = 10;

  FeedBloc(
    this._getPlansUseCase,
    this._matchPlanUseCase,
    this._createPlanUseCase,
    this._deletePlanUseCase,
  ) : super(const FeedState.initial()) {
    on<FetchPlans>(_onFetchPlans);
    on<RefreshPlans>(_onRefreshPlans);
    on<LoadMorePlans>(_onLoadMorePlans);
    on<FilterPlansByCategory>(_onFilterPlansByCategory);
    on<ClearFilters>(_onClearFilters);
    on<LikePlan>(_onLikePlan);
    on<UnlikePlan>(_onUnlikePlan);
    on<CreatePlan>(_onCreatePlan);
    on<DeletePlan>(_onDeletePlan);
  }

  Future<void> _onFetchPlans(
      final FetchPlans event, final Emitter<FeedState> emit) async {
    emit(const FeedState.loading());
    try {
      logger.d('Fetching initial plans');
      final result =
          await _getPlansUseCase(GetPlansParams(limit: _plansPerPage));
      final Either<AppFailure, List<PlanEntity>> unwrappedResult = result;
      unwrappedResult.fold(
        (failure) => emit(FeedState.error(message: failure.toString())),
        (plans) {
          if (plans.isEmpty) {
            emit(const FeedState.empty());
          } else {
            final String? lastDocId = plans.isNotEmpty ? plans.last.id : null;
            emit(FeedState.loaded(
              plans: plans,
              hasReachedEnd: plans.length < _plansPerPage,
              lastDocumentId: lastDocId,
            ));
          }
        },
      );
    } catch (e) {
      logger.e('Error fetching plans:', error: e);
      emit(FeedState.error(message: 'Failed to fetch plans: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshPlans(
      final RefreshPlans event, final Emitter<FeedState> emit) async {
    // Conservar planes actuales mientras se refresca
    final FeedState currentState = state;
    List<PlanEntity> currentPlans = <PlanEntity>[];

    if (currentState is FeedLoaded) {
      currentPlans = currentState.plans;
      emit(FeedState.refreshing(plans: currentPlans));
    } else {
      emit(const FeedState.loading());
    }

    try {
      logger.d('Refreshing plans');
      final result =
          await _getPlansUseCase(GetPlansParams(limit: _plansPerPage));
      final Either<AppFailure, List<PlanEntity>> unwrappedResult = result;
      unwrappedResult.fold(
        (failure) => emit(FeedState.error(message: failure.toString())),
        (plans) {
          if (plans.isEmpty) {
            emit(const FeedState.empty());
          } else {
            final String? lastDocId = plans.isNotEmpty ? plans.last.id : null;
            emit(FeedState.loaded(
              plans: plans,
              hasReachedEnd: plans.length < _plansPerPage,
              lastDocumentId: lastDocId,
            ));
          }
        },
      );
    } catch (e) {
      logger.e('Error refreshing plans:', error: e);
      // Si hay error, volver al estado anterior si teníamos planes
      if (currentPlans.isNotEmpty) {
        emit(FeedState.loaded(plans: currentPlans));
      } else {
        emit(FeedState.error(
            message: 'Failed to refresh plans: ${e.toString()}'));
      }
    }
  }

  Future<void> _onLoadMorePlans(
      final LoadMorePlans event, final Emitter<FeedState> emit) async {
    final FeedState currentState = state;

    if (currentState is FeedLoaded && !currentState.hasReachedEnd) {
      emit(FeedState.paginating(
        plans: currentState.plans,
        hasReachedEnd: currentState.hasReachedEnd,
      ));

      try {
        logger.d('Loading more plans from ${currentState.lastDocumentId}');
        final result = await _getPlansUseCase(
          GetPlansParams(
            limit: _plansPerPage,
            lastDocumentId: currentState.lastDocumentId,
          ),
        );
        final Either<AppFailure, List<PlanEntity>> unwrappedResult = result;
        unwrappedResult.fold(
          (failure) => emit(FeedState.error(message: failure.toString())),
          (morePlans) {
            final List<PlanEntity> allPlans = <PlanEntity>[
              ...currentState.plans,
              ...morePlans
            ];
            final bool hasReachedEnd = morePlans.length < _plansPerPage;
            final String? lastDocId = morePlans.isNotEmpty
                ? morePlans.last.id
                : currentState.lastDocumentId;

            emit(FeedState.loaded(
              plans: allPlans,
              hasReachedEnd: hasReachedEnd,
              lastDocumentId: lastDocId,
            ));
          },
        );
      } catch (e) {
        logger.e('Error loading more plans:', error: e);
        // Volver al estado anterior sin paginación
        emit(currentState);
        // Emitir error pero mantener los planes actuales
        emit(FeedState.error(
          message: 'Failed to load more plans: ${e.toString()}',
          plans: currentState.plans,
        ));
      }
    }
  }

  Future<void> _onFilterPlansByCategory(
      final FilterPlansByCategory event, final Emitter<FeedState> emit) async {
    emit(const FeedState.loading());

    try {
      logger.d('Filtering plans by category: ${event.category}');
      final result = await _getPlansUseCase(
          GetPlansParams(category: event.category, limit: _plansPerPage));
      final Either<AppFailure, List<PlanEntity>> unwrappedResult = result;

      unwrappedResult.fold(
        (failure) => emit(FeedState.error(message: failure.toString())),
        (filteredPlans) {
          if (filteredPlans.isEmpty) {
            emit(const FeedState.empty());
          } else {
            emit(FeedState.filtered(
              plans: filteredPlans,
              filterCategory: event.category,
            ));
          }
        },
      );
    } catch (e) {
      logger.e('Error filtering plans:', error: e);
      emit(FeedState.error(message: 'Failed to filter plans: ${e.toString()}'));
    }
  }

  void _onClearFilters(
      final ClearFilters event, final Emitter<FeedState> emit) {
    logger.d('Clearing filters');
    add(const FeedEvent.fetchPlans());
  }

  Future<void> _onLikePlan(
      final LikePlan event, final Emitter<FeedState> emit) async {
    try {
      logger.d('Liking plan: ${event.planId}');
      await _matchPlanUseCase(event.planId);

      // Actualizar el estado con el like
      final FeedState currentState = state;
      if (currentState is FeedLoaded || currentState is FeedFiltered) {
        // ignore: unused_local_variable
        List<PlanEntity> currentPlans = <PlanEntity>[];

        if (currentState is FeedLoaded) {
          currentPlans = currentState.plans;
        } else if (currentState is FeedFiltered) {
          currentPlans = currentState.plans;
        }

        // Actualizar el plan con el nuevo like (esto depende de tu implementación)
        // Aquí estamos asumiendo que el backend ya actualizó el like
        // y solo necesitamos recargar los datos
        add(const FeedEvent.refreshPlans());
      }
    } catch (e) {
      logger.e('Error liking plan:', error: e);
      emit(FeedState.error(message: 'Failed to like plan: ${e.toString()}'));
    }
  }

  Future<void> _onUnlikePlan(
      final UnlikePlan event, final Emitter<FeedState> emit) async {
    try {
      logger.d('Unliking plan: ${event.planId}');
      // Implementar la lógica para unlike (necesitarás un caso de uso)
      // await _unlikePlanUseCase(event.planId);

      // Similar a like, actualizar el estado después
      // Para este ejemplo, simplemente recargamos los planes
      add(const FeedEvent.refreshPlans());
    } catch (e) {
      logger.e('Error unliking plan:', error: e);
      emit(FeedState.error(message: 'Failed to unlike plan: ${e.toString()}'));
    }
  }

  Future<void> _onCreatePlan(
      final CreatePlan event, final Emitter<FeedState> emit) async {
    try {
      logger.d('Creating new plan: ${event.title}');

      final PlanEntity newPlan = PlanEntity(
        id: '', // El id será generado por el backend
        title: event.title,
        description: event.description,
        imageUrl: event.imageUrl,
        category: event.category,
        location: event.location,
        date: event.date,
        conditions: event.conditions,
        selectedThemes: event.selectedThemes, tags: [], creatorId: '', likes: 0,
        extraConditions: '',
      );

      await _createPlanUseCase(newPlan);

      // Recargar planes después de crear uno nuevo
      add(const FeedEvent.refreshPlans());
    } catch (e) {
      logger.e('Error creating plan:', error: e);
      emit(FeedState.error(message: 'Failed to create plan: ${e.toString()}'));
    }
  }

  Future<void> _onDeletePlan(
      final DeletePlan event, final Emitter<FeedState> emit) async {
    try {
      logger.d('Deleting plan: ${event.planId}');
      await _deletePlanUseCase(event.planId);

      // Actualizar estado después de eliminar
      final FeedState currentState = state;
      if (currentState is FeedLoaded || currentState is FeedFiltered) {
        List<PlanEntity> currentPlans = <PlanEntity>[];

        if (currentState is FeedLoaded) {
          currentPlans = currentState.plans;
        } else if (currentState is FeedFiltered) {
          currentPlans = currentState.plans;
        }

        // Filtrar el plan eliminado
        final List<PlanEntity> updatedPlans = currentPlans
            .where((final PlanEntity plan) => plan.id != event.planId)
            .toList();

        if (updatedPlans.isEmpty) {
          emit(const FeedState.empty());
        } else if (currentState is FeedLoaded) {
          emit(FeedState.loaded(
            plans: updatedPlans,
            hasReachedEnd: (currentState).hasReachedEnd,
            lastDocumentId: (currentState).lastDocumentId,
          ));
        } else if (currentState is FeedFiltered) {
          emit(FeedState.filtered(
            plans: updatedPlans,
            filterCategory: (currentState).filterCategory,
          ));
        }
      }
    } catch (e) {
      logger.e('Error deleting plan:', error: e);
      emit(FeedState.error(message: 'Failed to delete plan: ${e.toString()}'));
    }
  }
}
