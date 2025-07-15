import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/location/location_service.dart';

class LocationFilterWidget extends StatefulWidget {
  final Function(double latitude, double longitude, double radius) onLocationFilterChanged;
  final double? initialLatitude;
  final double? initialLongitude;
  final double initialRadius;
  final bool enabled;

  const LocationFilterWidget({
    super.key,
    required this.onLocationFilterChanged,
    this.initialLatitude,
    this.initialLongitude,
    this.initialRadius = 10.0,
    this.enabled = true,
  });

  @override
  State<LocationFilterWidget> createState() => _LocationFilterWidgetState();
}

class _LocationFilterWidgetState extends State<LocationFilterWidget> {
  late double _radius;
  LocationData? _selectedLocation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _radius = widget.initialRadius;
    
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _selectedLocation = LocationData(
        latitude: widget.initialLatitude!,
        longitude: widget.initialLongitude!,
        timestamp: DateTime.now(),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    if (!widget.enabled) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await LocationService.instance.getCurrentLocation();
      
      result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(failure.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (position) {
          final locationData = LocationData.fromPosition(position);
          setState(() {
            _selectedLocation = locationData;
          });
          _notifyLocationChange();
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _notifyLocationChange() {
    if (_selectedLocation != null) {
      widget.onLocationFilterChanged(
        _selectedLocation!.latitude,
        _selectedLocation!.longitude,
        _radius,
      );
    }
  }

  void _clearLocation() {
    setState(() {
      _selectedLocation = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(width: 8),
                Text(
                  'Filtro por Ubicación',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (_selectedLocation != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: widget.enabled ? _clearLocation : null,
                    tooltip: 'Limpiar filtro',
                  ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Ubicación seleccionada
            if (_selectedLocation != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedLocation!.address ?? 'Ubicación seleccionada',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lat: ${_selectedLocation!.latitude.toStringAsFixed(4)}, '
                      'Lng: ${_selectedLocation!.longitude.toStringAsFixed(4)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ] else ...[
              // Botones para seleccionar ubicación
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: widget.enabled && !_isLoading ? _getCurrentLocation : null,
                      icon: _isLoading 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.my_location),
                      label: const Text('Mi ubicación'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: widget.enabled ? () {
                        // TODO: Abrir selector de ubicación en mapa
                      } : null,
                      icon: const Icon(Icons.place),
                      label: const Text('Elegir en mapa'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            
            // Selector de radio
            Text(
              'Radio de búsqueda: ${_radius.toStringAsFixed(0)} km',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            
            Slider(
              value: _radius,
              min: 1.0,
              max: 50.0,
              divisions: 49,
              label: '${_radius.toStringAsFixed(0)} km',
              onChanged: widget.enabled ? (value) {
                setState(() {
                  _radius = value;
                });
                _notifyLocationChange();
              } : null,
            ),
            
            // Opciones predefinidas de radio
            Wrap(
              spacing: 8,
              children: [1, 5, 10, 25, 50].map((km) => FilterChip(
                label: Text('${km}km'),
                selected: _radius == km.toDouble(),
                onSelected: widget.enabled ? (selected) {
                  if (selected) {
                    setState(() {
                      _radius = km.toDouble();
                    });
                    _notifyLocationChange();
                  }
                } : null,
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class RadiusSelector extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final bool enabled;

  const RadiusSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1.0,
    this.max = 50.0,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Radio: ${value.toStringAsFixed(0)} km',
          style: theme.textTheme.bodyMedium,
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          label: '${value.toStringAsFixed(0)} km',
          onChanged: enabled ? onChanged : null,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${min.toStringAsFixed(0)}km', style: theme.textTheme.bodySmall),
            Text('${max.toStringAsFixed(0)}km', style: theme.textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}
