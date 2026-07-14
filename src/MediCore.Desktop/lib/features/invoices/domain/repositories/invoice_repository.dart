import '../entities/invoice.dart';
import '../entities/create_invoice_params.dart';
import '../entities/record_payment_params.dart';

abstract class InvoiceRepository {
  Future<Invoice> getById(String id);
  Future<List<Invoice>> getByPatient(String patientId);
  Future<Invoice> create(CreateInvoiceParams params);
  Future<Invoice> recordPayment(String invoiceId, RecordPaymentParams params);
}
