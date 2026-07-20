import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import 'data/datasources/pharmacy_remote_data_source.dart';
import 'data/repositories/pharmacy_repository_impl.dart';
import 'domain/repositories/pharmacy_repository.dart';

final pharmacyRemoteDataSourceProvider = Provider<PharmacyRemoteDataSource>(
  (ref) => PharmacyRemoteDataSource(ApiClient.instance),
);

final pharmacyRepositoryProvider = Provider<PharmacyRepository>(
  (ref) => PharmacyRepositoryImpl(ref.read(pharmacyRemoteDataSourceProvider)),
);
