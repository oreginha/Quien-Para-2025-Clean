// lib/services/implementations/image_cache_service.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageCacheService {
  static final DefaultCacheManager _cacheManager = DefaultCacheManager();

  static Future<String> getCachedImagePath(String imageUrl) async {
    try {
      final FileInfo? fileInfo = await _cacheManager.getFileFromCache(imageUrl);
      if (fileInfo != null) {
        return fileInfo.file.path;
      }

      final FileInfo file = await _cacheManager.downloadFile(imageUrl);
      return file.file.path;
    } catch (e) {
      if (kDebugMode) {
        print('Error caching image: $e');
      }
      return imageUrl;
    }
  }

  static Future<void> clearCache() async {
    await _cacheManager.emptyCache();
  }

  static Future<void> removeFile(String imageUrl) async {
    await _cacheManager.removeFile(imageUrl);
  }
}
