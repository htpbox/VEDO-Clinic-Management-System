import '../../../../core/api/api_client.dart';
import '../../../../core/network/api_response_envelope.dart';
import '../../domain/entities/create_staff_params.dart';
import '../../domain/entities/update_staff_params.dart';
import '../models/staff_member_model.dart';

abstract class StaffRemoteDataSource {
  Future<List<StaffMemberModel>> getDoctors();
  Future<List<StaffMemberModel>> getAll();
  Future<StaffMemberModel> create(CreateStaffParams params);
  Future<StaffMemberModel> update(String id, UpdateStaffParams params);
  Future<StaffMemberModel> setActiveStatus(String id, bool isActive);
}

class StaffRemoteDataSourceImpl implements StaffRemoteDataSource {
  final ApiClient _apiClient;

  const StaffRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<StaffMemberModel>> getDoctors() async {
    final response = await _apiClient.get('/staff/doctors');

    final envelope = ApiResponseEnvelope<List<StaffMemberModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) => StaffMemberModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    return envelope.data ?? [];
  }

  @override
  Future<List<StaffMemberModel>> getAll() async {
    final response = await _apiClient.get('/staff');

    final envelope = ApiResponseEnvelope<List<StaffMemberModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) => StaffMemberModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    return envelope.data ?? [];
  }

  @override
  Future<StaffMemberModel> create(CreateStaffParams params) async {
    final response = await _apiClient.post(
      '/staff',
      data: {
        'fullName': params.fullName,
        'email': params.email,
        'password': params.password,
        'phone': params.phone,
        'role': params.role,
      },
    );

    final envelope = ApiResponseEnvelope<StaffMemberModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => StaffMemberModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }

  @override
  Future<StaffMemberModel> update(String id, UpdateStaffParams params) async {
    final response = await _apiClient.put(
      '/staff/$id',
      data: {
        'fullName': params.fullName,
        'phone': params.phone,
        'role': params.role,
      },
    );

    final envelope = ApiResponseEnvelope<StaffMemberModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => StaffMemberModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }

  @override
  Future<StaffMemberModel> setActiveStatus(String id, bool isActive) async {
    final path = isActive ? '/staff/$id/activate' : '/staff/$id/deactivate';
    final response = await _apiClient.put(path);

    final envelope = ApiResponseEnvelope<StaffMemberModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => StaffMemberModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }
}
