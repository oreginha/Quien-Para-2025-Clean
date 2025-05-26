// lib/presentation/screens/user_onboarding/steps/age_input_step.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/core/theme/app_colors.dart';

import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/presentation/widgets/common/buttons/app_buttons.dart';
import 'package:quien_para/presentation/widgets/common/buttons/onboarding_button.dart';
import 'package:quien_para/presentation/widgets/responsive_onboarding_container.dart';
import 'package:quien_para/presentation/widgets/utils/styled_input.dart';

import '../../../bloc/profile/user_profile_bloc.dart';

class AgeInputStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const AgeInputStep({super.key, required this.onNext, required this.onBack});

  @override
  State<AgeInputStep> createState() => _AgeInputStepState();
}

class _AgeInputStepState extends State<AgeInputStep> {
  final TextEditingController _ageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _canContinue = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final state = context.read<UserProfileBloc>().state;
    _ageController.text = state.age?.toString() ?? '';
    _updateContinueButton(_ageController.text);
  }

  @override
  void dispose() {
    _ageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateContinueButton(String value) {
    final int? age = int.tryParse(value);
    setState(() {
      if (value.isEmpty) {
        _errorText = 'Por favor, ingresa tu edad';
        _canContinue = false;
      } else if (age == null) {
        _errorText = 'Por favor, ingresa un número válido';
        _canContinue = false;
      } else if (age < 18) {
        _errorText = 'Debes ser mayor de 18 años para continuar';
        _canContinue = false;
      } else if (age > 100) {
        _errorText = 'Por favor, ingresa una edad válida';
        _canContinue = false;
      } else {
        _errorText = null;
        _canContinue = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            children: [AppBackButton(onPressed: widget.onBack)],
          ),
          const SizedBox(height: 20),

          StyledInput(
            labelText: 'Edad',
            hintText: 'Ingresa tu edad',
            controller: _ageController,
            keyboardType: TextInputType.number,
            errorText: _errorText,
            focusNode: _focusNode,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            prefixIcon: Icon(
              Icons.calendar_today_outlined,
              color: _focusNode.hasFocus
                  ? AppColors.brandYellow
                  : AppColors.lightTextPrimary.withAlpha((255 * 0.7).round()),
            ),
            suffixIcon: _ageController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _ageController.clear();
                      _updateContinueButton('');
                      context.read<UserProfileBloc>().add(UpdateAgeEvent(0));
                    },
                  )
                : null,
            onChanged: (final String value) {
              context.read<UserProfileBloc>().add(
                UpdateAgeEvent(int.tryParse(value) ?? 0),
              );
              _updateContinueButton(value);
            },
            textInputAction: TextInputAction.done,
          ),

          const SizedBox(height: 24),

          // Age range selector for better UX
          Text(
            'Selecciona un rango de edad:',
            style: AppTypography.heading2(false).copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.lightTextPrimary.withAlpha((255 * 0.9).round()),
            ),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildAgeRangeButton('18-25', 21),
              _buildAgeRangeButton('26-35', 30),
              _buildAgeRangeButton('36-45', 40),
              _buildAgeRangeButton('46-55', 50),
              _buildAgeRangeButton('56-65', 60),
              _buildAgeRangeButton('66+', 70),
            ],
          ),

          const SizedBox(height: 24),

          // Información importante
          if (_errorText != null && _errorText!.contains('18 años'))
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.getCardBackground(
                  false,
                ).withAlpha((255 * 0.1).round()),
                borderRadius: BorderRadius.circular(AppRadius.button),
                border: Border.all(
                  color: AppColors.getBorder(
                    false,
                  ).withAlpha((255 * 0.3).round()),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.brandYellow,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Esta aplicación es solo para mayores de edad. Debes tener al menos 18 años para crear un perfil.',
                      style: TextStyle(
                        color: AppColors.brandYellow.withAlpha(
                          (255 * 0.9).round(),
                        ),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightTextPrimary.withAlpha(
                  (255 * 0.1).round(),
                ),
                borderRadius: BorderRadius.circular(AppRadius.button),
                border: Border.all(
                  color: AppColors.lightTextPrimary.withAlpha(
                    (255 * 0.3).round(),
                  ),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.brandYellow,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tu edad nos ayuda a mostrarte planes acordes a tu grupo etario y asegurar que cumples con los requisitos legales.',
                      style: TextStyle(
                        color: AppColors.lightTextPrimary.withAlpha(
                          (255 * 0.8).round(),
                        ),
                        fontSize: 14,
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

  Widget _buildAgeRangeButton(String label, int midValue) {
    final bool isSelected = int.tryParse(_ageController.text) == midValue;

    return GestureDetector(
      onTap: () {
        _ageController.text = midValue.toString();
        context.read<UserProfileBloc>().add(UpdateAgeEvent(midValue));
        _updateContinueButton(midValue.toString());
        // Ocultar teclado si está visible
        FocusScope.of(context).unfocus();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.getCardBackground(
                  false,
                ).withAlpha((255 * 0.2).round())
              : AppColors.getCardBackground(false),
          borderRadius: BorderRadius.circular(AppRadius.button),
          border: Border.all(
            color: isSelected
                ? AppColors.brandYellow
                : AppColors.getBorder(false),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? AppColors.brandYellow
                : AppColors.lightTextPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
