class StaffRoleOption {
  final String value;
  final String label;

  const StaffRoleOption(this.value, this.label);
}

/// Roles assignable from the Staff screen. SuperAdmin is excluded on
/// purpose — it's a system-level role from the backend UserRole enum,
/// not something clinic staff management should be able to grant.
const List<StaffRoleOption> assignableStaffRoles = [
  StaffRoleOption('ClinicAdmin', 'مدير العيادة'),
  StaffRoleOption('Doctor', 'طبيب'),
  StaffRoleOption('SeniorDoctor', 'طبيب استشاري'),
  StaffRoleOption('Receptionist', 'استقبال'),
  StaffRoleOption('Nurse', 'تمريض'),
  StaffRoleOption('HeadNurse', 'رئيس تمريض'),
  StaffRoleOption('Accountant', 'محاسب'),
  StaffRoleOption('Pharmacist', 'صيدلي'),
  StaffRoleOption('LabTechnician', 'فني معمل'),
  StaffRoleOption('RadiologyTechnician', 'فني أشعة'),
  StaffRoleOption('Viewer', 'مشاهدة فقط'),
];

String staffRoleLabel(String role) {
  for (final option in assignableStaffRoles) {
    if (option.value == role) return option.label;
  }
  if (role == 'SuperAdmin') return 'مدير عام';
  return role;
}
