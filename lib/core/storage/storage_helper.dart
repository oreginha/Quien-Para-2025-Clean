// lib/core/storage/storage_helper.dart
// Si no existe ya, crea este archivo

import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  late SharedPreferences _prefs;

  // Constructor que inicializa SharedPreferences
  static Future<StorageHelper> create() async {
    final StorageHelper instance = StorageHelper._();
    await instance._init();
    return instance;
  }

  // Constructor privado
  StorageHelper._();

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Método para obtener el token de autenticación
  Future<String?> getAuthToken() async {
    return _prefs.getString('auth_token');
  }

  // Otros métodos de almacenamiento que puedas necesitar
  Future<void> setAuthToken(final String token) async {
    await _prefs.setString('auth_token', token);
  }

  Future<void> clearAuthToken() async {
    await _prefs.remove('auth_token');
  }
}
