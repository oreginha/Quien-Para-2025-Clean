import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import '../../../core/network/network_helper.dart';

/// Widget que muestra un banner cuando no hay conexión a internet
class ConnectivityBanner extends StatefulWidget {
  final Widget child;

  const ConnectivityBanner({super.key, required this.child});

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner>
    with SingleTickerProviderStateMixin {
  final NetworkHelper _networkHelper = NetworkHelper();
  late final AnimationController _controller;
  late final Animation<double> _animation;

  bool _showBanner = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // Crear controlador de animación
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Animación para deslizar el banner
    _animation = Tween<double>(
      begin: -60.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Verificar conectividad inicial
    _checkInitialConnectivity();

    // Escuchar cambios de conectividad
    _networkHelper.connectivityStream.listen(_updateConnectivity);
  }

  Future<void> _checkInitialConnectivity() async {
    final List<ConnectivityResult> result =
        await Connectivity().checkConnectivity();
    _updateConnectivity(result);
    _isInitialized = true;
  }

  void _updateConnectivity(List<ConnectivityResult> result) {
    final bool hasConnection =
        result.isNotEmpty && !result.contains(ConnectivityResult.none);

    // Solo actualizar el estado si realmente cambió la conectividad
    if (_showBanner != !hasConnection) {
      setState(() {
        _showBanner = !hasConnection;
      });

      // Mostrar u ocultar el banner con animación
      if (_showBanner) {
        _controller.forward();
      } else if (_isInitialized) {
        // Evitar animación en la carga inicial
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment
          .topCenter, // Usando Alignment en lugar de AlignmentDirectional.topStart
      children: [
        widget.child,
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Positioned(
              top: _animation.value,
              left: 0,
              right: 0,
              child: _showBanner
                  ? Container(
                      color: AppColors.success,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.wifi_off, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Sin conexión a internet',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            );
          },
        ),
      ],
    );
  }
}
