class InventoryItem {
  final String id;
  final String name;
  final String sku;
  final String? barcode;
  final String? categoryId;
  final String? categoryName;
  final String unitOfMeasure;
  final bool isPharmacyItem;
  final bool tracksBatches;
  final double costPrice;
  final double salePrice;
  final int reorderPoint;
  final int safetyStock;
  final bool isActive;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.sku,
    this.barcode,
    this.categoryId,
    this.categoryName,
    required this.unitOfMeasure,
    required this.isPharmacyItem,
    required this.tracksBatches,
    required this.costPrice,
    required this.salePrice,
    required this.reorderPoint,
    required this.safetyStock,
    required this.isActive,
  });
}
