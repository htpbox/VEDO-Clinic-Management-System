import 'invoice_item.dart';

class Invoice {
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
  final List<InvoiceItem> items;
  final DateTime createdAt;

  const Invoice({
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
}
