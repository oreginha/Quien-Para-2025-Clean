// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class CustomCheckboxGroup extends StatefulWidget {
  final List<String> options;
  final ValueChanged<List<String>> onSelectionChanged;

  const CustomCheckboxGroup({
    super.key,
    required this.options,
    required this.onSelectionChanged,
  });

  @override
  _CustomCheckboxGroupState createState() => _CustomCheckboxGroupState();
}

class _CustomCheckboxGroupState extends State<CustomCheckboxGroup> {
  final List<String> _selectedOptions = <String>[];

  void _toggleSelection(final String option) {
    setState(() {
      if (_selectedOptions.contains(option)) {
        _selectedOptions.remove(option);
      } else {
        _selectedOptions.add(option);
      }
    });
    widget.onSelectionChanged(_selectedOptions);
  }

  @override
  Widget build(final BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: widget.options.map((final String option) {
        final bool isSelected = _selectedOptions.contains(option);
        return ChoiceChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (final _) => _toggleSelection(option),
          selectedColor: AppColors.brandYellow,
          backgroundColor: AppColors.darkSecondaryBackground,
          labelStyle: AppTypography.bodyMedium(true).copyWith(
            color: isSelected ? AppColors.brandYellow : Colors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? AppColors.brandYellow : Colors.white24,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        );
      }).toList(),
    );
  }
}
