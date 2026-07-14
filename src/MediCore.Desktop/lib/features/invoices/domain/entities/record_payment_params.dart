class RecordPaymentParams {
  final double amount;
  final String paymentMethod;
  final String? referenceNumber;
  final String? notes;

  const RecordPaymentParams({
    required this.amount,
    required this.paymentMethod,
    this.referenceNumber,
    this.notes,
  });
}
