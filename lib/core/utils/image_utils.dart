// lib/utils/image_utils.dart
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class ImageUtils {
  static Future<File> compressImage(final File file) async {
    final Directory dir = await getTemporaryDirectory();
    final String targetPath = path.join(
      dir.path,
      '${DateTime.now().toIso8601String()}.jpg',
    );

    final XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 70,
      minWidth: 1024,
      minHeight: 1024,
    );

    return File(result?.path ?? file.path);
  }

  static Future<File> processImageForUpload(final File imageFile) async {
    // Comprimir la imagen
    final File compressedFile = await compressImage(imageFile);
    return compressedFile;
  }
}
