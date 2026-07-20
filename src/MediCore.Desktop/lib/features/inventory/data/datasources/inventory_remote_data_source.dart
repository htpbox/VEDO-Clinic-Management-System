import '../../../../core/api/api_client.dart';
import '../../../../core/network/api_response_envelope.dart';
import '../models/inventory_models.dart';

class InventoryRemoteDataSource {
  final ApiClient _apiClient;

  const InventoryRemoteDataSource(this._apiClient);

  Future<List<InventoryItemModel>> getItems({String? search}) async {
    final response = await _apiClient.get(
      '/inventory/items',
      params: search != null && search.isNotEmpty ? {'search': search} : null,
    );
    final envelope = ApiResponseEnvelope<List<InventoryItemModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) => InventoryItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    return envelope.data ?? [];
  }

  Future<InventoryItemModel> createItem(Map<String, dynamic> body) async {
    final response = await _apiClient.post('/inventory/items', data: body);
    final envelope = ApiResponseEnvelope<InventoryItemModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => InventoryItemModel.fromJson(json as Map<String, dynamic>),
    );
    return envelope.data!;
  }

  Future<List<WarehouseModel>> getWarehouses() async {
    final response = await _apiClient.get('/inventory/warehouses');
    final envelope = ApiResponseEnvelope<List<WarehouseModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) => WarehouseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    return envelope.data ?? [];
  }

  Future<WarehouseModel> createWarehouse(Map<String, dynamic> body) async {
    final response = await _apiClient.post('/inventory/warehouses', data: body);
    final envelope = ApiResponseEnvelope<WarehouseModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => WarehouseModel.fromJson(json as Map<String, dynamic>),
    );
    return envelope.data!;
  }

  Future<List<InventoryCategoryModel>> getCategories() async {
    final response = await _apiClient.get('/inventory/categories');
    final envelope = ApiResponseEnvelope<List<InventoryCategoryModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) => InventoryCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    return envelope.data ?? [];
  }

  Future<List<StockLevelModel>> getStockLevels({
    String? warehouseId,
    String? itemId,
  }) async {
    final params = <String, dynamic>{};
    if (warehouseId != null) params['warehouseId'] = warehouseId;
    if (itemId != null) params['itemId'] = itemId;

    final response = await _apiClient.get(
      '/inventory/stock-levels',
      params: params.isEmpty ? null : params,
    );
    final envelope = ApiResponseEnvelope<List<StockLevelModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) => StockLevelModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    return envelope.data ?? [];
  }

  Future<List<LowStockItemModel>> getLowStockItems({String? warehouseId}) async {
    final response = await _apiClient.get(
      '/inventory/stock/low-stock',
      params: warehouseId != null ? {'warehouseId': warehouseId} : null,
    );
    final envelope = ApiResponseEnvelope<List<LowStockItemModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((e) => LowStockItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    return envelope.data ?? [];
  }

  Future<void> receiveStock(Map<String, dynamic> body) async {
    await _apiClient.post('/inventory/stock/receive', data: body);
  }

  Future<void> adjustStock(Map<String, dynamic> body) async {
    await _apiClient.post('/inventory/stock/adjust', data: body);
  }

  Future<void> transferStock(Map<String, dynamic> body) async {
    await _apiClient.post('/inventory/stock/transfer', data: body);
  }
}
