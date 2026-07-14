import 'token_manager.dart';
import '../context/current_user.dart';
import '../context/current_tenant.dart';
import '../storage/storage_service.dart';

class SessionManager {
  SessionManager._();
  static final SessionManager instance = SessionManager._();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;
    await CurrentUser.instance.loadFromStorage();
    await CurrentTenant.instance.load();
    _isInitialized = true;
  }

  Future<bool> isAuthenticated() async {
    return await TokenManager.instance.hasValidToken();
  }

  Future<void> startSession({
    required String token,
    required String userId,
    required String fullName,
    required String email,
    required String role,
    required String tenantId,
    required String tenantName,
    String? branchId,
  }) async {
    await TokenManager.instance.saveToken(token);
    await CurrentUser.instance.save(
      userId: userId,
      fullName: fullName,
      email: email,
      role: role,
      tenantId: tenantId,
      branchId: branchId,
    );
    await CurrentTenant.instance.save(
      tenantId: tenantId,
      tenantName: tenantName,
    );
  }

  Future<void> endSession() async {
    await TokenManager.instance.clearToken();
    await CurrentUser.instance.clear();
    await CurrentTenant.instance.clear();
    await StorageService.instance.clearAll();
    _isInitialized = false;
  }
}
