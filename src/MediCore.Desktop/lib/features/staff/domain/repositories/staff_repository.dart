import '../entities/staff_member.dart';

abstract class StaffRepository {
  Future<List<StaffMember>> getDoctors();
}
