import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/domain/enums/user_role.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../di/lab_di.dart';
import '../../domain/entities/lab_order.dart';

class LabWorklistScreen extends ConsumerWidget {
  const LabWorklistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(pendingLabOrdersProvider);
    final role = ref.watch(authNotifierProvider).user?.role;
    final canReview = role == UserRole.doctor ||
        role == UserRole.seniorDoctor ||
        role == UserRole.superAdmin ||
        role == UserRole.clinicAdmin;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(
              child: Text('لا توجد طلبات تحاليل معلقة', style: TextStyle(color: AppTheme.textSecondary)),
            );
          }
          return ListView.separated(
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _LabOrderCard(order: orders[index], canReview: canReview),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(
          child: Text('تعذر تحميل طلبات التحاليل', style: TextStyle(color: AppTheme.errorColor)),
        ),
      ),
    );
  }
}

class _LabOrderCard extends StatelessWidget {
  final LabOrder order;
  final bool canReview;

  const _LabOrderCard({required this.order, required this.canReview});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'طلب رقم: ${order.id.substring(0, 8)}',
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                Text(
                  '${order.orderedAt.year}-${order.orderedAt.month.toString().padLeft(2, '0')}-${order.orderedAt.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
            if (order.clinicalNotes != null && order.clinicalNotes!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(order.clinicalNotes!, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
            ],
            const Divider(),
            for (final item in order.items) _LabOrderItemRow(item: item, canReview: canReview),
          ],
        ),
      ),
    );
  }
}

class _LabOrderItemRow extends ConsumerWidget {
  final LabOrderItem item;
  final bool canReview;

  const _LabOrderItemRow({required this.item, required this.canReview});

  Color _flagColor(String flag) {
    switch (flag) {
      case 'Critical':
        return AppTheme.errorColor;
      case 'Low':
      case 'High':
        return AppTheme.warningColor;
      default:
        return AppTheme.secondaryColor;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = item.result;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(item.testName),
      subtitle: result == null
          ? const Text('لم يتم إدخال النتيجة بعد', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary))
          : Row(
              children: [
                Text(
                  result.textValue ?? result.numericValue?.toString() ?? '-',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (item.unit != null) Text(' ${item.unit}', style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _flagColor(result.flag).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    result.flag,
                    style: TextStyle(color: _flagColor(result.flag), fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
                if (result.reviewedByDoctor) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.verified_outlined, size: 14, color: AppTheme.secondaryColor),
                ],
              ],
            ),
      trailing: result == null
          ? TextButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => _EnterResultDialog(item: item),
              ),
              child: const Text('إدخال نتيجة'),
            )
          : (canReview && !result.reviewedByDoctor)
              ? TextButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => _ReviewResultDialog(item: item),
                  ),
                  child: const Text('مراجعة'),
                )
              : null,
    );
  }
}

class _EnterResultDialog extends ConsumerStatefulWidget {
  final LabOrderItem item;

  const _EnterResultDialog({required this.item});

  @override
  ConsumerState<_EnterResultDialog> createState() => _EnterResultDialogState();
}

class _EnterResultDialogState extends ConsumerState<_EnterResultDialog> {
  final _valueController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final numeric = double.tryParse(_valueController.text);
      await ref.read(labRepositoryProvider).enterResult(
            labOrderItemId: widget.item.id,
            numericValue: numeric,
            textValue: numeric == null ? _valueController.text.trim() : null,
          );
      if (mounted) {
        ref.invalidate(pendingLabOrdersProvider);
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('نتيجة: ${widget.item.testName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(_error!, style: const TextStyle(color: AppTheme.errorColor, fontSize: 13)),
            ),
          TextField(
            controller: _valueController,
            enabled: !_isLoading,
            decoration: InputDecoration(
              labelText: widget.item.unit == null ? 'القيمة' : 'القيمة (${widget.item.unit})',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}

class _ReviewResultDialog extends ConsumerStatefulWidget {
  final LabOrderItem item;

  const _ReviewResultDialog({required this.item});

  @override
  ConsumerState<_ReviewResultDialog> createState() => _ReviewResultDialogState();
}

class _ReviewResultDialogState extends ConsumerState<_ReviewResultDialog> {
  final _commentController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await ref.read(labRepositoryProvider).reviewResult(
            labOrderItemId: widget.item.id,
            doctorComment: _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
          );
      if (mounted) {
        ref.invalidate(pendingLabOrdersProvider);
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.item.result!;
    return AlertDialog(
      title: Text('مراجعة: ${widget.item.testName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('القيمة: ${result.textValue ?? result.numericValue?.toString() ?? '-'} (${result.flag})'),
          const SizedBox(height: 12),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(_error!, style: const TextStyle(color: AppTheme.errorColor, fontSize: 13)),
            ),
          TextField(
            controller: _commentController,
            enabled: !_isLoading,
            decoration: const InputDecoration(labelText: 'ملاحظات الطبيب (اختياري)'),
            maxLines: 2,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: const Text('تأكيد المراجعة'),
        ),
      ],
    );
  }
}
