// lib/presentation/screens/my_applications/my_applications_screen.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/presentation/widgets/common/feedback_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quien_para/presentation/widgets/responsive/new_responsive_scaffold.dart';

import '../../bloc/loading_cubit.dart';
import '../../bloc/my_applications/my_applications_cubit.dart';

/// La pantalla principal de aplicaciones del usuario
class MyApplicationsScreen extends StatefulWidget {
  final String? userId;

  const MyApplicationsScreen({super.key, this.userId});

  @override
  State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

/// Estado de la pantalla principal que proporciona el BlocProvider
class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
  @override
  Widget build(BuildContext context) {
    // Proporcionar el MyApplicationsCubit a toda la pantalla
    return BlocProvider(
      create: (context) => MyApplicationsCubit(
        firestore: FirebaseFirestore.instance,
        userId: widget.userId,
      ),
      child: _MyApplicationsScreenContent(userId: widget.userId),
    );
  }
}

/// Contenido real de la pantalla que usa el cubit
class _MyApplicationsScreenContent extends StatefulWidget {
  final String? userId;

  const _MyApplicationsScreenContent({this.userId});

  @override
  State<_MyApplicationsScreenContent> createState() =>
      _MyApplicationsScreenContentState();
}

class _MyApplicationsScreenContentState
    extends State<_MyApplicationsScreenContent> {
  late MyApplicationsCubit _cubit;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print(
        '📱🔍 MyApplicationsScreen.initState() - Inicializando con MyApplicationsCubit',
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Inicializar el cubit aquí para tener acceso a context
    _cubit = context.read<MyApplicationsCubit>();
  }

  // Implementación para cancelar una aplicación
  Future<void> _cancelApplication(String applicationId) async {
    if (!mounted) return;

    try {
      // Temporalmente no implementado hasta que se agregue al cubit
      FeedbackMessage.show(
        context,
        message: 'Función de cancelación temporalmente no disponible',
        type: FeedbackType.warning,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ MyApplicationsScreen - ERROR cancelando aplicación: $e');
      }

      if (mounted) {
        FeedbackMessage.showError(
          context,
          message: 'No se pudo cancelar la postulación',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Definir el AppBar que se usará tanto en móvil como en web
    final appBar = AppBar(
      backgroundColor: AppColors.getBackground(isDarkMode),
      elevation: 0,
      title: Text(
        'Mis Postulaciones',
        style: AppTypography.heading5(isDarkMode),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.getTextPrimary(isDarkMode),
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );

    // Definir el contenido principal
    final content =
        BlocBuilder<MyApplicationsCubit, LoadingState<MyApplicationsData>>(
      builder: (context, state) {
        // Estado de carga
        if (state.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.brandYellow),
          );
        }

        // Estado de error
        if (state.isError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.accentRed,
                  size: 48,
                ),
                const SizedBox(height: AppSpacing.m),
                Text(
                  state.errorMessage ?? 'Error al cargar postulaciones',
                  style: AppTypography.bodyLarge(isDarkMode),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.l),
                ElevatedButton(
                  onPressed: () => _cubit.loadApplications(),
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

        // Estado vacío
        if (state.isEmpty ||
            (state.isLoaded && state.data!.applications.isEmpty)) {
          return Center(
            child: Text(
              'No tienes postulaciones activas',
              style: AppTypography.bodyLarge(
                isDarkMode,
              ).copyWith(color: AppColors.getTextSecondary(isDarkMode)),
            ),
          );
        }

        // Estado cargado con datos
        if (state.isLoaded) {
          return _buildApplicationsList(state.data!, isDarkMode);
        }

        // Estado por defecto (no debería ocurrir)
        return Center(
          child: Text(
            'Estado no reconocido',
            style: AppTypography.bodyMedium(
              isDarkMode,
            ).copyWith(color: AppColors.getTextSecondary(isDarkMode)),
          ),
        );
      },
    );

    // Usar NewResponsiveScaffold para tener un diseño consistente
    return NewResponsiveScaffold(
      screenName: 'my_applications',
      appBar: appBar,
      body: content,
      currentIndex: 3, // Asumo que esto está en 3, ajustarlo según corresponda
      webTitle: 'Mis Postulaciones',
    );
  }

  Widget _buildApplicationsList(MyApplicationsData data, bool isDarkMode) {
    final applications = _cubit.getFilteredApplications();

    return RefreshIndicator(
      onRefresh: () async {
        if (kDebugMode) {
          print(
            '📱 MyApplicationsScreen - Refresh manual mediante pull-to-refresh',
          );
        }

        if (mounted) {
          // Recargar usando el cubit
          _cubit.loadApplications();
        }
        return Future.value();
      },
      color: AppColors.brandYellow,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.m),
        itemCount: applications.length,
        itemBuilder: (context, index) {
          final application = applications[index];
          final plan = _cubit.getPlanForApplication(application);
          final bool isPlanLoaded = plan != null;

          return Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.m),
            color: AppColors.getCardBackground(isDarkMode),
            elevation: AppElevation.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Estado de la aplicación
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(application.status),
                          borderRadius: BorderRadius.circular(AppRadius.s),
                        ),
                        child: Text(
                          _getStatusText(application.status),
                          style: AppTypography.labelSmall(
                            isDarkMode,
                          ).copyWith(color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      // Categoría
                      if (isPlanLoaded) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.s,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.brandYellow,
                            borderRadius: BorderRadius.circular(AppRadius.s),
                          ),
                          child: Text(
                            plan.category,
                            style:
                                AppTypography.labelSmall(isDarkMode).copyWith(
                              color: isDarkMode
                                  ? Colors.black
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.m),

                  // Título del plan
                  Text(
                    isPlanLoaded ? plan.title : 'Cargando plan...',
                    style: AppTypography.heading5(isDarkMode),
                  ),

                  const SizedBox(height: AppSpacing.s),

                  // Información adicional
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: AppIconSize.xs,
                        color: AppColors.getTextSecondary(isDarkMode),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        isPlanLoaded && plan.date != null
                            ? DateFormat('dd MMM. yyyy').format(plan.date!)
                            : 'Fecha no disponible',
                        style: AppTypography.bodyMedium(isDarkMode).copyWith(
                          color: AppColors.getTextSecondary(isDarkMode),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      if (isPlanLoaded) ...[
                        Icon(
                          Icons.location_on,
                          size: AppIconSize.xs,
                          color: AppColors.getTextSecondary(isDarkMode),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          plan.location,
                          style: AppTypography.bodyMedium(isDarkMode).copyWith(
                            color: AppColors.getTextSecondary(isDarkMode),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: AppSpacing.m),

                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            if (isPlanLoaded) {
                              context.go('/plan/${plan.id}');
                            }
                          },
                          icon: Icon(Icons.visibility, size: AppIconSize.s),
                          label: const Text('Ver plan'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.getTextPrimary(
                              isDarkMode,
                            ),
                            side: BorderSide(
                              color: AppColors.getBorder(isDarkMode),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.button,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (application.status == 'pending') ...[
                        const SizedBox(width: AppSpacing.s),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _cancelApplication(application.id),
                            icon: Icon(Icons.close, size: AppIconSize.s),
                            label: const Text('Cancelar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentRed,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.button,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.brandYellow;
      case 'accepted':
        return AppColors.success;
      case 'rejected':
        return AppColors.accentRed;
      default:
        return AppColors.info;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pendiente';
      case 'accepted':
        return 'Aceptada';
      case 'rejected':
        return 'Rechazada';
      default:
        return status;
    }
  }
}
