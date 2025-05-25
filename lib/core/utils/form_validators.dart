// lib/core/utils/form_validators.dart

/// Clase de utilidades para validaciones de formularios
class FormValidators {
  FormValidators._(); // Constructor privado para evitar instanciación

  /// Validación de campo requerido
  static String? required(String? value, {String message = 'Este campo es requerido'}) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  /// Validación de correo electrónico
  static String? email(String? value, {String message = 'Ingresa un correo electrónico válido'}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Si no es requerido, retorna null
    }
    
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegExp.hasMatch(value)) {
      return message;
    }
    
    return null;
  }

  /// Validación de longitud mínima
  static String? minLength(String? value, int minLength, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Si no es requerido, retorna null
    }
    
    if (value.length < minLength) {
      return message ?? 'Debe tener al menos $minLength caracteres';
    }
    
    return null;
  }

  /// Validación de longitud máxima
  static String? maxLength(String? value, int maxLength, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Si no es requerido, retorna null
    }
    
    if (value.length > maxLength) {
      return message ?? 'No debe exceder $maxLength caracteres';
    }
    
    return null;
  }

  /// Validación de URL
  static String? url(String? value, {String message = 'Ingresa una URL válida'}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Si no es requerido, retorna null
    }
    
    final urlRegExp = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );
    
    if (!urlRegExp.hasMatch(value)) {
      return message;
    }
    
    return null;
  }

  /// Validación de coincidencia de contraseñas
  static String? passwordMatch(
    String? value, 
    String? confirmValue, 
    {String message = 'Las contraseñas no coinciden'}
  ) {
    if (value == null || confirmValue == null || value.isEmpty || confirmValue.isEmpty) {
      return null; // Si alguno está vacío, retorna null
    }
    
    if (value != confirmValue) {
      return message;
    }
    
    return null;
  }

  /// Validación combinada (ejecuta múltiples validaciones)
  static String? multiple(String? value, List<String? Function(String?)> validators) {
    if (validators.isEmpty) return null;
    
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    
    return null;
  }
}
