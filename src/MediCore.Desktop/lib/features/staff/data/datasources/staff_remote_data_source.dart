import '../../../../core/api/api_client.dart';
import '../../../../core/network/api_response_envelope.dart';
import '../models/staff_member_model.dart';

abstract class StaffRemoteDataSource {
  Future<List<StaffMemberModel>> getDoctors();
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
}
