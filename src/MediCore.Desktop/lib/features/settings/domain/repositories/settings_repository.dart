import '../entities/tenant_settings.dart';
import '../entities/update_tenant_settings_params.dart';

abstract class SettingsRepository {
  Future<TenantSettings> getSettings();
  Future<TenantSettings> updateSettings(UpdateTenantSettingsParams params);
}
