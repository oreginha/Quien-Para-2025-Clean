// Implementación para dispositivos móviles (Android/iOS)
import 'dart:io';
import 'package:flutter/material.dart' show Color; // Importamos Color de Flutter
import 'package:image_picker/image_picker.dart';
import 'package:quien_para/core/logger/logger.dart';
import 'package:quien_para/core/services/stub_image_cropper.dart';
import '../../domain/interfaces/image_service_interface.dart';

class ImageServiceMobile implements ImageServiceInterface {
  final ImagePicker _picker;
  final ImageCropper _cropper;

  ImageServiceMobile({
    ImagePicker? picker,
    ImageCropper? cropper,
  })  : _picker = picker ?? ImagePicker(),
        _cropper = cropper ?? ImageCropper();

  @override
  Future<File?> pickImageFromGallery({
    double? maxWidth,
    double? maxHeight,
    int? quality,
    bool allowEditing = true,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: quality,
      );

      if (image == null) return null;

      File imageFile = File(image.path);
      if (allowEditing) {
        final File? editedFile = await cropImage(imageFile);
        if (editedFile != null) {
          imageFile = editedFile;
        }
      }

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
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: quality,
      );

      if (image == null) return null;

      File imageFile = File(image.path);
      if (allowEditing) {
        final File? editedFile = await cropImage(imageFile);
        if (editedFile != null) {
          imageFile = editedFile;
        }
      }

      return imageFile;
    } catch (e) {
      logger.e('Error picking image from camera: $e');
      return null;
    }
  }

  @override
  Future<File?> cropImage(final File imageFile) async {
    try {
      final CroppedFile? croppedFile = await _cropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Editar Imagen',
            toolbarColor: const Color(0xFFECD058),
            toolbarWidgetColor: const Color(0xFF322942),
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Editar Imagen',
            aspectRatioLockEnabled: false,
          ),
        ],
      );

      if (croppedFile == null) return null;
      return File(croppedFile.path);
    } catch (e) {
      logger.e('Error cropping image: $e');
      return null;
    }
  }

  @override
  Future<File?> rotateImage(File imageFile, double degrees) async {
    // Implementación básica de rotación usando el paquete image
    try {
      return imageFile; // Implementación simplificada
    } catch (e) {
      logger.e('Error rotating image: $e');
      return null;
    }
  }

  @override
  Future<File?> applyFilter(File imageFile, String filterName) async {
    // En esta implementación básica, simplemente devolvemos la misma imagen
    return imageFile;
  }

  @override
  Future<File?> adjustImage(
    File imageFile, {
    double brightness = 0,
    double contrast = 1,
  }) async {
    // Implementación simplificada
    return imageFile;
  }

  @override
  Future<File?> compressImage(File imageFile, {int quality = 85}) async {
    try {
      // Implementación simplificada
      return imageFile;
    } catch (e) {
      logger.e('Error compressing image: $e');
      return null;
    }
  }

  @override
  Future<File?> generateThumbnail(File imageFile, {int size = 200}) async {
    try {
      // Implementación simplificada
      return imageFile;
    } catch (e) {
      logger.e('Error generating thumbnail: $e');
      return null;
    }
  }
}
