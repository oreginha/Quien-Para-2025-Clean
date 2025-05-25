// lib/presentation/screens/create_proposal/steps/date_location_step.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_constants.dart';
import '../../../bloc/plan/plan_bloc.dart';
import '../../../bloc/plan/plan_event.dart';
import '../../../bloc/plan/plan_state.dart';

class DateLocationStep extends StatefulWidget {
  final PageController pageController;

  static const List<String> argentinaCapitals = <String>[
    'Ciudad Autónoma de Buenos Aires',
    'La Plata',
    'Rosario',
    'Córdoba',
    'San Miguel de Tucumán',
    'Mendoza',
    'San Salvador de Jujuy',
    'San Fernando del Valle de Catamarca',
    'Salta',
    'La Rioja',
    'San Juan',
    'Santa Fe',
    'Santiago del Estero',
    'Paraná',
    'Corrientes',
    'Posadas',
    'Resistencia',
    'Formosa',
    'Neuquén',
    'Viedma',
    'Rawson',
    'Santa Rosa',
    'Río Gallegos',
    'Ushuaia'
  ];

  static const List<String> enabledCities = <String>[
    'Ciudad Autónoma de Buenos Aires',
    'La Plata',
    'Rosario',
    'Córdoba'
  ];

  const DateLocationStep({
    super.key,
    required this.pageController,
    final DateTime? selectedDate,
    final String? selectedCity,
    required final void Function(DateTime date) onDateSelect,
    required final void Function(String city) onCitySelect,
    required final void Function() onNext,
  });

  @override
  State<DateLocationStep> createState() => _DateLocationStepState();
}

class _DateLocationStepState extends State<DateLocationStep> {
  final LayerLink _layerLink = LayerLink();
  late TextEditingController _cityController;
  OverlayEntry? _overlayEntry;
  List<String> _filteredCities = DateLocationStep.argentinaCapitals;
  bool _showDropdown = false;
  bool _isInitialized = false;

  // Campos para manejo de fecha
  String _dateSelectionType = 'specific'; // 'specific', 'range', 'any'
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      print('DateLocationStep - initState() llamado');
    }

    _cityController = TextEditingController();
    _cityController.addListener(_onSearchChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Inicializar con datos del estado del BLoC
    if (!_isInitialized) {
      try {
        final PlanState state = context.read<PlanBloc>().state;
        if (state is PlanLoaded) {
          // Inicializar controlador de ciudad
          _cityController.text = state.plan.location;

          // Inicializar fecha de inicio
          _startDate = state.plan.date;

          // Establecer tipo de selección de fecha desde las condiciones existentes
          final String? dateSelectionType =
              state.plan.conditions['dateSelectionType'];
          if (dateSelectionType != null) {
            _dateSelectionType = dateSelectionType;
          }

          // Cargar fecha de fin si existe y estamos en modo rango
          if (_dateSelectionType == 'range' &&
              state.plan.conditions['endDate'] != null) {
            try {
              _endDate = DateTime.parse(state.plan.conditions['endDate']!);
            } catch (e) {
              if (kDebugMode) {
                print('Error al parsear fecha de fin: $e');
              }
            }
          }

          if (kDebugMode) {
            print('DateLocationStep inicializado con:');
            print('Ciudad: ${_cityController.text}');
            print('Fecha inicial: $_startDate');
            print('Fecha final: $_endDate');
            print('Tipo de selección: $_dateSelectionType');
          }
        }
        _isInitialized = true;
      } catch (e) {
        if (kDebugMode) {
          print('Error initializing DateLocationStep: $e');
          print('Stack trace: ${StackTrace.current}');
        }
      }
    }
  }

  void _onSearchChanged() {
    final String query = _cityController.text.toLowerCase();
    setState(() {
      _filteredCities = DateLocationStep.argentinaCapitals
          .where((final String city) => city.toLowerCase().contains(query))
          .toList();
    });
    _updateOverlay();
  }

  void _showSuggestions() {
    _showDropdown = true;
    _updateOverlay();
  }

  void _hideSuggestions() {
    _showDropdown = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _updateOverlay() {
    _overlayEntry?.remove();
    if (!_showDropdown) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (final BuildContext context) => Positioned(
        width: size.width - 40, // Ajustar según el padding
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60),
          child: Material(
            elevation: Theme.of(context).cardTheme.elevation ?? 8,
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.l),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.3,
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _filteredCities.length,
                itemBuilder: (final BuildContext context, final int index) {
                  final String city = _filteredCities[index];
                  final bool isEnabled =
                      DateLocationStep.enabledCities.contains(city);
                  return ListTile(
                    title: Text(
                      city,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: isEnabled ? 0.9 : 0.5),
                            fontWeight:
                                isEnabled ? FontWeight.bold : FontWeight.normal,
                          ),
                    ),
                    trailing: isEnabled
                        ? null
                        : const Icon(Icons.lock, color: Colors.grey),
                    onTap: () {
                      if (isEnabled) {
                        _cityController.text = city;

                        // Actualizar la ubicación en el BLoC inmediatamente
                        if (kDebugMode) {
                          print('Actualizando ubicación: $city');
                        }

                        context.read<PlanBloc>().add(
                              PlanEvent.updateField(
                                field: 'location',
                                value: city,
                              ),
                            );
                        _hideSuggestions();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('La ciudad $city aún no está disponible'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildDateTypeOption(
      final String label, final String value, final bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _dateSelectionType = value;

            // Actualizar condiciones en el BLoC según el tipo seleccionado
            final PlanState state = context.read<PlanBloc>().state;
            if (state is PlanLoaded) {
              final Map<String, String> updatedConditions =
                  Map<String, String>.from(state.plan.conditions);
              updatedConditions['dateSelectionType'] = value;

              // Si cambiamos a "any", limpiamos la fecha
              if (value == 'any') {
                context.read<PlanBloc>().add(
                      const PlanEvent.updateField(field: 'date', value: null),
                    );
              }

              // Log para debug
              if (kDebugMode) {
                print('Cambiando tipo de fecha a: $value');
                print('Condiciones actualizadas: $updatedConditions');
              }

              context
                  .read<PlanBloc>()
                  .add(PlanEvent.updateSelectedOptions(updatedConditions));
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.brandYellow.withValues(alpha: 0.15)
                : AppColors.lightBackground.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppRadius.l),
            border: Border.all(
              color: isSelected ? AppColors.brandYellow : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withAlpha(230), // 0.9 * 255
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecificDateSelector(
      final BuildContext context, final PlanState state) {
    final PlanEntity? plan = state is PlanLoaded ? state.plan : null;

    return GestureDetector(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (final BuildContext context, final Widget? pickerChild) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: Colors.yellow,
                  onPrimary: Colors.black,
                  surface: Colors.grey,
                  onSurface: Colors.white,
                ),
              ),
              child: pickerChild!,
            );
          },
        );

        if (pickedDate != null && mounted) {
          setState(() {
            _startDate = pickedDate;
          });

          if (kDebugMode) {
            print('Fecha seleccionada: $pickedDate');
          }

          // Actualizar fecha en el BLoC
          if (mounted) {
            context.read<PlanBloc>().add(
                  PlanEvent.updateField(field: 'date', value: pickedDate),
                );
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .primary
              .withAlpha((0.15 * 255).toInt()),
          borderRadius: BorderRadius.circular(AppRadius.l),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.calendar_today,
              color: Colors.white.withAlpha(179), // 0.7 * 255
            ),
            const SizedBox(width: 12),
            Text(
              plan?.date != null
                  ? '${plan!.date!.day}/${plan.date!.month}/${plan.date!.year}'
                  : 'Seleccionar fecha',
              style: TextStyle(
                color: Colors.white.withAlpha(230), // 0.9 * 255
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              builder: (final BuildContext context, final Widget? pickerChild) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: Colors.yellow,
                      onPrimary: Colors.black,
                      surface: Colors.grey,
                      onSurface: Colors.white,
                    ),
                  ),
                  child: pickerChild!,
                );
              },
            );

            if (pickedDate != null && mounted) {
              setState(() {
                _startDate = pickedDate;
              });

              // Actualizar el BLoC con la fecha de inicio
              if (mounted) {
                // Primero actualizar el campo principal de fecha
                context.read<PlanBloc>().add(
                      PlanEvent.updateField(field: 'date', value: pickedDate),
                    );

                // Luego actualizar las condiciones con el tipo y la fecha de inicio
                final PlanState state = context.read<PlanBloc>().state;
                if (state is PlanLoaded) {
                  final Map<String, String> updatedConditions =
                      Map<String, String>.from(state.plan.conditions);
                  updatedConditions['dateSelectionType'] = 'range';
                  updatedConditions['startDate'] = pickedDate.toIso8601String();

                  if (kDebugMode) {
                    print('Actualizando fecha de inicio: $pickedDate');
                    print('Condiciones actualizadas: $updatedConditions');
                  }

                  context
                      .read<PlanBloc>()
                      .add(PlanEvent.updateSelectedOptions(updatedConditions));
                }
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withAlpha((0.15 * 255).toInt()),
              borderRadius: BorderRadius.circular(AppRadius.l),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.calendar_today,
                  color: Colors.white.withAlpha(179), // 0.7 * 255
                ),
                const SizedBox(width: 12),
                Text(
                  _startDate != null
                      ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                      : 'Fecha inicio',
                  style: TextStyle(
                    color: Colors.white.withAlpha(230), // 0.9 * 255
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            if (_startDate == null) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Primero selecciona la fecha de inicio'),
                    backgroundColor: AppColors
                        .warning, // Reemplazado color directo por color del tema
                  ),
                );
              }
              return;
            }

            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: _startDate!.add(const Duration(days: 1)),
              firstDate: _startDate!.add(const Duration(days: 1)),
              lastDate: _startDate!.add(const Duration(days: 30)),
              builder: (final BuildContext context, final Widget? pickerChild) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: Colors.yellow,
                      onPrimary: Colors.black,
                      surface: Colors.grey,
                      onSurface: Colors.white,
                    ),
                  ),
                  child: pickerChild!,
                );
              },
            );

            if (pickedDate != null && mounted) {
              setState(() {
                _endDate = pickedDate;
              });

              // Guardar la fecha final en condiciones
              if (mounted) {
                final PlanState state = context.read<PlanBloc>().state;
                if (state is PlanLoaded) {
                  final Map<String, String> updatedConditions =
                      Map<String, String>.from(state.plan.conditions);
                  updatedConditions['endDate'] = pickedDate.toIso8601String();

                  if (kDebugMode) {
                    print('Actualizando fecha de fin: $pickedDate');
                    print('Condiciones actualizadas: $updatedConditions');
                  }

                  context
                      .read<PlanBloc>()
                      .add(PlanEvent.updateSelectedOptions(updatedConditions));
                }
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withAlpha((0.15 * 255).toInt()),
              borderRadius: BorderRadius.circular(AppRadius.l),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.calendar_today,
                  color: Colors.white.withAlpha(179), // 0.7 * 255
                ),
                const SizedBox(width: 12),
                Text(
                  _endDate != null
                      ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                      : 'Fecha fin',
                  style: TextStyle(
                    color: Colors.white.withAlpha(230), // 0.9 * 255
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnyDateIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.yellow.withAlpha(38), // 0.15 * 255
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.yellow,
          width: 2,
        ),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.check_circle,
            color: Colors.yellow.withAlpha(179), // 0.7 * 255
          ),
          const SizedBox(width: 12),
          Text(
            'Fecha abierta - cualquier día',
            style: TextStyle(
              color: Colors.white.withAlpha(230), // 0.9 * 255
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  bool _isFormValid(final PlanState state) {
    if (state is! PlanLoaded) return false;

    final PlanEntity plan = state.plan;

    // Verificar validez del formulario según el tipo de fecha
    bool dateValid = false;

    if (_dateSelectionType == 'specific') {
      dateValid = plan.date != null;
    } else if (_dateSelectionType == 'range') {
      dateValid = _startDate != null && _endDate != null;
    } else if (_dateSelectionType == 'any') {
      dateValid = true; // Siempre válido para tipo "cualquier día"
    }

    // También verificamos que haya una ciudad seleccionada
    final bool locationValid = _cityController.text.trim().isNotEmpty;

    if (kDebugMode) {
      print('Validando formulario:');
      print('- Tipo de fecha: $_dateSelectionType');
      print('- Fecha válida: $dateValid');
      print('- Ubicación válida: $locationValid');
      print('- Fecha inicio: $_startDate');
      print('- Fecha fin: $_endDate');
      print('- Ciudad: ${_cityController.text}');
    }

    return dateValid && locationValid;
  }

  @override
  void dispose() {
    _cityController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<PlanBloc, PlanState>(
      builder: (final BuildContext context, final PlanState state) {
        if (state is! PlanLoaded) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
            ),
          );
        }

        // Actualizar _cityController si el estado tiene un valor diferente
        // y el controlador no tiene foco (para evitar interferir con la edición)
        if (!_cityController.text.contains(state.plan.location) &&
            !FocusScope.of(context).hasFocus) {
          _cityController.text = state.plan.location;
        }

        return GestureDetector(
          onTap: _hideSuggestions,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surface,
                ],
              ),
            ),
            child: LayoutBuilder(
              builder: (final BuildContext context,
                  final BoxConstraints constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 24),
                            // Selector de Tipo de Fecha
                            Text(
                              'Tipo de Fecha',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.9),
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: <Widget>[
                                _buildDateTypeOption(
                                    'Fecha Específica',
                                    'specific',
                                    _dateSelectionType == 'specific'),
                                const SizedBox(width: 8),
                                _buildDateTypeOption('Rango de Fechas', 'range',
                                    _dateSelectionType == 'range'),
                                const SizedBox(width: 8),
                                _buildDateTypeOption('Cualquier Día', 'any',
                                    _dateSelectionType == 'any'),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Widget condicional según el tipo de fecha
                            if (_dateSelectionType == 'specific')
                              _buildSpecificDateSelector(context, state),
                            if (_dateSelectionType == 'range')
                              _buildDateRangeSelector(context),
                            if (_dateSelectionType == 'any')
                              _buildAnyDateIndicator(),

                            const SizedBox(height: 24),
                            Text(
                              'Ciudad',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.9),
                                  ),
                            ),
                            const SizedBox(height: 8),
                            CompositedTransformTarget(
                              link: _layerLink,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color:
                                      Colors.white.withAlpha(26), // 0.1 * 255
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _cityController.text.isNotEmpty
                                        ? Colors.yellow
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: TextField(
                                  controller: _cityController,
                                  style: TextStyle(
                                      color: Colors.white
                                          .withAlpha(230)), // 0.9 * 255
                                  decoration: InputDecoration(
                                    hintText: 'Buscar ciudad...',
                                    hintStyle: TextStyle(
                                        color: Colors.white
                                            .withAlpha(128)), // 0.5 * 255
                                    border: InputBorder.none,
                                    icon: Icon(
                                      Icons.location_on,
                                      color: Colors.white
                                          .withAlpha(179), // 0.7 * 255
                                    ),
                                  ),
                                  onTap: _showSuggestions,
                                  onChanged: (final String value) {
                                    // Actualizar el valor en el BLoC con cada cambio
                                    context.read<PlanBloc>().add(
                                          PlanEvent.updateField(
                                            field: 'location',
                                            value: value,
                                          ),
                                        );
                                  },
                                ),
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isFormValid(state)
                                    ? () {
                                        if (kDebugMode) {
                                          print(
                                              'Continuando al siguiente paso con:');
                                          print(
                                              'Ciudad: ${_cityController.text}');
                                          print(
                                              'Tipo de fecha: $_dateSelectionType');
                                          print('Fecha inicio: $_startDate');
                                          if (_dateSelectionType == 'range') {
                                            print('Fecha fin: $_endDate');
                                          }
                                        }
                                        widget.pageController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors
                                      .brandYellow, // Reemplazado Colors.yellow por color del tema
                                  foregroundColor: AppColors
                                      .lightTextPrimary, // Reemplazado Colors.black por color del tema
                                  disabledBackgroundColor: AppColors
                                      .darkTextSecondary, // Reemplazado Colors.grey[800] por color del tema
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
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
