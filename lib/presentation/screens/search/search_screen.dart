// lib/presentation/screens/Search/search_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quien_para/presentation/widgets/common/cards/plan_card_types/plan_card.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/domain/entities/plan/plan_with_creator_entity.dart';
import 'package:quien_para/presentation/routes/app_router.dart';
import 'package:quien_para/presentation/widgets/responsive/new_responsive_scaffold.dart';
import 'package:quien_para/presentation/widgets/common/loading_indicator.dart';

import '../../bloc/search/search_bloc.dart';
import '../../bloc/search/search_event.dart';
import '../../bloc/search/search_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<SearchBloc>().add(const InitializeSearch());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<SearchBloc>().add(const LoadMoreResults());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 500);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Definir el AppBar que se usará tanto en móvil como en web
    final appBar = _buildAppBar(context, isDarkMode);

    // Definir el contenido principal
    final content = Column(
      children: [
        _buildSearchBar(context, isDarkMode),
        Expanded(
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state.status == SearchStatus.initial) {
                return _buildRecentSearches(context, state, isDarkMode);
              } else if (state.status == SearchStatus.loading &&
                  state.results.isEmpty) {
                return const Center(
                  child: LoadingIndicator(color: AppColors.brandYellow),
                );
              } else if (state.status == SearchStatus.failure) {
                return _buildErrorWidget(context, state.error, isDarkMode);
              } else if (state.results.isEmpty) {
                return _buildEmptyResults(context, isDarkMode);
              } else {
                return _buildSearchResults(context, state, isDarkMode);
              }
            },
          ),
        ),
      ],
    );

    // Usar NewResponsiveScaffold para tener un diseño consistente
    return NewResponsiveScaffold(
      screenName: 'search',
      appBar: appBar,
      body: content,
      currentIndex: 1, // Búsqueda está en índice 1
      webTitle: 'Búsqueda',
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDarkMode) {
    return AppBar(
      backgroundColor: AppColors.getBackground(isDarkMode),
      elevation: 0,
      title: Text(
        'Búsqueda',
        style: AppTypography.appBarTitle(isDarkMode),
      ),
      actions: <Widget>[
        // Botón para filtros de búsqueda
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.s),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.getSecondaryBackground(isDarkMode),
                borderRadius: BorderRadius.circular(AppRadius.s),
              ),
              child: Icon(
                Icons.filter_list,
                color: AppColors.brandYellow,
                size: AppIconSize.s,
              ),
            ),
            onPressed: () {
              context.push(AppRouter.searchFilters);
            },
            tooltip: 'Filtros de búsqueda',
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      decoration: BoxDecoration(
        color: AppColors.getBackground(isDarkMode),
        boxShadow: [
          BoxShadow(
            color: AppColors.withAlpha(
                AppColors.getTextSecondary(isDarkMode), 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          context.read<SearchBloc>().add(QueryChanged(query: value));
        },
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            context.read<SearchBloc>().add(SubmitSearch(query: value));
          }
        },
        decoration: InputDecoration(
          hintText: 'Buscar planes...',
          hintStyle: AppTypography.bodyMedium(isDarkMode).copyWith(
            color: AppColors.getTextSecondary(isDarkMode),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.getTextSecondary(isDarkMode),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: AppColors.getTextSecondary(isDarkMode),
                  ),
                  onPressed: () {
                    _searchController.clear();
                    context.read<SearchBloc>().add(ClearSearch());
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.getSecondaryBackground(isDarkMode),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.s),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: AppSpacing.s,
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSearches(
      BuildContext context, SearchState state, bool isDarkMode) {
    if (state.recentSearches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64.0,
              color: AppColors.getTextSecondary(isDarkMode),
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              'Busca planes por título, descripción o categoría',
              style: AppTypography.heading5(isDarkMode),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              'Aquí se mostrarán tus búsquedas recientes',
              style: AppTypography.labelLarge(isDarkMode).copyWith(
                color: AppColors.getTextSecondary(isDarkMode),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Búsquedas recientes',
                style: AppTypography.heading5(isDarkMode),
              ),
              TextButton(
                onPressed: () {
                  context.read<SearchBloc>().add(ClearRecentSearches());
                },
                child: Text(
                  'Borrar todo',
                  style: AppTypography.labelLarge(isDarkMode).copyWith(
                    color: AppColors.brandYellow,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s),
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.xs,
            children: state.recentSearches.map((query) {
              return _buildRecentSearchChip(context, query, isDarkMode);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearchChip(
      BuildContext context, String query, bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        _searchController.text = query;
        context.read<SearchBloc>().add(SelectRecentSearch(query: query));
      },
      child: Chip(
        backgroundColor: AppColors.getSecondaryBackground(isDarkMode),
        label: Text(
          query,
          style: AppTypography.bodyMedium(isDarkMode),
        ),
        avatar: Icon(
          Icons.history,
          size: AppIconSize.xs,
          color: AppColors.getTextSecondary(isDarkMode),
        ),
        deleteIcon: Icon(
          Icons.close,
          size: AppIconSize.xs,
          color: AppColors.getTextSecondary(isDarkMode),
        ),
        onDeleted: () {
          // Aquí podrías implementar la eliminación de una búsqueda individual
          // si decides añadir esta funcionalidad en el futuro
        },
      ),
    );
  }

  Widget _buildSearchResults(
      BuildContext context, SearchState state, bool isDarkMode) {
    return RefreshIndicator(
      color: AppColors.brandYellow,
      onRefresh: () async {
        if (_searchController.text.isNotEmpty) {
          context
              .read<SearchBloc>()
              .add(SubmitSearch(query: _searchController.text));
        }
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppSpacing.m),
        itemCount: state.results.length + (state.hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          return index >= state.results.length
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.m),
                    child: LoadingIndicator(color: AppColors.brandYellow),
                  ),
                )
              : _buildPlanCard(context, state.results[index], isDarkMode);
        },
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context,
      PlanWithCreatorEntity planWithCreator, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.m),
      child: GestureDetector(
        onTap: () {
          // Navegar a la pantalla de detalle del plan
          if (kDebugMode) {
            print('Navegando al plan: ${planWithCreator.plan.id}');
          }

          // Determinar si el usuario actual es el creador del plan
          final String currentUserId =
              FirebaseAuth.instance.currentUser?.uid ?? '';
          final bool isCreator =
              planWithCreator.plan.creatorId == currentUserId;

          context.push(
            '/otherProposalDetail/${planWithCreator.plan.id}',
            extra: {
              'planData': planWithCreator.plan,
              'planId': planWithCreator.plan.id,
              'isCreator': isCreator,
              'cardType': 'search',
              'creatorData': planWithCreator.creatorData,
            },
          );
        },
        child: PlanCard(
          planData: planWithCreator.plan,
          planId: planWithCreator.plan.id,
          cardType: PlanCardType.otherUserPlan,
          creatorData: planWithCreator.creatorData,
        ),
      ),
    );
  }

  Widget _buildErrorWidget(
      BuildContext context, String? errorMessage, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.0,
            color: AppColors.accentRed,
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            'Error al realizar la búsqueda',
            style: AppTypography.heading5(isDarkMode),
            textAlign: TextAlign.center,
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: AppSpacing.s),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
              child: Text(
                errorMessage,
                style: AppTypography.bodyMedium(isDarkMode),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.m),
          ElevatedButton(
            onPressed: () {
              if (_searchController.text.isNotEmpty) {
                context
                    .read<SearchBloc>()
                    .add(SubmitSearch(query: _searchController.text));
              } else {
                context.read<SearchBloc>().add(const InitializeSearch());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandYellow,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.s),
              ),
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyResults(BuildContext context, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64.0,
            color: AppColors.getTextSecondary(isDarkMode),
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            'No se encontraron resultados',
            style: AppTypography.heading5(isDarkMode),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            'Intenta con otra búsqueda o ajusta los filtros',
            style: AppTypography.bodyMedium(isDarkMode).copyWith(
              color: AppColors.getTextSecondary(isDarkMode),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
