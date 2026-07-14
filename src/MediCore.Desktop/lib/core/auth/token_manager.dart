import 'dart:convert';
import '../storage/storage_service.dart';

class TokenManager {
  TokenManager._();
  static final TokenManager instance = TokenManager._();

  String? _cachedToken;

  Future<void> saveToken(String token) async {
    _cachedToken = token;
    await StorageService.instance.saveToken(token);
  }

  Future<String?> getToken() async {
    _cachedToken ??= await StorageService.instance.getToken();
    return _cachedToken;
  }

  Future<void> clearToken() async {
    _cachedToken = null;
    await StorageService.instance.deleteToken();
  }

  Future<bool> hasValidToken() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return false;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final data = jsonDecode(decoded) as Map<String, dynamic>;
      final exp = data['exp'] as int?;
      if (exp == null) return false;
      final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return expiry.isAfter(DateTime.now());
    } catch (_) {
      return false;
    }
  }
}
