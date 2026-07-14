import 'create_invoice_item_params.dart';

class CreateInvoiceParams {
  final String patientId;
  final String? encounterId;
  final double discountAmount;
  final String? notes;
  final List<CreateInvoiceItemParams> items;

  const CreateInvoiceParams({
    required this.patientId,
    this.encounterId,
    this.discountAmount = 0,
    this.notes,
    required this.items,
  });
}
