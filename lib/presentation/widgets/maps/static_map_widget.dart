// lib/presentation/widgets/maps/static_map_widget.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/domain/entities/location_entity.dart';
import 'package:provider/provider.dart';

/// Widget para mostrar un mapa estático (no interactivo) con una ubicación fija
class StaticMapWidget extends StatefulWidget {
  /// Ubicación a mostrar
  final LocationEntity location;

  /// Altura del mapa
  final double height;

  /// Nivel de zoom
  final double zoom;

  /// Si se debe mostrar la información de la ubicación
  final bool showLocationInfo;

  /// Constructor
  const StaticMapWidget({
    super.key,
    required this.location,
    this.height = 200.0,
    this.zoom = 15.0,
    this.showLocationInfo = true,
  });

  @override
  State<StaticMapWidget> createState() => _StaticMapWidgetState();
}

class _StaticMapWidgetState extends State<StaticMapWidget> {
  /// Controlador para el mapa
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  /// Conjunto de marcadores para mostrar en el mapa
  late Set<Marker> _markers;

  /// Posición inicial de la cámara
  late CameraPosition _initialPosition;

  @override
  void initState() {
    super.initState();

    // Configurar la posición inicial de la cámara
    _initialPosition = CameraPosition(
      target: LatLng(widget.location.latitude, widget.location.longitude),
      zoom: widget.zoom,
    );

    // Configurar el marcador
    _markers = {
      Marker(
        markerId: const MarkerId('location_marker'),
        position: LatLng(widget.location.latitude, widget.location.longitude),
        infoWindow: InfoWindow(
          title: widget.location.name ?? 'Ubicación',
          snippet: widget.location.address,
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Contenedor del mapa con borde redondeado
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.m),
          child: SizedBox(
            height: widget.height,
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              markers: _markers,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
              rotateGesturesEnabled: false,
              scrollGesturesEnabled: false,
              zoomGesturesEnabled: false,
              tiltGesturesEnabled: false,
              liteModeEnabled: true,
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
                    "featureType": "poi",
                    "elementType": "labels.icon",
                    "stylers": [{
                      "visibility": "off"
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
                    "featureType": "water",
                    "elementType": "geometry",
                    "stylers": [{
                      "color": "#17263c"
                    }]
                  }
                ]'''
                  : null,
            ),
          ),
        ),

        // Información de la ubicación (opcional)
        if (widget.showLocationInfo &&
            (widget.location.name != null ||
                widget.location.address != null ||
                widget.location.city != null ||
                widget.location.country != null)) ...[
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.getCardBackground(isDarkMode),
              borderRadius: BorderRadius.circular(AppRadius.s),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: AppColors.brandYellow, size: 16),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.location.name != null)
                        Text(
                          widget.location.name!,
                          style: AppTypography.labelLarge(isDarkMode),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                      if (widget.location.address != null)
                        Text(
                          widget.location.address!,
                          style: AppTypography.bodyMedium(isDarkMode),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                      if (widget.location.city != null ||
                          widget.location.country != null)
                        Text(
                          [
                            widget.location.city,
                            widget.location.country,
                          ].where((e) => e != null).join(', '),
                          style: AppTypography.bodyMedium(isDarkMode),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
