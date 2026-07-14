import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/create_invoice_item_params.dart';
import '../../domain/entities/create_invoice_params.dart';
import '../../domain/entities/record_payment_params.dart';
import '../providers/invoice_notifier.dart';

class InvoiceForm extends ConsumerStatefulWidget {
  final String patientId;

  const InvoiceForm({super.key, required this.patientId});

  @override
  ConsumerState<InvoiceForm> createState() => _InvoiceFormState();
}

class _InvoiceFormState extends ConsumerState<InvoiceForm> {
  final _descriptionController = TextEditingController(text: 'كشف عام');
  final _priceController = TextEditingController(text: '200');
  final _paymentAmountController = TextEditingController();
  String _paymentMethod = 'Cash';

  @override
  void dispose() {
    _descriptionController.dispose();
    _priceController.dispose();
    _paymentAmountController.dispose();
    super.dispose();
  }

  Future<void> _createInvoice() async {
    final price = double.tryParse(_priceController.text.trim());
    if (price == null || _descriptionController.text.trim().isEmpty) return;

    await ref
        .read(invoiceNotifierProvider.notifier)
        .create(
          CreateInvoiceParams(
            patientId: widget.patientId,
            items: [
              CreateInvoiceItemParams(
                description: _descriptionController.text.trim(),
                unitPrice: price,
              ),
            ],
          ),
        );
  }

  Future<void> _recordPayment() async {
    final amount = double.tryParse(_paymentAmountController.text.trim());
    if (amount == null || amount <= 0) return;

    await ref
        .read(invoiceNotifierProvider.notifier)
        .recordPayment(
          RecordPaymentParams(amount: amount, paymentMethod: _paymentMethod),
        );
    _paymentAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(invoiceNotifierProvider);
    final invoice = state.invoice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'الفاتورة',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (state.errorMessage != null)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppTheme.errorColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              state.errorMessage!,
              style: const TextStyle(color: AppTheme.errorColor, fontSize: 13),
            ),
          ),
        if (invoice == null) ...[
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'وصف الخدمة'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'السعر'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: state.isLoading ? null : _createInvoice,
            child: state.isLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('إنشاء فاتورة'),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('رقم الفاتورة: ${invoice.invoiceNumber}'),
                Text('الإجمالي: ${invoice.totalAmount} ج.م'),
                Text('المدفوع: ${invoice.paidAmount} ج.م'),
                Text(
                  'المتبقي: ${invoice.remainingAmount} ج.م',
                  style: TextStyle(
                    color: invoice.remainingAmount > 0
                        ? AppTheme.errorColor
                        : AppTheme.secondaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text('الحالة: ${invoice.status}'),
              ],
            ),
          ),
          if (invoice.remainingAmount > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _paymentAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'مبلغ الدفع'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _paymentMethod,
                    decoration: const InputDecoration(labelText: 'طريقة الدفع'),
                    items: const [
                      DropdownMenuItem(value: 'Cash', child: Text('نقدي')),
                      DropdownMenuItem(value: 'Card', child: Text('بطاقة')),
                    ],
                    onChanged: (value) =>
                        setState(() => _paymentMethod = value ?? 'Cash'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: state.isLoading ? null : _recordPayment,
              child: state.isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('تسجيل دفعة'),
            ),
          ],
        ],
      ],
    );
  }
}
