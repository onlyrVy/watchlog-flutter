import 'package:shared_preferences/shared_preferences.dart';

/// Wraps SharedPreferences so nothing else in the app touches it
/// directly — if we ever swap to flutter_secure_storage for better
/// token security, this is the only file that changes.
class TokenStorage {
  static const _tokenKey = 'auth_token';
  static const _rememberedEmailKey = 'remembered_email';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// Remembers the email used at last successful login, so LoginPage
  /// can pre-fill it. Deliberately never stores the password.
  Future<void> saveRememberedEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_rememberedEmailKey, email);
  }

  Future<String?> getRememberedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_rememberedEmailKey);
  }
}
