// lib/presentation/screens/user_onboarding/steps/location_input_step.dart
// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_theme.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/presentation/widgets/common/buttons/app_buttons.dart';
import 'package:quien_para/presentation/widgets/common/buttons/onboarding_button.dart';
import 'package:quien_para/presentation/widgets/responsive_onboarding_container.dart';
import 'package:quien_para/presentation/widgets/utils/styled_input.dart';

import '../../../bloc/profile/user_profile_bloc.dart';

class LocationInputStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const LocationInputStep({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<LocationInputStep> createState() => _LocationInputStepState();
}

class _LocationInputStepState extends State<LocationInputStep> {
  final TextEditingController _locationController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _canContinue = false;
  bool _isUsingCurrentLocation = false;
  bool _isLoadingLocation = false;
  String? _errorText;

  // Lista de ciudades populares para sugerencias
  final List<String> _popularLocations = [
    'Buenos Aires',
    'Córdoba',
    'Rosario',
    'Mendoza',
    'La Plata',
    'San Miguel de Tucumán',
    'Mar del Plata',
    'Salta',
  ];

  @override
  void initState() {
    super.initState();
    final String? initialLocation =
        context.read<UserProfileBloc>().state.location;
    _locationController.text = initialLocation ?? '';
    _updateContinueButton(_locationController.text);
  }

  @override
  void dispose() {
    _locationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateContinueButton(final String value) {
    final String trimmedValue = value.trim();
    setState(() {
      if (trimmedValue.isEmpty) {
        _canContinue = false;
        _errorText = 'Por favor, ingresa tu ubicación';
      } else if (trimmedValue.length < 3) {
        _canContinue = false;
        _errorText = 'El nombre de la ubicación es muy corto';
      } else {
        _canContinue = true;
        _errorText = null;
      }
    });
  }

  Future<void> _getCurrentLocation() async {
    // Ocultar teclado si está visible
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoadingLocation = true;
      _errorText = null;
    });

    // Simular obtención de ubicación
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _locationController.text = 'Buenos Aires';
        _isUsingCurrentLocation = true;
        _isLoadingLocation = false;
      });

      // Actualizar en el bloc
      context.read<UserProfileBloc>().add(
            UpdateLocationEvent(_locationController.text),
          );
      _updateContinueButton(_locationController.text);
    }
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
              AppBackButton(
                onPressed: widget.onBack,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Contenedor de ubicación actual con animación
          GestureDetector(
            onTap: _isLoadingLocation ? null : _getCurrentLocation,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: _isUsingCurrentLocation
                    ? AppColors.getCardBackground(false)
                        .withAlpha((255 * 0.15).round())
                    : AppColors.getCardBackground(false)
                        .withAlpha((255 * 0.5).round()),
                borderRadius: BorderRadius.circular(AppRadius.button),
                border: Border.all(
                  color: _isUsingCurrentLocation
                      ? AppColors.getBorder(false)
                      : AppColors.getBorder(false)
                          .withAlpha((255 * 0.3).round()),
                  width: _isUsingCurrentLocation ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  _isLoadingLocation
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.getBorder(false),
                            ),
                          ),
                        )
                      : Icon(
                          Icons.my_location,
                          color: _isUsingCurrentLocation
                              ? AppColors.getBorder(false)
                              : AppColors.lightTextPrimary
                                  .withAlpha((255 * 0.7).round()),
                        ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _isLoadingLocation
                          ? 'Obteniendo ubicación...'
                          : 'Usar mi ubicación actual',
                      style: TextStyle(
                        fontWeight: _isUsingCurrentLocation
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: _isUsingCurrentLocation
                            ? AppColors.getBorder(false)
                            : AppColors.lightTextPrimary,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  if (_isUsingCurrentLocation)
                    Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          Text(
            'O ingresa tu ubicación manualmente:',
            style: TextStyle(
              color: AppColors.lightTextPrimary.withAlpha((255 * 0.9).round()),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          StyledInput(
            labelText: '',
            hintText: 'Ingresa tu ciudad',
            controller: _locationController,
            errorText: _errorText,
            focusNode: _focusNode,
            prefixIcon: Icon(
              Icons.location_on_outlined,
              color: _focusNode.hasFocus
                  ? AppColors.getBorder(false)
                  : AppColors.lightTextPrimary.withAlpha((255 * 0.7).round()),
            ),
            onChanged: (final String value) {
              context.read<UserProfileBloc>().add(UpdateLocationEvent(value));
              _updateContinueButton(value);
              setState(() {
                _isUsingCurrentLocation = false;
              });
            },
            textInputAction: TextInputAction.done,
          ),

          const SizedBox(height: 24),
          Text(
            'Ubicaciones populares:',
            style: TextStyle(
              color: AppColors.lightTextPrimary.withAlpha((255 * 0.9).round()),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _popularLocations.map((location) {
              final bool isSelected = _locationController.text == location;

              return GestureDetector(
                onTap: () {
                  // Ocultar teclado si está visible
                  FocusScope.of(context).unfocus();

                  setState(() {
                    _locationController.text = location;
                    _isUsingCurrentLocation = false;
                    _errorText = null;
                  });
                  context.read<UserProfileBloc>().add(
                        UpdateLocationEvent(location),
                      );
                  _updateContinueButton(location);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.getBorder(false)
                        : AppColors.lightTextPrimary
                            .withAlpha((255 * 0.5).round()),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.getBorder(false)
                          : AppColors.getBorder(false)
                              .withAlpha((255 * 0.3).round()),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    location,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.lightTextPrimary
                          : AppColors.lightTextPrimary,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.getCardBackground(false)
                  .withAlpha((255 * 0.1).round()),
              borderRadius: BorderRadius.circular(AppRadius.button),
              border: Border.all(
                color:
                    AppColors.getBorder(false).withAlpha((255 * 0.3).round()),
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
                    'Tu ubicación nos ayuda a mostrarte planes y personas cercanas a ti. También puedes cambiarla más adelante.',
                    style: TextStyle(
                      color: AppColors.lightTextPrimary
                          .withAlpha((255 * 0.8).round()),
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
}
