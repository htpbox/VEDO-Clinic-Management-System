import '../entities/inventory_item.dart';
import '../entities/inventory_support_entities.dart';

abstract class InventoryRepository {
  Future<List<InventoryItem>> getItems({String? search});
  Future<InventoryItem> createItem({
    required String name,
    required String sku,
    String? barcode,
    String? categoryId,
    required String unitOfMeasure,
    required bool isPharmacyItem,
    required bool tracksBatches,
    required double costPrice,
    required double salePrice,
    required int reorderPoint,
    required int safetyStock,
  });

  Future<List<Warehouse>> getWarehouses();
  Future<Warehouse> createWarehouse({required String name, String? location});

  Future<List<InventoryCategory>> getCategories();

  Future<List<StockLevel>> getStockLevels({String? warehouseId, String? itemId});
  Future<List<LowStockItem>> getLowStockItems({String? warehouseId});

  Future<void> receiveStock({
    required String warehouseId,
    required String itemId,
    required double quantity,
    required double unitCost,
    String? batchNumber,
    DateTime? expiryDate,
  });

  Future<void> adjustStock({
    required String warehouseId,
    required String itemId,
    required double newQuantity,
    required String reason,
  });

  Future<void> transferStock({
    required String fromWarehouseId,
    required String toWarehouseId,
    required String itemId,
    required double quantity,
  });
}
