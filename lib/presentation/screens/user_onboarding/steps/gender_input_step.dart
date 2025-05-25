// lib/presentation/screens/user_onboarding/steps/gender_input_step.dart
// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/presentation/widgets/common/buttons/app_buttons.dart';

import '../../../bloc/profile/user_profile_bloc.dart';

class GenderInputStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const GenderInputStep({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<GenderInputStep> createState() => _GenderInputStepState();
}

class _GenderInputStepState extends State<GenderInputStep> {
  String? _selectedGender;
  bool _canContinue = false;

  @override
  void initState() {
    super.initState();
    _selectedGender = context.read<UserProfileBloc>().state.gender;
    _updateContinueButton();
  }

  void _updateContinueButton() {
    setState(() {
      _canContinue = _selectedGender != null;
    });
  }

  void _selectGender(final String gender) {
    setState(() {
      _selectedGender = gender;
    });
    context.read<UserProfileBloc>().add(UpdateGenderEvent(gender));
    _updateContinueButton();
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              AppBackButton(
                onPressed: widget.onBack,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              _buildGenderOption('Hombre', Icons.male),
              const SizedBox(height: 16),
              _buildGenderOption('Mujer', Icons.female),
              const SizedBox(height: 20),
              AppButton(
                onPressed: _canContinue ? widget.onNext : null,
                text: 'Continuar',
                disabled: !_canContinue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenderOption(final String gender, final IconData icon) {
    final bool isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () => _selectGender(gender),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandYellow : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.brandYellow
                : Colors.grey.withAlpha((0.3 * 255).round()),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              gender,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
