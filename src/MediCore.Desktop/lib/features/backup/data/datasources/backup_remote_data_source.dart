import '../../../../core/api/api_client.dart';
import '../../../../core/network/api_response_envelope.dart';
import '../models/backup_file_model.dart';

abstract class BackupRemoteDataSource {
  Future<List<BackupFileModel>> list();
  Future<BackupFileModel> create();
  Future<List<int>> download(String fileName);
  Future<void> restore(String fileName, String confirmationPhrase);
  Future<void> delete(String fileName);
}

class BackupRemoteDataSourceImpl implements BackupRemoteDataSource {
  final ApiClient _apiClient;

  const BackupRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<BackupFileModel>> list() async {
    final response = await _apiClient.get('/backup');

    final envelope = ApiResponseEnvelope<List<BackupFileModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) => BackupFileModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

    return envelope.data ?? [];
  }

  @override
  Future<BackupFileModel> create() async {
    final response = await _apiClient.post('/backup');

    final envelope = ApiResponseEnvelope<BackupFileModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => BackupFileModel.fromJson(json as Map<String, dynamic>),
    );

    return envelope.data!;
  }

  @override
  Future<List<int>> download(String fileName) async {
    final response = await _apiClient.download('/backup/$fileName/download');
    return response.data ?? [];
  }

  @override
  Future<void> restore(String fileName, String confirmationPhrase) async {
    await _apiClient.post(
      '/backup/$fileName/restore',
      data: {'confirmationPhrase': confirmationPhrase},
    );
  }

  @override
  Future<void> delete(String fileName) async {
    await _apiClient.delete('/backup/$fileName');
  }
}
