import '../../domain/entities/inventory_item.dart';
import '../../domain/entities/inventory_support_entities.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_remote_data_source.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource _remoteDataSource;

  const InventoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<InventoryItem>> getItems({String? search}) async {
    final models = await _remoteDataSource.getItems(search: search);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
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
  }) async {
    final model = await _remoteDataSource.createItem({
      'name': name,
      'sku': sku,
      'barcode': barcode,
      'categoryId': categoryId,
      'unitOfMeasure': unitOfMeasure,
      'isPharmacyItem': isPharmacyItem,
      'tracksBatches': tracksBatches,
      'costPrice': costPrice,
      'salePrice': salePrice,
      'reorderPoint': reorderPoint,
      'safetyStock': safetyStock,
    });
    return model.toEntity();
  }

  @override
  Future<List<Warehouse>> getWarehouses() async {
    final models = await _remoteDataSource.getWarehouses();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Warehouse> createWarehouse({required String name, String? location}) async {
    final model = await _remoteDataSource.createWarehouse({
      'name': name,
      'location': location,
    });
    return model.toEntity();
  }

  @override
  Future<List<InventoryCategory>> getCategories() async {
    final models = await _remoteDataSource.getCategories();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<StockLevel>> getStockLevels({String? warehouseId, String? itemId}) async {
    final models = await _remoteDataSource.getStockLevels(
      warehouseId: warehouseId,
      itemId: itemId,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<LowStockItem>> getLowStockItems({String? warehouseId}) async {
    final models = await _remoteDataSource.getLowStockItems(warehouseId: warehouseId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> receiveStock({
    required String warehouseId,
    required String itemId,
    required double quantity,
    required double unitCost,
    String? batchNumber,
    DateTime? expiryDate,
  }) {
    final formattedExpiry = expiryDate == null
        ? null
        : '${expiryDate.year}-${expiryDate.month.toString().padLeft(2, '0')}-${expiryDate.day.toString().padLeft(2, '0')}';

    return _remoteDataSource.receiveStock({
      'warehouseId': warehouseId,
      'itemId': itemId,
      'quantity': quantity,
      'unitCost': unitCost,
      'batchNumber': batchNumber,
      'expiryDate': formattedExpiry,
      'referenceType': 'ManualReceive',
    });
  }

  @override
  Future<void> adjustStock({
    required String warehouseId,
    required String itemId,
    required double newQuantity,
    required String reason,
  }) {
    return _remoteDataSource.adjustStock({
      'warehouseId': warehouseId,
      'itemId': itemId,
      'newQuantity': newQuantity,
      'reason': reason,
    });
  }

  @override
  Future<void> transferStock({
    required String fromWarehouseId,
    required String toWarehouseId,
    required String itemId,
    required double quantity,
  }) {
    return _remoteDataSource.transferStock({
      'fromWarehouseId': fromWarehouseId,
      'toWarehouseId': toWarehouseId,
      'itemId': itemId,
      'quantity': quantity,
    });
  }
}
