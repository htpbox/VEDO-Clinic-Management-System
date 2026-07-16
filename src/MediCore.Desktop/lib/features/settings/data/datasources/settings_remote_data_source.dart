import '../../../../core/api/api_client.dart';
import '../../../../core/network/api_response_envelope.dart';
import '../../domain/entities/update_tenant_settings_params.dart';
import '../models/tenant_settings_model.dart';

abstract class SettingsRemoteDataSource {
  Future<TenantSettingsModel> getSettings();
  Future<TenantSettingsModel> updateSettings(UpdateTenantSettingsParams params);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final ApiClient _apiClient;

  const SettingsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<TenantSettingsModel> getSettings() async {
    final response = await _apiClient.get('/settings');

    final envelope = ApiResponseEnvelope<TenantSettingsModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => TenantSettingsModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }

  @override
  Future<TenantSettingsModel> updateSettings(
    UpdateTenantSettingsParams params,
  ) async {
    final response = await _apiClient.put(
      '/settings',
      data: {
        'name': params.name,
        'nameEn': params.nameEn,
        'phone': params.phone,
        'email': params.email,
        'address': params.address,
        'city': params.city,
        'governorate': params.governorate,
        'taxNumber': params.taxNumber,
      },
    );

    final envelope = ApiResponseEnvelope<TenantSettingsModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => TenantSettingsModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }
}
