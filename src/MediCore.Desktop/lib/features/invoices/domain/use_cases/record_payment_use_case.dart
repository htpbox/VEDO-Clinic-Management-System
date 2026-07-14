import '../entities/invoice.dart';
import '../entities/record_payment_params.dart';
import '../repositories/invoice_repository.dart';

class RecordPaymentUseCase {
  final InvoiceRepository repository;

  const RecordPaymentUseCase(this.repository);

  Future<Invoice> execute(String invoiceId, RecordPaymentParams params) {
    return repository.recordPayment(invoiceId, params);
  }
}
