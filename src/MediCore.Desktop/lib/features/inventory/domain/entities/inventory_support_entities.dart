class StockLevel {
  final String itemId;
  final String itemName;
  final String warehouseId;
  final String warehouseName;
  final double quantityOnHand;
  final double averageCost;

  const StockLevel({
    required this.itemId,
    required this.itemName,
    required this.warehouseId,
    required this.warehouseName,
    required this.quantityOnHand,
    required this.averageCost,
  });
}

class LowStockItem {
  final String itemId;
  final String itemName;
  final String sku;
  final String warehouseId;
  final String warehouseName;
  final double quantityOnHand;
  final int reorderPoint;
  final int safetyStock;

  const LowStockItem({
    required this.itemId,
    required this.itemName,
    required this.sku,
    required this.warehouseId,
    required this.warehouseName,
    required this.quantityOnHand,
    required this.reorderPoint,
    required this.safetyStock,
  });
}

class Warehouse {
  final String id;
  final String name;
  final String? location;
  final bool isActive;

  const Warehouse({
    required this.id,
    required this.name,
    this.location,
    required this.isActive,
  });
}

class InventoryCategory {
  final String id;
  final String name;
  final String? parentCategoryId;

  const InventoryCategory({
    required this.id,
    required this.name,
    this.parentCategoryId,
  });
}
