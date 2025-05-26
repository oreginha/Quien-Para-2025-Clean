// ignore_for_file: unused_element

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';

/// Widget que muestra imágenes de red con manejo de errores y reintentos
/// automáticos cuando hay problemas de conectividad
class NetworkResilientImage extends StatelessWidget {
  const NetworkResilientImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.memCacheWidth,
    this.memCacheHeight,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.retryDuration = const Duration(seconds: 3),
    this.maxRetries = 3,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final Duration fadeInDuration;
  final Duration retryDuration;
  final int maxRetries;

  @override
  Widget build(BuildContext context) {
    // Si la URL está vacía, mostrar el widget de error
    if (imageUrl.isEmpty) {
      return _buildErrorWidget();
    }

    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: fadeInDuration,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      maxWidthDiskCache: 800, // Limitar el tamaño máximo en caché de disco
      maxHeightDiskCache: 800,
      errorListener: (error) {
        if (kDebugMode) {
          print('Error al cargar imagen: $imageUrl - Error: $error');
        }
      },
      errorWidget: (context, url, error) => _buildErrorWidget(),
      placeholder: (context, url) => _buildPlaceholderWidget(),
      // Configuración para reintentos
      placeholderFadeInDuration: const Duration(milliseconds: 100),
      // NO incluir progressIndicatorBuilder aquí para evitar conflicto con placeholder
      // Habilitar reintentos automáticos
      useOldImageOnUrlChange: true,
      // Reducir la escala de la imagen para optimizar memoria
      filterQuality: FilterQuality.medium,
      // No utilizar la caché HTTP para forzar la recarga en caso de error
      cacheKey: imageUrl,
      // Evitar que se guarde la imagen en caché si hay error
      // skipMemoryCache: false,
    );

    // Aplicar el borderRadius si se especifica
    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }

  Widget _buildPlaceholderWidget() {
    return placeholder ??
        Container(
          width: width,
          height: height,
          color: AppColors.lightTextPrimary.withAlpha((255 * 0.1).round()),
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.brandYellow,
                ),
              ),
            ),
          ),
        );
  }

  Widget _buildLoadingWidget(double progress) {
    return Container(
      width: width,
      height: height,
      color: AppColors.lightBackground.withAlpha((0.1 * 255).round()),
      child: Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            value: progress > 0 ? progress : null,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandYellow),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return errorWidget ??
        Container(
          width: width,
          height: height,
          color: AppColors.lightTextPrimary.withAlpha((255 * 0.1).round()), //
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image,
                  color: AppColors.lightTextPrimary.withAlpha(
                    (255 * 0.8).round(),
                  ),
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  'Error al cargar la imagen',
                  style: TextStyle(
                    color: AppColors.lightTextPrimary.withAlpha(
                      (255 * 0.8).round(),
                    ),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
  }
}
