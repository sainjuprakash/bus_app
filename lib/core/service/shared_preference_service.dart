import 'package:shared_preferences/shared_preferences.dart';

class PrefsServiceKeys {
  static const String isEnglishSelected = '';
  static const String accessTokem = 'accessTokem';
  static const String languageCode = 'en';
  static const String busId = 'busID';
}

class PrefsService {
  const PrefsService._(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  static Future<PrefsService> getInstance() async {
    final _prefs = await SharedPreferences.getInstance();
    return PrefsService._(_prefs);
  }

  /// Reads a value of any type from persistent storage.
  Object? get(String key) => _sharedPreferences.get(key);

  /// Reads a value from persistent storage, throwing an exception if it's not a bool.
  bool? getBool(String key) => _sharedPreferences.getBool(key);

  /// Saves a string [value] to persistent storage in the background.
  ///
  /// Note: Due to limitations in Android's SharedPreferences, values cannot start with any one of the following:
  ///
  /// - 'VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu'
  /// - 'VGhpcyBpcyB0aGUgcHJlZml4IGZvciBCaWdJbnRlZ2Vy'
  /// - 'VGhpcyBpcyB0aGUgcHJlZml4IGZvciBEb3VibGUu'
  Future<bool> setString(String key, String value) =>
      _sharedPreferences.setString(key, value);

  /// Completes with true once the user preferences for the app has been cleared.
  Future<bool> clear() => _sharedPreferences.clear();

  /// Returns true if persistent storage the contains the given [key].
  bool containsKey(String key) => _sharedPreferences.containsKey(key);

  /// Saves a boolean [value] to persistent storage in the background.
  Future<void> setBool(String key, bool value) =>
      _sharedPreferences.setBool(key, value);

  /// Saves an integer [value] to persistent storage in the background.
  Future<bool> setInt(String key, int value) =>
      _sharedPreferences.setInt(key, value);

  /// Android doesn't support storing doubles, so it will be stored as a float.
  Future<bool> setDouble(String key, double value) =>
      _sharedPreferences.setDouble(key, value);

  /// Saves a list of strings [value] to persistent storage in the background.
  Future<bool> setStringList(String key, List<String> value) =>
      _sharedPreferences.setStringList(key, value);

  /// Reads a value from persistent storage, throwing an exception if it's not a double.
  double? getDouble(String key) => _sharedPreferences.getDouble(key);

  /// Reads a value from persistent storage, throwing an exception if it's not an int.
  int? getInt(String key) => _sharedPreferences.getInt(key);

  /// Returns all keys in the persistent storage.
  Set<String> getKeys() => _sharedPreferences.getKeys();

  /// Reads a value from persistent storage, throwing an exception if it's not a String.
  String? getString(String key) => _sharedPreferences.getString(key);

  /// Reads a set of string values from persistent storage, throwing an exception if it's not a string set.
  List<String>? getStringList(String key) =>
      _sharedPreferences.getStringList(key);

  /// Fetches the latest values from the host platform.
  ///
  /// Use this method to observe modifications that were made in native code (without using the plugin) while the app is running.
  Future<void> reload() => _sharedPreferences.reload();

  /// Removes an entry from persistent storage.
  Future<bool> remove(String key) => _sharedPreferences.remove(key);
}
