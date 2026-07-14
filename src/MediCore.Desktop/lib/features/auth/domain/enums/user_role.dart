enum UserRole {
  superAdmin,
  clinicAdmin,
  doctor,
  seniorDoctor,
  receptionist,
  headNurse,
  nurse,
  accountant,
  pharmacist,
  labTechnician,
  radiologyTechnician,
  viewer,
  unknown;

  static UserRole fromString(String value) {
    final normalized = value.trim().toLowerCase();

    return UserRole.values.firstWhere(
      (role) => role.name.toLowerCase() == normalized,
      orElse: () => UserRole.unknown,
    );
  }
}
