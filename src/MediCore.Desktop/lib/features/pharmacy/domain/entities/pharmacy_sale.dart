class PharmacySaleItem {
  final String id;
  final String itemId;
  final String itemName;
  final double quantity;
  final double unitPrice;

  const PharmacySaleItem({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
  });

  double get lineTotal => quantity * unitPrice;
}

class PharmacySale {
  final String id;
  final String warehouseId;
  final String? patientId;
  final String? prescriptionId;
  final String? invoiceId;
  final String saleType;
  final String status;
  final DateTime saleDate;
  final double totalAmount;
  final List<PharmacySaleItem> items;

  const PharmacySale({
    required this.id,
    required this.warehouseId,
    this.patientId,
    this.prescriptionId,
    this.invoiceId,
    required this.saleType,
    required this.status,
    required this.saleDate,
    required this.totalAmount,
    required this.items,
  });
}

/// A line the pharmacist is building up before submitting the sale -
/// local UI state, not sent to the backend until CreateSale.
class PharmacyCartLine {
  final String itemId;
  final String itemName;
  final double unitPrice;
  final double quantity;
  final String? prescriptionItemId;

  const PharmacyCartLine({
    required this.itemId,
    required this.itemName,
    required this.unitPrice,
    required this.quantity,
    this.prescriptionItemId,
  });

  double get lineTotal => quantity * unitPrice;
}
