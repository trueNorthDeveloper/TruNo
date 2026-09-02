abstract class TokenStorage {
  Future<void> saveTokens({required String access, required String refresh});
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveUserRole(String role);
  Future<String?> getUserRole();
  Future<void> clearTokens();
}
