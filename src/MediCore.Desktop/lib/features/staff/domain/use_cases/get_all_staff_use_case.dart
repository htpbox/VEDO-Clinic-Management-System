import '../entities/staff_member.dart';
import '../repositories/staff_repository.dart';

class GetAllStaffUseCase {
  final StaffRepository repository;

  const GetAllStaffUseCase(this.repository);

  Future<List<StaffMember>> execute() {
    return repository.getAll();
  }
}
