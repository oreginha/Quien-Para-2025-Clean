// lib/core/utils/image_utils/image_helper.dart

import 'package:flutter/material.dart';

class ImageHelper {
  /// Verifica si una URL de imagen es válida para mostrar
  static bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) {
      return false;
    }

    // Ignorar URLs de data:image/
    if (url.startsWith('data:image/')) {
      return false;
    }

    // Ignorar URLs problemáticas
    if (url.contains('via.placeholder.com') ||
        url.contains('placeholder.com')) {
      return false;
    }

    return true;
  }

  /// Devuelve un widget de imagen de manera segura
  static Widget getImageWidget({
    required String? imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    IconData placeholderIcon = Icons.image,
    Color? darkPrimaryBackground,
    Color? iconColor,
    BorderRadius? borderRadius,
  }) {
    final Widget imageWidget = isValidImageUrl(imageUrl)
        ? Image.network(
            imageUrl!,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(
              width: width,
              height: height,
              icon: Icons.image_not_supported,
              darkPrimaryBackground: darkPrimaryBackground,
              iconColor: iconColor,
            ),
          )
        : _buildPlaceholder(
            width: width,
            height: height,
            icon: placeholderIcon,
            darkPrimaryBackground: darkPrimaryBackground,
            iconColor: iconColor,
          );

    // Si se especifica un borderRadius, envuelve la imagen en un ClipRRect
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  /// Construye un widget placeholder para cuando no hay imagen
  static Widget _buildPlaceholder({
    double? width,
    double? height,
    IconData icon = Icons.image,
    Color? darkPrimaryBackground,
    Color? iconColor,
  }) {
    return Container(
      width: width,
      height: height,
      color: darkPrimaryBackground ?? Colors.grey[800],
      child: Icon(
        icon,
        color: iconColor ?? Colors.white54,
        size: (width != null && height != null)
            ? (width + height) / 4 // Tamaño proporcional al contenedor
            : 24,
      ),
    );
  }
}
