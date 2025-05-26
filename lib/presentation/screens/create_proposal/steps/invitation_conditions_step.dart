// lib/presentation/screens/create_proposal/steps/invitation_conditions_step.dart
// ignore_for_file: inference_failure_on_instance_creation, always_specify_types, inference_failure_on_function_return_type

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/core/theme/theme_utils.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';

import '../../../bloc/plan/plan_bloc.dart';
import '../../../bloc/plan/plan_event.dart';
import '../../../bloc/plan/plan_state.dart';

class InvitationConditionsStep extends StatefulWidget {
  final PageController pageController;

  static const Map<String, List<String>> conditionOptions =
      <String, List<String>>{
        'Número de invitados': <String>['∞', '1', '2', '3', '4'],
        'Condiciones de pago': <String>[
          'Cada uno lo suyo',
          '50/50',
          'Yo invito',
        ],
        'Nivel de actividad': <String>['Tranquilo', 'Moderado', 'Intenso'],
        'Edad recomendada': <String>['Todas las edades', '18+', '21+'],
        'Transporte': <String>['No necesario', 'Compartido', 'Individual'],
        'Equipamiento': <String>['No necesario', 'Básico', 'Especializado'],
      };

  const InvitationConditionsStep({
    super.key,
    required this.pageController,
    final int? guestCount,
    final String? payCondition,
    required final String extraConditions,
    required final void Function(dynamic count) onGuestCountSelect,
    required final void Function(dynamic condition) onPayConditionSelect,
    required final void Function(dynamic value) onExtraConditionsChange,
    required final void Function() onSubmit,
  });

  static final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      // ignore: deprecated_member_use
      printTime: true,
    ),
  );

  @override
  State<InvitationConditionsStep> createState() =>
      _InvitationConditionsStepState();
}

class _InvitationConditionsStepState extends State<InvitationConditionsStep> {
  late TextEditingController _extraConditionsController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      print('InvitationConditionsStep - initState()');
    }

    _extraConditionsController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      try {
        final PlanBloc bloc = context.read<PlanBloc>();
        final PlanState state = bloc.state;
        if (state is PlanLoaded) {
          // Cargar condiciones extras si existen
          _extraConditionsController.text =
              state.plan.conditions['extraConditions'] ?? '';
        }

        _isInitialized = true;
      } catch (e) {
        if (kDebugMode) {
          print('Error inicializando InvitationConditionsStep: $e');
          print('Stack trace: ${StackTrace.current}');
        }
      }
    }
  }

  void _submitPlan(final BuildContext context) {
    final PlanBloc bloc = context.read<PlanBloc>();
    final PlanState state = bloc.state;

    if (state is PlanLoaded &&
        _areAllRequiredOptionsSelected(state.plan.conditions)) {
      // Añadir logs para visualizar el BLoC y su estado
      InvitationConditionsStep.logger.i('🟢 BLoC ANTES DE NAVEGACIÓN 🟢');
      InvitationConditionsStep.logger.i('🟢 ID de PlanBloc: ${bloc.hashCode}');

      InvitationConditionsStep.logger.i('🟢 Plan ID: ${state.plan.id}');
      InvitationConditionsStep.logger.i('🟢 Título: ${state.plan.title}');
      InvitationConditionsStep.logger.i('🟢 Categoría: ${state.plan.category}');
      InvitationConditionsStep.logger.i('🟢 Ubicación: ${state.plan.location}');
      InvitationConditionsStep.logger.i(
        '🟢 Condiciones: ${state.plan.conditions}',
      );

      // Navegar a la pantalla de detalle usando GoRouter
      context.goNamed(
        'proposalDetail',
        extra: bloc, // Pasar el mismo bloc como extra
      );
    } else {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, selecciona todas las condiciones requeridas',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<PlanBloc, PlanState>(
      builder: (final BuildContext context, final PlanState state) {
        if (state is! PlanLoaded) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
            ),
          );
        }

        final PlanEntity plan = state.plan;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ThemeUtils.background, ThemeUtils.brandYellow],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 24),
                  ...InvitationConditionsStep.conditionOptions.entries.map(
                    (
                      final MapEntry<String, List<String>> entry,
                    ) => _buildSection(
                      title: entry.key,
                      child: _buildOptionGrid(
                        context: context,
                        options: entry.value,
                        selectedOption: plan.conditions[entry.key],
                        onSelect: (final String option) {
                          final Map<String, String> newOptions =
                              Map<String, String>.from(plan.conditions);
                          newOptions[entry.key] = option;

                          if (kDebugMode) {
                            print(
                              'Seleccionando condición para ${entry.key}: $option',
                            );
                            print('Condiciones actualizadas: $newOptions');
                          }

                          context.read<PlanBloc>().add(
                            PlanEvent.updateSelectedOptions(newOptions),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Condiciones adicionales (opcional)',
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((0.1 * 255).round()),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: (_extraConditionsController.text.isNotEmpty)
                              ? Colors.yellow
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: TextField(
                        controller: _extraConditionsController,
                        maxLines: 3,
                        style: TextStyle(
                          color: Colors.white.withAlpha((0.9 * 255).round()),
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Ej: Traer bebidas, equipo deportivo necesario...',
                          hintStyle: TextStyle(
                            color: Colors.white.withAlpha((0.5 * 255).round()),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        onChanged: (final String value) {
                          if (kDebugMode) {
                            print(
                              'Actualizando condiciones adicionales: $value',
                            );
                          }

                          context.read<PlanBloc>().add(
                            PlanEvent.updateExtraConditions(value),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _areAllRequiredOptionsSelected(plan.conditions)
                          ? () => _submitPlan(context)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Vista Previa del Plan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _areAllRequiredOptionsSelected(final Map<String, String> conditions) {
    // Verificamos que todas las opciones requeridas (excluyendo extraConditions) estén seleccionadas
    final Iterable<String> requiredOptions =
        InvitationConditionsStep.conditionOptions.keys;

    final bool result = requiredOptions.every(
      (final String key) =>
          conditions.containsKey(key) && conditions[key]!.isNotEmpty,
    );

    if (kDebugMode) {
      print('Validando condiciones requeridas: $result');
      print('Condiciones actuales: $conditions');
      print('Opciones requeridas: $requiredOptions');
    }

    return result;
  }

  Widget _buildSection({
    required final String title,
    required final Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white.withAlpha((0.9 * 255).round()),
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildOptionGrid({
    required final BuildContext context,
    required final List<String> options,
    required final String? selectedOption,
    required final Function(String) onSelect,
  }) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: options.length > 3 ? 4 : 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.5,
      children: options.map((final String option) {
        final bool isSelected = selectedOption == option;
        return GestureDetector(
          onTap: () => onSelect(option),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.yellow.withAlpha((0.15 * 255).round())
                  : Colors.white.withAlpha((0.1 * 255).round()),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.yellow : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                option,
                style: TextStyle(
                  color: Colors.white.withAlpha((0.9 * 255).round()),
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _extraConditionsController.dispose();
    super.dispose();
  }
}
