import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import 'data/datasources/lab_remote_data_source.dart';
import 'data/repositories/lab_repository_impl.dart';
import 'domain/entities/lab_order.dart';
import 'domain/repositories/lab_repository.dart';

final labRemoteDataSourceProvider = Provider<LabRemoteDataSource>(
  (ref) => LabRemoteDataSource(ApiClient.instance),
);

final labRepositoryProvider = Provider<LabRepository>(
  (ref) => LabRepositoryImpl(ref.read(labRemoteDataSourceProvider)),
);

final labCatalogProvider = FutureProvider<List<LabTestCatalogEntry>>(
  (ref) => ref.read(labRepositoryProvider).getCatalog(),
);

final pendingLabOrdersProvider = FutureProvider.autoDispose<List<LabOrder>>(
  (ref) => ref.read(labRepositoryProvider).getPendingOrders(),
);
