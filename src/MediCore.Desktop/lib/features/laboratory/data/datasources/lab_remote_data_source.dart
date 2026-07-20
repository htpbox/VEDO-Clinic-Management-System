import '../../../../core/api/api_client.dart';
import '../../../../core/network/api_response_envelope.dart';
import '../models/lab_order_model.dart';

class LabRemoteDataSource {
  final ApiClient _apiClient;

  const LabRemoteDataSource(this._apiClient);

  Future<List<LabTestCatalogEntryModel>> getCatalog() async {
    final response = await _apiClient.get('/lab/catalog');
    final envelope = ApiResponseEnvelope<List<LabTestCatalogEntryModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) => LabTestCatalogEntryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    return envelope.data ?? [];
  }

  Future<LabOrderModel> createOrder(Map<String, dynamic> body) async {
    final response = await _apiClient.post('/lab/orders', data: body);
    final envelope = ApiResponseEnvelope<LabOrderModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => LabOrderModel.fromJson(json as Map<String, dynamic>),
    );
    return envelope.data!;
  }

  Future<LabOrderModel> getById(String id) async {
    final response = await _apiClient.get('/lab/orders/$id');
    final envelope = ApiResponseEnvelope<LabOrderModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => LabOrderModel.fromJson(json as Map<String, dynamic>),
    );
    return envelope.data!;
  }

  Future<List<LabOrderModel>> getByPatient(String patientId) async {
    final response = await _apiClient.get('/lab/orders/patient/$patientId');
    final envelope = ApiResponseEnvelope<List<LabOrderModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) => LabOrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    return envelope.data ?? [];
  }

  Future<List<LabOrderModel>> getPendingOrders() async {
    final response = await _apiClient.get('/lab/orders/pending');
    final envelope = ApiResponseEnvelope<List<LabOrderModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) => LabOrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    return envelope.data ?? [];
  }

  Future<LabOrderModel> enterResult(Map<String, dynamic> body) async {
    final response = await _apiClient.post('/lab/results', data: body);
    final envelope = ApiResponseEnvelope<LabOrderModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => LabOrderModel.fromJson(json as Map<String, dynamic>),
    );
    return envelope.data!;
  }

  Future<LabOrderModel> reviewResult(String labOrderItemId, Map<String, dynamic> body) async {
    final response = await _apiClient.post('/lab/results/$labOrderItemId/review', data: body);
    final envelope = ApiResponseEnvelope<LabOrderModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => LabOrderModel.fromJson(json as Map<String, dynamic>),
    );
    return envelope.data!;
  }
}
