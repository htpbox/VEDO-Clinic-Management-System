import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../di/backup_di.dart';
import '../../domain/entities/backup_file.dart';

class BackupScreen extends ConsumerWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backupsAsync = ref.watch(backupListProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'النسخ الاحتياطي والاستعادة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  try {
                    await ref.read(backupRepositoryProvider).create();
                    ref.invalidate(backupListProvider);
                    messenger.showSnackBar(
                      const SnackBar(content: Text('تم إنشاء نسخة احتياطية جديدة')),
                    );
                  } catch (e) {
                    messenger.showSnackBar(
                      SnackBar(content: Text('فشل إنشاء النسخة الاحتياطية: $e')),
                    );
                  }
                },
                icon: const Icon(Icons.backup_outlined, size: 18),
                label: const Text('إنشاء نسخة احتياطية الآن'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'تنبيه: عملية الاستعادة تستبدل البيانات الحالية بالكامل ولا يمكن التراجع عنها.',
            style: TextStyle(fontSize: 12, color: AppTheme.errorColor),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: backupsAsync.when(
              data: (backups) => _BackupList(backups: backups),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => const Center(
                child: Text(
                  'تعذر تحميل قائمة النسخ الاحتياطية',
                  style: TextStyle(color: AppTheme.errorColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackupList extends ConsumerWidget {
  final List<BackupFile> backups;

  const _BackupList({required this.backups});

  Future<void> _download(BuildContext context, WidgetRef ref, BackupFile backup) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final bytes = await ref
          .read(backupRepositoryProvider)
          .download(backup.fileName);
      final downloadsDir =
          Platform.environment['USERPROFILE'] ?? Platform.environment['HOME'] ?? '.';
      final savePath = '$downloadsDir${Platform.pathSeparator}Downloads${Platform.pathSeparator}${backup.fileName}';
      final file = File(savePath);
      await file.create(recursive: true);
      await file.writeAsBytes(bytes);
      messenger.showSnackBar(SnackBar(content: Text('تم الحفظ في: $savePath')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('فشل التنزيل: $e')));
    }
  }

  Future<void> _restore(BuildContext context, WidgetRef ref, BackupFile backup) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الاستعادة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'سيتم استبدال جميع البيانات الحالية بمحتوى هذه النسخة الاحتياطية. '
              'اكتب RESTORE للتأكيد.',
            ),
            const SizedBox(height: 12),
            TextField(controller: controller),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            child: const Text('استعادة'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(backupRepositoryProvider)
          .restore(backup.fileName, controller.text.trim());
      messenger.showSnackBar(const SnackBar(content: Text('تمت عملية الاستعادة بنجاح')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('فشلت عملية الاستعادة: $e')));
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, BackupFile backup) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف النسخة الاحتياطية'),
        content: Text('هل تريد حذف ${backup.fileName}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.errorColor),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(backupRepositoryProvider).delete(backup.fileName);
      ref.invalidate(backupListProvider);
      messenger.showSnackBar(const SnackBar(content: Text('تم حذف النسخة الاحتياطية')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('فشل الحذف: $e')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (backups.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد نسخ احتياطية بعد',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      );
    }

    return ListView.separated(
      itemCount: backups.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final backup = backups[index];
        return ListTile(
          leading: const Icon(Icons.description_outlined, color: AppTheme.primaryColor),
          title: Text(backup.fileName),
          subtitle: Text('${backup.sizeLabel} • ${backup.createdAt.toLocal()}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'تنزيل',
                icon: const Icon(Icons.download_outlined),
                onPressed: () => _download(context, ref, backup),
              ),
              IconButton(
                tooltip: 'استعادة',
                icon: const Icon(Icons.restore_outlined),
                onPressed: () => _restore(context, ref, backup),
              ),
              IconButton(
                tooltip: 'حذف',
                icon: const Icon(Icons.delete_outline, color: AppTheme.errorColor),
                onPressed: () => _delete(context, ref, backup),
              ),
            ],
          ),
        );
      },
    );
  }
}
