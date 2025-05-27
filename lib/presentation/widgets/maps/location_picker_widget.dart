// lib/presentation/widgets/maps/location_picker_widget.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/domain/entities/location_entity.dart';
import 'package:quien_para/domain/usecases/maps/get_current_location_usecase.dart';
import 'package:quien_para/domain/usecases/maps/reverse_geocode_usecase.dart';
import 'package:provider/provider.dart';

/// Widget selector de ubicación con mapa interactivo
class LocationPickerWidget extends StatefulWidget {
  /// Callback cuando se selecciona una ubicación
  final Function(LocationEntity) onLocationSelected;

  /// Ubicación inicial (opcional)
  final LocationEntity? initialLocation;

  /// Altura del widget
  final double height;

  /// Constructor
  const LocationPickerWidget({
    super.key,
    required this.onLocationSelected,
    this.initialLocation,
    this.height = 300.0,
  });

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  /// Controlador del mapa
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  /// Caso de uso para obtener la ubicación actual
  late final GetCurrentLocationUseCase _getCurrentLocationUseCase;

  /// Caso de uso para geocodificación inversa
  late final ReverseGeocodeUseCase _reverseGeocodeUseCase;

  /// Ubicación seleccionada actualmente
  LocationEntity? _selectedLocation;

  /// Marcadores del mapa
  Set<Marker> _markers = {};

  /// Estado de carga
  bool _isLoading = true;

  /// Cámara inicial del mapa
  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(40.4168, -3.7038), // Madrid como posición predeterminada
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();

    // Inicializar casos de uso
    _getCurrentLocationUseCase = GetIt.I<GetCurrentLocationUseCase>();
    _reverseGeocodeUseCase = GetIt.I<ReverseGeocodeUseCase>();

    // Establecer ubicación inicial o cargar la ubicación actual
    _loadInitialLocation();
  }

  /// Carga la ubicación inicial o la ubicación del usuario
  Future<void> _loadInitialLocation() async {
    try {
      // Si hay una ubicación inicial, usarla
      if (widget.initialLocation != null) {
        await _selectLocation(
          LatLng(
            widget.initialLocation!.latitude,
            widget.initialLocation!.longitude,
          ),
        );
      } else {
        // Si no hay ubicación inicial, intentar obtener la ubicación actual
        final currentLocation = await _getCurrentLocationUseCase.execute();
        await _selectLocation(
          LatLng(currentLocation.latitude, currentLocation.longitude),
        );
      }
    } catch (e) {
      // En caso de error, usar la ubicación predeterminada
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo obtener tu ubicación actual'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Selecciona una ubicación en el mapa
  Future<void> _selectLocation(LatLng latLng) async {
    try {
      // Obtener información de la ubicación mediante geocodificación inversa
      final locationInfo = await _reverseGeocodeUseCase.execute(
        latLng.latitude,
        latLng.longitude,
      );

      if (locationInfo != null) {
        _selectedLocation = locationInfo;
      } else {
        _selectedLocation = LocationEntity(
          latitude: latLng.latitude,
          longitude: latLng.longitude,
          name: 'Ubicación seleccionada',
        );
      }

      // Actualizar marcador en el mapa
      setState(() {
        _markers = {
          Marker(
            markerId: const MarkerId('selected_location'),
            position: latLng,
            infoWindow: InfoWindow(
              title: _selectedLocation?.name ?? 'Ubicación seleccionada',
              snippet: _selectedLocation?.address,
            ),
          ),
        };
      });

      // Animar cámara a la nueva ubicación
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(latLng));

      // Notificar la selección
      widget.onLocationSelected(_selectedLocation!);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar ubicación: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Título
        Text(
          'Selecciona una ubicación',
          style: AppTypography.heading6(isDarkMode),
        ),
        const SizedBox(height: AppSpacing.s),

        // Mapa
        SizedBox(
          height: widget.height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.m),
            child: Stack(
              children: [
                // Mapa de Google
                GoogleMap(
                  initialCameraPosition: _initialCameraPosition,
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  compassEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  style: isDarkMode
                      ? '''[{
                      "elementType": "geometry",
                      "stylers": [{
                        "color": "#242f3e"
                      }]
                    },
                    {
                      "elementType": "labels.text.fill",
                      "stylers": [{
                        "color": "#746855"
                      }]
                    },
                    {
                      "elementType": "labels.text.stroke",
                      "stylers": [{
                        "color": "#242f3e"
                      }]
                    },
                    {
                      "featureType": "administrative.locality",
                      "elementType": "labels.text.fill",
                      "stylers": [{
                        "color": "#d59563"
                      }]
                    },
                    {
                      "featureType": "poi",
                      "elementType": "labels.text.fill",
                      "stylers": [{
                        "color": "#d59563"
                      }]
                    },
                    {
                      "featureType": "poi.park",
                      "elementType": "geometry",
                      "stylers": [{
                        "color": "#263c3f"
                      }]
                    },
                    {
                      "featureType": "poi.park",
                      "elementType": "labels.text.fill",
                      "stylers": [{
                        "color": "#6b9a76"
                      }]
                    },
                    {
                      "featureType": "road",
                      "elementType": "geometry",
                      "stylers": [{
                        "color": "#38414e"
                      }]
                    },
                    {
                      "featureType": "road",
                      "elementType": "geometry.stroke",
                      "stylers": [{
                        "color": "#212a37"
                      }]
                    },
                    {
                      "featureType": "road",
                      "elementType": "labels.text.fill",
                      "stylers": [{
                        "color": "#9ca5b3"
                      }]
                    },
                    {
                      "featureType": "road.highway",
                      "elementType": "geometry",
                      "stylers": [{
                        "color": "#746855"
                      }]
                    },
                    {
                      "featureType": "road.highway",
                      "elementType": "geometry.stroke",
                      "stylers": [{
                        "color": "#1f2835"
                      }]
                    },
                    {
                      "featureType": "road.highway",
                      "elementType": "labels.text.fill",
                      "stylers": [{
                        "color": "#f3d19c"
                      }]
                    },
                    {
                      "featureType": "transit",
                      "elementType": "geometry",
                      "stylers": [{
                        "color": "#2f3948"
                      }]
                    },
                    {
                      "featureType": "transit.station",
                      "elementType": "labels.text.fill",
                      "stylers": [{
                        "color": "#d59563"
                      }]
                    },
                    {
                      "featureType": "water",
                      "elementType": "geometry",
                      "stylers": [{
                        "color": "#17263c"
                      }]
                    },
                    {
                      "featureType": "water",
                      "elementType": "labels.text.fill",
                      "stylers": [{
                        "color": "#515c6d"
                      }]
                    },
                    {
                      "featureType": "water",
                      "elementType": "labels.text.stroke",
                      "stylers": [{
                        "color": "#17263c"
                      }]
                    }]'''
                      : null,
                  onTap: _selectLocation,
                  mapType: MapType.normal,
                  padding: const EdgeInsets.all(AppSpacing.m),
                ),

                // Indicador de carga
                if (_isLoading)
                  Container(
                    color: AppColors.withAlpha(Colors.black, 0.3),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.brandYellow,
                        ),
                      ),
                    ),
                  ),

                // Botones de control
                Positioned(
                  right: AppSpacing.s,
                  top: AppSpacing.s,
                  child: Column(
                    children: [
                      // Botón de ubicación actual
                      FloatingActionButton.small(
                        heroTag: 'btn_current_location',
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            final location =
                                await _getCurrentLocationUseCase.execute();
                            if (mounted) {
                              await _selectLocation(
                                LatLng(location.latitude, location.longitude),
                              );
                            }
                          } catch (e) {
                            // Verificamos si el widget está montado antes de usar el BuildContext
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Error al obtener ubicación: $e',
                                  ),
                                ),
                              );
                            }
                          } finally {
                            if (mounted) {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }
                        },
                        backgroundColor: AppColors.brandYellow,
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s),
                      // Botón de zoom in
                      FloatingActionButton.small(
                        heroTag: 'btn_zoom_in',
                        onPressed: () async {
                          final controller = await _controller.future;
                          if (mounted) {
                            controller.animateCamera(CameraUpdate.zoomIn());
                          }
                        },
                        backgroundColor: AppColors.getCardBackground(
                          isDarkMode,
                        ),
                        child: Icon(
                          Icons.add,
                          color: AppColors.getTextPrimary(isDarkMode),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      // Botón de zoom out
                      FloatingActionButton.small(
                        heroTag: 'btn_zoom_out',
                        onPressed: () async {
                          final controller = await _controller.future;
                          if (mounted) {
                            controller.animateCamera(CameraUpdate.zoomOut());
                          }
                        },
                        backgroundColor: AppColors.getCardBackground(
                          isDarkMode,
                        ),
                        child: Icon(
                          Icons.remove,
                          color: AppColors.getTextPrimary(isDarkMode),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Información de la ubicación seleccionada
        if (_selectedLocation != null) ...[
          const SizedBox(height: AppSpacing.s),
          Container(
            padding: const EdgeInsets.all(AppSpacing.s),
            decoration: BoxDecoration(
              color: AppColors.getCardBackground(isDarkMode),
              borderRadius: BorderRadius.circular(AppRadius.s),
              border: Border.all(color: AppColors.getBorder(isDarkMode)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedLocation?.name ?? 'Ubicación seleccionada',
                  style: AppTypography.labelLarge(
                    isDarkMode,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
                if (_selectedLocation?.address != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _selectedLocation!.address!,
                    style: AppTypography.bodyMedium(isDarkMode),
                  ),
                ],
                if (_selectedLocation?.city != null ||
                    _selectedLocation?.country != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    [
                      _selectedLocation?.city,
                      _selectedLocation?.country,
                    ].where((e) => e != null).join(', '),
                    style: AppTypography.bodyMedium(isDarkMode),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}
