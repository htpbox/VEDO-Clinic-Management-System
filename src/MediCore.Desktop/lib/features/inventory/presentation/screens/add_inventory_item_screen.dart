import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../di/inventory_di.dart';
import '../../domain/repositories/inventory_repository.dart';

class AddInventoryItemScreen extends ConsumerStatefulWidget {
  const AddInventoryItemScreen({super.key});

  @override
  ConsumerState<AddInventoryItemScreen> createState() => _AddInventoryItemScreenState();
}

class _AddInventoryItemScreenState extends ConsumerState<AddInventoryItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _costController = TextEditingController(text: '0');
  final _priceController = TextEditingController(text: '0');
  final _reorderController = TextEditingController(text: '0');
  final _safetyController = TextEditingController(text: '0');
  bool _isPharmacyItem = false;
  bool _tracksBatches = false;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _costController.dispose();
    _priceController.dispose();
    _reorderController.dispose();
    _safetyController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repo = ref.read(inventoryRepositoryProvider);
      await repo.createItem(
        name: _nameController.text.trim(),
        sku: _skuController.text.trim(),
        barcode: _barcodeController.text.trim().isEmpty ? null : _barcodeController.text.trim(),
        unitOfMeasure: 'unit',
        isPharmacyItem: _isPharmacyItem,
        tracksBatches: _tracksBatches,
        costPrice: double.tryParse(_costController.text) ?? 0,
        salePrice: double.tryParse(_priceController.text) ?? 0,
        reorderPoint: int.tryParse(_reorderController.text) ?? 0,
        safetyStock: int.tryParse(_safetyController.text) ?? 0,
      );

      if (mounted) {
        ref.invalidate(inventoryItemsProvider);
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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 480,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'إضافة صنف جديد',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 20),
                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_error!, style: const TextStyle(color: AppTheme.errorColor, fontSize: 13)),
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: _nameController,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(labelText: 'اسم الصنف'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'اسم الصنف مطلوب' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _skuController,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(labelText: 'رمز الصنف (SKU)'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'رمز الصنف مطلوب' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _barcodeController,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(labelText: 'الباركود (اختياري)'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _costController,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'سعر التكلفة'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'سعر البيع'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _reorderController,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'حد إعادة الطلب'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _safetyController,
                        enabled: !_isLoading,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'مخزون الأمان'),
                      ),
                    ),
                  ],
                ),
                CheckboxListTile(
                  value: _isPharmacyItem,
                  onChanged: _isLoading ? null : (v) => setState(() => _isPharmacyItem = v ?? false),
                  title: const Text('صنف صيدلية (دواء)', style: TextStyle(fontSize: 13)),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  value: _tracksBatches,
                  onChanged: _isLoading ? null : (v) => setState(() => _tracksBatches = v ?? false),
                  title: const Text('تتبع الدفعات وتاريخ الصلاحية', style: TextStyle(fontSize: 13)),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
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
                            : const Text('حفظ'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
