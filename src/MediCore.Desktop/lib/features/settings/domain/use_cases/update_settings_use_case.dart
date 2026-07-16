import '../entities/tenant_settings.dart';
import '../entities/update_tenant_settings_params.dart';
import '../repositories/settings_repository.dart';

class UpdateSettingsUseCase {
  final SettingsRepository repository;

  const UpdateSettingsUseCase(this.repository);

  Future<TenantSettings> execute(UpdateTenantSettingsParams params) =>
      repository.updateSettings(params);
}
