import '../../domain/entities/pharmacy_sale.dart';
import '../../domain/repositories/pharmacy_repository.dart';
import '../datasources/pharmacy_remote_data_source.dart';

class PharmacyRepositoryImpl implements PharmacyRepository {
  final PharmacyRemoteDataSource _remoteDataSource;

  const PharmacyRepositoryImpl(this._remoteDataSource);

  @override
  Future<PharmacySale> createSale({
    required String warehouseId,
    String? patientId,
    String? prescriptionId,
    required String saleType,
    required bool createInvoice,
    required List<PharmacyCartLine> items,
  }) async {
    final model = await _remoteDataSource.createSale({
      'warehouseId': warehouseId,
      'patientId': patientId,
      'prescriptionId': prescriptionId,
      'saleType': saleType,
      'createInvoice': createInvoice,
      'items': items
          .map((line) => {
                'itemId': line.itemId,
                'quantity': line.quantity,
                'unitPrice': line.unitPrice,
                'prescriptionItemId': line.prescriptionItemId,
              })
          .toList(),
    });
    return model.toEntity();
  }

  @override
  Future<PharmacySale> getById(String id) async {
    final model = await _remoteDataSource.getById(id);
    return model.toEntity();
  }

  @override
  Future<List<PharmacySale>> getByPatient(String patientId) async {
    final models = await _remoteDataSource.getByPatient(patientId);
    return models.map((m) => m.toEntity()).toList();
  }
}
