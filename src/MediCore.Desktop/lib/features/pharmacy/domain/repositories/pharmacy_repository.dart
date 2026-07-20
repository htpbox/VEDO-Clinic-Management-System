import '../entities/pharmacy_sale.dart';

abstract class PharmacyRepository {
  Future<PharmacySale> createSale({
    required String warehouseId,
    String? patientId,
    String? prescriptionId,
    required String saleType,
    required bool createInvoice,
    required List<PharmacyCartLine> items,
  });

  Future<PharmacySale> getById(String id);
  Future<List<PharmacySale>> getByPatient(String patientId);
}
