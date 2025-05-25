// lib/core/widgets/optimized/cached_network_image.dart
import 'package:flutter/material.dart';
import 'package:quien_para/core/services/image_cache_service.dart';

/// Widget para mostrar imágenes de red con soporte de caché optimizado
class OptimizedNetworkImage extends StatefulWidget {
  /// URL de la imagen
  final String imageUrl;

  /// Widget a mostrar mientras se carga la imagen
  final Widget? placeholder;

  /// Widget a mostrar en caso de error
  final Widget? errorWidget;

  /// Cómo ajustar la imagen dentro del espacio disponible
  final BoxFit? fit;

  /// Ancho del widget
  final double? width;

  /// Alto del widget
  final double? height;

  /// Color para aplicar a la imagen
  final Color? color;

  /// Modo de mezcla del color
  final BlendMode? colorBlendMode;

  /// Si se debe mostrar imagen de fondo durante la carga
  final bool usePlaceholderFade;

  /// Duración de la animación de fade
  final Duration fadeInDuration;

  const OptimizedNetworkImage({
    super.key,
    required this.imageUrl,
    this.placeholder,
    this.errorWidget,
    this.fit,
    this.width,
    this.height,
    this.color,
    this.colorBlendMode,
    this.usePlaceholderFade = true,
    this.fadeInDuration = const Duration(milliseconds: 300),
  });

  @override
  State<OptimizedNetworkImage> createState() => _OptimizedNetworkImageState();
}

class _OptimizedNetworkImageState extends State<OptimizedNetworkImage>
    with SingleTickerProviderStateMixin {
  /// Controlador de la animación
  late AnimationController _controller;

  /// Proveedor de la imagen
  ImageProvider? _imageProvider;

  /// Si ocurrió un error
  bool _hasError = false;

  /// Si la imagen está cargando
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Inicializar controlador de animación
    _controller = AnimationController(
      vsync: this,
      duration: widget.fadeInDuration,
    );

    _loadImage();
  }

  @override
  void didUpdateWidget(OptimizedNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.imageUrl != widget.imageUrl) {
      _loadImage();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadImage() async {
    if (widget.imageUrl.isEmpty) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
      _imageProvider = null;
    });

    try {
      // Usamos getCachedImagePath en lugar de getImage
      final String cachedPath = 
          await ImageCacheService.getCachedImagePath(widget.imageUrl);
      
      // Crear el imageProvider adecuado
      final imageProvider = NetworkImage(cachedPath);

      if (mounted) {
        setState(() {
          _imageProvider = imageProvider;
          _isLoading = false;
        });

        _controller.forward(from: 0.0);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildPlaceholder();
    }

    if (_hasError || _imageProvider == null) {
      return _buildErrorWidget();
    }

    return FadeTransition(
      opacity: _controller,
      child: Image(
        image: _imageProvider!,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        color: widget.color,
        colorBlendMode: widget.colorBlendMode,
      ),
    );
  }

  Widget _buildPlaceholder() {
    if (widget.placeholder != null) {
      return widget.placeholder!;
    }

    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey[300],
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (widget.errorWidget != null) {
      return widget.errorWidget!;
    }

    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      ),
    );
  }
}
