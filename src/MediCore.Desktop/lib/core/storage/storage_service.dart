import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  final _secureStorage = const FlutterSecureStorage(
    wOptions: WindowsOptions(useBackwardCompatibility: false),
  );

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: AppConstants.tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: AppConstants.tokenKey);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: AppConstants.tokenKey);
  }

  Future<void> saveUserData(String userData) async {
    await _secureStorage.write(key: AppConstants.userKey, value: userData);
  }

  Future<String?> getUserData() async {
    return await _secureStorage.read(key: AppConstants.userKey);
  }

  Future<void> saveTenantId(String tenantId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tenantKey, tenantId);
  }

  Future<String?> getTenantId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tenantKey);
  }

  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> saveExpiresAt(String expiresAt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.expiresAtKey, expiresAt);
  }

  Future<String?> getExpiresAt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.expiresAtKey);
  }
}
