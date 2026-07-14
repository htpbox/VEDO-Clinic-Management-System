import '../../../../core/api/api_client.dart';
import '../../../../core/network/api_response_envelope.dart';
import '../../domain/entities/create_encounter_params.dart';
import '../../domain/entities/update_encounter_params.dart';
import '../models/encounter_model.dart';

abstract class EncounterRemoteDataSource {
  Future<EncounterModel> getById(String id);
  Future<List<EncounterModel>> getByPatient(String patientId);
  Future<EncounterModel> create(CreateEncounterParams params);
  Future<EncounterModel> update(String id, UpdateEncounterParams params);
  Future<EncounterModel> close(String id);
}

class EncounterRemoteDataSourceImpl implements EncounterRemoteDataSource {
  final ApiClient _apiClient;

  const EncounterRemoteDataSourceImpl(this._apiClient);

  @override
  Future<EncounterModel> getById(String id) async {
    final response = await _apiClient.get('/encounters/$id');

    final envelope = ApiResponseEnvelope<EncounterModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => EncounterModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }

  @override
  Future<List<EncounterModel>> getByPatient(String patientId) async {
    final response = await _apiClient.get('/encounters/patient/$patientId');

    final envelope = ApiResponseEnvelope<List<EncounterModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) => EncounterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    return envelope.data ?? [];
  }

  @override
  Future<EncounterModel> create(CreateEncounterParams params) async {
    final response = await _apiClient.post(
      '/encounters',
      data: {
        'patientId': params.patientId,
        'appointmentId': params.appointmentId,
        'encounterType': params.encounterType,
        'chiefComplaint': params.chiefComplaint,
      },
    );

    final envelope = ApiResponseEnvelope<EncounterModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => EncounterModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }

  @override
  Future<EncounterModel> update(String id, UpdateEncounterParams params) async {
    final response = await _apiClient.put(
      '/encounters/$id',
      data: {
        'chiefComplaint': params.chiefComplaint,
        'hpi': params.hpi,
        'physicalExam': params.physicalExam,
        'clinicalNotes': params.clinicalNotes,
        'treatmentPlan': params.treatmentPlan,
        'followUpDate': params.followUpDate?.toIso8601String(),
        'followUpNotes': params.followUpNotes,
      },
    );

    final envelope = ApiResponseEnvelope<EncounterModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => EncounterModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }

  @override
  Future<EncounterModel> close(String id) async {
    final response = await _apiClient.put('/encounters/$id/close');

    final envelope = ApiResponseEnvelope<EncounterModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => EncounterModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }
}
