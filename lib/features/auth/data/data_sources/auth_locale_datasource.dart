import 'package:shared_preferences/shared_preferences.dart';

const String _tokenKey = 'token_key';

abstract class AuthLocaleDataSource {
  Future<bool> saveToken(String token);
  Future<String?> getToken();
  Future<bool> removeToken();
}

class AuthLocaleDataSourceImpl implements AuthLocaleDataSource {
  @override
  Future<bool> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  @override
  Future<bool> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_tokenKey);
  }
}
