import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../inventory/di/inventory_di.dart';
import '../../../inventory/domain/entities/inventory_item.dart';
import '../../di/pharmacy_di.dart';
import '../../domain/entities/pharmacy_sale.dart';

/// A simple point-of-sale style screen: search an item, add it to the cart
/// with a quantity, repeat, then submit as one pharmacy sale. Stock is
/// issued and (optionally) an invoice created server-side in one atomic
/// call to PharmacyController.CreateSale.
class PharmacySaleScreen extends ConsumerStatefulWidget {
  const PharmacySaleScreen({super.key});

  @override
  ConsumerState<PharmacySaleScreen> createState() => _PharmacySaleScreenState();
}

class _PharmacySaleScreenState extends ConsumerState<PharmacySaleScreen> {
  final _searchController = TextEditingController();
  final List<PharmacyCartLine> _cart = [];
  String? _selectedWarehouseId;
  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addToCart(InventoryItem item) {
    setState(() {
      final existingIndex = _cart.indexWhere((l) => l.itemId == item.id);
      if (existingIndex >= 0) {
        final existing = _cart[existingIndex];
        _cart[existingIndex] = PharmacyCartLine(
          itemId: existing.itemId,
          itemName: existing.itemName,
          unitPrice: existing.unitPrice,
          quantity: existing.quantity + 1,
        );
      } else {
        _cart.add(PharmacyCartLine(
          itemId: item.id,
          itemName: item.name,
          unitPrice: item.salePrice,
          quantity: 1,
        ));
      }
      _searchController.clear();
    });
  }

  void _updateQuantity(int index, double quantity) {
    if (quantity <= 0) {
      setState(() => _cart.removeAt(index));
      return;
    }
    setState(() {
      final line = _cart[index];
      _cart[index] = PharmacyCartLine(
        itemId: line.itemId,
        itemName: line.itemName,
        unitPrice: line.unitPrice,
        quantity: quantity,
      );
    });
  }

  double get _total => _cart.fold(0, (sum, line) => sum + line.lineTotal);

  Future<void> _submitSale() async {
    if (_cart.isEmpty) {
      setState(() => _error = 'أضف صنفًا واحدًا على الأقل');
      return;
    }
    if (_selectedWarehouseId == null) {
      setState(() => _error = 'يجب اختيار المخزن');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      final repo = ref.read(pharmacyRepositoryProvider);
      await repo.createSale(
        warehouseId: _selectedWarehouseId!,
        saleType: 'Retail',
        createInvoice: false,
        items: _cart,
      );

      if (mounted) {
        setState(() => _cart.clear());
        ref.invalidate(lowStockItemsProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إتمام عملية البيع بنجاح')),
        );
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(inventoryItemsProvider);
    final warehousesAsync = ref.watch(warehousesProvider);
    final query = _searchController.text.trim().toLowerCase();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: item search
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'ابحث عن صنف بالاسم أو الباركود',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: itemsAsync.when(
                    data: (items) {
                      final filtered = query.isEmpty
                          ? const <InventoryItem>[]
                          : items
                              .where((i) =>
                                  i.name.toLowerCase().contains(query) ||
                                  (i.barcode?.toLowerCase().contains(query) ?? false))
                              .toList();
                      if (filtered.isEmpty) {
                        return const Center(
                          child: Text('ابحث لعرض الأصناف', style: TextStyle(color: AppTheme.textSecondary)),
                        );
                      }
                      return ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return ListTile(
                            title: Text(item.name),
                            subtitle: Text('${item.salePrice.toStringAsFixed(2)} ج.م'),
                            trailing: const Icon(Icons.add_circle_outline, color: AppTheme.primaryColor),
                            onTap: () => _addToCart(item),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => const Center(
                      child: Text('تعذر تحميل الأصناف', style: TextStyle(color: AppTheme.errorColor)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Right: cart
          Expanded(
            flex: 2,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'سلة البيع',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    warehousesAsync.when(
                      data: (warehouses) => DropdownButtonFormField<String>(
                        initialValue: _selectedWarehouseId,
                        decoration: const InputDecoration(labelText: 'المخزن'),
                        items: [
                          for (final w in warehouses) DropdownMenuItem(value: w.id, child: Text(w.name)),
                        ],
                        onChanged: (v) => setState(() => _selectedWarehouseId = v),
                      ),
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 12),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(_error!, style: const TextStyle(color: AppTheme.errorColor, fontSize: 13)),
                      ),
                    Expanded(
                      child: _cart.isEmpty
                          ? const Center(
                              child: Text('السلة فارغة', style: TextStyle(color: AppTheme.textSecondary)),
                            )
                          : ListView.builder(
                              itemCount: _cart.length,
                              itemBuilder: (context, index) {
                                final line = _cart[index];
                                return ListTile(
                                  dense: true,
                                  title: Text(line.itemName),
                                  subtitle: Text('${line.unitPrice.toStringAsFixed(2)} ج.م × ${line.quantity.toStringAsFixed(0)}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, size: 20),
                                        onPressed: () => _updateQuantity(index, line.quantity - 1),
                                      ),
                                      Text(line.lineTotal.toStringAsFixed(2)),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline, size: 20),
                                        onPressed: () => _updateQuantity(index, line.quantity + 1),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('الإجمالي', style: TextStyle(fontWeight: FontWeight.w700)),
                        Text(
                          '${_total.toStringAsFixed(2)} ج.م',
                          style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primaryColor, fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitSale,
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('إتمام البيع'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
