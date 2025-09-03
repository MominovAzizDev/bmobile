import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();
  
  // Token keys
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _loginKey = 'user_login';
  static const String _passwordKey = 'user_password';
  static const String _userDataKey = 'user_data';
  
  // Token operations
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }
  
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
  
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
  
  // Credentials operations
  static Future<void> saveCredentials(String login, String password) async {
    await _storage.write(key: _loginKey, value: login);
    await _storage.write(key: _passwordKey, value: password);
  }
  
  static Future<Map<String, String?>> getCredentials() async {
    final login = await _storage.read(key: _loginKey);
    final password = await _storage.read(key: _passwordKey);
    return {'login': login, 'password': password};
  }

  // Clear all data
  static Future<void> delete()async{
    await _storage.deleteAll();
  }  


  static Future<void> deleteCredentials() async {
    await _storage.delete(key: _loginKey);
    await _storage.delete(key: _passwordKey);
  }
  
  // User data operations
  static Future<void> saveUserData(String userData) async {
    await _storage.write(key: _userDataKey, value: userData);
  }
  
  static Future<String?> getUserData() async {
    return await _storage.read(key: _userDataKey);
  }
  
  static Future<void> deleteUserData() async {
    await _storage.delete(key: _userDataKey);
  }
}