import '../entities/staff_member.dart';
import '../repositories/staff_repository.dart';

class SetStaffActiveStatusUseCase {
  final StaffRepository repository;

  const SetStaffActiveStatusUseCase(this.repository);

  Future<StaffMember> execute(String id, bool isActive) {
    return repository.setActiveStatus(id, isActive);
  }
}
