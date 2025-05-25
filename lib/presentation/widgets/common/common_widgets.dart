// ignore_for_file: prefer_final_parameters, inference_failure_on_function_return_type, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';

import 'package:quien_para/core/theme/theme_utils.dart';
// Las importaciones no utilizadas se han eliminado
import 'package:quien_para/presentation/widgets/common/buttons/app_buttons.dart';

import '../../bloc/search/search_filters_bloc.dart';
import '../../bloc/search/search_filters_event.dart';

final List<Map<String, dynamic>> steps = <Map<String, dynamic>>[
  <String, dynamic>{
    'icon': '👋',
    'title': 'Bienvenido',
    'subtitle': 'Empecemos con tu nombre'
  },
  <String, dynamic>{
    'icon': '🎂',
    'title': 'Tu edad',
    'subtitle': 'Necesitamos saber que sos mayor de edad'
  },
  <String, dynamic>{
    'icon': '👤',
    'title': 'Género',
    'subtitle': 'Ayudanos a conocerte mejor'
  },
  <String, dynamic>{
    'icon': '📍',
    'title': 'Ubicación',
    'subtitle': 'Para mostrarte planes cercanos'
  },
  <String, dynamic>{
    'icon': '📸',
    'title': 'Fotos',
    'subtitle': 'Muestra tu mejor versión'
  },
  <String, dynamic>{
    'icon': '❤️',
    'title': 'Intereses',
    'subtitle': 'Qué tipo de planes te gustan'
  },
  <String, dynamic>{
    'icon': '✨',
    'title': 'Listo',
    'subtitle': 'Revisá tu perfil antes de continuar'
  },
];

class CommonWidgets {
  /// Widget para construir tarjetas expansibles
  static Widget buildCard({required String title, required Widget content}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF4A5F78), // Color gris azulado para las cards
        borderRadius: BorderRadius.circular(AppRadius.m),
        // ignore: always_specify_types
        boxShadow: [
          BoxShadow(
            color: AppColors.getCardBackground(false)
                .withAlpha((0.2 * 255).round()),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: AppColors.lightTextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        iconColor: AppColors.lightTextPrimary,
        collapsedIconColor: AppColors.lightTextPrimary,
        initiallyExpanded: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: content,
          ),
        ],
      ),
    );
  }

  /// Widget para crear campos de texto personalizados
  static Widget buildTextFormField({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
    String? hintText,
    bool isPassword = false,
    String? Function(String?)? validator,
    Widget? prefixIcon,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.lightTextPrimary.withAlpha((0.5 * 255).round()),
        ),
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide(
            color: AppColors.lightBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide(
            color: AppColors.lightBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide(
            color: AppColors.lightTextPrimary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: AppColors.lightBackground.withAlpha((0.3 * 255).round()),
      ),
      style: TextStyle(
        color: AppColors.lightTextPrimary,
      ),
      onChanged: onChanged,
    );
  }

  /// Widget específico para campo de búsqueda
  static Widget buildSearchField({
    required BuildContext context,
    required String searchQuery,
    String hintText = 'Buscar...',
  }) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.lightTextPrimary.withAlpha((0.5 * 255).round()),
        ),
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.lightTextPrimary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide(
            color: AppColors.lightBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide(
            color: AppColors.lightBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide(
            color: AppColors.lightTextPrimary,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: AppColors.lightBackground.withAlpha((0.3 * 255).round()),
      ),
      style: TextStyle(
        color: AppColors.lightTextPrimary,
      ),
      onChanged: (String value) {
        context.read<SearchFiltersBloc>().add(
              SearchFiltersEvent.updateSearchQuery(value),
            );
      },
      controller: TextEditingController(text: searchQuery),
    );
  }

  static Widget buildLabeledSlider({
    required BuildContext context,
    required double value,
    required double min,
    required double max,
    // ignore: inference_failure_on_function_return_type
    required final Function(double) onChanged,
    int divisions = 20,
    String prefix = '+',
    String suffix = 'KM',
    String maxLabel = 'Max: ',
    Color? thumbColor,
    Color? activeTrackColor,
    Color? inactiveTrackColor,
    Color? overlayColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '$prefix${value.round()} $suffix',
              style: AppTypography.bodyMedium(false),
            ),
            Text(
              '$maxLabel${max.round()} $suffix',
              style: AppTypography.bodyMedium(false),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 8,
            thumbColor: thumbColor ?? AppColors.lightTextPrimary,
            activeTrackColor: activeTrackColor ?? AppColors.brandYellow,
            inactiveTrackColor: inactiveTrackColor ??
                Colors.white.withAlpha((0.3 * 255).round()),
            overlayColor: overlayColor ??
                AppColors.lightTextPrimary.withAlpha((0.2 * 255).round()),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  /// Widget para construir botones de acción
  static Widget buildActionButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
    String? colorType,
    Color? darkPrimaryBackground,
    Color? textColor,
    bool enabled = true,
  }) {
    // Determinar colores basados en el tipo
    Color bgColor;
    Color fgColor;

    if (colorType == 'rojo' || colorType == 'danger') {
      bgColor = AppColors.success;
      fgColor = Colors.white;
    } else if (colorType == 'Azul' || colorType == 'primary') {
      bgColor = AppColors.lightTextPrimary;
      fgColor = AppColors.lightTextPrimary;
    } else if (colorType == 'amarillo' || colorType == null) {
      bgColor = AppColors.lightTextPrimary;
      fgColor = AppColors.lightTextPrimary;
    } else {
      // Colores por defecto
      bgColor = AppColors.lightTextPrimary;
      fgColor = AppColors.lightTextPrimary;
    }

    // Permitir sobrescribir los colores determinados por tipo
    bgColor = darkPrimaryBackground ?? bgColor;
    fgColor = textColor ?? fgColor;

    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        disabledBackgroundColor: bgColor.withAlpha((0.6 * 255).round()),
        disabledForegroundColor: fgColor.withAlpha((0.6 * 255).round()),
        textStyle: AppTypography.bodyMedium(false),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
        elevation: 2,
      ),
      child: Text(
        label,
        style: AppTypography.bodyMedium(false).copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: textColor ?? AppColors.lightTextPrimary,
        ),
      ),
    );
  }

  static Widget buildCustomCheckboxTile({
    required String title,
    required bool value,
    required Function(bool?) onChanged,
    Color? activeColor,
    Color? checkColor,
    ListTileControlAffinity controlAffinity = ListTileControlAffinity.leading,
    EdgeInsetsGeometry? contentPadding,
    bool dense = true,
    TextStyle? titleStyle,
    Widget? subtitle,
    bool enabled = true,
  }) {
    return CheckboxListTile(
      title: Text(title, style: titleStyle ?? AppTypography.bodyMedium(false)),
      value: value,
      activeColor: activeColor ?? AppColors.lightTextPrimary,
      checkColor: checkColor ?? AppColors.lightTextPrimary,
      controlAffinity: controlAffinity,
      contentPadding: contentPadding ?? EdgeInsets.zero,
      dense: dense,
      enabled: enabled,
      subtitle: subtitle,
      onChanged: enabled ? onChanged : null,
    );
  }

  static Widget buildHeader(int step) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color:
            AppColors.getCardBackground(false).withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(AppRadius.l),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          Text(
            steps[step]['icon'] as String,
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 16),
          Text(
            steps[step]['title'] as String,
            style: AppTypography.bodyMedium(false).copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.lightTextPrimary,
            ),
          ),
          Text(
            steps[step]['subtitle'] as String,
            style: AppTypography.appBarTitle(false).copyWith(
              color: ThemeUtils.lightSecondaryBackground,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildProgressBar(int step) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      height: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
          value: (step + 1) / steps.length,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandYellow),
        ),
      ),
    );
  }
}

class StyledInputContainer extends StatelessWidget {
  final Widget child;

  const StyledInputContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // ignore: always_specify_types
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: child,
    );
  }
}

class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool isEnabled;
  final double? width;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onPressed: onPressed,
      text: text,
      isLoading: isLoading,
      disabled: !isEnabled,
      fullWidth: width !=
          null, // Si se especificó un ancho, asumimos que quiere ocupar todo el espacio disponible
      style: AppButtonStyle.primary, // Estilo por defecto
    );
  }
}
