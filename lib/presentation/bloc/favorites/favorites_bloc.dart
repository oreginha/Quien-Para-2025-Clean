import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/favorites/check_if_favorite_usecase.dart';
import '../../../domain/usecases/favorites/get_user_favorites_usecase.dart';
import '../../../domain/usecases/favorites/toggle_favorite_usecase.dart';
import '../../../domain/entities/plan/plan_with_creator_entity.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetUserFavoritesUseCase _getUserFavoritesUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;
  final CheckIfFavoriteUseCase _checkIfFavoriteUseCase;

  // Cache para el estado de favoritos de planes individuales
  final Map<String, bool> _favoriteStatusCache = {};

  FavoritesBloc({
    required GetUserFavoritesUseCase getUserFavoritesUseCase,
    required ToggleFavoriteUseCase toggleFavoriteUseCase,
    required CheckIfFavoriteUseCase checkIfFavoriteUseCase,
  })  : _getUserFavoritesUseCase = getUserFavoritesUseCase,
        _toggleFavoriteUseCase = toggleFavoriteUseCase,
        _checkIfFavoriteUseCase = checkIfFavoriteUseCase,
        super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<LoadMoreFavorites>(_onLoadMoreFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
    on<CheckFavoriteStatus>(_onCheckFavoriteStatus);
    on<CheckSingleFavoriteStatus>(_onCheckSingleFavoriteStatus);
    on<ClearFavorites>(_onClearFavorites);
    on<RefreshFavorites>(_onRefreshFavorites);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    if (event.refresh || state is! FavoritesLoaded) {
      emit(FavoritesLoading());
    }

    final result = await _getUserFavoritesUseCase.execute(
      userId: event.userId,
      limit: 20,
    );

    result.fold(
      (failure) => emit(FavoritesError(message: failure.message)),
      (favorites) {
        // Actualizar cache
        for (final plan in favorites) {
          _favoriteStatusCache[plan.plan.id] = true;
        }

        emit(FavoritesLoaded(
          favorites: favorites,
          hasReachedMax: favorites.length < 20,
        ));
      },
    );
  }

  Future<void> _onLoadMoreFavorites(
    LoadMoreFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FavoritesLoaded || currentState.hasReachedMax) {
      return;
    }

    final result = await _getUserFavoritesUseCase.execute(
      userId: event.userId,
      limit: 20,
      lastDocumentId: currentState.lastDocumentId,
    );

    result.fold(
      (failure) => emit(FavoritesError(message: failure.message)),
      (newFavorites) {
        // Actualizar cache
        for (final plan in newFavorites) {
          _favoriteStatusCache[plan.plan.id] = true;
        }

        final updatedFavorites = [...currentState.favorites, ...newFavorites];
        emit(currentState.copyWith(
          favorites: updatedFavorites,
          hasReachedMax: newFavorites.length < 20,
          lastDocumentId: newFavorites.isNotEmpty
              ? newFavorites.last.plan.id
              : currentState.lastDocumentId,
        ));
      },
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoriteToggleLoading(planId: event.planId));

    final result = await _toggleFavoriteUseCase.execute(
      userId: event.userId,
      planId: event.planId,
    );

    result.fold(
      (failure) {
        emit(FavoriteToggleError(
          planId: event.planId,
          message: failure.message,
        ));
      },
      (isFavorite) {
        // Actualizar cache
        _favoriteStatusCache[event.planId] = isFavorite;

        emit(FavoriteToggleSuccess(
          planId: event.planId,
          isFavorite: isFavorite,
        ));

        // Si estamos en la lista de favoritos y se removió el favorito,
        // actualizar la lista
        final currentState = state;
        if (currentState is FavoritesLoaded && !isFavorite) {
          final updatedFavorites = currentState.favorites
              .where((plan) => plan.plan.id != event.planId)
              .toList();
          
          emit(currentState.copyWith(favorites: updatedFavorites));
        }
      },
    );
  }

  Future<void> _onCheckFavoriteStatus(
    CheckFavoriteStatus event,
    Emitter<FavoritesState> emit,
  ) async {
    final Map<String, bool> statusMap = {};

    for (final planId in event.planIds) {
      // Verificar cache primero
      if (_favoriteStatusCache.containsKey(planId)) {
        statusMap[planId] = _favoriteStatusCache[planId]!;
        continue;
      }

      // Si no está en cache, consultar
      final result = await _checkIfFavoriteUseCase.execute(
        userId: event.userId,
        planId: planId,
      );

      result.fold(
        (failure) => statusMap[planId] = false, // Default a false en caso de error
        (isFavorite) {
          statusMap[planId] = isFavorite;
          _favoriteStatusCache[planId] = isFavorite;
        },
      );
    }

    emit(FavoriteCheckLoaded(favoriteStatus: statusMap));
  }

  Future<void> _onCheckSingleFavoriteStatus(
    CheckSingleFavoriteStatus event,
    Emitter<FavoritesState> emit,
  ) async {
    // Verificar cache primero
    if (_favoriteStatusCache.containsKey(event.planId)) {
      emit(FavoriteCheckLoaded(
        favoriteStatus: {event.planId: _favoriteStatusCache[event.planId]!},
      ));
      return;
    }

    final result = await _checkIfFavoriteUseCase.execute(
      userId: event.userId,
      planId: event.planId,
    );

    result.fold(
      (failure) => emit(FavoriteCheckLoaded(
        favoriteStatus: {event.planId: false},
      )),
      (isFavorite) {
        _favoriteStatusCache[event.planId] = isFavorite;
        emit(FavoriteCheckLoaded(
          favoriteStatus: {event.planId: isFavorite},
        ));
      },
    );
  }

  void _onClearFavorites(
    ClearFavorites event,
    Emitter<FavoritesState> emit,
  ) {
    _favoriteStatusCache.clear();
    emit(FavoritesInitial());
  }

  Future<void> _onRefreshFavorites(
    RefreshFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    _favoriteStatusCache.clear();
    add(LoadFavorites(userId: event.userId, refresh: true));
  }

  /// Método público para obtener el estado de favorito desde cache
  bool? getCachedFavoriteStatus(String planId) {
    return _favoriteStatusCache[planId];
  }

  /// Método público para limpiar el cache de un plan específico
  void clearCacheForPlan(String planId) {
    _favoriteStatusCache.remove(planId);
  }

  @override
  Future<void> close() {
    _favoriteStatusCache.clear();
    return super.close();
  }
}
