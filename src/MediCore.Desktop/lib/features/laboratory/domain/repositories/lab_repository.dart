import '../entities/lab_order.dart';

abstract class LabRepository {
  Future<List<LabTestCatalogEntry>> getCatalog();

  Future<LabOrder> createOrder({
    required String patientId,
    String? encounterId,
    String? clinicalNotes,
    required List<String> labTestCatalogIds,
    required bool createInvoice,
  });

  Future<LabOrder> getById(String id);
  Future<List<LabOrder>> getByPatient(String patientId);
  Future<List<LabOrder>> getPendingOrders();

  Future<LabOrder> enterResult({
    required String labOrderItemId,
    double? numericValue,
    String? textValue,
  });

  Future<LabOrder> reviewResult({
    required String labOrderItemId,
    String? doctorComment,
  });
}
