import '../entities/login_result.dart';

abstract class AuthRepository {
  Future<LoginResult> login({
    required String email,
    required String password,
    required bool rememberMe,
  });

  Future<void> logout();

  Future<LoginResult?> getSavedSession();
}
