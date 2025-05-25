// lib/core/widgets/lazy_resources.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/utils/memory_manager.dart';

/// Widget para cargar imágenes de red con lazy loading y caché
class LazyNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool enableMemoryCleanup;
  final Duration fadeInDuration;
  final Duration placeholderFadeOutDuration;
  final String? semanticLabel;

  /// Constructor
  const LazyNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.enableMemoryCleanup = true,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.placeholderFadeOutDuration = const Duration(milliseconds: 300),
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    // Verificar si la URL está vacía
    if (imageUrl.isEmpty) {
      return _buildErrorWidget();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: fadeInDuration,
      placeholderFadeInDuration: placeholderFadeOutDuration,
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildErrorWidget(),
      // Listener para liberar memoria con cacheManager cuando se completa la carga
      imageBuilder: enableMemoryCleanup
          ? (context, imageProvider) {
              _triggerMemoryCleanup();
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: fit,
                  ),
                ),
              );
            }
          : null,
      memCacheWidth: _calculateMemCacheWidth(),
      memCacheHeight: _calculateMemCacheHeight(),
    );
  }

  /// Construye el widget de placeholder
  Widget _buildPlaceholder() {
    return placeholder ??
        Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            ),
          ),
        );
  }

  /// Construye el widget de error
  Widget _buildErrorWidget() {
    return errorWidget ??
        Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: Center(
            child: Icon(
              Icons.broken_image,
              color: Colors.grey[400],
              size: 24,
            ),
          ),
        );
  }

  /// Calcula el ancho apropiado para la caché de memoria
  int? _calculateMemCacheWidth() {
    if (width == null) return null;
    // Reducir la resolución en caché para ahorrar memoria
    return (width! * 1.2).toInt();
  }

  /// Calcula la altura apropiada para la caché de memoria
  int? _calculateMemCacheHeight() {
    if (height == null) return null;
    // Reducir la resolución en caché para ahorrar memoria
    return (height! * 1.2).toInt();
  }

  /// Gatilla una limpieza de memoria después de cargar imágenes pesadas
  void _triggerMemoryCleanup() {
    if (!enableMemoryCleanup) return;

    // Programar una limpieza de memoria para liberar recursos
    MemoryManager().scheduleCleanup(
      delay: const Duration(seconds: 5),
      aggressive: false,
    );
  }
}

/// Widget para cargar componentes pesados de manera perezosa
class LazyLoadWidget extends StatefulWidget {
  final Widget Function() builder;
  final Widget placeholder;
  final Duration delay;
  final bool triggerMemoryCleanup;

  const LazyLoadWidget({
    super.key,
    required this.builder,
    required this.placeholder,
    this.delay = const Duration(milliseconds: 300),
    this.triggerMemoryCleanup = false,
  });

  @override
  LazyLoadWidgetState createState() => LazyLoadWidgetState();
}

class LazyLoadWidgetState extends State<LazyLoadWidget> {
  bool _isLoaded = false;
  late Widget _child;

  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  Future<void> _loadWidget() async {
    // Retardo controlado para dar prioridad a elementos críticos
    await Future.delayed(widget.delay);

    if (!mounted) return;

    try {
      _child = widget.builder();

      if (mounted) {
        setState(() {
          _isLoaded = true;
        });
      }

      // Opcional: limpiar memoria después de cargar componentes pesados
      if (widget.triggerMemoryCleanup) {
        MemoryManager().performCleanup(aggressive: false);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error en lazy loading de widget: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _isLoaded ? _child : widget.placeholder,
    );
  }
}

/// Mixin para precarga de recursos en segundo plano
mixin ResourcePreloader<T extends StatefulWidget> on State<T> {
  final Set<ImageProvider> _preloadedImages = {};
  final Set<String> _preloadingUrls = {};

  /// Precarga una imagen en segundo plano
  Future<void> preloadImage(String imageUrl) async {
    if (imageUrl.isEmpty || _preloadingUrls.contains(imageUrl)) return;

    _preloadingUrls.add(imageUrl);

    try {
      final ImageProvider provider = NetworkImage(imageUrl);

      await precacheImage(provider, context);

      if (mounted) {
        _preloadedImages.add(provider);
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error al precargar imagen: $e');
      }
    } finally {
      _preloadingUrls.remove(imageUrl);
    }
  }

  /// Precarga múltiples imágenes en paralelo
  Future<void> preloadImages(List<String> imageUrls) async {
    final List<Future<void>> futures = [];

    for (final String url in imageUrls) {
      if (url.isNotEmpty && !_preloadingUrls.contains(url)) {
        futures.add(preloadImage(url));
      }
    }

    await Future.wait(futures);
  }

  @override
  void dispose() {
    // Limpiar los recursos al desmontar el widget
    _preloadedImages.clear();
    _preloadingUrls.clear();
    super.dispose();
  }
}
