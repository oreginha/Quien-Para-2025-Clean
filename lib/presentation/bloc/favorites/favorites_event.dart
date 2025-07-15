import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {
  final String userId;
  final bool refresh;

  const LoadFavorites({
    required this.userId,
    this.refresh = false,
  });

  @override
  List<Object> get props => [userId, refresh];
}

class LoadMoreFavorites extends FavoritesEvent {
  final String userId;

  const LoadMoreFavorites({required this.userId});

  @override
  List<Object> get props => [userId];
}

class ToggleFavorite extends FavoritesEvent {
  final String userId;
  final String planId;

  const ToggleFavorite({
    required this.userId,
    required this.planId,
  });

  @override
  List<Object> get props => [userId, planId];
}

class CheckFavoriteStatus extends FavoritesEvent {
  final String userId;
  final List<String> planIds;

  const CheckFavoriteStatus({
    required this.userId,
    required this.planIds,
  });

  @override
  List<Object> get props => [userId, planIds];
}

class CheckSingleFavoriteStatus extends FavoritesEvent {
  final String userId;
  final String planId;

  const CheckSingleFavoriteStatus({
    required this.userId,
    required this.planId,
  });

  @override
  List<Object> get props => [userId, planId];
}

class ClearFavorites extends FavoritesEvent {}

class RefreshFavorites extends FavoritesEvent {
  final String userId;

  const RefreshFavorites({required this.userId});

  @override
  List<Object> get props => [userId];
}
