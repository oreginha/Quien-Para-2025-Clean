import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import '../../domain/entities/chat/message_entity.dart';
import '../../core/error/exceptions.dart';

/// Servicio para subir archivos de chat a Firebase Storage
class FileUploadService {
  final FirebaseStorage _storage;
  
  // Referencias a las carpetas de storage
  late final Reference _chatFilesRef;
  late final Reference _userImagesRef;
  late final Reference _planImagesRef;

  FileUploadService({required FirebaseStorage storage}) : _storage = storage {
    _initializeReferences();
  }

  /// Inicializa las referencias de Firebase Storage
  void _initializeReferences() {
    _chatFilesRef = _storage.ref('chat_files');
    _userImagesRef = _storage.ref('user_images');
    _planImagesRef = _storage.ref('plan_images');
  }

  // =================== UPLOAD DE ARCHIVOS ===================

  /// Sube un archivo para chat y retorna FileAttachment
  Future<FileAttachment> uploadChatFile({
    required String chatId,
    required String filePath,
    required String fileName,
    String? mimeType,
    Function(double)? onProgress,
  }) async {
    try {
      // Validar archivo
      final file = File(filePath);
      if (!await file.exists()) {
        throw FileException('El archivo no existe: $filePath');
      }

      // Obtener información del archivo
      final fileSize = await file.length();
      final fileExtension = path.extension(fileName).toLowerCase();
      final detectedMimeType = mimeType ?? _getMimeTypeFromExtension(fileExtension);
      
      // Validar tamaño del archivo (50MB máximo)
      if (fileSize > 50 * 1024 * 1024) {
        throw FileException('El archivo es demasiado grande (máximo 50MB)');
      }

      // Determinar tipo de archivo y carpeta
      final fileType = _getFileType(detectedMimeType, fileExtension);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uniqueFileName = '${timestamp}_$fileName';

      // Crear referencia en Storage
      final fileRef = _chatFilesRef
          .child(chatId)
          .child(fileType)
          .child(uniqueFileName);

      // Configurar metadata
      final metadata = SettableMetadata(
        contentType: detectedMimeType,
        customMetadata: {
          'chatId': chatId,
          'originalName': fileName,
          'uploadedAt': timestamp.toString(),
        },
      );

      // Subir archivo
      final uploadTask = fileRef.putFile(file, metadata);

      // Monitorear progreso si se proporciona callback
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      // Esperar a que termine la subida
      final taskSnapshot = await uploadTask;

      // Obtener URL de descarga
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Generar thumbnail si es imagen o video
      String? thumbnailUrl;
      if (fileType == 'images' || fileType == 'videos') {
        thumbnailUrl = await _generateThumbnail(fileRef, detectedMimeType);
      }

      // Crear FileAttachment
      return FileAttachment(
        fileName: fileName,
        fileUrl: downloadUrl,
        mimeType: detectedMimeType,
        fileSize: fileSize,
        thumbnailUrl: thumbnailUrl,
        metadata: {
          'uploadedAt': timestamp.toString(),
          'chatId': chatId,
          'storageRef': fileRef.fullPath,
        },
      );
    } catch (e) {
      if (e is FirebaseException) {
        throw FileException('Error de Firebase Storage: ${e.message}');
      }
      throw FileException('Error subiendo archivo: ${e.toString()}');
    }
  }

  /// Sube una imagen desde bytes (para cámara o galería)
  Future<FileAttachment> uploadImageFromBytes({
    required String chatId,
    required Uint8List imageBytes,
    required String fileName,
    String mimeType = 'image/jpeg',
    Function(double)? onProgress,
  }) async {
    try {
      // Validar tamaño (10MB máximo para imágenes)
      if (imageBytes.length > 10 * 1024 * 1024) {
        throw FileException('La imagen es demasiado grande (máximo 10MB)');
      }

      // Crear nombre único
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = _getExtensionFromMimeType(mimeType);
      final uniqueFileName = '${timestamp}_$fileName$extension';

      // Crear referencia en Storage
      final fileRef = _chatFilesRef
          .child(chatId)
          .child('images')
          .child(uniqueFileName);

      // Configurar metadata
      final metadata = SettableMetadata(
        contentType: mimeType,
        customMetadata: {
          'chatId': chatId,
          'originalName': fileName,
          'uploadedAt': timestamp.toString(),
        },
      );

      // Subir imagen
      final uploadTask = fileRef.putData(imageBytes, metadata);

      // Monitorear progreso
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      // Esperar subida
      final taskSnapshot = await uploadTask;

      // Obtener URL
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Generar thumbnail
      final thumbnailUrl = await _generateImageThumbnail(fileRef, imageBytes);

      return FileAttachment(
        fileName: fileName,
        fileUrl: downloadUrl,
        mimeType: mimeType,
        fileSize: imageBytes.length,
        thumbnailUrl: thumbnailUrl,
        metadata: {
          'uploadedAt': timestamp.toString(),
          'chatId': chatId,
          'storageRef': fileRef.fullPath,
        },
      );
    } catch (e) {
      if (e is FirebaseException) {
        throw FileException('Error de Firebase Storage: ${e.message}');
      }
      throw FileException('Error subiendo imagen: ${e.toString()}');
    }
  }

  // =================== GESTIÓN DE ARCHIVOS ===================

  /// Elimina un archivo del chat
  Future<void> deleteFile(String fileUrl) async {
    try {
      // Extraer referencia del storage desde la URL
      final ref = _storage.refFromURL(fileUrl);
      
      // Eliminar archivo
      await ref.delete();
      
      // Intentar eliminar thumbnail si existe
      try {
        final thumbnailRef = _storage.ref('${ref.fullPath}_thumbnail');
        await thumbnailRef.delete();
      } catch (e) {
        // El thumbnail puede no existir, no es error crítico
        print('Thumbnail no encontrado o ya eliminado: $e');
      }
    } catch (e) {
      if (e is FirebaseException && e.code == 'object-not-found') {
        // El archivo ya no existe, no es un error
        return;
      }
      throw FileException('Error eliminando archivo: ${e.toString()}');
    }
  }

  /// Obtiene información de un archivo
  Future<Map<String, dynamic>?> getFileInfo(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      final metadata = await ref.getMetadata();
      
      return {
        'name': ref.name,
        'size': metadata.size,
        'contentType': metadata.contentType,
        'timeCreated': metadata.timeCreated?.toIso8601String(),
        'updated': metadata.updated?.toIso8601String(),
        'customMetadata': metadata.customMetadata,
      };
    } catch (e) {
      print('Error obteniendo info del archivo: $e');
      return null;
    }
  }

  /// Limpia archivos antiguos de un chat
  Future<void> cleanupOldFiles(String chatId, {Duration maxAge = const Duration(days: 30)}) async {
    try {
      final chatRef = _chatFilesRef.child(chatId);
      final listResult = await chatRef.listAll();
      
      final cutoffTime = DateTime.now().subtract(maxAge);
      
      for (final ref in listResult.items) {
        try {
          final metadata = await ref.getMetadata();
          if (metadata.timeCreated != null && metadata.timeCreated!.isBefore(cutoffTime)) {
            await ref.delete();
            print('Archivo eliminado: ${ref.name}');
          }
        } catch (e) {
          print('Error procesando archivo ${ref.name}: $e');
        }
      }
      
      // Procesar subcarpetas recursivamente
      for (final prefix in listResult.prefixes) {
        final subListResult = await prefix.listAll();
        for (final ref in subListResult.items) {
          try {
            final metadata = await ref.getMetadata();
            if (metadata.timeCreated != null && metadata.timeCreated!.isBefore(cutoffTime)) {
              await ref.delete();
              print('Archivo eliminado: ${ref.name}');
            }
          } catch (e) {
            print('Error procesando archivo ${ref.name}: $e');
          }
        }
      }
    } catch (e) {
      throw FileException('Error limpiando archivos antiguos: ${e.toString()}');
    }
  }

  // =================== MÉTODOS AUXILIARES ===================

  /// Determina el tipo de archivo según MIME type
  String _getFileType(String mimeType, String extension) {
    if (mimeType.startsWith('image/')) {
      return 'images';
    } else if (mimeType.startsWith('video/')) {
      return 'videos';
    } else if (mimeType.startsWith('audio/')) {
      return 'audio';
    } else if (_isDocumentType(mimeType, extension)) {
      return 'documents';
    } else {
      return 'files';
    }
  }

  /// Verifica si es un tipo de documento
  bool _isDocumentType(String mimeType, String extension) {
    const documentMimeTypes = [
      'application/pdf',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'application/vnd.ms-excel',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'application/vnd.ms-powerpoint',
      'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      'text/plain',
    ];

    const documentExtensions = [
      '.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx', '.txt'
    ];

    return documentMimeTypes.contains(mimeType) || 
           documentExtensions.contains(extension.toLowerCase());
  }

  /// Obtiene MIME type desde extensión
  String _getMimeTypeFromExtension(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.mp4':
        return 'video/mp4';
      case '.mov':
        return 'video/quicktime';
      case '.avi':
        return 'video/x-msvideo';
      case '.mp3':
        return 'audio/mpeg';
      case '.wav':
        return 'audio/wav';
      case '.m4a':
        return 'audio/mp4';
      case '.pdf':
        return 'application/pdf';
      case '.doc':
        return 'application/msword';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case '.txt':
        return 'text/plain';
      default:
        return 'application/octet-stream';
    }
  }

  /// Obtiene extensión desde MIME type
  String _getExtensionFromMimeType(String mimeType) {
    switch (mimeType) {
      case 'image/jpeg':
        return '.jpg';
      case 'image/png':
        return '.png';
      case 'image/gif':
        return '.gif';
      case 'image/webp':
        return '.webp';
      case 'video/mp4':
        return '.mp4';
      case 'video/quicktime':
        return '.mov';
      case 'audio/mpeg':
        return '.mp3';
      case 'audio/wav':
        return '.wav';
      case 'audio/mp4':
        return '.m4a';
      case 'application/pdf':
        return '.pdf';
      case 'text/plain':
        return '.txt';
      default:
        return '';
    }
  }

  /// Genera thumbnail para imagen o video
  Future<String?> _generateThumbnail(Reference fileRef, String mimeType) async {
    try {
      // Para MVP, solo retornamos null
      // En el futuro se puede implementar generación real de thumbnails
      // usando packages como image o video_thumbnail
      return null;
    } catch (e) {
      print('Error generando thumbnail: $e');
      return null;
    }
  }

  /// Genera thumbnail específico para imagen
  Future<String?> _generateImageThumbnail(Reference fileRef, Uint8List imageBytes) async {
    try {
      // Para MVP, solo retornamos null
      // En el futuro se puede implementar redimensionado de imagen
      return null;
    } catch (e) {
      print('Error generando thumbnail de imagen: $e');
      return null;
    }
  }

  // =================== UTILIDADES PÚBLICAS ===================

  /// Valida si el archivo es válido para subir
  bool isValidFile(String filePath, {int maxSizeBytes = 50 * 1024 * 1024}) {
    final file = File(filePath);
    
    if (!file.existsSync()) return false;
    
    final fileSize = file.lengthSync();
    if (fileSize > maxSizeBytes) return false;
    
    return true;
  }

  /// Obtiene el tamaño formateado de un archivo
  String getFormattedFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  /// Limpia recursos del servicio
  void dispose() {
    // Limpiar cualquier recurso si es necesario
  }
}
