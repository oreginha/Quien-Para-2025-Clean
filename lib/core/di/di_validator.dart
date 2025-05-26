// lib/core/di/di_validator.dart

import 'package:get_it/get_it.dart';
import 'di_logger.dart';

/// Clase para validar el estado de las dependencias registradas
///
/// Proporciona métodos para comprobar si las dependencias requeridas
/// están correctamente registradas y disponibles.
class DIValidator {
  /// Comprueba si una lista de tipos está registrada en el contenedor
  static bool areTypesRegistered<T>(GetIt container, List<Type> types) {
    DILogger.debug('Validando ${types.length} tipos...');

    final List<Type> missing = [];

    for (final type in types) {
      try {
        if (!container.isRegistered<Object>(instanceName: type.toString())) {
          DILogger.warning('Tipo no registrado: $type');
          missing.add(type);
        } else {
          DILogger.debug('✓ Tipo registrado: $type');
        }
      } catch (e) {
        DILogger.error('Error al verificar registro de $type: $e');
        missing.add(type);
      }
    }

    if (missing.isEmpty) {
      DILogger.success('Todos los tipos (${types.length}) están registrados');
      return true;
    } else {
      DILogger.warning('Faltan ${missing.length} tipos: $missing');
      return false;
    }
  }

  /// Verifica dependencias específicas requeridas para un componente
  static void validateDependenciesFor(
    String component,
    GetIt container,
    List<Type> requiredTypes,
  ) {
    DILogger.debug('Validando dependencias para: $component');

    final result = areTypesRegistered(container, requiredTypes);

    if (result) {
      DILogger.success('Validación exitosa para: $component');
    } else {
      DILogger.error(
        'Validación fallida para: $component - Dependencias faltantes',
      );
    }
  }

  /// Muestra el estado completo de registro de un contenedor
  static void dumpContainerState(GetIt container) {
    try {
      DILogger.debug('Dumping container state...');

      if (container.allReadySync()) {
        DILogger.info(
          'El contenedor está listo. No es posible listar los tipos registrados directamente porque GetIt no expone esta información públicamente.',
        );
      } else {
        DILogger.warning(
          'El contenedor no está listo. No es posible listar los tipos registrados.',
        );
      }
      DILogger.success('Estado del contenedor volcado correctamente');
    } catch (e) {
      DILogger.error('Error al volcar estado del contenedor', e);
    }
  }
}
