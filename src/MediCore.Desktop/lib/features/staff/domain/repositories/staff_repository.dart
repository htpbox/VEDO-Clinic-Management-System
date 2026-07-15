import '../entities/create_staff_params.dart';
import '../entities/staff_member.dart';
import '../entities/update_staff_params.dart';

abstract class StaffRepository {
  Future<List<StaffMember>> getDoctors();
  Future<List<StaffMember>> getAll();
  Future<StaffMember> create(CreateStaffParams params);
  Future<StaffMember> update(String id, UpdateStaffParams params);
  Future<StaffMember> setActiveStatus(String id, bool isActive);
}
