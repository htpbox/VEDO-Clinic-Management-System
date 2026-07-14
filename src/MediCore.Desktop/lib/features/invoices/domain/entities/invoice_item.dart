class InvoiceItem {
  final String id;
  final String description;
  final double quantity;
  final double unitPrice;
  final double totalPrice;

  const InvoiceItem({
    required this.id,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });
}