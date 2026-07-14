class CreateAppointmentParams {
  final String patientId;
  final String doctorId;
  final DateTime appointmentDate;
  final String startTime;
  final String endTime;
  final String? chiefComplaint;
  final String? notes;

  const CreateAppointmentParams({
    required this.patientId,
    required this.doctorId,
    required this.appointmentDate,
    required this.startTime,
    required this.endTime,
    this.chiefComplaint,
    this.notes,
  });
}
