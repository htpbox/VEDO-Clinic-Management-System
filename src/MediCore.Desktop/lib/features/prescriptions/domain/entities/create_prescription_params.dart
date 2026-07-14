import 'create_prescription_item_params.dart';

class CreatePrescriptionParams {
  final String encounterId;
  final String patientId;
  final String? notes;
  final List<CreatePrescriptionItemParams> items;

  const CreatePrescriptionParams({
    required this.encounterId,
    required this.patientId,
    this.notes,
    required this.items,
  });
}
