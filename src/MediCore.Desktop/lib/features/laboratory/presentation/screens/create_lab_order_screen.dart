import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../di/lab_di.dart';

class CreateLabOrderScreen extends ConsumerStatefulWidget {
  final String patientId;
  final String patientName;

  const CreateLabOrderScreen({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  ConsumerState<CreateLabOrderScreen> createState() => _CreateLabOrderScreenState();
}

class _CreateLabOrderScreenState extends ConsumerState<CreateLabOrderScreen> {
  final _notesController = TextEditingController();
  final Set<String> _selectedTestIds = {};
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_selectedTestIds.isEmpty) {
      setState(() => _error = 'اختر فحصًا واحدًا على الأقل');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repo = ref.read(labRepositoryProvider);
      await repo.createOrder(
        patientId: widget.patientId,
        clinicalNotes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        labTestCatalogIds: _selectedTestIds.toList(),
        createInvoice: true,
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
    final catalogAsync = ref.watch(labCatalogProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 480,
        height: 560,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'طلب تحاليل: ${widget.patientName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 16),
            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_error!, style: const TextStyle(color: AppTheme.errorColor, fontSize: 13)),
              ),
              const SizedBox(height: 12),
            ],
            Expanded(
              child: catalogAsync.when(
                data: (catalog) {
                  if (catalog.isEmpty) {
                    return const Center(
                      child: Text('لا توجد فحوصات في القائمة', style: TextStyle(color: AppTheme.textSecondary)),
                    );
                  }
                  return ListView.builder(
                    itemCount: catalog.length,
                    itemBuilder: (context, index) {
                      final test = catalog[index];
                      return CheckboxListTile(
                        value: _selectedTestIds.contains(test.id),
                        onChanged: _isLoading
                            ? null
                            : (checked) => setState(() {
                                  if (checked == true) {
                                    _selectedTestIds.add(test.id);
                                  } else {
                                    _selectedTestIds.remove(test.id);
                                  }
                                }),
                        title: Text(test.name),
                        subtitle: Text('${test.price.toStringAsFixed(2)} ج.م'),
                        dense: true,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => const Center(
                  child: Text('تعذر تحميل قائمة الفحوصات', style: TextStyle(color: AppTheme.errorColor)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              enabled: !_isLoading,
              decoration: const InputDecoration(labelText: 'ملاحظات سريرية (اختياري)'),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    child: const Text('إلغاء'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubmit,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('إرسال الطلب'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
