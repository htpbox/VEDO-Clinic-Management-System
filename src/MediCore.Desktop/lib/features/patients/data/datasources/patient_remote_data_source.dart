import '../../../../core/api/api_client.dart';
import '../../../../core/network/api_response_envelope.dart';
import '../../domain/entities/create_patient_params.dart';
import '../../domain/entities/update_patient_params.dart';
import '../models/patient_model.dart';

abstract class PatientRemoteDataSource {
  Future<List<PatientModel>> search(String searchTerm);
  Future<PatientModel> getById(String id);
  Future<PatientModel> create(CreatePatientParams params);
  Future<PatientModel> update(String id, UpdatePatientParams params);
  Future<void> delete(String id);
}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final ApiClient _apiClient;

  const PatientRemoteDataSourceImpl(this._apiClient);

  @override
  Future<void> delete(String id) async {
    await _apiClient.delete('/patients/$id');
  }

  @override
  Future<List<PatientModel>> search(String searchTerm) async {
    final response = await _apiClient.get(
      '/patients/search',
      params: {'searchTerm': searchTerm},
    );

    final body = response.data as Map<String, dynamic>;
    final envelope = ApiResponseEnvelope<List<PatientModel>>.fromJson(
      body,
      (json) => (json as List<dynamic>)
          .map((e) => PatientModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    return envelope.data ?? [];
  }

  @override
  Future<PatientModel> getById(String id) async {
    final response = await _apiClient.get('/patients/$id');

    final envelope = ApiResponseEnvelope<PatientModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => PatientModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }

  @override
  Future<PatientModel> create(CreatePatientParams params) async {
    final response = await _apiClient.post(
      '/patients',
      data: {
        'fullName': params.fullName,
        'gender': params.gender,
        'dateOfBirth': params.dateOfBirth?.toIso8601String(),
        'nationalId': params.nationalId,
        'phone': params.phone,
        'phoneSecondary': params.phoneSecondary,
        'email': params.email,
        'address': params.address,
        'governorate': params.governorate,
        'bloodType': params.bloodType,
        'emergencyContactName': params.emergencyContactName,
        'emergencyContactPhone': params.emergencyContactPhone,
        'emergencyContactRelation': params.emergencyContactRelation,
        'insuranceCompany': params.insuranceCompany,
        'insuranceNumber': params.insuranceNumber,
        'insuranceExpiry': params.insuranceExpiry?.toIso8601String(),
        'notes': params.notes,
      },
    );

    final envelope = ApiResponseEnvelope<PatientModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => PatientModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }

  @override
  Future<PatientModel> update(String id, UpdatePatientParams params) async {
    final response = await _apiClient.put(
      '/patients/$id',
      data: {
        'fullName': params.fullName,
        'dateOfBirth': params.dateOfBirth?.toIso8601String(),
        'phone': params.phone,
        'phoneSecondary': params.phoneSecondary,
        'email': params.email,
        'address': params.address,
        'governorate': params.governorate,
        'bloodType': params.bloodType,
        'emergencyContactName': params.emergencyContactName,
        'emergencyContactPhone': params.emergencyContactPhone,
        'emergencyContactRelation': params.emergencyContactRelation,
        'insuranceCompany': params.insuranceCompany,
        'insuranceNumber': params.insuranceNumber,
        'insuranceExpiry': params.insuranceExpiry?.toIso8601String(),
        'notes': params.notes,
      },
    );

    final envelope = ApiResponseEnvelope<PatientModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => PatientModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }
}
