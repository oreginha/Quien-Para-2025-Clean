// optimized_profile_image.dart
// ignore_for_file: always_specify_types

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import '../../core/utils/optimized_image_provider.dart';
import '../../core/utils/performance_logger.dart';

/// Widget optimizado para mostrar imágenes de perfil con carga eficiente,
/// caché y placeholders optimizados para mejorar el rendimiento.
class OptimizedProfileImage extends StatefulWidget {
  final String? imageUrl;
  final double radius;
  final String? heroTag;
  final VoidCallback? onTap;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;
  final Widget? placeholderWidget;
  final Widget? errorWidget;
  final bool useHeroAnimation;

  const OptimizedProfileImage({
    super.key,
    this.imageUrl,
    this.radius = 40.0,
    this.heroTag,
    this.onTap,
    this.showBorder = true,
    this.borderColor,
    this.borderWidth = 2.0,
    this.placeholderWidget,
    this.errorWidget,
    this.useHeroAnimation = true,
  });

  @override
  State<OptimizedProfileImage> createState() => _OptimizedProfileImageState();
}

class _OptimizedProfileImageState extends State<OptimizedProfileImage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _hasError = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Tamaño de caché optimo para thumbnails de perfil
  final int _thumbnailSize =
      120; // 120x120 es suficiente para la mayoría de avatares

  @override
  void initState() {
    super.initState();

    // Configurar animación de aparición suave
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Precargar la imagen si hay una URL
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      _precacheProfileImage();
    } else {
      _isLoading = false;
      _hasError = true;
    }
  }

  @override
  void didUpdateWidget(OptimizedProfileImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Si la URL cambió, recargar la imagen
    if (widget.imageUrl != oldWidget.imageUrl) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
        _precacheProfileImage();
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  /// Precarga la imagen de perfil optimizada
  void _precacheProfileImage() {
    if (widget.imageUrl == null) return;

    // Usar performance logger para medir tiempo de carga
    PerformanceLogger.logAsyncOperation('ProfileImage-Load', () async {
      try {
        // Obtener el proveedor de imágenes optimizado
        final ImageProvider<Object> imageProvider =
            OptimizedImageProvider().getOptimizedNetworkImage(
          widget.imageUrl!,
          width: _thumbnailSize,
          height: _thumbnailSize,
          cacheToFile: true,
          cacheToMemory: true,
        );

        // Precargar en caché
        final ImageConfiguration config = ImageConfiguration();
        final ImageStream stream = imageProvider.resolve(config);

        final Completer<void> completer = Completer<void>();

        final ImageStreamListener listener = ImageStreamListener(
          (ImageInfo info, bool syncCall) {
            // Imagen cargada exitosamente
            setState(() {
              _isLoading = false;
              _hasError = false;
            });

            // Iniciar animación de aparición suave
            _fadeController.forward();

            if (!completer.isCompleted) {
              completer.complete();
            }
          },
          onError: (dynamic exception, StackTrace? stackTrace) {
            if (kDebugMode) {
              print('Error cargando imagen de perfil: $exception');
            }

            setState(() {
              _isLoading = false;
              _hasError = true;
            });

            if (!completer.isCompleted) {
              completer.completeError(exception as Object);
            }
          },
        );

        stream.addListener(listener);

        // Establecer tiempo máximo para evitar bloqueos
        Future.delayed(const Duration(seconds: 10), () {
          if (_isLoading && !completer.isCompleted) {
            stream.removeListener(listener);
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
            completer.completeError(
              TimeoutException('Tiempo de carga excedido'),
            );
          }
        });

        return completer.future;
      } catch (e) {
        if (kDebugMode) {
          print('Error en precarga de imagen: $e');
        }
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget content = _buildAvatarContent();

    // Aplicar animación de aparición suave si no hay error
    final Widget animatedContent = !_hasError && !_isLoading
        ? FadeTransition(opacity: _fadeAnimation, child: content)
        : content;

    // Aplicar Hero animation si está habilitado y hay tag
    if (widget.useHeroAnimation && widget.heroTag != null) {
      return Hero(tag: widget.heroTag!, child: animatedContent);
    }

    return GestureDetector(onTap: widget.onTap, child: animatedContent);
  }

  Widget _buildAvatarContent() {
    // Contenedor con borde opcional
    return Container(
      decoration: widget.showBorder
          ? BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.borderColor ?? AppColors.lightTextPrimary,
                width: widget.borderWidth,
              ),
            )
          : null,
      child: _buildAvatarWithFallbacks(),
    );
  }

  Widget _buildAvatarWithFallbacks() {
    // Si está cargando, mostrar indicador de carga
    if (_isLoading) {
      return _buildLoadingIndicator();
    }

    // Si hay error o no hay URL, mostrar fallback
    if (_hasError || widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      return _buildErrorWidget();
    }

    // Mostrar la imagen optimizada
    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: Colors.transparent,
      backgroundImage: OptimizedImageProvider().getOptimizedNetworkImage(
        widget.imageUrl!,
        width: _thumbnailSize,
        height: _thumbnailSize,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return widget.placeholderWidget ??
        CircleAvatar(
          radius: widget.radius,
          backgroundColor: AppColors.getCardBackground(false),
          child: SizedBox(
            width: widget.radius * 0.6,
            height: widget.radius * 0.6,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.borderColor ?? AppColors.lightTextPrimary,
              ),
            ),
          ),
        );
  }

  Widget _buildErrorWidget() {
    return widget.errorWidget ??
        CircleAvatar(
          radius: widget.radius,
          backgroundColor: AppColors.getCardBackground(false),
          child: Icon(
            Icons.person,
            size: widget.radius * 0.8,
            color: widget.borderColor,
          ),
        );
  }
}
