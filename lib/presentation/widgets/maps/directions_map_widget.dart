// lib/presentation/widgets/maps/directions_map_widget.dart

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
import 'package:quien_para/domain/usecases/maps/get_directions_usecase.dart';
import 'package:provider/provider.dart';

/// Widget para mostrar direcciones y rutas entre dos ubicaciones
class DirectionsMapWidget extends StatefulWidget {
  /// Ubicación de destino
  final LocationEntity destination;

  /// Ubicación de origen (opcional, si no se proporciona se usará la ubicación actual)
  final LocationEntity? origin;

  /// Altura del widget
  final double height;

  /// Modo de transporte (driving, walking, bicycling, transit)
  final String travelMode;

  /// Constructor
  const DirectionsMapWidget({
    super.key,
    required this.destination,
    this.origin,
    this.height = 300.0,
    this.travelMode = 'driving',
  });

  @override
  State<DirectionsMapWidget> createState() => _DirectionsMapWidgetState();
}

class _DirectionsMapWidgetState extends State<DirectionsMapWidget> {
  /// Controlador del mapa
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  /// Caso de uso para obtener la ubicación actual
  late final GetCurrentLocationUseCase _getCurrentLocationUseCase;

  /// Caso de uso para obtener direcciones
  late final GetDirectionsUseCase _getDirectionsUseCase;

  /// Marcadores en el mapa
  final Set<Marker> _markers = {};

  /// Polilíneas para la ruta
  final Set<Polyline> _polylines = {};

  /// Estado de carga
  bool _isLoading = true;

  /// Información de la ruta
  Map<String, dynamic>? _routeInfo;

  /// Ubicación de origen calculada
  LocationEntity? _originLocation;

  /// Posición inicial de la cámara
  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(40.4168, -3.7038), // Madrid como posición predeterminada
    zoom: 12.0,
  );

  @override
  void initState() {
    super.initState();

    // Inicializar casos de uso
    _getCurrentLocationUseCase = GetIt.I<GetCurrentLocationUseCase>();
    _getDirectionsUseCase = GetIt.I<GetDirectionsUseCase>();

    // Cargar la ruta
    _loadRoute();
  }

  /// Carga la ruta entre origen y destino
  Future<void> _loadRoute() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Si se proporciona un origen, usarlo, si no, obtener la ubicación actual
      final LocationEntity origin;
      if (widget.origin != null) {
        origin = widget.origin!;
      } else {
        origin = await _getCurrentLocationUseCase.execute();
      }

      _originLocation = origin;

      // Establecer marcadores
      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('origin'),
            position: LatLng(origin.latitude, origin.longitude),
            infoWindow: InfoWindow(
              title: origin.name ?? 'Origen',
              snippet: origin.address,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
        );

        _markers.add(
          Marker(
            markerId: const MarkerId('destination'),
            position: LatLng(
              widget.destination.latitude,
              widget.destination.longitude,
            ),
            infoWindow: InfoWindow(
              title: widget.destination.name ?? 'Destino',
              snippet: widget.destination.address,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        );
      });

      // Obtener direcciones para la ruta
      final Map<String, dynamic> routeData = await _getDirectionsUseCase
          .execute(origin, widget.destination, mode: widget.travelMode);

      _routeInfo = routeData;

      // Si hay una ruta, dibujar la polilínea
      if (routeData.containsKey('points') && !routeData.containsKey('error')) {
        final List<dynamic> points = routeData['points'];
        final List<LatLng> polylineCoordinates = [];

        for (final point in points) {
          polylineCoordinates.add(LatLng(point['lat'], point['lng']));
        }

        setState(() {
          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: polylineCoordinates,
              color: AppColors.brandYellow,
              width: 5,
            ),
          );
        });

        // Ajustar la vista para mostrar toda la ruta
        if (polylineCoordinates.isNotEmpty && mounted) {
          await Future.delayed(const Duration(milliseconds: 300));
          final GoogleMapController controller = await _controller.future;

          // Crear un límite que incluya todos los puntos
          final bounds = _createBoundsFromPoints(polylineCoordinates);

          // Animar cámara a los límites calculados
          controller.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, 70.0), // 70 es el padding
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar la ruta: $e'),
            duration: const Duration(seconds: 3),
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

  /// Crea los límites del mapa basados en una lista de puntos
  LatLngBounds _createBoundsFromPoints(List<LatLng> points) {
    // Calcular latitud y longitud mínima y máxima
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    // Crear límites
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Título
        Text('Cómo llegar', style: AppTypography.heading6(isDarkMode)),
        const SizedBox(height: AppSpacing.s),

        // Mapa con ruta
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
                  polylines: _polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  compassEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  style: isDarkMode
                      ? '''[
                      {
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
                      }
                    ]'''
                      : null,
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
                      // Botón de recalcular ruta
                      FloatingActionButton.small(
                        heroTag: 'btn_recalculate_route',
                        onPressed: _loadRoute,
                        backgroundColor: AppColors.brandYellow,
                        child: const Icon(Icons.refresh, color: Colors.black),
                      ),
                      const SizedBox(height: AppSpacing.s),
                      // Botón de zoom in
                      FloatingActionButton.small(
                        heroTag: 'btn_zoom_in',
                        onPressed: () async {
                          final controller = await _controller.future;
                          controller.animateCamera(CameraUpdate.zoomIn());
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
                          controller.animateCamera(CameraUpdate.zoomOut());
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

        // Información de la ruta
        if (_routeInfo != null &&
            !_isLoading &&
            _routeInfo!.containsKey('distance')) ...[
          const SizedBox(height: AppSpacing.s),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: AppSpacing.s,
            ),
            decoration: BoxDecoration(
              color: AppColors.getCardBackground(isDarkMode),
              borderRadius: BorderRadius.circular(AppRadius.s),
              border: Border.all(color: AppColors.getBorder(isDarkMode)),
            ),
            child: Column(
              children: [
                // Origen y destino
                Row(
                  children: [
                    CircleAvatar(
                      radius: 8,
                      backgroundColor: AppColors.brandYellow,
                      child: const Icon(
                        Icons.trip_origin,
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        _originLocation?.name ?? 'Tu ubicación',
                        style: AppTypography.bodyMedium(isDarkMode),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 8,
                      backgroundColor: AppColors.brandYellow,
                      child: const Icon(
                        Icons.place,
                        size: 10,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        widget.destination.name ?? 'Destino',
                        style: AppTypography.bodyMedium(isDarkMode),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Divider(),
                ),

                // Información de distancia y tiempo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Icon(
                          _getIconForTravelMode(widget.travelMode),
                          color: AppColors.getTextSecondary(isDarkMode),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _routeInfo!['distance']['text'],
                          style: AppTypography.labelLarge(
                            isDarkMode,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.timer,
                          color: AppColors.getTextSecondary(isDarkMode),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _routeInfo!['duration']['text'],
                          style: AppTypography.labelLarge(
                            isDarkMode,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// Obtiene el icono correspondiente al modo de transporte
  IconData _getIconForTravelMode(String mode) {
    switch (mode) {
      case 'driving':
        return Icons.directions_car;
      case 'walking':
        return Icons.directions_walk;
      case 'bicycling':
        return Icons.directions_bike;
      case 'transit':
        return Icons.directions_transit;
      default:
        return Icons.directions;
    }
  }
}
