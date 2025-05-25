// lib/services/interfaces/image_service_interface.dart
import 'dart:io';

abstract class ImageServiceInterface {
  /// Picks an image from the gallery with preview and editing capabilities
  Future<File?> pickImageFromGallery({
    double? maxWidth,
    double? maxHeight,
    int? quality,
    bool allowEditing = true,
  });

  /// Picks an image from the camera with preview and editing capabilities
  Future<File?> pickImageFromCamera({
    double? maxWidth,
    double? maxHeight,
    int? quality,
    bool allowEditing = true,
  });

  /// Crops the given image file
  Future<File?> cropImage(File imageFile);

  /// Rotates the given image file by specified degrees
  Future<File?> rotateImage(File imageFile, double degrees);

  /// Applies a filter to the given image file
  Future<File?> applyFilter(File imageFile, String filterName);

  /// Adjusts brightness and contrast of the given image file
  Future<File?> adjustImage(
    File imageFile, {
    double brightness = 0,
    double contrast = 1,
  });

  /// Compresses the given image file
  Future<File?> compressImage(File imageFile, {int quality = 85});

  /// Generates a thumbnail from the given image file
  Future<File?> generateThumbnail(File imageFile, {int size = 200});
}
