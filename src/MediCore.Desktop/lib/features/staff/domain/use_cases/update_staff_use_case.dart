import '../entities/staff_member.dart';
import '../entities/update_staff_params.dart';
import '../repositories/staff_repository.dart';

class UpdateStaffUseCase {
  final StaffRepository repository;

  const UpdateStaffUseCase(this.repository);

  Future<StaffMember> execute(String id, UpdateStaffParams params) {
    return repository.update(id, params);
  }
}
