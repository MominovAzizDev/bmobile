import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const String _loginKey = 'login';
  static const String _tokenKey = 'jwt_token';
  static const String _passwordKey = 'password';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> saveCredentials(String login, String password) async {
    await _storage.write(key: _loginKey, value: login);
    await _storage.write(key: _passwordKey, value: password);
  }

  static Future<void> deleteCredentials() async {
    await _storage.delete(key: _loginKey);
    await _storage.delete(key: _passwordKey);
  }

  static Future<Map<String, String?>> getCredentials() async {
    var data = {
      "login": await _storage.read(key: _loginKey),
      "password": await _storage.read(key: _passwordKey),
    };
    return data;
  }
}
