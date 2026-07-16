class BackupFile {
  final String fileName;
  final int sizeBytes;
  final DateTime createdAt;

  const BackupFile({
    required this.fileName,
    required this.sizeBytes,
    required this.createdAt,
  });

  String get sizeLabel {
    final mb = sizeBytes / (1024 * 1024);
    if (mb >= 1) return '${mb.toStringAsFixed(1)} MB';
    return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
  }
}
