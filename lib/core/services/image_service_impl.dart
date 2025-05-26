// lib/services/implementations/image_service_impl.dart
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:quien_para/core/logger/logger.dart';
import '../../domain/interfaces/image_service_interface.dart';

// Versión simplificada para desarrollo en Chrome
// Para compatibilidad con web, no usamos image_cropper directamente

class ImageServiceImpl implements ImageServiceInterface {
  final ImagePicker _picker;

  // Constructor simple para compatibilidad web y móvil
  ImageServiceImpl({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  @override
  Future<File?> pickImageFromGallery({
    double? maxWidth,
    double? maxHeight,
    int? quality,
    bool allowEditing = true,
  }) async {
    if (kIsWeb) {
      // En web, simplemente retornamos null por ahora
      logger.d('Web platform detected, image picking/cropping not supported');
      return null;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: quality,
      );

      if (image == null) return null;

      File imageFile = File(image.path);
      // Para desarrollo en Chrome, omitimos el recorte de imágenes
      // En la versión completa para móvil, aquí se haría el cropImage

      return imageFile;
    } catch (e) {
      logger.e('Error picking image from gallery: $e');
      return null;
    }
  }

  @override
  Future<File?> pickImageFromCamera({
    double? maxWidth,
    double? maxHeight,
    int? quality,
    bool allowEditing = true,
  }) async {
    if (kIsWeb) {
      // En web, simplemente retornamos null por ahora
      logger.d('Web platform detected, image picking/cropping not supported');
      return null;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: quality,
      );

      if (image == null) return null;

      File imageFile = File(image.path);
      // Para desarrollo en Chrome, omitimos el recorte de imágenes
      // En la versión completa para móvil, aquí se haría el cropImage

      return imageFile;
    } catch (e) {
      logger.e('Error picking image from camera: $e');
      return null;
    }
  }

  @override
  Future<File?> cropImage(final File imageFile) async {
    // Versión simplificada para compatibilidad web
    if (kIsWeb) {
      logger.d('Web platform detected, image cropping not supported');
      return imageFile; // Devolvemos la imagen original en web
    }

    try {
      // En una versión real, aquí usaríamos image_cropper
      // Para desarrollo web, simplemente devolvemos la imagen original
      logger.d('Image cropping temporarily disabled for web compatibility');
      return imageFile;
    } catch (e) {
      logger.e('Error cropping image: $e');
      return imageFile; // Devolvemos la imagen original en caso de error
    }
  }

  @override
  Future<File?> rotateImage(File imageFile, double degrees) async {
    if (kIsWeb) {
      logger.d('Web platform detected, image rotation not supported');
      return imageFile;
    }

    try {
      final img.Image? image = img.decodeImage(await imageFile.readAsBytes());
      if (image == null) return null;

      final img.Image rotatedImage = img.copyRotate(
        image,
        angle: degrees.toInt(),
      );
      final String tempPath = (await getTemporaryDirectory()).path;
      final String outputPath =
          '$tempPath/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final File outputFile = File(outputPath);
      await outputFile.writeAsBytes(img.encodeJpg(rotatedImage));

      return outputFile;
    } catch (e) {
      logger.e('Error rotating image: $e');
      return null;
    }
  }

  @override
  Future<File?> applyFilter(File imageFile, String filterName) async {
    if (kIsWeb) {
      logger.d('Web platform detected, image filtering not supported');
      return imageFile;
    }

    try {
      final img.Image? image = img.decodeImage(await imageFile.readAsBytes());
      if (image == null) return null;

      img.Image filteredImage;
      switch (filterName.toLowerCase()) {
        case 'grayscale':
          filteredImage = img.grayscale(image);
          break;
        case 'sepia':
          filteredImage = img.sepia(image);
          break;
        default:
          return imageFile; // Devolvemos la imagen original si el filtro no existe
      }

      final String tempPath = (await getTemporaryDirectory()).path;
      final String outputPath =
          '$tempPath/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final File outputFile = File(outputPath);
      await outputFile.writeAsBytes(img.encodeJpg(filteredImage));

      return outputFile;
    } catch (e) {
      logger.e('Error applying filter to image: $e');
      return imageFile; // Devolvemos la imagen original en caso de error
    }
  }

  @override
  Future<File?> adjustImage(
    File imageFile, {
    double brightness = 0,
    double contrast = 1,
  }) async {
    if (kIsWeb) {
      logger.d('Web platform detected, image adjustment not supported');
      return imageFile;
    }

    try {
      final img.Image? image = img.decodeImage(await imageFile.readAsBytes());
      if (image == null) return imageFile;

      final img.Image adjustedImage = img.adjustColor(
        image,
        brightness: brightness,
        contrast: contrast,
      );

      final String tempPath = (await getTemporaryDirectory()).path;
      final String outputPath =
          '$tempPath/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final File outputFile = File(outputPath);
      await outputFile.writeAsBytes(img.encodeJpg(adjustedImage));

      return outputFile;
    } catch (e) {
      logger.e('Error adjusting image: $e');
      return imageFile; // Devolvemos la imagen original en caso de error
    }
  }

  @override
  Future<File?> compressImage(File imageFile, {int quality = 85}) async {
    if (kIsWeb) {
      logger.d('Web platform detected, image compression not supported');
      return imageFile;
    }

    try {
      final img.Image? image = img.decodeImage(await imageFile.readAsBytes());
      if (image == null) return imageFile;

      final String tempPath = (await getTemporaryDirectory()).path;
      final String outputPath =
          '$tempPath/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final File outputFile = File(outputPath);
      await outputFile.writeAsBytes(img.encodeJpg(image, quality: quality));

      return outputFile;
    } catch (e) {
      logger.e('Error compressing image: $e');
      return imageFile; // Devolvemos la imagen original en caso de error
    }
  }

  @override
  Future<File?> generateThumbnail(File imageFile, {int size = 200}) async {
    if (kIsWeb) {
      logger.d('Web platform detected, thumbnail generation not supported');
      return imageFile;
    }

    try {
      final img.Image? image = img.decodeImage(await imageFile.readAsBytes());
      if (image == null) return imageFile;

      final img.Image thumbnail = img.copyResize(
        image,
        width: size,
        height: size,
      );
      final String tempPath = (await getTemporaryDirectory()).path;
      final String outputPath =
          '$tempPath/thumb_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final File outputFile = File(outputPath);
      await outputFile.writeAsBytes(img.encodeJpg(thumbnail, quality: 85));

      return outputFile;
    } catch (e) {
      logger.e('Error generating thumbnail: $e');
      return imageFile; // Devolvemos la imagen original en caso de error
    }
  }
}
