import 'dart:convert';

import '../../../../core/storage/storage_service.dart';
import '../../domain/entities/authenticated_user.dart';
import '../../domain/entities/login_result.dart';
import '../../domain/enums/user_role.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final StorageService _storageService;

  const AuthRepositoryImpl(this._remoteDataSource, this._storageService);

  @override
  Future<LoginResult> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final model = await _remoteDataSource.login(
      email: email,
      password: password,
    );

    final result = model.toEntity();

    await _storageService.saveToken(result.accessToken);
    await _storageService.saveTenantId(result.user.tenantId);
    await _storageService.saveExpiresAt(
      result.accessTokenExpiresAt.toIso8601String(),
    );
    await _storageService.saveUserData(
      jsonEncode({
        'id': result.user.id,
        'email': result.user.email,
        'fullName': result.user.fullName,
        'role': result.user.role.name,
        'tenantId': result.user.tenantId,
        'branchId': result.user.branchId,
      }),
    );

    return result;
  }

  @override
  Future<void> logout() async {
    await _storageService.clearAll();
  }

  @override
  Future<LoginResult?> getSavedSession() async {
    final token = await _storageService.getToken();
    final userDataRaw = await _storageService.getUserData();
    final expiresAtRaw = await _storageService.getExpiresAt();

    if (token == null || userDataRaw == null || expiresAtRaw == null) {
      return null;
    }

    final expiresAt = DateTime.parse(expiresAtRaw);
    if (expiresAt.isBefore(DateTime.now())) {
      await _storageService.clearAll();
      return null;
    }

    final userData = jsonDecode(userDataRaw) as Map<String, dynamic>;

    return LoginResult(
      user: AuthenticatedUser(
        id: userData['id'] as String,
        email: userData['email'] as String,
        fullName: userData['fullName'] as String,
        role: UserRole.fromString(userData['role'] as String),
        tenantId: userData['tenantId'] as String,
        branchId: userData['branchId'] as String?,
      ),
      accessToken: token,
      accessTokenExpiresAt: expiresAt,
    );
  }
}
