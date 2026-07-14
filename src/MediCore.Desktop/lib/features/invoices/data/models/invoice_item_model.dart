import '../../domain/entities/invoice_item.dart';

class InvoiceItemModel {
  final String id;
  final String description;
  final double quantity;
  final double unitPrice;
  final double totalPrice;

  const InvoiceItemModel({
    required this.id,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) {
    return InvoiceItemModel(
      id: json['id'] as String,
      description: json['description'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }

  InvoiceItem toEntity() {
    return InvoiceItem(
      id: id,
      description: description,
      quantity: quantity,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
    );
  }
}
