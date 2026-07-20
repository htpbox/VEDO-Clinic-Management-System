import '../../../../core/api/api_client.dart';
import '../../../../core/network/api_response_envelope.dart';
import '../models/pharmacy_sale_model.dart';

class PharmacyRemoteDataSource {
  final ApiClient _apiClient;

  const PharmacyRemoteDataSource(this._apiClient);

  Future<PharmacySaleModel> createSale(Map<String, dynamic> body) async {
    final response = await _apiClient.post('/pharmacy/sales', data: body);
    final envelope = ApiResponseEnvelope<PharmacySaleModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => PharmacySaleModel.fromJson(json as Map<String, dynamic>),
    );
    return envelope.data!;
  }

  Future<PharmacySaleModel> getById(String id) async {
    final response = await _apiClient.get('/pharmacy/sales/$id');
    final envelope = ApiResponseEnvelope<PharmacySaleModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => PharmacySaleModel.fromJson(json as Map<String, dynamic>),
    );
    return envelope.data!;
  }

  Future<List<PharmacySaleModel>> getByPatient(String patientId) async {
    final response = await _apiClient.get('/pharmacy/sales/patient/$patientId');
    final envelope = ApiResponseEnvelope<List<PharmacySaleModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) => PharmacySaleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    return envelope.data ?? [];
  }
}
