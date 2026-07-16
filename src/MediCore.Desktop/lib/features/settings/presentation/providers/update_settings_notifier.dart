import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/settings_di.dart';
import '../../domain/entities/tenant_settings.dart';
import '../../domain/entities/update_tenant_settings_params.dart';

enum UpdateSettingsStatus { initial, loading, success, error }

class UpdateSettingsState {
  final UpdateSettingsStatus status;
  final String? errorMessage;

  const UpdateSettingsState({
    this.status = UpdateSettingsStatus.initial,
    this.errorMessage,
  });

  bool get isLoading => status == UpdateSettingsStatus.loading;
}

class UpdateSettingsNotifier extends StateNotifier<UpdateSettingsState> {
  final Ref _ref;

  UpdateSettingsNotifier(this._ref) : super(const UpdateSettingsState());

  Future<TenantSettings?> submit(UpdateTenantSettingsParams params) async {
    state = const UpdateSettingsState(status: UpdateSettingsStatus.loading);
    try {
      final useCase = _ref.read(updateSettingsUseCaseProvider);
      final settings = await useCase.execute(params);
      state = const UpdateSettingsState(status: UpdateSettingsStatus.success);
      return settings;
    } catch (e) {
      state = UpdateSettingsState(
        status: UpdateSettingsStatus.error,
        errorMessage: e.toString(),
      );
      return null;
    }
  }
}

final updateSettingsNotifierProvider = StateNotifierProvider.autoDispose<
  UpdateSettingsNotifier,
  UpdateSettingsState
>((ref) => UpdateSettingsNotifier(ref));
