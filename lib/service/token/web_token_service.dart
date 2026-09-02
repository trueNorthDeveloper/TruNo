import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:truenorthflutterfrontend/app/userApplication/userAuthModule/model/user_me_model.dart';

// GIVEN WEBTOKENSERVICE CLASS INDICATED TO WEB TOKEN THAT'S MEANS IF APPLICATION USED WEB PLATFROM LIKE(CHROME/BROWSER) SO GENEATED TOKEN AFTER LOGIN STORE IN FLUTTER
//FLUTTER SECURE STORAGE INSTEAD OF LOCALSTORAGE LIKE(SHARED PREEFREANCE) SOME OTHER METHOD HAVE IN IT LIKE TOKEN SAVE ,TOKEN REFRESH,GET ACCESS TOKEN
class WebTokenService {
  // Initialize storage with Web Options to guarantee encryption settings
 
  final _storage = const FlutterSecureStorage(
    webOptions: WebOptions(
      dbName: 'SecureAppDb',
      publicKey: 'AppEncKey',
    ),
  );
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  // Save tokens from your login JSON response
  Future<void> saveTokens(
      {required String access, required String refresh}) async {
    await _storage.write(key: _accessTokenKey, value: access);
    await _storage.write(key: _refreshTokenKey, value: refresh);
  }

  // Retrieve the access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // Retrieve the refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // Wipe storage on logout
  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

//save use info..........................................
  Future<void> saveUserInfoInWebStore(UsermeModel user) async {
    await _storage.write(key: "user_role", value: user.role);
    await _storage.write(key: "user_id", value: user.id.toString());
    await _storage.write(key: "user_email", value: user.email);
  }

  //get and return user role...........
  Future<String?> getWebRole() async {
    return await _storage.read(key: "user_role");
  }
}
