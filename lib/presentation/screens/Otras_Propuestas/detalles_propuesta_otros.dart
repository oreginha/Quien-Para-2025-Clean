// lib/presentation/screens/Otras_Propuestas/detalles_propuesta_otros.dart

// ignore_for_file: file_names, unused_local_variable, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/entities/security/report_entity.dart';
import 'package:quien_para/presentation/routes/app_router.dart';
import 'package:quien_para/presentation/widgets/responsive/new_responsive_scaffold.dart';
import 'package:quien_para/presentation/widgets/buttons/report_button.dart';

// Importamos los widgets modulares
import '../../bloc/matching/matching_bloc.dart';
import '../../bloc/matching/matching_event.dart';
import 'widgets/index.dart';
import '../../widgets/modals/success_application_modal.dart';

/// Pantalla de detalle de propuestas creadas por otros usuarios
/// Refactorizada para usar el nuevo sistema de responsive scaffold para web y móvil
class DetallesPropuestaOtros extends StatefulWidget {
  final String planId;
  final bool isCreator;

  const DetallesPropuestaOtros({
    super.key,
    required this.planId,
    this.isCreator = false,
  });

  @override
  State<DetallesPropuestaOtros> createState() => _DetallesPropuestaOtrosState();
}

class _DetallesPropuestaOtrosState extends State<DetallesPropuestaOtros> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Configurar listener para cambios en MatchingBloc
    _setupMatchingBlocListener();
  }

  /// Configura el listener para MatchingBloc
  void _setupMatchingBlocListener() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final matchingBloc = context.read<MatchingBloc>();
      matchingBloc.stream.listen((state) {
        state.when(
          initial: () {},
          loading: () {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          userApplicationsLoaded: (_) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          planApplicationsLoaded: (_) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          applicationActionSuccess: (message, application) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });

              // Mostrar modal de éxito
              _showSuccessModal();
            }
          },
          error: (errorMessage) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(errorMessage)));
            }
          },
        );
      });
    });
  }

  /// Muestra el modal de éxito después de postularse a un plan
  void _showSuccessModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SuccessApplicationModal(
          title: '¡Postulación exitosa!',
          description:
              'Tu postulación ha sido enviada. El creador del plan revisará tu solicitud y te notificará cuando la acepte o rechace.',
          buttonText: 'Entendido',
          icon: Icons.check_circle,
          iconColor: AppColors.success,
        );
      },
    );
  }

  /// Maneja la postulación a un plan
  Future<void> handlePostulation(String planId, [String? message]) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Necesitas iniciar sesión para postularte'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Usar el MatchingBloc para aplicar al plan
      context.read<MatchingBloc>().add(
            MatchingEvent.applyToPlan(planId, message),
          );

      // El resto del flujo se manejará a través del BlocListener
    } catch (e) {
      if (kDebugMode) {
        print('Error al postularse: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al postularse: $e')));
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('DetallesPropuestaOtros - Cargando plan con ID: ${widget.planId}');
    }

    // Obtener el proveedor de tema para usarlo en toda la UI
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return StreamBuilder<DocumentSnapshot>(
      stream: widget.planId.isNotEmpty
          ? FirebaseFirestore.instance
              .collection('plans')
              .doc(widget.planId)
              .snapshots()
          : Stream<DocumentSnapshot>.empty(),
      builder: (
        final BuildContext context,
        final AsyncSnapshot<DocumentSnapshot<Object?>> snapshot,
      ) {
        // Si hay un error al cargar los datos
        if (snapshot.hasError) {
          return _buildErrorScreen(
            context,
            'Error al cargar el plan',
            isDarkMode,
          );
        }

        // Mostrar pantalla de carga mientras se obtienen los datos
        if (!snapshot.hasData) {
          return _buildLoadingScreen(context, isDarkMode);
        }

        // Extraer los datos del plan
        final Map<String, dynamic> planData =
            snapshot.data!.data() as Map<String, dynamic>? ??
                <String, dynamic>{};

        // Convertir a entidad de Plan
        final plan = PlanEntity(
          id: widget.planId,
          title: planData['title']?.toString() ?? 'Sin título',
          description:
              (planData['description'] as String?) ?? 'Sin descripción',
          imageUrl: (planData['imageUrl'] as String?) ?? '',
          creatorId: (planData['creatorId'] as String?) ?? '',
          date: planData['date'] != null
              ? (planData['date'] as Timestamp).toDate()
              : DateTime.now(),
          category: (planData['category'] as String?) ?? '',
          location: (planData['location'] as String?) ?? '',
          tags: [],
          conditions: {},
          selectedThemes: [],
          likes: 0,
          extraConditions: '',
        );

        // Crear el AppBar personalizado para esta pantalla
        final appBar = AppBar(
          backgroundColor: AppColors.getBackground(isDarkMode),
          elevation: 0,
          title: Text(
            plan.title,
            style: AppTypography.heading2(isDarkMode),
            overflow: TextOverflow.ellipsis,
          ),
          iconTheme: IconThemeData(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          actions: [
            // Botón de reportar plan
            if (!widget.isCreator)
              ReportButton(
                reportedUserId: plan.creatorId,
                reportedPlanId: plan.id,
                type: ReportType.plan,
                style: ReportButtonStyle.icon,
              ),
            // Botón de menú adicional
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              onSelected: (String value) {
                switch (value) {
                  case 'share':
                    // TODO: Implementar compartir plan
                    break;
                  case 'security':
                    showSecurityBottomSheet(
                      context: context,
                      targetUserId: plan.creatorId,
                      targetPlanId: plan.id,
                      type: ReportType.plan,
                    );
                    break;
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(
                        Icons.share,
                        color: AppColors.getTextPrimary(isDarkMode),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Compartir',
                        style: AppTypography.bodyMedium(isDarkMode),
                      ),
                    ],
                  ),
                ),
                if (!widget.isCreator)
                  PopupMenuItem<String>(
                    value: 'security',
                    child: Row(
                      children: [
                        Icon(Icons.security, color: AppColors.accentRed),
                        const SizedBox(width: 8),
                        Text(
                          'Seguridad',
                          style: AppTypography.bodyMedium(
                            isDarkMode,
                          ).copyWith(color: AppColors.accentRed),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        );

        // Contenido principal de la pantalla
        final body = _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.brandYellow,
                ),
              )
            : _buildPlanDetailsContent(context, plan, isDarkMode);

        // Construir la pantalla utilizando NewResponsiveScaffold para soporte web
        return NewResponsiveScaffold(
          screenName: AppRouter.otherProposalDetail,
          appBar: appBar,
          body: body,
          currentIndex: -1, // No es una pantalla en la barra de navegación
          webTitle: plan.title, // Usar el título del plan para la versión web
          darkPrimaryBackground:
              isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
        );
      },
    );
  }

  /// Construye la pantalla de error
  Widget _buildErrorScreen(
    BuildContext context,
    String errorMessage,
    bool isDarkMode,
  ) {
    return NewResponsiveScaffold(
      screenName: 'Error',
      appBar: AppBar(
        backgroundColor: AppColors.getBackground(isDarkMode),
        title: Text(
          'Error',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      body: Center(
        child: Text(errorMessage, style: AppTypography.heading1(isDarkMode)),
      ),
      currentIndex: -1,
      webTitle: 'Error',
      darkPrimaryBackground:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
    );
  }

  /// Construye la pantalla de carga
  Widget _buildLoadingScreen(BuildContext context, bool isDarkMode) {
    return NewResponsiveScaffold(
      screenName: 'Cargando',
      appBar: AppBar(
        backgroundColor: AppColors.getBackground(isDarkMode),
        title: Text(
          'Cargando...',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      body: Center(
        child: CircularProgressIndicator(color: AppColors.brandYellow),
      ),
      currentIndex: -1,
      webTitle: 'Cargando...',
      darkPrimaryBackground:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
    );
  }

  /// Construye el contenido principal de la pantalla
  Widget _buildPlanDetailsContent(
    BuildContext context,
    PlanEntity plan,
    bool isDarkMode,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: Theme.of(context).brightness == Brightness.dark
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.darkBackground, Color(0xFF121212)],
              )
            : null,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con imagen
            PlanHeaderWidget(plan: plan, isDarkMode: isDarkMode),

            // Contenido principal
            Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Detalles de fecha y ubicación
                  PlanInfoWidget(plan: plan, isDarkMode: isDarkMode),

                  const SizedBox(height: AppSpacing.xxl),

                  // Sección de descripción
                  PlanDescriptionWidget(
                    description: plan.description,
                    isDarkMode: isDarkMode,
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Sección del creador
                  Text(
                    'Creado por',
                    style: AppTypography.heading2(
                      isDarkMode,
                    ).copyWith(color: AppColors.brandYellow),
                  ),
                  SizedBox(height: AppSpacing.xl),
                  CreatorProfileWidget(
                    creatorId: plan.creatorId,
                    isDarkMode: isDarkMode,
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Botones de acción
                  if (!widget.isCreator)
                    ActionButtonsWidget(
                      plan: plan,
                      isDarkMode: isDarkMode,
                      onPostulationHandler: handlePostulation,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
