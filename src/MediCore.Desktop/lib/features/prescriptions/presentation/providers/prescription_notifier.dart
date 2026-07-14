import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/prescription_di.dart';
import '../../domain/entities/prescription.dart';
import '../../domain/entities/create_prescription_params.dart';

enum PrescriptionStatus { initial, loading, success, error }

class PrescriptionState {
  final PrescriptionStatus status;
  final Prescription? prescription;
  final String? errorMessage;

  const PrescriptionState({
    this.status = PrescriptionStatus.initial,
    this.prescription,
    this.errorMessage,
  });

  bool get isLoading => status == PrescriptionStatus.loading;
}

class PrescriptionNotifier extends StateNotifier<PrescriptionState> {
  final Ref _ref;

  PrescriptionNotifier(this._ref) : super(const PrescriptionState());

  Future<void> create(CreatePrescriptionParams params) async {
    state = const PrescriptionState(status: PrescriptionStatus.loading);
    try {
      final useCase = _ref.read(createPrescriptionUseCaseProvider);
      final prescription = await useCase.execute(params);
      state = PrescriptionState(
        status: PrescriptionStatus.success,
        prescription: prescription,
      );
    } catch (e) {
      state = PrescriptionState(
        status: PrescriptionStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    state = const PrescriptionState();
  }
}

final prescriptionNotifierProvider =
    StateNotifierProvider.autoDispose<PrescriptionNotifier, PrescriptionState>(
      (ref) => PrescriptionNotifier(ref),
    );
