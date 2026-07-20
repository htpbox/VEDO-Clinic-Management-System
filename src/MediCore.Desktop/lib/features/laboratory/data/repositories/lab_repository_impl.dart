import '../../domain/entities/lab_order.dart';
import '../../domain/repositories/lab_repository.dart';
import '../datasources/lab_remote_data_source.dart';

class LabRepositoryImpl implements LabRepository {
  final LabRemoteDataSource _remoteDataSource;

  const LabRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<LabTestCatalogEntry>> getCatalog() => _remoteDataSource.getCatalog();

  @override
  Future<LabOrder> createOrder({
    required String patientId,
    String? encounterId,
    String? clinicalNotes,
    required List<String> labTestCatalogIds,
    required bool createInvoice,
  }) async {
    final model = await _remoteDataSource.createOrder({
      'patientId': patientId,
      'encounterId': encounterId,
      'clinicalNotes': clinicalNotes,
      'labTestCatalogIds': labTestCatalogIds,
      'createInvoice': createInvoice,
    });
    return model.toEntity();
  }

  @override
  Future<LabOrder> getById(String id) async {
    final model = await _remoteDataSource.getById(id);
    return model.toEntity();
  }

  @override
  Future<List<LabOrder>> getByPatient(String patientId) async {
    final models = await _remoteDataSource.getByPatient(patientId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<LabOrder>> getPendingOrders() async {
    final models = await _remoteDataSource.getPendingOrders();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<LabOrder> enterResult({
    required String labOrderItemId,
    double? numericValue,
    String? textValue,
  }) async {
    final model = await _remoteDataSource.enterResult({
      'labOrderItemId': labOrderItemId,
      'numericValue': numericValue,
      'textValue': textValue,
    });
    return model.toEntity();
  }

  @override
  Future<LabOrder> reviewResult({
    required String labOrderItemId,
    String? doctorComment,
  }) async {
    final model = await _remoteDataSource.reviewResult(labOrderItemId, {
      'doctorComment': doctorComment,
    });
    return model.toEntity();
  }
}
