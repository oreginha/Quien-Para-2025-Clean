import 'package:equatable/equatable.dart';

/// Representa un mensaje en el sistema de chat
class MessageEntity extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final List<String> readBy;
  final MessageStatus status;
  final FileAttachment? attachment;
  final LocationData? location;
  final String? replyToMessageId;
  final Map<String, dynamic>? metadata;
  final bool isDeleted;
  final DateTime? editedAt;

  const MessageEntity({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.timestamp,
    this.readBy = const [],
    this.status = MessageStatus.sent,
    this.attachment,
    this.location,
    this.replyToMessageId,
    this.metadata,
    this.isDeleted = false,
    this.editedAt,
  });

  /// Crea una copia del mensaje con valores actualizados
  MessageEntity copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    List<String>? readBy,
    MessageStatus? status,
    FileAttachment? attachment,
    LocationData? location,
    String? replyToMessageId,
    Map<String, dynamic>? metadata,
    bool? isDeleted,
    DateTime? editedAt,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      readBy: readBy ?? this.readBy,
      status: status ?? this.status,
      attachment: attachment ?? this.attachment,
      location: location ?? this.location,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      metadata: metadata ?? this.metadata,
      isDeleted: isDeleted ?? this.isDeleted,
      editedAt: editedAt ?? this.editedAt,
    );
  }

  /// Verifica si el mensaje ha sido leído por un usuario específico
  bool isReadBy(String userId) {
    return readBy.contains(userId);
  }

  /// Marca el mensaje como leído por un usuario
  MessageEntity markAsReadBy(String userId) {
    if (isReadBy(userId)) return this;
    
    return copyWith(
      readBy: [...readBy, userId],
      status: MessageStatus.delivered,
    );
  }

  /// Verifica si el mensaje es una respuesta a otro mensaje
  bool get isReply => replyToMessageId != null;

  /// Verifica si el mensaje ha sido editado
  bool get isEdited => editedAt != null;

  /// Obtiene el texto de preview para el mensaje
  String get previewText {
    if (isDeleted) return 'Mensaje eliminado';
    
    switch (type) {
      case MessageType.text:
        return content;
      case MessageType.image:
        return '📷 Imagen';
      case MessageType.file:
        return '📎 Archivo';
      case MessageType.audio:
        return '🎵 Audio';
      case MessageType.video:
        return '🎬 Video';
      case MessageType.location:
        return '📍 Ubicación';
      case MessageType.system:
        return content;
    }
  }

  /// Verifica si el mensaje tiene contenido multimedia
  bool get hasAttachment => attachment != null;

  /// Verifica si el mensaje contiene ubicación
  bool get hasLocation => location != null;

  @override
  List<Object?> get props => [
        id,
        chatId,
        senderId,
        content,
        type,
        timestamp,
        readBy,
        status,
        attachment,
        location,
        replyToMessageId,
        metadata,
        isDeleted,
        editedAt,
      ];

  @override
  String toString() {
    return 'MessageEntity{id: $id, senderId: $senderId, type: $type, content: ${content.length > 50 ? '${content.substring(0, 50)}...' : content}}';
  }
}

/// Tipos de mensaje soportados
enum MessageType {
  text,
  image,
  file,
  audio,
  video,
  location,
  system;

  String get displayName {
    switch (this) {
      case MessageType.text:
        return 'Texto';
      case MessageType.image:
        return 'Imagen';
      case MessageType.file:
        return 'Archivo';
      case MessageType.audio:
        return 'Audio';
      case MessageType.video:
        return 'Video';
      case MessageType.location:
        return 'Ubicación';
      case MessageType.system:
        return 'Sistema';
    }
  }

  bool get isMedia => [MessageType.image, MessageType.audio, MessageType.video].contains(this);
  bool get isFile => this == MessageType.file;
  bool get isLocation => this == MessageType.location;
  bool get isSystem => this == MessageType.system;
}

/// Estados posibles de un mensaje
enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed;

  String get displayName {
    switch (this) {
      case MessageStatus.sending:
        return 'Enviando';
      case MessageStatus.sent:
        return 'Enviado';
      case MessageStatus.delivered:
        return 'Entregado';
      case MessageStatus.read:
        return 'Leído';
      case MessageStatus.failed:
        return 'Falló';
    }
  }

  bool get isCompleted => [MessageStatus.delivered, MessageStatus.read].contains(this);
  bool get isFailed => this == MessageStatus.failed;
  bool get isPending => [MessageStatus.sending, MessageStatus.sent].contains(this);
}

/// Información de archivo adjunto
class FileAttachment extends Equatable {
  final String fileName;
  final String fileUrl;
  final String? mimeType;
  final int? fileSize;
  final String? thumbnailUrl;
  final Duration? duration; // Para audio/video
  final Map<String, dynamic>? metadata;

  const FileAttachment({
    required this.fileName,
    required this.fileUrl,
    this.mimeType,
    this.fileSize,
    this.thumbnailUrl,
    this.duration,
    this.metadata,
  });

  FileAttachment copyWith({
    String? fileName,
    String? fileUrl,
    String? mimeType,
    int? fileSize,
    String? thumbnailUrl,
    Duration? duration,
    Map<String, dynamic>? metadata,
  }) {
    return FileAttachment(
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      mimeType: mimeType ?? this.mimeType,
      fileSize: fileSize ?? this.fileSize,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      duration: duration ?? this.duration,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Obtiene el tamaño del archivo formateado
  String get formattedSize {
    if (fileSize == null) return 'Tamaño desconocido';
    
    if (fileSize! < 1024) {
      return '${fileSize!} B';
    } else if (fileSize! < 1024 * 1024) {
      return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  /// Verifica si el archivo es una imagen
  bool get isImage {
    return mimeType?.startsWith('image/') ?? fileName.toLowerCase().endsWith(RegExp(r'\.(jpg|jpeg|png|gif|webp)$'));
  }

  /// Verifica si el archivo es un video
  bool get isVideo {
    return mimeType?.startsWith('video/') ?? fileName.toLowerCase().endsWith(RegExp(r'\.(mp4|avi|mov|wmv|flv)$'));
  }

  /// Verifica si el archivo es audio
  bool get isAudio {
    return mimeType?.startsWith('audio/') ?? fileName.toLowerCase().endsWith(RegExp(r'\.(mp3|wav|aac|ogg|m4a)$'));
  }

  @override
  List<Object?> get props => [
        fileName,
        fileUrl,
        mimeType,
        fileSize,
        thumbnailUrl,
        duration,
        metadata,
      ];
}

/// Información de ubicación
class LocationData extends Equatable {
  final double latitude;
  final double longitude;
  final String? address;
  final String? name;
  final double? accuracy;

  const LocationData({
    required this.latitude,
    required this.longitude,
    this.address,
    this.name,
    this.accuracy,
  });

  LocationData copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? name,
    double? accuracy,
  }) {
    return LocationData(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      name: name ?? this.name,
      accuracy: accuracy ?? this.accuracy,
    );
  }

  /// Obtiene las coordenadas formateadas
  String get formattedCoordinates {
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }

  /// Obtiene la URL de Google Maps
  String get googleMapsUrl {
    return 'https://www.google.com/maps?q=$latitude,$longitude';
  }

  @override
  List<Object?> get props => [latitude, longitude, address, name, accuracy];
}
