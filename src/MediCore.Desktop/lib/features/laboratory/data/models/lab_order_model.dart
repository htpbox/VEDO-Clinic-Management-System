import '../../domain/entities/lab_order.dart';

class LabTestCatalogEntryModel extends LabTestCatalogEntry {
  const LabTestCatalogEntryModel({
    required super.id,
    required super.code,
    required super.name,
    super.unit,
    super.referenceLow,
    super.referenceHigh,
    required super.price,
  });

  factory LabTestCatalogEntryModel.fromJson(Map<String, dynamic> json) {
    return LabTestCatalogEntryModel(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      unit: json['unit'] as String?,
      referenceLow: (json['referenceLow'] as num?)?.toDouble(),
      referenceHigh: (json['referenceHigh'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
    );
  }
}

class LabResultModel extends LabResult {
  const LabResultModel({
    required super.id,
    super.numericValue,
    super.textValue,
    required super.flag,
    required super.reviewedByDoctor,
    super.doctorComment,
    required super.enteredAt,
  });

  factory LabResultModel.fromJson(Map<String, dynamic> json) {
    return LabResultModel(
      id: json['id'] as String,
      numericValue: (json['numericValue'] as num?)?.toDouble(),
      textValue: json['textValue'] as String?,
      flag: json['flag']?.toString() ?? 'Normal',
      reviewedByDoctor: json['reviewedByDoctor'] as bool? ?? false,
      doctorComment: json['doctorComment'] as String?,
      enteredAt: DateTime.parse(json['enteredAt'] as String),
    );
  }
}

class LabOrderItemModel extends LabOrderItem {
  const LabOrderItemModel({
    required super.id,
    required super.labTestCatalogId,
    required super.testName,
    super.unit,
    super.referenceLow,
    super.referenceHigh,
    super.result,
  });

  factory LabOrderItemModel.fromJson(Map<String, dynamic> json) {
    return LabOrderItemModel(
      id: json['id'] as String,
      labTestCatalogId: json['labTestCatalogId'] as String,
      testName: json['testName'] as String,
      unit: json['unit'] as String?,
      referenceLow: (json['referenceLow'] as num?)?.toDouble(),
      referenceHigh: (json['referenceHigh'] as num?)?.toDouble(),
      result: json['result'] == null
          ? null
          : LabResultModel.fromJson(json['result'] as Map<String, dynamic>),
    );
  }
}

class LabOrderModel extends LabOrder {
  const LabOrderModel({
    required super.id,
    required super.patientId,
    required super.doctorId,
    required super.status,
    required super.orderedAt,
    super.clinicalNotes,
    required super.items,
  });

  factory LabOrderModel.fromJson(Map<String, dynamic> json) {
    return LabOrderModel(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] as String,
      status: json['status']?.toString() ?? 'Ordered',
      orderedAt: DateTime.parse(json['orderedAt'] as String),
      clinicalNotes: json['clinicalNotes'] as String?,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => LabOrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  LabOrder toEntity() => this;
}
