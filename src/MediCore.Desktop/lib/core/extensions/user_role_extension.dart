import '../../features/auth/domain/enums/user_role.dart';

extension UserRoleDisplayName on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.superAdmin:
        return 'مدير عام';
      case UserRole.clinicAdmin:
        return 'مدير عيادة';
      case UserRole.doctor:
        return 'طبيب';
      case UserRole.seniorDoctor:
        return 'طبيب أول';
      case UserRole.receptionist:
        return 'موظف استقبال';
      case UserRole.headNurse:
        return 'رئيس تمريض';
      case UserRole.nurse:
        return 'ممرض';
      case UserRole.accountant:
        return 'محاسب';
      case UserRole.pharmacist:
        return 'صيدلي';
      case UserRole.labTechnician:
        return 'فني مختبر';
      case UserRole.radiologyTechnician:
        return 'فني أشعة';
      case UserRole.viewer:
        return 'مشاهد';
      case UserRole.unknown:
        return 'غير معروف';
    }
  }
}
