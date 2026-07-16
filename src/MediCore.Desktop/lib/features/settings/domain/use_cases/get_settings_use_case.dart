import '../entities/tenant_settings.dart';
import '../repositories/settings_repository.dart';

class GetSettingsUseCase {
  final SettingsRepository repository;

  const GetSettingsUseCase(this.repository);

  Future<TenantSettings> execute() => repository.getSettings();
}
