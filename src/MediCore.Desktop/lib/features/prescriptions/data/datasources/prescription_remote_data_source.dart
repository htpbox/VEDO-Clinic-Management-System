import '../../../../core/api/api_client.dart';
import '../../../../core/network/api_response_envelope.dart';
import '../../domain/entities/create_prescription_params.dart';
import '../models/prescription_model.dart';

abstract class PrescriptionRemoteDataSource {
  Future<PrescriptionModel> getById(String id);
  Future<List<PrescriptionModel>> getByPatient(String patientId);
  Future<PrescriptionModel> create(CreatePrescriptionParams params);
}

class PrescriptionRemoteDataSourceImpl implements PrescriptionRemoteDataSource {
  final ApiClient _apiClient;

  const PrescriptionRemoteDataSourceImpl(this._apiClient);

  @override
  Future<PrescriptionModel> getById(String id) async {
    final response = await _apiClient.get('/prescriptions/$id');

    final envelope = ApiResponseEnvelope<PrescriptionModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => PrescriptionModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }

  @override
  Future<List<PrescriptionModel>> getByPatient(String patientId) async {
    final response = await _apiClient.get('/prescriptions/patient/$patientId');

    final envelope = ApiResponseEnvelope<List<PrescriptionModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) => PrescriptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    return envelope.data ?? [];
  }

  @override
  Future<PrescriptionModel> create(CreatePrescriptionParams params) async {
    final response = await _apiClient.post(
      '/prescriptions',
      data: {
        'encounterId': params.encounterId,
        'patientId': params.patientId,
        'notes': params.notes,
        'items': params.items
            .map(
              (item) => {
                'drugName': item.drugName,
                'activeIngredient': item.activeIngredient,
                'dose': item.dose,
                'frequency': item.frequency,
                'route': item.route,
                'durationDays': item.durationDays,
                'quantity': item.quantity,
                'instructions': item.instructions,
              },
            )
            .toList(),
      },
    );

    final envelope = ApiResponseEnvelope<PrescriptionModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => PrescriptionModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }
}
