import '../../domain/entities/invoice.dart';
import '../../domain/entities/create_invoice_params.dart';
import '../../domain/entities/record_payment_params.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../datasources/invoice_remote_data_source.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource _remoteDataSource;

  const InvoiceRepositoryImpl(this._remoteDataSource);

  @override
  Future<Invoice> getById(String id) async {
    final model = await _remoteDataSource.getById(id);
    return model.toEntity();
  }

  @override
  Future<List<Invoice>> getByPatient(String patientId) async {
    final models = await _remoteDataSource.getByPatient(patientId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Invoice> create(CreateInvoiceParams params) async {
    final model = await _remoteDataSource.create(params);
    return model.toEntity();
  }

  @override
  Future<Invoice> recordPayment(
    String invoiceId,
    RecordPaymentParams params,
  ) async {
    final model = await _remoteDataSource.recordPayment(invoiceId, params);
    return model.toEntity();
  }
}
