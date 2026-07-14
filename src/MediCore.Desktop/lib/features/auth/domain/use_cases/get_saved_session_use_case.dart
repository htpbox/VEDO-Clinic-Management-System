import '../entities/login_result.dart';
import '../repositories/auth_repository.dart';

class GetSavedSessionUseCase {
  final AuthRepository repository;

  const GetSavedSessionUseCase(this.repository);

  Future<LoginResult?> execute() {
    return repository.getSavedSession();
  }
}
