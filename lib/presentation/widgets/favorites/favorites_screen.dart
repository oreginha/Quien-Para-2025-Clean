import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/plan/plan_with_creator_entity.dart';
import '../../bloc/favorites/favorites_bloc.dart';
import '../../bloc/favorites/favorites_event.dart';
import '../../bloc/favorites/favorites_state.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../common/plan_card.dart';
import '../common/loading_indicator.dart';
import '../common/error_widget.dart';
import '../common/empty_state_widget.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ScrollController _scrollController = ScrollController();
  late String _userId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Obtener userId del estado de autenticación
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthenticatedState) {
      _userId = authState.user.id;
      // Cargar favoritos al iniciar
      context.read<FavoritesBloc>().add(LoadFavorites(userId: _userId));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<FavoritesBloc>().add(LoadMoreFavorites(userId: _userId));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onRefresh() {
    context.read<FavoritesBloc>().add(RefreshFavorites(userId: _userId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Favoritos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _onRefresh,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _onRefresh();
          // Esperar un poco para la animación
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            if (state is FavoritesLoading) {
              return const Center(child: LoadingIndicator());
            }
            
            if (state is FavoritesError) {
              return Center(
                child: ErrorStateWidget(
                  message: state.message,
                  onRetry: _onRefresh,
                ),
              );
            }
            
            if (state is FavoritesLoaded) {
              if (state.favorites.isEmpty) {
                return const Center(
                  child: EmptyStateWidget(
                    icon: Icons.favorite_border,
                    title: 'Sin favoritos',
                    message: 'Aún no has marcado ningún plan como favorito.\nExplora planes y marca los que más te gusten.',
                  ),
                );
              }

              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= state.favorites.length) {
                            return state.hasReachedMax
                                ? const SizedBox.shrink()
                                : const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(child: LoadingIndicator()),
                                  );
                          }

                          final planWithCreator = state.favorites[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: PlanCard(
                              plan: planWithCreator.plan,
                              creator: planWithCreator.creator,
                              showFavoriteButton: true,
                              onTap: () {
                                // TODO: Navegar a detalles del plan
                              },
                            ),
                          );
                        },
                        childCount: state.hasReachedMax
                            ? state.favorites.length
                            : state.favorites.length + 1,
                      ),
                    ),
                  ),
                ],
              );
            }

            // Estado inicial
            return const Center(
              child: EmptyStateWidget(
                icon: Icons.favorite_border,
                title: 'Mis Favoritos',
                message: 'Cargando tus planes favoritos...',
              ),
            );
          },
        ),
      ),
    );
  }
}
