import '../entities/invoice.dart';
import '../entities/create_invoice_params.dart';
import '../repositories/invoice_repository.dart';

class CreateInvoiceUseCase {
  final InvoiceRepository repository;

  const CreateInvoiceUseCase(this.repository);

  Future<Invoice> execute(CreateInvoiceParams params) {
    return repository.create(params);
  }
}
