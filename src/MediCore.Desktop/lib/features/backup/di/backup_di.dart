import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../data/datasources/backup_remote_data_source.dart';
import '../data/repositories/backup_repository_impl.dart';
import '../domain/entities/backup_file.dart';
import '../domain/repositories/backup_repository.dart';

final backupRemoteDataSourceProvider = Provider<BackupRemoteDataSource>(
  (ref) => BackupRemoteDataSourceImpl(ApiClient.instance),
);

final backupRepositoryProvider = Provider<BackupRepository>(
  (ref) => BackupRepositoryImpl(ref.read(backupRemoteDataSourceProvider)),
);

final backupListProvider = FutureProvider.autoDispose<List<BackupFile>>((
  ref,
) async {
  return ref.read(backupRepositoryProvider).list();
});
