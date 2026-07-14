import '../entities/staff_member.dart';
import '../repositories/staff_repository.dart';

class GetDoctorsUseCase {
  final StaffRepository repository;

  const GetDoctorsUseCase(this.repository);

  Future<List<StaffMember>> execute() {
    return repository.getDoctors();
  }
}
