// lib/presentation/screens/create_proposal/onboarding_plan_flow_responsive.dart
// ignore_for_file: always_specify_types, unnecessary_null_comparison, inference_failure_on_untyped_parameter

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/constants/app_constants.dart';
import 'package:quien_para/core/constants/app_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/core/di/di.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/presentation/bloc/plan/plan_bloc.dart';
import 'package:quien_para/presentation/bloc/plan/plan_event.dart';
import 'package:quien_para/presentation/bloc/plan/plan_state.dart';
import 'package:quien_para/presentation/widgets/responsive/new_responsive_scaffold.dart';
import 'steps/plan_type_step.dart';
import 'steps/date_location_step.dart';
import 'steps/plan_suggestions_step.dart';
import 'steps/event_details_step.dart';
import 'steps/invitation_conditions_step.dart';

class OnboardingPlanFlowResponsive extends StatefulWidget {
  final String? planId;
  final Map<String, dynamic>? planData;
  final bool isEditing;

  const OnboardingPlanFlowResponsive({
    super.key,
    this.planId,
    this.planData,
    this.isEditing = false,
  });

  @override
  State<OnboardingPlanFlowResponsive> createState() =>
      _OnboardingPlanFlowResponsiveState();
}

class _OnboardingPlanFlowResponsiveState
    extends State<OnboardingPlanFlowResponsive>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late final PlanBloc _planBloc;
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // Configuración de la animación para la barra de progreso
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1 / steps.length).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();

    if (kDebugMode) {
      print(
        'Inicializando OnboardingPlanFlow - Modo: ${widget.isEditing ? 'Edición' : 'Creación'}',
      );
    }

    // Obtener PlanBloc del contenedor de dependencias
    _planBloc = sl<PlanBloc>();
    _pageController.addListener(_handlePageChange);

    // Inicializar el plan según el modo
    Future.microtask(() {
      if (widget.isEditing && widget.planData != null) {
        // Si estamos editando, cargar los datos existentes
        _planBloc.add(PlanEvent.loadExistingPlan(planData: widget.planData!));
        // Pre-validar los pasos con los datos existentes
        _preValidateSteps();
      } else {
        // Si es un nuevo plan, crear uno vacío
        _planBloc.add(const PlanEvent.create());
      }
    });
  }

  void _preValidateSteps() {
    if (widget.planData != null) {
      final planData = widget.planData!;
      // Validar cada paso según los datos existentes
      setState(() {
        // Paso 1: Tipo de plan
        steps[0]['isValid'] = planData['category'] != null;

        // Paso 2: Fecha y lugar
        steps[1]['isValid'] =
            planData['date'] != null && planData['location'] != null;

        // Paso 3: Sugerencias (siempre válido en edición)
        steps[2]['isValid'] = true;

        // Paso 4: Detalles
        steps[3]['isValid'] =
            planData['title'] != null && planData['description'] != null;

        // Paso 5: Condiciones
        steps[4]['isValid'] = true; // Las condiciones son opcionales
      });
    }
  }

  void _handlePageChange() {
    if (!mounted) return;
    final int newPage = _pageController.page?.round() ?? 0;
    if (newPage != _currentPage) {
      setState(() => _currentPage = newPage);

      // Actualizar animación de progreso
      _animationController.animateTo(
        (newPage + 1) / steps.length,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    if (kDebugMode) {
      print('Dispose de OnboardingPlanFlow');
    }
    _pageController.removeListener(_handlePageChange);
    _pageController.dispose();
    _animationController.dispose();
    _planBloc.close();
    super.dispose();
  }

  final List<Map<String, Object>> steps = <Map<String, Object>>[
    <String, Object>{
      'icon': '🚦',
      'materialIcon': AppIcons.trafficLight,
      'title': 'Comencemos',
      'subtitle': 'Elige el tipo de plan que quieres crear',
      'isValid': false,
    },
    <String, Object>{
      'icon': '📍',
      'materialIcon': AppIcons.location,
      'title': 'Fecha y Lugar',
      'subtitle': 'Dónde y cuándo será el plan',
      'isValid': false,
    },
    <String, Object>{
      'icon': '💡',
      'materialIcon': AppIcons.idea,
      'title': 'Sugerencias',
      'subtitle': 'Revisa nuestras recomendaciones',
      'isValid': false,
    },
    <String, Object>{
      'icon': '✏️',
      'materialIcon': AppIcons.edit,
      'title': 'Detalles',
      'subtitle': 'Describe tu propuesta para que otros se animen a unirse',
      'isValid': false,
    },
    <String, Object>{
      'icon': '⚙️',
      'materialIcon': AppIcons.gear,
      'title': 'Condiciones',
      'subtitle': 'Establece las condiciones para unirse',
      'isValid': false,
    },
  ];

  void _updateStepValidation(int index, bool isValid) {
    if (!mounted) return;
    setState(() {
      steps[index] = Map<String, Object>.from(steps[index])
        ..['isValid'] = isValid;
    });
  }

  @override
  Widget build(final BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // AppBar para la pantalla (aunque en web será ocultado por NewResponsiveScaffold)
    final appBar = AppBar(
      backgroundColor: isDarkMode
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.close, color: AppColors.getTextPrimary(isDarkMode)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.isEditing ? 'Editar Plan' : 'Crear Plan',
        style: TextStyle(
          color: AppColors.getTextPrimary(isDarkMode),
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        if (_currentPage > 0)
          TextButton(
            onPressed: _previousPage,
            child: Text(
              'Atrás',
              style: TextStyle(
                color: AppColors.brandYellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );

    // Contenido principal
    final content = BlocProvider<PlanBloc>.value(
      value: _planBloc,
      child: BlocListener<PlanBloc, PlanState>(
        listener: (final BuildContext context, final PlanState state) {
          if (kDebugMode) {
            print('Estado del PlanBloc en OnboardingPlanFlow: $state');
          }
        },
        child: BlocBuilder<PlanBloc, PlanState>(
          builder: (final BuildContext context, final PlanState state) {
            if (state is PlanInitial) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.brandYellow,
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Progress bar and header
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Column(
                      children: [
                        // Progress bar
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Step numbers and back button
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Paso ${_currentPage + 1} de ${steps.length}',
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? AppColors.darkTextSecondary
                                            : AppColors.lightTextSecondary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (_currentPage > 0)
                                      GestureDetector(
                                        onTap: _previousPage,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.arrow_back_ios,
                                              size: 16,
                                              color: AppColors.brandYellow,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Volver',
                                              style: TextStyle(
                                                color: AppColors.brandYellow,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              // Progress bar
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? AppColors.darkSecondaryBackground
                                      : AppColors.lightSecondaryBackground,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: (_currentPage + 1) / steps.length,
                                    backgroundColor: Colors.transparent,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.brandYellow,
                                    ),
                                    minHeight: 8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Header
                        _buildHeader(_currentPage),
                      ],
                    );
                  },
                ),

                // Contenido principal de los pasos
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (final int page) =>
                        setState(() => _currentPage = page),
                    children: <Widget>[
                      PlanTypeStep(
                        pageController: _pageController,
                        planTypes: PlanType.planTypes.keys.toList(),
                        selectedType: state is PlanLoaded
                            ? state.plan.category
                            : null,
                        onSelect: (final type) {
                          context.read<PlanBloc>().add(
                            PlanEvent.updateField(field: 'type', value: type),
                          );
                          _updateStepValidation(0, true);
                          _nextPage();
                        },
                      ),
                      DateLocationStep(
                        pageController: _pageController,
                        selectedCity: state is PlanLoaded
                            ? state.plan.location
                            : null,
                        onDateSelect: (final date) {
                          context.read<PlanBloc>().add(
                            PlanEvent.updateField(field: 'date', value: date),
                          );
                        },
                        onCitySelect: (final city) {
                          context.read<PlanBloc>().add(
                            PlanEvent.updateField(field: 'city', value: city),
                          );
                          _updateStepValidation(1, true);
                        },
                        onNext: () {
                          if (state is PlanLoaded &&
                              state.plan.date != null &&
                              state.plan.location != null) {
                            _nextPage();
                          }
                        },
                      ),
                      PlanSuggestionsStep(
                        state: _planBloc,
                        onStateUpdate: (PlanBloc newState) {
                          // Aquí podrías implementar alguna lógica para actualizar el estado
                        },
                        onNext: () {
                          _updateStepValidation(2, true);
                          _nextPage();
                        },
                        onBack: _previousPage,
                      ),
                      EventDetailsStep(
                        pageController: _pageController,
                        title: state is PlanLoaded ? state.plan.title : '',
                        description: state is PlanLoaded
                            ? state.plan.description
                            : '',
                        location: state is PlanLoaded
                            ? state.plan.location
                            : '',
                        onTitleChange: (final value) {
                          context.read<PlanBloc>().add(
                            PlanEvent.updateField(field: 'title', value: value),
                          );
                        },
                        onDescriptionChange: (final value) {
                          context.read<PlanBloc>().add(
                            PlanEvent.updateField(
                              field: 'description',
                              value: value,
                            ),
                          );
                        },
                        onLocationChange: (final value) {
                          context.read<PlanBloc>().add(
                            PlanEvent.updateField(
                              field: 'location',
                              value: value,
                            ),
                          );
                        },
                        onNext: () {
                          if (state is PlanLoaded &&
                              state.plan.title.isNotEmpty &&
                              state.plan.description.isNotEmpty) {
                            _updateStepValidation(3, true);
                            _nextPage();
                          }
                        },
                      ),
                      InvitationConditionsStep(
                        pageController: _pageController,
                        guestCount: state is PlanLoaded
                            ? state.plan.guestCount
                            : null,
                        payCondition: state is PlanLoaded
                            ? state.plan.payCondition
                            : null,
                        extraConditions: state is PlanLoaded
                            ? state.plan.extraConditions
                            : '',
                        onGuestCountSelect: (final count) {
                          context.read<PlanBloc>().add(
                            PlanEvent.updateField(
                              field: 'guestCount',
                              value: count,
                            ),
                          );
                        },
                        onPayConditionSelect: (final condition) {
                          context.read<PlanBloc>().add(
                            PlanEvent.updateField(
                              field: 'payCondition',
                              value: condition,
                            ),
                          );
                        },
                        onExtraConditionsChange: (final value) {
                          context.read<PlanBloc>().add(
                            PlanEvent.updateExtraConditions(value.toString()),
                          );
                        },
                        onSubmit: () {
                          if (state is PlanLoaded &&
                              state.plan.guestCount != null &&
                              state.plan.payCondition != null) {
                            _updateStepValidation(4, true);
                            context.read<PlanBloc>().add(
                              const PlanEvent.save(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

    // Usar NewResponsiveScaffold para tener un diseño consistente en web y móvil
    return NewResponsiveScaffold(
      screenName: 'create_proposal',
      appBar: appBar,
      body: content,
      currentIndex: 1, // Propuestas está en índice 1
      webTitle: widget.isEditing ? 'Editar Plan' : 'Crear Plan',
    );
  }

  void _nextPage() {
    if (_currentPage < steps.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.mediumAnimationDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: AppConstants.mediumAnimationDuration,
      curve: Curves.easeInOut,
    );
  }

  Widget _buildHeader(int step) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.brandYellow.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                steps[step]['icon'] as String,
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            steps[step]['title'] as String,
            style: TextStyle(
              color: isDarkMode
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            steps[step]['subtitle'] as String,
            style: TextStyle(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
