// lib/presentation/screens/Feed_Otros_Usuarios/widgets/interests_section_widget.dart

import 'package:flutter/material.dart';
import 'interest_chip_widget.dart';

/// Widget que muestra la sección de intereses del usuario
class InterestsSectionWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final Color textPrimary;
  final Color borderColor;

  const InterestsSectionWidget({
    super.key,
    required this.userData,
    required this.textPrimary,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final List<dynamic> interests =
        userData['interests'] as List<dynamic>? ?? <dynamic>[];

    if (interests.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Intereses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: interests
                .map(
                  (final dynamic interest) =>
                      InterestChipWidget(label: interest.toString()),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
