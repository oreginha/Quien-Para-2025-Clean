// lib/presentation/widgets/search_button_widget.dart
// ignore_for_file: inference_failure_on_instance_creation, always_specify_types

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:quien_para/presentation/routes/app_router.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(final BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Usar GoRouter para navegar a la pantalla de filtros de búsqueda
        context.navigateTo(AppRouter.searchFilters);
      },
      backgroundColor: AppColors.brandYellow,
      child: const Icon(Icons.search, color: Colors.white),
    );
  }
}
