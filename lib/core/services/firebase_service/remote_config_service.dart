import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireBaseRemoteConfigService {
  static const String _keyUrl = "remote_config_url";

  static Future<void> getConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 1),
        minimumFetchInterval: const Duration(seconds: 10),
      ));

      await remoteConfig.fetchAndActivate();

      final jsonConfig = remoteConfig.getString("remote_config_url");
      print("config: $jsonConfig");

      // ✅ Lưu vào SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUrl, jsonConfig);
    } catch (e) {
      print("Error fetching remote config: $e");
      rethrow;
    }
  }

  /// Hàm lấy url đã lưu (nếu có)
  static Future<String?> getSavedUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUrl);
  }
}
