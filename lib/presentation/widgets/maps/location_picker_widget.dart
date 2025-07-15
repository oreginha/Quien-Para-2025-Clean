import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/location/location_service.dart';
import 'package:geolocator/geolocator.dart';

class LocationPickerWidget extends StatefulWidget {
  final Function(LocationData) onLocationSelected;
  final LocationData? initialLocation;
  final String? placeholder;
  final bool enabled;

  const LocationPickerWidget({
    super.key,
    required this.onLocationSelected,
    this.initialLocation,
    this.placeholder,
    this.enabled = true,
  });

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  LocationData? _selectedLocation;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation;
      _controller.text = widget.initialLocation!.address ?? 
          '${widget.initialLocation!.latitude.toStringAsFixed(4)}, ${widget.initialLocation!.longitude.toStringAsFixed(4)}';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            _controller.text = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
          });
          widget.onLocationSelected(locationData);
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

  void _showLocationPicker() {
    if (!widget.enabled) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => LocationPickerBottomSheet(
        onLocationSelected: (location) {
          setState(() {
            _selectedLocation = location;
            _controller.text = location.address ?? 
                '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}';
          });
          widget.onLocationSelected(location);
          Navigator.of(context).pop();
        },
        initialLocation: _selectedLocation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          enabled: widget.enabled,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Ubicación',
            hintText: widget.placeholder ?? 'Seleccionar ubicación',
            suffixIcon: _isLoading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.my_location),
                        onPressed: _getCurrentLocation,
                        tooltip: 'Usar ubicación actual',
                      ),
                      IconButton(
                        icon: const Icon(Icons.place),
                        onPressed: _showLocationPicker,
                        tooltip: 'Seleccionar en mapa',
                      ),
                    ],
                  ),
            border: const OutlineInputBorder(),
          ),
          onTap: widget.enabled ? _showLocationPicker : null,
        ),
        if (_selectedLocation != null) ...[
          const SizedBox(height: 8),
          Text(
            'Lat: ${_selectedLocation!.latitude.toStringAsFixed(6)}, '
            'Lng: ${_selectedLocation!.longitude.toStringAsFixed(6)}',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}

class LocationPickerBottomSheet extends StatefulWidget {
  final Function(LocationData) onLocationSelected;
  final LocationData? initialLocation;

  const LocationPickerBottomSheet({
    super.key,
    required this.onLocationSelected,
    this.initialLocation,
  });

  @override
  State<LocationPickerBottomSheet> createState() => _LocationPickerBottomSheetState();
}

class _LocationPickerBottomSheetState extends State<LocationPickerBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<LocationSearchResult> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchLocation(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      // TODO: Implementar búsqueda de ubicaciones con geocoding
      // Por ahora, simulamos algunos resultados
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _searchResults = [
          LocationSearchResult(
            name: '$query - Centro',
            address: '$query, Centro',
            latitude: -34.6037,
            longitude: -58.3816,
          ),
          LocationSearchResult(
            name: '$query - Norte',
            address: '$query, Zona Norte',
            latitude: -34.5937,
            longitude: -58.3716,
          ),
        ];
      });
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<void> _useCurrentLocation() async {
    final result = await LocationService.instance.getCurrentLocation();
    
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            backgroundColor: Colors.red,
          ),
        );
      },
      (position) {
        final locationData = LocationData.fromPosition(position);
        widget.onLocationSelected(locationData);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seleccionar Ubicación',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          
          // Campo de búsqueda
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar ciudad o dirección',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _isSearching 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : null,
              border: const OutlineInputBorder(),
            ),
            onChanged: _searchLocation,
          ),
          
          const SizedBox(height: 16),
          
          // Botón de ubicación actual
          ListTile(
            leading: const Icon(Icons.my_location),
            title: const Text('Usar ubicación actual'),
            onTap: _useCurrentLocation,
          ),
          
          const Divider(),
          
          // Resultados de búsqueda
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final result = _searchResults[index];
                return ListTile(
                  leading: const Icon(Icons.place),
                  title: Text(result.name),
                  subtitle: Text(result.address),
                  onTap: () {
                    final locationData = LocationData(
                      latitude: result.latitude,
                      longitude: result.longitude,
                      timestamp: DateTime.now(),
                      address: result.address,
                    );
                    widget.onLocationSelected(locationData);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LocationSearchResult {
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  LocationSearchResult({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}
