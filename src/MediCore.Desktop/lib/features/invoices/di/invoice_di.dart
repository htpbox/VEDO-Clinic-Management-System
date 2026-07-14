import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../data/datasources/invoice_remote_data_source.dart';
import '../data/repositories/invoice_repository_impl.dart';
import '../domain/repositories/invoice_repository.dart';
import '../domain/use_cases/create_invoice_use_case.dart';
import '../domain/use_cases/get_patient_invoices_use_case.dart';
import '../domain/use_cases/record_payment_use_case.dart';

final invoiceRemoteDataSourceProvider = Provider<InvoiceRemoteDataSource>(
  (ref) => InvoiceRemoteDataSourceImpl(ApiClient.instance),
);

final invoiceRepositoryProvider = Provider<InvoiceRepository>(
  (ref) => InvoiceRepositoryImpl(ref.read(invoiceRemoteDataSourceProvider)),
);

final createInvoiceUseCaseProvider = Provider<CreateInvoiceUseCase>(
  (ref) => CreateInvoiceUseCase(ref.read(invoiceRepositoryProvider)),
);

final getPatientInvoicesUseCaseProvider = Provider<GetPatientInvoicesUseCase>(
  (ref) => GetPatientInvoicesUseCase(ref.read(invoiceRepositoryProvider)),
);

final recordPaymentUseCaseProvider = Provider<RecordPaymentUseCase>(
  (ref) => RecordPaymentUseCase(ref.read(invoiceRepositoryProvider)),
);
