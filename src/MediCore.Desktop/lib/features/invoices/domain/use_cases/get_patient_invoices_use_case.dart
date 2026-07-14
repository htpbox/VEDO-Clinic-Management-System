import '../entities/invoice.dart';
import '../repositories/invoice_repository.dart';

class GetPatientInvoicesUseCase {
  final InvoiceRepository repository;

  const GetPatientInvoicesUseCase(this.repository);

  Future<List<Invoice>> execute(String patientId) {
    return repository.getByPatient(patientId);
  }
}
