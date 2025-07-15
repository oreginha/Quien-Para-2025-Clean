import 'package:equatable/equatable.dart';
import '../../../domain/entities/plan/plan_with_creator_entity.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<PlanWithCreatorEntity> favorites;
  final bool hasReachedMax;
  final String? lastDocumentId;

  const FavoritesLoaded({
    required this.favorites,
    this.hasReachedMax = false,
    this.lastDocumentId,
  });

  @override
  List<Object?> get props => [favorites, hasReachedMax, lastDocumentId];

  FavoritesLoaded copyWith({
    List<PlanWithCreatorEntity>? favorites,
    bool? hasReachedMax,
    String? lastDocumentId,
  }) {
    return FavoritesLoaded(
      favorites: favorites ?? this.favorites,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      lastDocumentId: lastDocumentId ?? this.lastDocumentId,
    );
  }
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError({required this.message});

  @override
  List<Object> get props => [message];
}

class FavoriteToggleLoading extends FavoritesState {
  final String planId;

  const FavoriteToggleLoading({required this.planId});

  @override
  List<Object> get props => [planId];
}

class FavoriteToggleSuccess extends FavoritesState {
  final String planId;
  final bool isFavorite;

  const FavoriteToggleSuccess({
    required this.planId,
    required this.isFavorite,
  });

  @override
  List<Object> get props => [planId, isFavorite];
}

class FavoriteToggleError extends FavoritesState {
  final String planId;
  final String message;

  const FavoriteToggleError({
    required this.planId,
    required this.message,
  });

  @override
  List<Object> get props => [planId, message];
}

class FavoriteCheckLoaded extends FavoritesState {
  final Map<String, bool> favoriteStatus;

  const FavoriteCheckLoaded({required this.favoriteStatus});

  @override
  List<Object> get props => [favoriteStatus];
}
