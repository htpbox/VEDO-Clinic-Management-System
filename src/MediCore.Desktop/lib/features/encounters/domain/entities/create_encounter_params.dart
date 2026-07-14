class CreateEncounterParams {
  final String patientId;
  final String? appointmentId;
  final String encounterType;
  final String? chiefComplaint;

  const CreateEncounterParams({
    required this.patientId,
    this.appointmentId,
    this.encounterType = 'outpatient',
    this.chiefComplaint,
  });
}
