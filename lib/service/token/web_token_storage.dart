import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/model/user_me_model.dart';
import 'package:truenorthflutterfrontend/service/token/token_storage.dart';

class WebTokenStorage implements TokenStorage {
  WebTokenStorage._internal();
  static final WebTokenStorage instance = WebTokenStorage._internal();
  final _storage = const FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: 'SecureAppDb',
      publicKey: 'AppEncKey',
    ),
  );
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _roleKey = 'user_role';
  @override
  Future<void> saveTokens(
      {required String access, required String refresh}) async {
    await _storage.write(key: _accessTokenKey, value: access);
    await _storage.write(key: _refreshTokenKey, value: refresh);
  }

  @override
  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);

  @override
  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);
  @override
  Future<void> saveUserRole(String role) async {
    await _storage.write(key: _roleKey, value: role);
  }

  @override
  Future<String?> getUserRole() => _storage.read(key: _roleKey);
  @override
  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _roleKey);
  }

  // Keep your extra user-info methods if other screens use them
  Future<void> saveUserInfoInWebStore(UsermeModel user) async {
    await _storage.write(key: "user_role", value: user.role);
    await _storage.write(key: "user_id", value: user.id.toString());
    await _storage.write(key: "user_email", value: user.email);
  }
}
