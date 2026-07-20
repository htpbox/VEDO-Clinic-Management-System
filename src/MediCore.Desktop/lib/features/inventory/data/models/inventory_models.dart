import '../../domain/entities/inventory_item.dart';
import '../../domain/entities/inventory_support_entities.dart';

class InventoryItemModel extends InventoryItem {
  const InventoryItemModel({
    required super.id,
    required super.name,
    required super.sku,
    super.barcode,
    super.categoryId,
    super.categoryName,
    required super.unitOfMeasure,
    required super.isPharmacyItem,
    required super.tracksBatches,
    required super.costPrice,
    required super.salePrice,
    required super.reorderPoint,
    required super.safetyStock,
    required super.isActive,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    return InventoryItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String,
      barcode: json['barcode'] as String?,
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      unitOfMeasure: json['unitOfMeasure'] as String? ?? 'unit',
      isPharmacyItem: json['isPharmacyItem'] as bool? ?? false,
      tracksBatches: json['tracksBatches'] as bool? ?? false,
      costPrice: (json['costPrice'] as num?)?.toDouble() ?? 0,
      salePrice: (json['salePrice'] as num?)?.toDouble() ?? 0,
      reorderPoint: (json['reorderPoint'] as num?)?.toInt() ?? 0,
      safetyStock: (json['safetyStock'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  InventoryItem toEntity() => this;
}

class WarehouseModel extends Warehouse {
  const WarehouseModel({
    required super.id,
    required super.name,
    super.location,
    required super.isActive,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Warehouse toEntity() => this;
}

class InventoryCategoryModel extends InventoryCategory {
  const InventoryCategoryModel({
    required super.id,
    required super.name,
    super.parentCategoryId,
  });

  factory InventoryCategoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      parentCategoryId: json['parentCategoryId'] as String?,
    );
  }

  InventoryCategory toEntity() => this;
}

class StockLevelModel extends StockLevel {
  const StockLevelModel({
    required super.itemId,
    required super.itemName,
    required super.warehouseId,
    required super.warehouseName,
    required super.quantityOnHand,
    required super.averageCost,
  });

  factory StockLevelModel.fromJson(Map<String, dynamic> json) {
    return StockLevelModel(
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String,
      warehouseId: json['warehouseId'] as String,
      warehouseName: json['warehouseName'] as String,
      quantityOnHand: (json['quantityOnHand'] as num).toDouble(),
      averageCost: (json['averageCost'] as num).toDouble(),
    );
  }

  StockLevel toEntity() => this;
}

class LowStockItemModel extends LowStockItem {
  const LowStockItemModel({
    required super.itemId,
    required super.itemName,
    required super.sku,
    required super.warehouseId,
    required super.warehouseName,
    required super.quantityOnHand,
    required super.reorderPoint,
    required super.safetyStock,
  });

  factory LowStockItemModel.fromJson(Map<String, dynamic> json) {
    return LowStockItemModel(
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String,
      sku: json['sku'] as String,
      warehouseId: json['warehouseId'] as String,
      warehouseName: json['warehouseName'] as String,
      quantityOnHand: (json['quantityOnHand'] as num).toDouble(),
      reorderPoint: (json['reorderPoint'] as num).toInt(),
      safetyStock: (json['safetyStock'] as num).toInt(),
    );
  }

  LowStockItem toEntity() => this;
}
