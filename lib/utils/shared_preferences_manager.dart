import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  SharedPreferencesManager({required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  bool containsKey(String key) => sharedPreferences.containsKey(key);

  Future<bool?>? putStringList(String key, List<String> value) =>
      sharedPreferences.setStringList(key, value);
  List<String>? getStringList(String key) =>
      sharedPreferences.getStringList(key);

  Future<bool?>? putBool(String key, bool value) =>
      sharedPreferences.setBool(key, value);

  bool? getBool(String key) => sharedPreferences.getBool(key);

  Future<bool?>? putString(String key, String value) =>
      sharedPreferences.setString(key, value);

  String? getString(String key) {
    return sharedPreferences.getString(key);
  }

  Future<bool?>? putInt(String key, int value) =>
      sharedPreferences.setInt(key, value);

  int? getInt(String key) => sharedPreferences.getInt(key);

  Future? clear() => sharedPreferences.clear();
  Future? remove(String key) => sharedPreferences.remove(key);

  List<String>? getListString(String key) =>
      sharedPreferences.getStringList(key);

  Future updateListString(String key, String value) async {
    final preValue = getListString(key);
    return sharedPreferences.setStringList(key, [...preValue ?? [], value]);
  }
}
