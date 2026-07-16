import '../../domain/entities/tenant_settings.dart';
import '../../domain/entities/update_tenant_settings_params.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_remote_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource _remoteDataSource;

  const SettingsRepositoryImpl(this._remoteDataSource);

  @override
  Future<TenantSettings> getSettings() async {
    final model = await _remoteDataSource.getSettings();
    return model.toEntity();
  }

  @override
  Future<TenantSettings> updateSettings(
    UpdateTenantSettingsParams params,
  ) async {
    final model = await _remoteDataSource.updateSettings(params);
    return model.toEntity();
  }
}
