// Factory para crear la implementación adecuada del servicio de imágenes
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:quien_para/domain/interfaces/image_service_interface.dart';
import 'image_service_mobile.dart';
import 'image_service_web.dart';

/// Factory para seleccionar la implementación correcta del servicio de imágenes
/// según la plataforma en la que se está ejecutando la aplicación
class ImageServiceFactory {
  /// Crea una instancia de ImageServiceInterface apropiada para la plataforma actual
  static ImageServiceInterface create() {
    if (kIsWeb) {
      // En web, usar la implementación compatible con web
      return ImageServiceWeb();
    } else {
      // En móvil, usar la implementación completa 
      return ImageServiceMobile();
    }
  }
}
