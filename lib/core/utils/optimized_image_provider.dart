// optimized_image_provider.dart
// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:crypto/crypto.dart';
import 'dart:convert';

/// Proveedor de imágenes optimizado para mejorar el rendimiento y reducir el uso de memoria
/// en la aplicación al cargar y mostrar imágenes.
class OptimizedImageProvider {
  // Singleton
  static final OptimizedImageProvider _instance =
      OptimizedImageProvider._internal();
  factory OptimizedImageProvider() => _instance;
  OptimizedImageProvider._internal();

  // Caché en memoria para imágenes
  final Map<String, ImageProvider> _memoryCache =
      <String, ImageProvider<Object>>{};

  // Limitador de tamaño de caché
  final int _maxCacheSize = 50;

  // Directorio de caché
  Directory? _cacheDir;

  /// Inicializa el proveedor de imágenes
  Future<void> initialize() async {
    if (kDebugMode) {
      print('📸 [OptimizedImageProvider] Inicializando proveedor de imágenes');
    }

    // Preparar directorio de caché
    _cacheDir = await getTemporaryDirectory();

    // Crear subdirectorio para caché de imágenes si no existe
    final Directory imageCacheDir =
        Directory(path.join(_cacheDir!.path, 'image_cache'));
    if (!await imageCacheDir.exists()) {
      await imageCacheDir.create(recursive: true);
    }

    if (kDebugMode) {
      print(
          '📸 [OptimizedImageProvider] Directorio de caché: ${imageCacheDir.path}');
    }
  }

  /// Obtiene una imagen optimizada a partir de una URL
  ImageProvider getOptimizedNetworkImage(
    String url, {
    int? width,
    int? height,
    bool cacheToFile = true,
    bool cacheToMemory = true,
  }) {
    // Generar clave para esta imagen
    final String cacheKey = _generateCacheKey(url, width, height);

    // Verificar si está en caché de memoria
    if (cacheToMemory && _memoryCache.containsKey(cacheKey)) {
      if (kDebugMode) {
        print('📸 [OptimizedImageProvider] Hit en caché de memoria para: $url');
      }
      return _memoryCache[cacheKey]!;
    }

    // Crear proveedor de imagen optimizado
    final ImageProvider imageProvider = ResizeNetworkImage(
      url,
      width: width,
      height: height,
      cacheKey: cacheKey,
      fileCacheEnabled: cacheToFile,
    );

    // Almacenar en caché de memoria si está habilitado
    if (cacheToMemory) {
      _addToMemoryCache(cacheKey, imageProvider);
    }

    return imageProvider;
  }

  /// Obtiene una imagen optimizada a partir de un archivo
  ImageProvider getOptimizedFileImage(
    File file, {
    int? width,
    int? height,
    bool cacheToMemory = true,
  }) {
    // Generar clave para esta imagen
    final String cacheKey = _generateCacheKey(file.path, width, height);

    // Verificar si está en caché de memoria
    if (cacheToMemory && _memoryCache.containsKey(cacheKey)) {
      if (kDebugMode) {
        print(
            '📸 [OptimizedImageProvider] Hit en caché de memoria para archivo: ${file.path}');
      }
      return _memoryCache[cacheKey]!;
    }

    // Crear proveedor optimizado
    final ImageProvider imageProvider = ResizeFileImage(
      file,
      width: width,
      height: height,
    );

    // Almacenar en caché de memoria si está habilitado
    if (cacheToMemory) {
      _addToMemoryCache(cacheKey, imageProvider);
    }

    return imageProvider;
  }

  /// Agrega una imagen a la caché en memoria con manejo de límite
  void _addToMemoryCache(String key, ImageProvider imageProvider) {
    // Si alcanzamos el límite, eliminar la primera entrada
    if (_memoryCache.length >= _maxCacheSize) {
      final String firstKey = _memoryCache.keys.first;
      _memoryCache.remove(firstKey);
      if (kDebugMode) {
        print('📸 [OptimizedImageProvider] Caché llena, eliminando: $firstKey');
      }
    }

    // Agregar nueva imagen a la caché
    _memoryCache[key] = imageProvider;
  }

  /// Genera una clave de caché para una imagen
  String _generateCacheKey(String source, int? width, int? height) {
    final String dimensionsKey =
        width != null && height != null ? '_${width}x$height' : '';

    // Generar hash para URL o ruta de archivo
    final String hash = md5.convert(utf8.encode(source)).toString();

    return '$hash$dimensionsKey';
  }

  /// Limpia la caché de memoria
  void clearMemoryCache() {
    _memoryCache.clear();
    if (kDebugMode) {
      print('📸 [OptimizedImageProvider] Caché de memoria limpiada');
    }
  }

  /// Limpia la caché de archivos
  Future<void> clearFileCache() async {
    if (_cacheDir != null) {
      final Directory imageCacheDir =
          Directory(path.join(_cacheDir!.path, 'image_cache'));

      if (await imageCacheDir.exists()) {
        await imageCacheDir.delete(recursive: true);
        await imageCacheDir.create();

        if (kDebugMode) {
          print('📸 [OptimizedImageProvider] Caché de archivos limpiada');
        }
      }
    }
  }
}

/// Proveedor optimizado para imágenes de red con redimensionamiento
class ResizeNetworkImage extends ImageProvider<ResizeNetworkImage> {
  final String url;
  final int? width;
  final int? height;
  final String cacheKey;
  final bool fileCacheEnabled;

  ResizeNetworkImage(
    this.url, {
    this.width,
    this.height,
    required this.cacheKey,
    this.fileCacheEnabled = true,
  });

  @override
  Future<ResizeNetworkImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<ResizeNetworkImage>(this);
  }

  @override
  ImageStreamCompleter loadImage(
      ResizeNetworkImage key, ImageDecoderCallback decode) {
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, chunkEvents, decode),
      chunkEvents: chunkEvents.stream,
      scale: 1.0,
      informationCollector: () sync* {
        yield ErrorDescription('URL: $url');
      },
    );
  }

  Future<ui.Codec> _loadAsync(
    ResizeNetworkImage key,
    StreamController<ImageChunkEvent> chunkEvents,
    ImageDecoderCallback decode,
  ) async {
    try {
      // Intentar cargar desde caché de archivo primero si está habilitado
      if (fileCacheEnabled) {
        final Directory cacheDir = await getTemporaryDirectory();
        if (cacheDir != null) {
          final String cachePath =
              path.join(cacheDir.path, 'image_cache', cacheKey);
          final File cacheFile = File(cachePath);

          if (await cacheFile.exists()) {
            final Uint8List bytes = await cacheFile.readAsBytes();
            if (bytes.isNotEmpty) {
              // Redimensionar si es necesario
              if (width != null || height != null) {
                final ui.Codec codec = await ui.instantiateImageCodec(
                  bytes,
                  targetWidth: width,
                  targetHeight: height,
                );
                return codec;
              }
              return decode(bytes as ui.ImmutableBuffer);
            }
          }
        }
      }

      // Si no está en caché, descargar de la red
      final Uri resolved = Uri.base.resolve(url);
      final HttpClient httpClient = HttpClient()..autoUncompress = true;
      final HttpClientRequest request = await httpClient.getUrl(resolved);

      final HttpClientResponse response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        throw Exception('HTTP error ${response.statusCode}');
      }

      final Uint8List bytes = await consolidateHttpClientResponseBytes(
        response,
        onBytesReceived: (int cumulative, int? total) {
          chunkEvents.add(ImageChunkEvent(
            cumulativeBytesLoaded: cumulative,
            expectedTotalBytes: total,
          ));
        },
      );

      if (bytes.lengthInBytes == 0) {
        throw Exception('NetworkImage is empty');
      }

      // Guardar en caché de archivo si está habilitado
      if (fileCacheEnabled) {
        final Directory cacheDir = await getTemporaryDirectory();
        if (cacheDir != null) {
          final String cacheDirPath = path.join(cacheDir.path, 'image_cache');
          final Directory cacheDirObj = Directory(cacheDirPath);
          if (!await cacheDirObj.exists()) {
            await cacheDirObj.create(recursive: true);
          }

          final String cachePath = path.join(cacheDirPath, cacheKey);
          final File cacheFile = File(cachePath);
          await cacheFile.writeAsBytes(bytes);
        }
      }

      // Redimensionar si es necesario
      if (width != null || height != null) {
        final ui.Codec codec = await ui.instantiateImageCodec(
          bytes,
          targetWidth: width,
          targetHeight: height,
        );
        return codec;
      }

      return decode(bytes as ui.ImmutableBuffer);
    } finally {
      chunkEvents.close();
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is ResizeNetworkImage &&
        other.url == url &&
        other.width == width &&
        other.height == height;
  }

  @override
  int get hashCode => Object.hash(url, width, height);

  @override
  String toString() =>
      'ResizeNetworkImage(url: $url, width: $width, height: $height)';
}

/// Proveedor optimizado para imágenes de archivo con redimensionamiento
class ResizeFileImage extends ImageProvider<ResizeFileImage> {
  final File file;
  final int? width;
  final int? height;

  ResizeFileImage(
    this.file, {
    this.width,
    this.height,
  });

  @override
  Future<ResizeFileImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<ResizeFileImage>(this);
  }

  @override
  ImageStreamCompleter loadImage(
      ResizeFileImage key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
      informationCollector: () sync* {
        yield ErrorDescription('Path: ${file.path}');
      },
    );
  }

  Future<ui.Codec> _loadAsync(
    ResizeFileImage key,
    ImageDecoderCallback decode,
  ) async {
    final Uint8List bytes = await file.readAsBytes();

    if (bytes.isEmpty) {
      throw Exception('FileImage is empty');
    }

    // Redimensionar si es necesario
    if (width != null || height != null) {
      final ui.Codec codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: width,
        targetHeight: height,
      );
      return codec;
    }

    return decode(bytes as ui.ImmutableBuffer);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is ResizeFileImage &&
        other.file.path == file.path &&
        other.width == width &&
        other.height == height;
  }

  @override
  int get hashCode => Object.hash(file.path, width, height);

  @override
  String toString() =>
      'ResizeFileImage(file: ${file.path}, width: $width, height: $height)';
}
