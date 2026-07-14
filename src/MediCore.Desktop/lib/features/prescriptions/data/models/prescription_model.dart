import '../../domain/entities/prescription.dart';
import 'prescription_item_model.dart';

class PrescriptionModel {
  final String id;
  final String encounterId;
  final String patientId;
  final String doctorId;
  final String prescriptionNumber;
  final String status;
  final String? notes;
  final List<PrescriptionItemModel> items;
  final DateTime createdAt;

  const PrescriptionModel({
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

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] as String,
      encounterId: json['encounterId'] as String,
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] as String,
      prescriptionNumber: json['prescriptionNumber'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => PrescriptionItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Prescription toEntity() {
    return Prescription(
      id: id,
      encounterId: encounterId,
      patientId: patientId,
      doctorId: doctorId,
      prescriptionNumber: prescriptionNumber,
      status: status,
      notes: notes,
      items: items.map((i) => i.toEntity()).toList(),
      createdAt: createdAt,
    );
  }
}
