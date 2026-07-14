import '../storage/storage_service.dart';

class CurrentTenant {
  CurrentTenant._();
  static final CurrentTenant instance = CurrentTenant._();

  String? _tenantId;
  String? _tenantName;

  String? get tenantId => _tenantId;
  String? get tenantName => _tenantName;

  Future<void> load() async {
    _tenantId = await StorageService.instance.getTenantId();
  }

  Future<void> save({
    required String tenantId,
    required String tenantName,
  }) async {
    _tenantId = tenantId;
    _tenantName = tenantName;
    await StorageService.instance.saveTenantId(tenantId);
  }

  Future<void> clear() async {
    _tenantId = null;
    _tenantName = null;
  }
}
