// lib/core/utils/mock_shared_preferences.dart
import 'package:shared_preferences/shared_preferences.dart';

/// Simulación de SharedPreferences para modo de emergencia
class MockSharedPreferences implements SharedPreferences {
  final Map<String, Object> _data = {};

  @override
  bool getBool(String key) => (_data[key] as bool?) ?? false;

  @override
  int? getInt(String key) => _data[key] as int?;

  @override
  double? getDouble(String key) => _data[key] as double?;

  @override
  String? getString(String key) => _data[key] as String?;

  @override
  List<String>? getStringList(String key) => _data[key] as List<String>?;

  @override
  Future<bool> setBool(String key, bool value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<bool> setInt(String key, int value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<bool> setString(String key, String value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    _data[key] = value;
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    _data.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    _data.clear();
    return true;
  }

  @override
  bool containsKey(String key) => _data.containsKey(key);

  @override
  Set<String> getKeys() => _data.keys.toSet();

  @override
  Object? get(String key) => _data[key];

  @override
  Future<void> reload() async {
    // No hace nada
  }
  
  @override
  Future<bool> commit() async {
    // En una implementación real, esto guardaría los datos en el disco
    // En nuestra simulación, simplemente retornamos true
    return true;
  }
}
