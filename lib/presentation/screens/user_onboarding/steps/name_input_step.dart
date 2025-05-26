//lib/presentation/screens/user_onboarding/steps/name_input_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/presentation/widgets/common/buttons/app_buttons.dart';
import 'package:quien_para/presentation/widgets/common/buttons/onboarding_button.dart';
import 'package:quien_para/presentation/widgets/responsive_onboarding_container.dart';
import 'package:quien_para/presentation/widgets/utils/styled_input.dart';

import '../../../bloc/profile/user_profile_bloc.dart';

class NameInputStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const NameInputStep({super.key, required this.onNext, required this.onBack});

  @override
  State<NameInputStep> createState() => _NameInputStepState();
}

class _NameInputStepState extends State<NameInputStep> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _canContinue = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final String initialName = context.read<UserProfileBloc>().state.name;
    _nameController.text = initialName;
    _updateContinueButton(initialName);

    // No activar el teclado automáticamente
    _focusNode.addListener(() {
      setState(() {}); // Actualiza la UI cuando cambia el foco
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateContinueButton(final String value) {
    final String trimmedValue = value.trim();

    setState(() {
      if (trimmedValue.isEmpty) {
        _canContinue = false;
        _errorText = 'Por favor, ingresa tu nombre';
      } else if (trimmedValue.length < 2) {
        _canContinue = false;
        _errorText = 'Tu nombre debe tener al menos 2 caracteres';
      } else {
        _canContinue = true;
        _errorText = null;
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    return ResponsiveOnboardingContainer(
      bottomActions: OnboardingButton(
        text: 'Continuar',
        onPressed: _canContinue ? widget.onNext : null,
        isEnabled: _canContinue,
        icon: Icons.arrow_forward,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppBackButton(onPressed: widget.onBack, showConfirmDialog: false),
            ],
          ),
          const SizedBox(height: 20),
          StyledInput(
            labelText: 'Nombre',
            hintText: '¿Cómo te llamas?',
            controller: _nameController,
            errorText: _errorText,
            focusNode: _focusNode,
            prefixIcon: Icon(
              Icons.person_outline,
              color: _focusNode.hasFocus
                  ? AppColors.brandYellow
                  : AppColors.lightTextPrimary.withAlpha((255 * 0.7).round()),
            ),
            onChanged: (final String value) {
              context.read<UserProfileBloc>().add(UpdateNameEvent(value));
              _updateContinueButton(value);
            },
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 20),

          // Sugerencias añadidas como mejora UX
          if (!_canContinue)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.getCardBackground(
                  false,
                ).withAlpha((255 * 0.1).round()),
                borderRadius: BorderRadius.circular(AppRadius.l),
                border: Border.all(
                  color: AppColors.getBorder(
                    false,
                  ).withAlpha((255 * 0.3).round()),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: AppColors.brandYellow,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Consejos',
                        style: TextStyle(
                          color: AppColors.brandYellow,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tu nombre ayudará a otros usuarios a conocerte mejor. Puede ser tu nombre completo o un apodo.',
                    style: TextStyle(
                      color: AppColors.lightTextPrimary.withAlpha(
                        (255 * 0.8).round(),
                      ),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),
          // Ejemplos de nombres populares
          if (_nameController.text.isEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nombres populares:',
                  style: TextStyle(
                    color: AppColors.lightTextPrimary.withAlpha(
                      (255 * 0.8).round(),
                    ),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildNameChip('Ana'),
                    _buildNameChip('Carlos'),
                    _buildNameChip('Lucía'),
                    _buildNameChip('Diego'),
                    _buildNameChip('María'),
                    _buildNameChip('Javier'),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildNameChip(String name) {
    return GestureDetector(
      onTap: () {
        _nameController.text = name;
        context.read<UserProfileBloc>().add(UpdateNameEvent(name));
        _updateContinueButton(name);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.lightTextPrimary.withAlpha((255 * 0.5).round()),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.lightTextPrimary.withAlpha((255 * 0.3).round()),
          ),
        ),
        child: Text(
          name,
          style: TextStyle(color: AppColors.lightTextPrimary, fontSize: 14),
        ),
      ),
    );
  }
}
