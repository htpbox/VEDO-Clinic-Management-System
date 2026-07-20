import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import 'data/datasources/inventory_remote_data_source.dart';
import 'data/repositories/inventory_repository_impl.dart';
import 'domain/entities/inventory_item.dart';
import 'domain/entities/inventory_support_entities.dart';
import 'domain/repositories/inventory_repository.dart';

final inventoryRemoteDataSourceProvider = Provider<InventoryRemoteDataSource>(
  (ref) => InventoryRemoteDataSource(ApiClient.instance),
);

final inventoryRepositoryProvider = Provider<InventoryRepository>(
  (ref) => InventoryRepositoryImpl(ref.read(inventoryRemoteDataSourceProvider)),
);

final inventoryItemsProvider = FutureProvider.autoDispose<List<InventoryItem>>(
  (ref) => ref.read(inventoryRepositoryProvider).getItems(),
);

final warehousesProvider = FutureProvider<List<Warehouse>>(
  (ref) => ref.read(inventoryRepositoryProvider).getWarehouses(),
);

final inventoryCategoriesProvider = FutureProvider<List<InventoryCategory>>(
  (ref) => ref.read(inventoryRepositoryProvider).getCategories(),
);

final lowStockItemsProvider = FutureProvider.autoDispose<List<LowStockItem>>(
  (ref) => ref.read(inventoryRepositoryProvider).getLowStockItems(),
);

final stockLevelsProvider = FutureProvider.autoDispose<List<StockLevel>>(
  (ref) => ref.read(inventoryRepositoryProvider).getStockLevels(),
);
