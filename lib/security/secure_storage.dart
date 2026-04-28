import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  // Save the theme choice
  static Future<void> saveTheme(String theme) async {
    await _storage.write(key: 'theme-mode', value: theme);
  }

  // Fetch the theme choice
  static Future<String?> getTheme() async {
    return await _storage.read(key: 'theme-mode');
  }
}