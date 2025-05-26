// lib/presentation/screens/proposal_detail_screen.dart

import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/presentation/widgets/navigation_aware_scaffold.dart';
import 'package:quien_para/presentation/widgets/modals/success_plan_modal.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import '../../bloc/plan/plan_bloc.dart';
import '../../bloc/plan/plan_event.dart';
import '../../bloc/plan/plan_state.dart';
import '../../routes/app_router.dart';

class ProposalDetailScreen extends StatefulWidget {
  final Map<String, String>? initialConditions;

  const ProposalDetailScreen({this.initialConditions, super.key});

  @override
  State<ProposalDetailScreen> createState() => _ProposalDetailScreenState();
}

class _ProposalDetailScreenState extends State<ProposalDetailScreen> {
  bool _isLoading = true;
  bool _isSavingInProgress = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPlanData();

      if (widget.initialConditions != null &&
          widget.initialConditions!.isNotEmpty) {
        final PlanBloc bloc = BlocProvider.of<PlanBloc>(context);
        final PlanState state = bloc.state;

        if (state is PlanLoaded) {
          if (state.plan.conditions.isEmpty) {
            BlocProvider.of<PlanBloc>(
              context,
            ).add(PlanEvent.updateSelectedOptions(widget.initialConditions!));
          }
        }
      }
    });
  }

  Future<void> _loadPlanData() async {
    if (!mounted) return;

    final PlanBloc planBloc = BlocProvider.of<PlanBloc>(context);
    final PlanState state = planBloc.state;

    if (state is PlanLoaded && state.plan.location.isNotEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      String? planId;
      if (state is PlanLoaded) {
        planId = state.plan.id;
      }

      if (planId != null && planId.isNotEmpty) {
        final PlanRepository repository = Provider.of<PlanRepository>(
          context,
          listen: false,
        );
        final Either<AppFailure, PlanEntity?> planEntity = await repository
            .getById(planId);

        planBloc.add(PlanEvent.updateField(field: 'plan', value: planEntity));

        setState(() {
          _isLoading = false;
        });
        return;
      }

      planBloc.add(const PlanEvent.create());
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error cargando datos del plan';
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return BlocConsumer<PlanBloc, PlanState>(
      listener: (context, state) {
        state.maybeWhen(
          saving: (_) {
            // Ya se está mostrando el indicador de progreso
          },
          saved: (plan) {
            setState(() {
              _isSavingInProgress = false;
            });
            _showSuccessModal(plan.title);
          },
          error: (message, _) {
            setState(() {
              _isSavingInProgress = false;
            });
            _showErrorSnackbar(message);
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        if (_isLoading) {
          return _buildLoadingScreen(isDarkMode);
        }

        final PlanEntity? plan = _getPlanFromState(state);

        if (plan == null || plan.conditions.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((final _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Error: Plan incompleto, vuelve a completar las condiciones',
                ),
                backgroundColor: AppColors.accentRed,
              ),
            );
            Navigator.pop(context);
          });

          return Scaffold(
            backgroundColor: AppColors.getBackground(isDarkMode),
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.brandYellow,
                ),
              ),
            ),
          );
        }

        return NavigationAwareScaffold(
          screenName: AppRouter.proposalDetail,
          appBar: AppBar(
            backgroundColor: AppColors.getBackground(isDarkMode),
            elevation: 0,
            title: Text(
              'Vista previa del plan',
              style: AppTypography.appBarTitle(isDarkMode),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.getTextPrimary(isDarkMode),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: <Widget>[
              if (_errorMessage != null)
                IconButton(
                  icon: Icon(Icons.refresh, color: AppColors.brandYellow),
                  tooltip: 'Reintentar',
                  onPressed: () {
                    setState(() {
                      _errorMessage = null;
                      _isLoading = true;
                    });
                    _loadPlanData();
                  },
                ),
            ],
          ),
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (_errorMessage != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.s),
                        color: AppColors.accentRed.withAlpha(
                          179,
                        ), // Actualizado desde withOpacity(0.7)
                        child: Text(
                          'Error: $_errorMessage',
                          style: AppTypography.bodyMedium(
                            isDarkMode,
                          ).copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    _buildHeaderImage(plan, isDarkMode),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.m),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Título y descripción principal
                          Text(
                            plan.title.isEmpty ? 'Sin título' : plan.title,
                            style: AppTypography.heading3(isDarkMode),
                          ),
                          const SizedBox(height: AppSpacing.s),
                          Text(
                            plan.description.isEmpty
                                ? 'Sin descripción'
                                : plan.description,
                            style: AppTypography.bodyLarge(isDarkMode).copyWith(
                              color: AppColors.getTextSecondary(isDarkMode),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.l),

                          // Detalles del evento
                          _buildSection(
                            'Detalles del Evento',
                            isDarkMode,
                            children: <Widget>[
                              _buildDetailRow(
                                Icons.category,
                                'Categoría',
                                plan.category.isEmpty
                                    ? 'No especificada'
                                    : plan.category,
                                isDarkMode,
                              ),
                              _buildDetailRow(
                                Icons.calendar_today,
                                'Fecha',
                                plan.date != null
                                    ? DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(plan.date!)
                                    : 'No especificada',
                                isDarkMode,
                              ),
                              _buildDetailRow(
                                Icons.location_on,
                                'Ubicación',
                                plan.location.isEmpty
                                    ? 'No especificada'
                                    : plan.location,
                                isDarkMode,
                              ),
                            ],
                          ),

                          // Condiciones del plan
                          if (_getMainConditions(plan.conditions).isNotEmpty)
                            _buildSection(
                              'Condiciones',
                              isDarkMode,
                              children: <Widget>[
                                ..._getMainConditions(
                                  plan.conditions,
                                ).toList().map(
                                  (final MapEntry<String, dynamic> entry) =>
                                      _buildDetailRow(
                                        Icons.check_circle_outline,
                                        entry.key,
                                        entry.value.toString(),
                                        isDarkMode,
                                      ),
                                ),
                              ],
                            ),

                          // Condiciones adicionales
                          if (_hasExtraConditions(plan.conditions))
                            _buildSection(
                              'Condiciones adicionales',
                              isDarkMode,
                              children: <Widget>[
                                Text(
                                  plan.conditions['extraConditions'].toString(),
                                  style: AppTypography.bodyMedium(isDarkMode)
                                      .copyWith(
                                        color: AppColors.getTextSecondary(
                                          isDarkMode,
                                        ),
                                        height: 1.5,
                                      ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Botones de acción
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: AppColors.getBackground(isDarkMode),
                  padding: const EdgeInsets.all(AppSpacing.m),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isSavingInProgress
                              ? null
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.getTextPrimary(
                              isDarkMode,
                            ),
                            side: BorderSide(
                              color: AppColors.getTextPrimary(isDarkMode),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.m,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.button,
                              ),
                            ),
                          ),
                          child: const Text('Editar'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSavingInProgress
                              ? null
                              : () async {
                                  setState(() {
                                    _isSavingInProgress = true;
                                  });

                                  try {
                                    final PlanBloc planBloc =
                                        BlocProvider.of<PlanBloc>(context);
                                    planBloc.add(const PlanEvent.save());

                                    // Esperar a que se complete la operación
                                    await Future.delayed(
                                      const Duration(seconds: 3),
                                    );

                                    if (!mounted) return;

                                    setState(() {
                                      _isSavingInProgress = false;
                                    });
                                  } catch (e) {
                                    setState(() {
                                      _isSavingInProgress = false;
                                    });
                                    _showErrorSnackbar(
                                      'Error al guardar el plan: ${e.toString()}',
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brandYellow,
                            foregroundColor: isDarkMode
                                ? Colors.black
                                : AppColors.lightTextPrimary,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.m,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.button,
                              ),
                            ),
                            disabledBackgroundColor: AppColors.getTextSecondary(
                              isDarkMode,
                            ),
                          ),
                          child: _isSavingInProgress
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      isDarkMode
                                          ? Colors.black
                                          : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                )
                              : const Text('Publicar Plan'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingScreen(bool isDarkMode) {
    return Scaffold(
      backgroundColor: AppColors.getBackground(isDarkMode),
      appBar: AppBar(
        backgroundColor: AppColors.getBackground(isDarkMode),
        elevation: 0,
        title: Text(
          'Vista previa del plan',
          style: AppTypography.appBarTitle(isDarkMode),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandYellow),
            ),
            const SizedBox(height: AppSpacing.l),
            Text(
              'Cargando datos del plan...',
              style: AppTypography.bodyLarge(
                isDarkMode,
              ).copyWith(color: AppColors.getTextSecondary(isDarkMode)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage(final PlanEntity plan, bool isDarkMode) {
    String imageUrl = plan.imageUrl;
    final bool isDataUrl = imageUrl.startsWith('data:image/');

    if (isDataUrl || imageUrl.isEmpty) {
      final String category = plan.category.isNotEmpty ? plan.category : 'Plan';
      final String title = plan.title.isNotEmpty ? plan.title : 'Plan';
      imageUrl =
          'https://via.placeholder.com/600x300/3498db/ffffff?text=$category:+$title';
    }

    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Imagen principal
          if (imageUrl.isNotEmpty && !isDataUrl)
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder:
                  (
                    final BuildContext context,
                    final Object error,
                    final StackTrace? stackTrace,
                  ) {
                    return _buildPlaceholderImage(plan, isDarkMode);
                  },
              loadingBuilder:
                  (
                    final BuildContext context,
                    final Widget child,
                    final ImageChunkEvent? loadingProgress,
                  ) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        _buildPlaceholderImage(plan, isDarkMode),
                        Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.brandYellow,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
            )
          else
            _buildPlaceholderImage(plan, isDarkMode),

          // Overlay oscuro
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.transparent,
                  Colors.black.withAlpha(
                    179,
                  ), // Actualizado desde withOpacity(0.7)
                ],
              ),
            ),
          ),

          // Marcador de categoría
          if (plan.category.isNotEmpty)
            Positioned(
              top: AppSpacing.m,
              right: AppSpacing.m,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.brandYellow,
                  borderRadius: BorderRadius.circular(AppRadius.s),
                ),
                child: Text(
                  plan.category,
                  style: AppTypography.labelMedium(isDarkMode).copyWith(
                    color: isDarkMode
                        ? Colors.black
                        : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage(final PlanEntity plan, bool isDarkMode) {
    final int colorValue = plan.id.hashCode % 0xFFFFFF;
    final Color color = Color(0xFF000000 + (colorValue & 0xFFFFFF));

    final String title = plan.title.isNotEmpty ? plan.title : 'Plan sin título';
    final String category = plan.category.isNotEmpty
        ? plan.category
        : 'Sin categoría';

    return Container(
      color: color,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              _getCategoryIcon(plan.category),
              size: 64,
              color: Colors.white.withAlpha(
                179,
              ), // Actualizado desde withOpacity(0.7)
            ),
            const SizedBox(height: AppSpacing.m),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              child: Text(
                title,
                style: AppTypography.heading4(
                  isDarkMode,
                ).copyWith(color: Colors.white),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              category,
              style: AppTypography.bodyLarge(isDarkMode).copyWith(
                color: Colors.white.withAlpha(
                  179,
                ), // Actualizado desde withOpacity(0.7)
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'deportes':
        return Icons.sports;
      case 'música':
      case 'musica':
      case 'recitales':
        return Icons.music_note;
      case 'cine':
      case 'teatro':
        return Icons.movie;
      case 'cocina':
        return Icons.restaurant;
      case 'social':
      case 'eventos sociales':
        return Icons.people;
      case 'festivales':
        return Icons.celebration;
      default:
        return Icons.event;
    }
  }

  void _showSuccessModal(final String title) {
    if (!mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return SuccessPlanModal(planTitle: title);
      },
    );
  }

  void _showErrorSnackbar(final String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.accentRed,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Reintentar',
          textColor: Colors.white,
          onPressed: () async {
            setState(() {
              _isSavingInProgress = true;
            });

            try {
              final PlanBloc planBloc = BlocProvider.of<PlanBloc>(context);
              planBloc.add(const PlanEvent.save());

              await Future.delayed(const Duration(seconds: 3));

              if (!mounted) return;
            } catch (e) {
              setState(() {
                _isSavingInProgress = false;
              });
              _showErrorSnackbar('Error al guardar el plan: ${e.toString()}');
            }
          },
        ),
      ),
    );
  }

  PlanEntity? _getPlanFromState(final PlanState state) {
    return state.maybeWhen(
      loaded: (final PlanEntity plan) => plan,
      saving: (final PlanEntity? plan) => plan,
      saved: (final PlanEntity plan) => plan,
      error: (final _, final PlanEntity? plan) => plan,
      orElse: () => null,
    );
  }

  Widget _buildSection(
    final String title,
    bool isDarkMode, {
    required final List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: AppTypography.heading5(
            isDarkMode,
          ).copyWith(color: AppColors.brandYellow),
        ),
        const SizedBox(height: AppSpacing.m),
        ...children,
        const SizedBox(height: AppSpacing.l),
      ],
    );
  }

  Widget _buildDetailRow(
    final IconData icon,
    final String label,
    final String value,
    bool isDarkMode,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.m),
      child: Row(
        children: <Widget>[
          Icon(icon, color: AppColors.brandYellow, size: AppIconSize.s),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: AppTypography.labelMedium(
                    isDarkMode,
                  ).copyWith(color: AppColors.getTextSecondary(isDarkMode)),
                ),
                Text(value, style: AppTypography.bodyLarge(isDarkMode)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<MapEntry<String, dynamic>> _getMainConditions(
    final Map<String, dynamic> conditions,
  ) {
    return conditions.entries
        .where(
          (final MapEntry<String, dynamic> entry) =>
              entry.key != 'extraConditions' &&
              entry.key != 'dateSelectionType' &&
              entry.key != 'startDate' &&
              entry.key != 'endDate',
        )
        .toList();
  }

  bool _hasExtraConditions(final Map<String, dynamic> conditions) {
    return conditions.containsKey('extraConditions') &&
        conditions['extraConditions'] != null &&
        conditions['extraConditions'].toString().isNotEmpty;
  }
}
