// lib/presentation/screens/search/search_filters_screen.dart
// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/presentation/routes/app_router.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';

import '../../bloc/search/search_filters_bloc.dart';
import '../../bloc/search/search_filters_event.dart';
import '../../bloc/search/search_filters_state.dart';

class SearchFiltersScreen extends StatelessWidget {
  static const List<String> predefinedCategories = [
    'Social',
    'Cultural',
    'Deportivo',
    'Entretenimiento',
  ];

  const SearchFiltersScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return BlocProvider(
      create: (final _) =>
          SearchFiltersBloc()..add(const SearchFiltersEvent.loadSavedFilters()),
      child: const _SearchFiltersView(),
    );
  }
}

class _SearchFiltersView extends StatelessWidget {
  const _SearchFiltersView();

  @override
  Widget build(final BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return BlocConsumer<SearchFiltersBloc, SearchFiltersState>(
      listener: (context, state) {
        // Mostrar mensaje de error si existe
        if (state.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.accentRed,
              ),
            );
          });
        }
      },
      builder: (final BuildContext context, final SearchFiltersState state) {
        // Mostrar indicador de carga si isLoading es true
        if (state.isLoading) {
          return Scaffold(
            backgroundColor: AppColors.getBackground(isDarkMode),
            appBar: AppBar(
              backgroundColor: AppColors.getBackground(isDarkMode),
              title: Text(
                'Filtros de búsqueda',
                style: AppTypography.heading5(isDarkMode),
              ),
              elevation: 0,
            ),
            body: Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.brandYellow),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.getBackground(isDarkMode),
          appBar: AppBar(
            backgroundColor: AppColors.getBackground(isDarkMode),
            title: Text(
              'Filtros de búsqueda',
              style: AppTypography.heading5(isDarkMode),
            ),
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.getTextPrimary(isDarkMode),
              ),
              onPressed: () => context.closeScreen(),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Barra de búsqueda
                  _buildSearchBar(context, isDarkMode, state),

                  const SizedBox(height: AppSpacing.l),

                  // Distancia
                  _buildDistanceSection(context, isDarkMode, state),

                  const SizedBox(height: AppSpacing.l),

                  // Categorías
                  _buildCategoriesSection(context, isDarkMode, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(
      BuildContext context, bool isDarkMode, SearchFiltersState state) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Buscar planes',
        hintStyle: AppTypography.bodyMedium(isDarkMode).copyWith(
          color: AppColors.getTextSecondary(isDarkMode),
        ),
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.getTextSecondary(isDarkMode),
        ),
        filled: true,
        fillColor: AppColors.getCardBackground(isDarkMode),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
          borderSide: BorderSide(
            color: AppColors.brandYellow,
            width: 2,
          ),
        ),
      ),
      style: AppTypography.bodyMedium(isDarkMode),
      onChanged: (value) {
        context.read<SearchFiltersBloc>().add(
              SearchFiltersEvent.updateSearchQuery(value),
            );
      },
    );
  }

  Widget _buildDistanceSection(
      BuildContext context, bool isDarkMode, SearchFiltersState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Distancia',
          style: AppTypography.heading6(isDarkMode),
        ),
        const SizedBox(height: AppSpacing.s),
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppColors.accentRed,
                  inactiveTrackColor: AppColors.getBorder(isDarkMode),
                  thumbColor: AppColors.brandYellow,
                  overlayColor: AppColors.brandYellow.withValues(alpha: 0.2),
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 10,
                  ),
                ),
                child: Slider(
                  value: state.distanceValue,
                  min: 0,
                  max: 1000,
                  onChanged: (value) {
                    context.read<SearchFiltersBloc>().add(
                          SearchFiltersEvent.distanceChanged(value),
                        );
                  },
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            Text(
              'Max: ${state.distanceValue.toInt()} KM',
              style: AppTypography.bodyMedium(isDarkMode),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoriesSection(
      BuildContext context, bool isDarkMode, SearchFiltersState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categorías',
          style: AppTypography.heading6(isDarkMode),
        ),
        const SizedBox(height: AppSpacing.m),
        Wrap(
          spacing: AppSpacing.s,
          runSpacing: AppSpacing.s,
          children: SearchFiltersScreen.predefinedCategories.map((category) {
            final bool isSelected = state.selectedCategory == category;
            return ChoiceChip(
              label: Text(
                category,
                style: AppTypography.bodyMedium(isDarkMode).copyWith(
                  color: isSelected
                      ? (isDarkMode ? Colors.black : AppColors.lightTextPrimary)
                      : AppColors.getTextPrimary(isDarkMode),
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.brandYellow,
              backgroundColor: AppColors.getCardBackground(isDarkMode),
              side: BorderSide(
                color: isSelected
                    ? AppColors.brandYellow
                    : AppColors.getBorder(isDarkMode),
              ),
              onSelected: (selected) {
                context.read<SearchFiltersBloc>().add(
                      SearchFiltersEvent.updateCategoryFilter(
                          selected ? category : ''),
                    );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
