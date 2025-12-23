import 'package:shared_preferences/shared_preferences.dart';
import 'package:utils/utils.dart';

/// A wrapper around [SharedPreferences] that logs all write operations.
class LoggingSharedPreferences implements SharedPreferences {
  final SharedPreferences _prefs;

  LoggingSharedPreferences(this._prefs);

  @override
  Set<String> getKeys() {
    return _prefs.getKeys();
  }

  @override
  Object? get(String key) {
    return _prefs.get(key);
  }

  @override
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  @override
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  @override
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  @override
  String? getString(String key) {
    return _prefs.getString(key);
  }

  @override
  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // --- Write Methods (Logged) ---

  @override
  Future<bool> setBool(String key, bool value) {
    AppLogger.info('Setting key: $key to $value', feature: LogFeature.storage);
    return _prefs.setBool(key, value);
  }

  @override
  Future<bool> setInt(String key, int value) {
    AppLogger.info('Setting key: $key to $value', feature: LogFeature.storage);
    return _prefs.setInt(key, value);
  }

  @override
  Future<bool> setDouble(String key, double value) {
    AppLogger.info('Setting key: $key to $value', feature: LogFeature.storage);
    return _prefs.setDouble(key, value);
  }

  @override
  Future<bool> setString(String key, String value) {
    AppLogger.info('Setting key: $key to "$value"', feature: LogFeature.storage);
    return _prefs.setString(key, value);
  }

  @override
  Future<bool> setStringList(String key, List<String> value) {
    AppLogger.info('Setting key: $key to $value', feature: LogFeature.storage);
    return _prefs.setStringList(key, value);
  }

  @override
  Future<bool> remove(String key) {
    AppLogger.info('Removing key: $key', feature: LogFeature.storage);
    return _prefs.remove(key);
  }

  @override
  Future<bool> clear() {
    AppLogger.info('Clearing all keys', feature: LogFeature.storage);
    return _prefs.clear();
  }

  @override
  Future<void> reload() {
    return _prefs.reload();
  }

  @override
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // Helper for deprecated members if needed/requested by interface
  // The SharedPreferences interface might demand these depending on version.
  @override
  Future<bool> commit() async {
    // ignore: deprecated_member_use
    return _prefs.commit();
  }
}
