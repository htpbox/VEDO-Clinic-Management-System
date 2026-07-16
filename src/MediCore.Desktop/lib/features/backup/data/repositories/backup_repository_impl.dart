import '../../domain/entities/backup_file.dart';
import '../../domain/repositories/backup_repository.dart';
import '../datasources/backup_remote_data_source.dart';

class BackupRepositoryImpl implements BackupRepository {
  final BackupRemoteDataSource _remoteDataSource;

  const BackupRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<BackupFile>> list() async {
    final models = await _remoteDataSource.list();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<BackupFile> create() async {
    final model = await _remoteDataSource.create();
    return model.toEntity();
  }

  @override
  Future<List<int>> download(String fileName) =>
      _remoteDataSource.download(fileName);

  @override
  Future<void> restore(String fileName, String confirmationPhrase) =>
      _remoteDataSource.restore(fileName, confirmationPhrase);

  @override
  Future<void> delete(String fileName) => _remoteDataSource.delete(fileName);
}
