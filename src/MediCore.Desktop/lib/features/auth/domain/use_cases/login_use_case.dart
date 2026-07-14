import '../entities/login_result.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  Future<LoginResult> execute({
    required String email,
    required String password,
    required bool rememberMe,
  }) {
    return repository.login(
      email: email,
      password: password,
      rememberMe: rememberMe,
    );
  }
}
