import '../../../../core/api/api_client.dart';
import '../../../../core/network/api_response_envelope.dart';
import '../../domain/entities/create_invoice_params.dart';
import '../../domain/entities/record_payment_params.dart';
import '../models/invoice_model.dart';

abstract class InvoiceRemoteDataSource {
  Future<InvoiceModel> getById(String id);
  Future<List<InvoiceModel>> getByPatient(String patientId);
  Future<InvoiceModel> create(CreateInvoiceParams params);
  Future<InvoiceModel> recordPayment(
    String invoiceId,
    RecordPaymentParams params,
  );
}

class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  final ApiClient _apiClient;

  const InvoiceRemoteDataSourceImpl(this._apiClient);

  @override
  Future<InvoiceModel> getById(String id) async {
    final response = await _apiClient.get('/invoices/$id');

    final envelope = ApiResponseEnvelope<InvoiceModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => InvoiceModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }

  @override
  Future<List<InvoiceModel>> getByPatient(String patientId) async {
    final response = await _apiClient.get('/invoices/patient/$patientId');

    final envelope = ApiResponseEnvelope<List<InvoiceModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    return envelope.data ?? [];
  }

  @override
  Future<InvoiceModel> create(CreateInvoiceParams params) async {
    final response = await _apiClient.post(
      '/invoices',
      data: {
        'patientId': params.patientId,
        'encounterId': params.encounterId,
        'discountAmount': params.discountAmount,
        'notes': params.notes,
        'items': params.items
            .map(
              (item) => {
                'description': item.description,
                'quantity': item.quantity,
                'unitPrice': item.unitPrice,
              },
            )
            .toList(),
      },
    );

    final envelope = ApiResponseEnvelope<InvoiceModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => InvoiceModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }

  @override
  Future<InvoiceModel> recordPayment(
    String invoiceId,
    RecordPaymentParams params,
  ) async {
    final response = await _apiClient.post(
      '/invoices/$invoiceId/payments',
      data: {
        'amount': params.amount,
        'paymentMethod': params.paymentMethod,
        'referenceNumber': params.referenceNumber,
        'notes': params.notes,
      },
    );

    final envelope = ApiResponseEnvelope<InvoiceModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => InvoiceModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }
}
