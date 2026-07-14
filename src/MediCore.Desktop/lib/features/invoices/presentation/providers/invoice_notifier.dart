import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/invoice_di.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/create_invoice_params.dart';
import '../../domain/entities/record_payment_params.dart';

enum InvoiceStatus { initial, loading, success, error }

class InvoiceState {
  final InvoiceStatus status;
  final Invoice? invoice;
  final String? errorMessage;

  const InvoiceState({
    this.status = InvoiceStatus.initial,
    this.invoice,
    this.errorMessage,
  });

  bool get isLoading => status == InvoiceStatus.loading;
}

class InvoiceNotifier extends StateNotifier<InvoiceState> {
  final Ref _ref;

  InvoiceNotifier(this._ref) : super(const InvoiceState());

  Future<void> create(CreateInvoiceParams params) async {
    state = const InvoiceState(status: InvoiceStatus.loading);
    try {
      final useCase = _ref.read(createInvoiceUseCaseProvider);
      final invoice = await useCase.execute(params);
      state = InvoiceState(status: InvoiceStatus.success, invoice: invoice);
    } catch (e) {
      state = InvoiceState(
        status: InvoiceStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> recordPayment(RecordPaymentParams params) async {
    final current = state.invoice;
    if (current == null) return;

    state = state.copyWithLoading();
    try {
      final useCase = _ref.read(recordPaymentUseCaseProvider);
      final updated = await useCase.execute(current.id, params);
      state = InvoiceState(status: InvoiceStatus.success, invoice: updated);
    } catch (e) {
      state = InvoiceState(
        status: InvoiceStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

extension on InvoiceState {
  InvoiceState copyWithLoading() {
    return InvoiceState(status: InvoiceStatus.loading, invoice: invoice);
  }
}

final invoiceNotifierProvider =
    StateNotifierProvider.autoDispose<InvoiceNotifier, InvoiceState>(
      (ref) => InvoiceNotifier(ref),
    );
