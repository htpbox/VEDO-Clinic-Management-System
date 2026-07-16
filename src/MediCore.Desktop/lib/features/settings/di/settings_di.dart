import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../data/datasources/settings_remote_data_source.dart';
import '../data/repositories/settings_repository_impl.dart';
import '../domain/entities/tenant_settings.dart';
import '../domain/repositories/settings_repository.dart';
import '../domain/use_cases/get_settings_use_case.dart';
import '../domain/use_cases/update_settings_use_case.dart';

final settingsRemoteDataSourceProvider = Provider<SettingsRemoteDataSource>(
  (ref) => SettingsRemoteDataSourceImpl(ApiClient.instance),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepositoryImpl(ref.read(settingsRemoteDataSourceProvider)),
);

final getSettingsUseCaseProvider = Provider<GetSettingsUseCase>(
  (ref) => GetSettingsUseCase(ref.read(settingsRepositoryProvider)),
);

final updateSettingsUseCaseProvider = Provider<UpdateSettingsUseCase>(
  (ref) => UpdateSettingsUseCase(ref.read(settingsRepositoryProvider)),
);

final settingsProvider = FutureProvider<TenantSettings>((ref) async {
  final useCase = ref.read(getSettingsUseCaseProvider);
  return useCase.execute();
});
