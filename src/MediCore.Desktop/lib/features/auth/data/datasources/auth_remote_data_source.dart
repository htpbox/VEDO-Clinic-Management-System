import '../../../../core/api/api_client.dart';
import '../../../../core/network/api_response_envelope.dart';
import '../models/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  const AuthRemoteDataSourceImpl(this._apiClient);

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    final envelope = ApiResponseEnvelope<LoginResponseModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => LoginResponseModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }
}
