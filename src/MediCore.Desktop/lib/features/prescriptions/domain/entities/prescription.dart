import 'prescription_item.dart';

class Prescription {
  final String id;
  final String encounterId;
  final String patientId;
  final String doctorId;
  final String prescriptionNumber;
  final String status;
  final String? notes;
  final List<PrescriptionItem> items;
  final DateTime createdAt;

  const Prescription({
    required this.id,
    required this.encounterId,
    required this.patientId,
    required this.doctorId,
    required this.prescriptionNumber,
    required this.status,
    this.notes,
    required this.items,
    required this.createdAt,
  });
}
