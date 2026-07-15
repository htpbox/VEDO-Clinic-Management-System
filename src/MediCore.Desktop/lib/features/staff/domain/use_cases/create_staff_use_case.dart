import '../entities/create_staff_params.dart';
import '../entities/staff_member.dart';
import '../repositories/staff_repository.dart';

class CreateStaffUseCase {
  final StaffRepository repository;

  const CreateStaffUseCase(this.repository);

  Future<StaffMember> execute(CreateStaffParams params) {
    return repository.create(params);
  }
}
