// lib/presentation/screens/feed_propuestas.dart
// ignore_for_file: always_specify_types, avoid_dynamic_calls, file_names

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/usecases/plan/get_plans_usecase.dart';
import 'package:quien_para/core/di/progressive_injection.dart';
import 'package:quien_para/presentation/widgets/responsive/new_responsive_scaffold.dart';
import 'package:quien_para/presentation/widgets/common/loading_indicator.dart';
import '../../bloc/auth/auth_cubit.dart';
import '../../bloc/plan/plan_bloc.dart';
import '../../bloc/plan/plan_event.dart';
import '../../routes/app_router.dart';

class FeedPropuestas extends StatefulWidget {
  const FeedPropuestas({super.key});

  @override
  State<FeedPropuestas> createState() => _FeedPropuestasState();
}

class _FeedPropuestasState extends State<FeedPropuestas> {
  late ScrollController _scrollController;
  GetPlansUseCase? _useCase;
  String? _currentUserId;
  List<PlanEntity> _plans = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Capturar el ID del usuario
    final currentUserId = context.read<AuthCubit>().state.user?['id'];
    _currentUserId = currentUserId;

    // Inicializar y cargar datos
    _initializeAndLoad();
  }

  Future<void> _initializeAndLoad() async {
    try {
      _useCase = ProgressiveInjection.sl.get<GetPlansUseCase>(
        instanceName: 'GetPlansUseCase',
      );

      if (mounted) {
        await _loadPlans();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error inicializando GetPlansUseCase: $e');
      }
      if (mounted) {
        setState(() {
          _error = 'Error de inicialización';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadPlans() async {
    if (_useCase == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await _useCase!.call(GetPlansParams());

      result.fold(
        (failure) {
          if (kDebugMode) {
            print('Error cargando planes: ${failure.message}');
          }
          setState(() {
            _error = failure.message;
            _isLoading = false;
          });
        },
        (plans) {
          setState(() {
            _plans = plans;
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error en _loadPlans: $e');
      }
      setState(() {
        _error = 'Error al cargar planes';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return NewResponsiveScaffold(
      screenName: 'FeedPropuestas',
      appBar: _buildAppBar(context, isDarkMode),
      body: _buildBody(isDarkMode),
      currentIndex: 1, // Propuestas está en índice 1
      webTitle: 'Propuestas',
    );
  }

  Widget _buildBody(bool isDarkMode) {
    if (_useCase == null) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandYellow),
        ),
      );
    }

    if (_isLoading) {
      return Center(
        child: LoadingIndicator(color: AppColors.brandYellow),
      );
    }

    if (_error != null) {
      return _buildErrorState(isDarkMode, _error!);
    }

    if (_plans.isEmpty) {
      return _buildEmptyState(isDarkMode);
    }

    return _buildPlansList(_plans, isDarkMode);
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDarkMode) {
    return AppBar(
      backgroundColor: AppColors.getBackground(isDarkMode),
      elevation: 0,
      toolbarHeight: 56,
      centerTitle: true,
      title: Text(
        "Quién Para?",
        style: AppTypography.appBarTitle(isDarkMode),
      ),
      actions: <Widget>[
        // Botón para filtros de búsqueda
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.s),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(AppSpacing.s),
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
        // Botón para ver mis planes
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.s),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(AppSpacing.s),
              decoration: BoxDecoration(
                color: AppColors.getSecondaryBackground(isDarkMode),
                borderRadius: BorderRadius.circular(AppRadius.s),
              ),
              child: Icon(
                Icons.list_alt,
                color: AppColors.brandYellow,
                size: AppIconSize.s,
              ),
            ),
            onPressed: () {
              context.push(AppRouter.mainPlan);
            },
            tooltip: 'Mis Planes',
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(bool isDarkMode, String error) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.error_outline,
            color: AppColors.accentRed,
            size: 48,
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            'Error al cargar los planes',
            style: AppTypography.heading5(isDarkMode),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            error,
            style: AppTypography.bodySmall(isDarkMode),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.l),
          ElevatedButton(
            onPressed: _loadPlans,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandYellow,
              foregroundColor:
                  isDarkMode ? Colors.black : AppColors.lightTextPrimary,
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.event_note,
            size: 64,
            color: AppColors.getTextSecondary(isDarkMode),
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            'No hay planes disponibles',
            style: AppTypography.heading5(isDarkMode),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            '¡Sé el primero en crear uno!',
            style: AppTypography.bodyMedium(isDarkMode),
          ),
          const SizedBox(height: AppSpacing.l),
          ElevatedButton.icon(
            onPressed: () {
              context.read<PlanBloc>().add(const PlanEvent.clear());
              context.push(AppRouter.createProposal);
            },
            icon: const Icon(Icons.add),
            label: const Text('Crear Plan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandYellow,
              foregroundColor:
                  isDarkMode ? Colors.black : AppColors.lightTextPrimary,
              elevation: AppElevation.s,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.l,
                vertical: AppSpacing.m,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlansList(List<PlanEntity> plans, bool isDarkMode) {
    return RefreshIndicator(
      onRefresh: _loadPlans,
      color: AppColors.brandYellow,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppSpacing.m),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return _buildPlanCard(plan, isDarkMode);
        },
      ),
    );
  }

  Widget _buildPlanCard(PlanEntity plan, bool isDarkMode) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      elevation: AppElevation.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      color: AppColors.getCardBackground(isDarkMode),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Imagen del plan
          _buildPlanImage(plan.imageUrl, isDarkMode),

          // Contenido del plan
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Título del plan
                Text(
                  plan.title.isNotEmpty ? plan.title : 'Plan sin título',
                  style: AppTypography.heading5(isDarkMode),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.s),

                // Descripción del plan
                Text(
                  plan.description.isNotEmpty
                      ? plan.description
                      : 'Sin descripción disponible',
                  style: AppTypography.bodyMedium(isDarkMode),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.m),

                // Detalles del plan
                Row(
                  children: <Widget>[
                    _buildDetailChip(
                      Icons.calendar_today,
                      plan.date != null
                          ? plan.date.toString().split(' ')[0]
                          : 'Fecha no especificada',
                      isDarkMode,
                    ),
                    const SizedBox(width: AppSpacing.s),
                    Expanded(
                      child: _buildDetailChip(
                        Icons.location_on,
                        plan.location.isNotEmpty
                            ? plan.location
                            : 'Sin ubicación',
                        isDarkMode,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.m),

                // Botón de acción
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(
                        '/otherProposalDetail/${plan.id}',
                        extra: <String, Object>{'isCreator': false},
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandYellow,
                      foregroundColor: isDarkMode
                          ? Colors.black
                          : AppColors.lightTextPrimary,
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.m),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.button),
                      ),
                      elevation: AppElevation.button,
                    ),
                    child: Text(
                      '¡Me interesa!',
                      style: AppTypography.buttonLarge(isDarkMode),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanImage(String? imageUrl, bool isDarkMode) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.card),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 200,
        child: imageUrl != null && imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  if (kDebugMode) {
                    print('Error cargando imagen del plan: $error');
                  }
                  return _buildImagePlaceholder(isDarkMode);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppColors.getSecondaryBackground(isDarkMode),
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.brandYellow),
                      ),
                    ),
                  );
                },
              )
            : _buildImagePlaceholder(isDarkMode),
      ),
    );
  }

  Widget _buildImagePlaceholder(bool isDarkMode) {
    return Container(
      color: AppColors.getSecondaryBackground(isDarkMode),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              size: 40,
              color: AppColors.getTextSecondary(isDarkMode),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Sin imagen',
              style: AppTypography.bodySmall(isDarkMode),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String text, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.getSecondaryBackground(isDarkMode).withOpacity(0.7),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.getTextPrimary(isDarkMode),
          ),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              text,
              style: AppTypography.labelSmall(isDarkMode),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
