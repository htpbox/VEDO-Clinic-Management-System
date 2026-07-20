import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../di/inventory_di.dart';
import '../../domain/entities/inventory_item.dart';
import 'add_inventory_item_screen.dart';
import 'receive_stock_screen.dart';

class InventoryListScreen extends ConsumerStatefulWidget {
  const InventoryListScreen({super.key});

  @override
  ConsumerState<InventoryListScreen> createState() => _InventoryListScreenState();
}

class _InventoryListScreenState extends ConsumerState<InventoryListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(inventoryItemsProvider);
    final lowStockAsync = ref.watch(lowStockItemsProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'بحث بالاسم أو رمز الصنف أو الباركود',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => const AddInventoryItemScreen(),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('إضافة صنف'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          lowStockAsync.when(
            data: (lowStock) => lowStock.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.warningColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.warningColor.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AppTheme.warningColor, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'يوجد ${lowStock.length} صنف بحاجة لإعادة الطلب',
                            style: const TextStyle(color: AppTheme.warningColor, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
            loading: () => const SizedBox.shrink(),
            error: (e, _) => const SizedBox.shrink(),
          ),
          Expanded(
            child: itemsAsync.when(
              data: (items) {
                final query = _searchController.text.trim().toLowerCase();
                final filtered = query.isEmpty
                    ? items
                    : items
                        .where((i) =>
                            i.name.toLowerCase().contains(query) ||
                            i.sku.toLowerCase().contains(query) ||
                            (i.barcode?.toLowerCase().contains(query) ?? false))
                        .toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('لا توجد أصناف', style: TextStyle(color: AppTheme.textSecondary)),
                  );
                }

                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) => _InventoryItemTile(item: filtered[index]),
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
    );
  }
}

class _InventoryItemTile extends StatelessWidget {
  final InventoryItem item;

  const _InventoryItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: item.isPharmacyItem ? AppTheme.secondaryColor : AppTheme.primaryColor,
        child: Icon(
          item.isPharmacyItem ? Icons.medication_outlined : Icons.inventory_2_outlined,
          color: Colors.white,
          size: 20,
        ),
      ),
      title: Text(item.name),
      subtitle: Text('${item.sku} • ${item.salePrice.toStringAsFixed(2)} ج.م'),
      trailing: TextButton.icon(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => ReceiveStockScreen(item: item),
        ),
        icon: const Icon(Icons.add_box_outlined, size: 18),
        label: const Text('استلام كمية'),
      ),
    );
  }
}
