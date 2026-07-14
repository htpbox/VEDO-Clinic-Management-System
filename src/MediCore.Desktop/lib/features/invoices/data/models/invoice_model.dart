import '../../domain/entities/invoice.dart';
import 'invoice_item_model.dart';

class InvoiceModel {
  final String id;
  final String patientId;
  final String? encounterId;
  final String invoiceNumber;
  final DateTime invoiceDate;
  final double subtotal;
  final double discountAmount;
  final double taxAmount;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final String status;
  final List<InvoiceItemModel> items;
  final DateTime createdAt;

  const InvoiceModel({
    required this.id,
    required this.patientId,
    this.encounterId,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.subtotal,
    required this.discountAmount,
    required this.taxAmount,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
    required this.status,
    required this.items,
    required this.createdAt,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      encounterId: json['encounterId'] as String?,
      invoiceNumber: json['invoiceNumber'] as String,
      invoiceDate: DateTime.parse(json['invoiceDate'] as String),
      subtotal: (json['subtotal'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num).toDouble(),
      taxAmount: (json['taxAmount'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paidAmount: (json['paidAmount'] as num).toDouble(),
      remainingAmount: (json['remainingAmount'] as num).toDouble(),
      status: json['status'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => InvoiceItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Invoice toEntity() {
    return Invoice(
      id: id,
      patientId: patientId,
      encounterId: encounterId,
      invoiceNumber: invoiceNumber,
      invoiceDate: invoiceDate,
      subtotal: subtotal,
      discountAmount: discountAmount,
      taxAmount: taxAmount,
      totalAmount: totalAmount,
      paidAmount: paidAmount,
      remainingAmount: remainingAmount,
      status: status,
      items: items.map((i) => i.toEntity()).toList(),
      createdAt: createdAt,
    );
  }
}
