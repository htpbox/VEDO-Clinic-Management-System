import '../../domain/entities/pharmacy_sale.dart';

class PharmacySaleItemModel extends PharmacySaleItem {
  const PharmacySaleItemModel({
    required super.id,
    required super.itemId,
    required super.itemName,
    required super.quantity,
    required super.unitPrice,
  });

  factory PharmacySaleItemModel.fromJson(Map<String, dynamic> json) {
    return PharmacySaleItemModel(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
    );
  }
}

class PharmacySaleModel extends PharmacySale {
  const PharmacySaleModel({
    required super.id,
    required super.warehouseId,
    super.patientId,
    super.prescriptionId,
    super.invoiceId,
    required super.saleType,
    required super.status,
    required super.saleDate,
    required super.totalAmount,
    required super.items,
  });

  factory PharmacySaleModel.fromJson(Map<String, dynamic> json) {
    return PharmacySaleModel(
      id: json['id'] as String,
      warehouseId: json['warehouseId'] as String,
      patientId: json['patientId'] as String?,
      prescriptionId: json['prescriptionId'] as String?,
      invoiceId: json['invoiceId'] as String?,
      saleType: json['saleType']?.toString() ?? 'Retail',
      status: json['status']?.toString() ?? 'Completed',
      saleDate: DateTime.parse(json['saleDate'] as String),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => PharmacySaleItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  PharmacySale toEntity() => this;
}
