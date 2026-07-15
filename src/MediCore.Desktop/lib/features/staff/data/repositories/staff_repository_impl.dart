import '../../domain/entities/create_staff_params.dart';
import '../../domain/entities/staff_member.dart';
import '../../domain/entities/update_staff_params.dart';
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

  @override
  Future<List<StaffMember>> getAll() async {
    final models = await _remoteDataSource.getAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<StaffMember> create(CreateStaffParams params) async {
    final model = await _remoteDataSource.create(params);
    return model.toEntity();
  }

  @override
  Future<StaffMember> update(String id, UpdateStaffParams params) async {
    final model = await _remoteDataSource.update(id, params);
    return model.toEntity();
  }

  @override
  Future<StaffMember> setActiveStatus(String id, bool isActive) async {
    final model = await _remoteDataSource.setActiveStatus(id, isActive);
    return model.toEntity();
  }
}
