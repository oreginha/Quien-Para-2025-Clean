// lib/presentation/screens/create_proposal/steps/plan_type_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart'; // Reemplazando theme_utils por app_colors
import '../../../bloc/plan/plan_bloc.dart';
import '../../../bloc/plan/plan_event.dart';
import '../../../bloc/plan/plan_state.dart';

class PlanTypeStep extends StatelessWidget {
  final PageController pageController;

  const PlanTypeStep({
    super.key,
    required this.pageController,
    required final List<String> planTypes,
    final String? selectedType,
    required final void Function(String type) onSelect,
  });

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<PlanBloc, PlanState>(
      builder: (final BuildContext context, final PlanState state) {
        if (state is! PlanLoaded) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors
                  .brandYellow), // Usando AppColors en lugar de ThemeUtils
            ),
          );
        }

        final PlanEntity plan = state.plan;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.getBackground(Theme.of(context).brightness ==
                    Brightness.dark), // Reemplazo que respeta el modo
                AppColors.getSecondaryBackground(Theme.of(context).brightness ==
                    Brightness.dark), // Reemplazo que respeta el modo
              ],
            ),
          ),
          child: LayoutBuilder(
            builder:
                (final BuildContext context, final BoxConstraints constraints) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: PlanType.planTypes.length,
                        itemBuilder:
                            (final BuildContext context, final int index) {
                          final String type =
                              PlanType.planTypes.keys.elementAt(index);
                          final Map<String, dynamic> details =
                              PlanType.planTypes[type]!;
                          // Cambio: ahora solo un tipo puede estar seleccionado
                          final bool isSelected =
                              plan.selectedThemes.isNotEmpty &&
                                  plan.selectedThemes.first == type;

                          return GestureDetector(
                            onTap: () {
                              // Actualizar temas seleccionados con BLoC
                              context.read<PlanBloc>().add(
                                  PlanEvent.updateSelectedThemes(
                                      <String>[type]));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.brandYellow
                                        .withAlpha((0.15 * 255).toInt())
                                    : AppColors.getBackground(
                                            Theme.of(context).brightness ==
                                                Brightness.dark)
                                        .withAlpha(
                                            120), // Reemplazo que respeta el modo
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors
                                          .brandYellow // Color de marca consistente
                                      : Colors
                                          .transparent, // Colors.transparent se mantiene ya que es un valor constante universal
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    details['emoji'] as String,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    type,
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.brandYellow
                                          : AppColors.getTextPrimary(
                                              Theme.of(context).brightness ==
                                                  Brightness.dark),
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            // Solo necesitamos un tipo seleccionado
                            onPressed: plan.selectedThemes.isNotEmpty
                                ? () {
                                    // Verificar si debe mostrar sugerencias basado en el tipo
                                    final String selectedType =
                                        plan.selectedThemes.first;
                                    final bool needsSuggestions = <String>[
                                      'Recitales',
                                      'Festivales',
                                      'Teatro',
                                      'Cine'
                                    ].contains(selectedType);

                                    // Si no necesita sugerencias, saltar directamente a detalles
                                    if (needsSuggestions) {
                                      pageController.nextPage(
                                        duration: AppConstants
                                            .mediumAnimationDuration,
                                        curve: Curves.easeInOut,
                                      );
                                    } else {
                                      // Saltar a la página de detalles (2 páginas adelante)
                                      pageController.animateToPage(
                                        3, // Índice de EventDetailsStep
                                        duration: AppConstants
                                            .mediumAnimationDuration,
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brandYellow,
                              foregroundColor: AppColors.getBackground(
                                  Theme.of(context).brightness ==
                                      Brightness.dark),
                              disabledBackgroundColor:
                                  AppColors.brandYellow.withValues(alpha: 0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Continuar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
