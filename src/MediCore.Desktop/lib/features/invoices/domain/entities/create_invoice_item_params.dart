class CreateInvoiceItemParams {
  final String description;
  final double quantity;
  final double unitPrice;

  const CreateInvoiceItemParams({
    required this.description,
    this.quantity = 1,
    required this.unitPrice,
  });
}
