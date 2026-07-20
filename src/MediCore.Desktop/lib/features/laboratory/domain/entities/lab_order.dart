class LabTestCatalogEntry {
  final String id;
  final String code;
  final String name;
  final String? unit;
  final double? referenceLow;
  final double? referenceHigh;
  final double price;

  const LabTestCatalogEntry({
    required this.id,
    required this.code,
    required this.name,
    this.unit,
    this.referenceLow,
    this.referenceHigh,
    required this.price,
  });
}

class LabResult {
  final String id;
  final double? numericValue;
  final String? textValue;
  final String flag;
  final bool reviewedByDoctor;
  final String? doctorComment;
  final DateTime enteredAt;

  const LabResult({
    required this.id,
    this.numericValue,
    this.textValue,
    required this.flag,
    required this.reviewedByDoctor,
    this.doctorComment,
    required this.enteredAt,
  });

  bool get isAbnormal => flag != 'Normal';
  bool get isCritical => flag == 'Critical';
}

class LabOrderItem {
  final String id;
  final String labTestCatalogId;
  final String testName;
  final String? unit;
  final double? referenceLow;
  final double? referenceHigh;
  final LabResult? result;

  const LabOrderItem({
    required this.id,
    required this.labTestCatalogId,
    required this.testName,
    this.unit,
    this.referenceLow,
    this.referenceHigh,
    this.result,
  });
}

class LabOrder {
  final String id;
  final String patientId;
  final String doctorId;
  final String status;
  final DateTime orderedAt;
  final String? clinicalNotes;
  final List<LabOrderItem> items;

  const LabOrder({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.status,
    required this.orderedAt,
    this.clinicalNotes,
    required this.items,
  });
}
