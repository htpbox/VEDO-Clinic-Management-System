class UpdateEncounterParams {
  final String? chiefComplaint;
  final String? hpi;
  final String? physicalExam;
  final String? clinicalNotes;
  final String? treatmentPlan;
  final DateTime? followUpDate;
  final String? followUpNotes;

  const UpdateEncounterParams({
    this.chiefComplaint,
    this.hpi,
    this.physicalExam,
    this.clinicalNotes,
    this.treatmentPlan,
    this.followUpDate,
    this.followUpNotes,
  });
}
