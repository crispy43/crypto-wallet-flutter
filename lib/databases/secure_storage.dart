import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// * Secure Storage
class SecureStorage {
  static FlutterSecureStorage? _storage;

  static void init() {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
  }

  static bool get isInitialized => _storage != null;

  static Future<String?> read(String key) async {
    return _storage!.read(key: key);
  }

  static Future<Map<String, String>> readAll() async {
    return _storage!.readAll();
  }

  static Future<void> write(String key, String value) async {
    await _storage!.write(key: key, value: value);
  }

  static Future<void> delete(String key) async {
    await _storage!.delete(key: key);
  }

  static Future<void> deleteAll() async {
    await _storage!.deleteAll();
  }
}
