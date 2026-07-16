import '../../domain/entities/backup_file.dart';

class BackupFileModel extends BackupFile {
  const BackupFileModel({
    required super.fileName,
    required super.sizeBytes,
    required super.createdAt,
  });

  factory BackupFileModel.fromJson(Map<String, dynamic> json) {
    return BackupFileModel(
      fileName: json['fileName'] as String,
      sizeBytes: (json['sizeBytes'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  BackupFile toEntity() => this;
}
