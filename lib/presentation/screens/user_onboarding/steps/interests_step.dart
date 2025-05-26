//lib/presentation/screens/user_onboarding/steps/interests_step.dart
// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/presentation/widgets/common/common_widgets.dart';

import '../../../bloc/profile/user_profile_bloc.dart';

class InterestsStep extends StatefulWidget {
  final VoidCallback onComplete;

  const InterestsStep({super.key, required this.onComplete});

  @override
  State<InterestsStep> createState() => _InterestsStepState();
}

class _InterestsStepState extends State<InterestsStep> {
  final List<String> interests = <String>[
    'Música',
    'Cine',
    'Deportes',
    'Arte',
    'Gastronomía',
    'Naturaleza',
    'Viajes',
    'Tecnología',
    'Fiestas',
    'Cultura',
  ];

  Set<String> selectedInterests = <String>{};
  bool _canContinue = false;

  @override
  void initState() {
    super.initState();
    // Get initial interests from state
    final List<String> userInterests = context
        .read<UserProfileBloc>()
        .state
        .interests;
    selectedInterests = Set.from(userInterests);
    _updateContinueButton();
  }

  void _updateContinueButton() {
    setState(() {
      _canContinue = selectedInterests.isNotEmpty;
    });
  }

  void _toggleInterest(final String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });

    // Update the bloc
    context.read<UserProfileBloc>().add(
      UpdateInterestsEvent(selectedInterests.toList()),
    );

    _updateContinueButton();
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Selecciona tus intereses',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: interests.map((final String interest) {
                final bool isSelected = selectedInterests.contains(interest);
                return GestureDetector(
                  onTap: () => _toggleInterest(interest),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.lightCardBackground.withValues(alpha: 0.2)
                          : AppColors.lightCardBackground,
                      borderRadius: BorderRadius.circular(AppRadius.button),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.brandYellow
                            : Colors.grey.withAlpha((0.3 * 255).round()),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withAlpha((0.05 * 255).round()),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          interest,
                          style: TextStyle(
                            color: isSelected ? Colors.black87 : Colors.black54,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        if (isSelected) ...<Widget>[
                          const SizedBox(width: 6),
                          Icon(
                            Icons.check,
                            size: 16,
                            color: AppColors.brandYellow,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Center(
            child: SizedBox(
              width: 250,
              child: StyledButton(
                onPressed: _canContinue ? widget.onComplete : null,
                text: 'Continuar',
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
