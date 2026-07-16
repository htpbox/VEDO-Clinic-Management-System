import '../entities/backup_file.dart';

abstract class BackupRepository {
  Future<List<BackupFile>> list();
  Future<BackupFile> create();
  Future<List<int>> download(String fileName);
  Future<void> restore(String fileName, String confirmationPhrase);
  Future<void> delete(String fileName);
}
