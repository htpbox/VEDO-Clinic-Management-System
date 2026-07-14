import '../../domain/entities/staff_member.dart';
import '../../domain/repositories/staff_repository.dart';
import '../datasources/staff_remote_data_source.dart';

class StaffRepositoryImpl implements StaffRepository {
  final StaffRemoteDataSource _remoteDataSource;

  const StaffRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<StaffMember>> getDoctors() async {
    final models = await _remoteDataSource.getDoctors();
    return models.map((m) => m.toEntity()).toList();
  }
}
