import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../di/inventory_di.dart';
import '../../domain/entities/inventory_item.dart';

class ReceiveStockScreen extends ConsumerStatefulWidget {
  final InventoryItem item;

  const ReceiveStockScreen({super.key, required this.item});

  @override
  ConsumerState<ReceiveStockScreen> createState() => _ReceiveStockScreenState();
}

class _ReceiveStockScreenState extends ConsumerState<ReceiveStockScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _unitCostController = TextEditingController();
  final _batchController = TextEditingController();
  DateTime? _expiryDate;
  String? _selectedWarehouseId;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _unitCostController.text = widget.item.costPrice.toString();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _unitCostController.dispose();
    _batchController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedWarehouseId == null) {
      setState(() => _error = 'يجب اختيار المخزن');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repo = ref.read(inventoryRepositoryProvider);
      await repo.receiveStock(
        warehouseId: _selectedWarehouseId!,
        itemId: widget.item.id,
        quantity: double.parse(_quantityController.text),
        unitCost: double.tryParse(_unitCostController.text) ?? 0,
        batchNumber: _batchController.text.trim().isEmpty ? null : _batchController.text.trim(),
        expiryDate: _expiryDate,
      );

      if (mounted) {
        ref.invalidate(lowStockItemsProvider);
        ref.invalidate(stockLevelsProvider);
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
    final warehousesAsync = ref.watch(warehousesProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 440,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'استلام كمية: ${widget.item.name}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
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
              warehousesAsync.when(
                data: (warehouses) => DropdownButtonFormField<String>(
                  initialValue: _selectedWarehouseId,
                  decoration: const InputDecoration(labelText: 'المخزن'),
                  items: [
                    for (final w in warehouses) DropdownMenuItem(value: w.id, child: Text(w.name)),
                  ],
                  onChanged: _isLoading ? null : (v) => setState(() => _selectedWarehouseId = v),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => const Text('تعذر تحميل المخازن', style: TextStyle(color: AppTheme.errorColor)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                enabled: !_isLoading,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'الكمية'),
                validator: (v) {
                  final q = double.tryParse(v ?? '');
                  return (q == null || q <= 0) ? 'أدخل كمية صحيحة' : null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _unitCostController,
                enabled: !_isLoading,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'سعر الوحدة'),
              ),
              if (widget.item.tracksBatches) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _batchController,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(labelText: 'رقم الدفعة (اختياري)'),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _isLoading
                      ? null
                      : () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(const Duration(days: 365)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => _expiryDate = picked);
                        },
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'تاريخ الصلاحية (اختياري)'),
                    child: Text(
                      _expiryDate == null
                          ? 'اختر التاريخ'
                          : '${_expiryDate!.year}-${_expiryDate!.month.toString().padLeft(2, '0')}-${_expiryDate!.day.toString().padLeft(2, '0')}',
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
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
                          : const Text('استلام'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
