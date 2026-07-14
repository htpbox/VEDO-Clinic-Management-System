import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/patient_di.dart';
import '../../domain/entities/patient.dart';
import '../../domain/entities/update_patient_params.dart';

enum EditPatientStatus { initial, loading, success, error }

class EditPatientState {
  final EditPatientStatus status;
  final String? errorMessage;

  const EditPatientState({
    this.status = EditPatientStatus.initial,
    this.errorMessage,
  });

  bool get isLoading => status == EditPatientStatus.loading;
}

class EditPatientNotifier extends StateNotifier<EditPatientState> {
  final Ref _ref;

  EditPatientNotifier(this._ref) : super(const EditPatientState());

  Future<Patient?> submit(String id, UpdatePatientParams params) async {
    state = const EditPatientState(status: EditPatientStatus.loading);
    try {
      final useCase = _ref.read(updatePatientUseCaseProvider);
      final patient = await useCase.execute(id, params);
      state = const EditPatientState(status: EditPatientStatus.success);
      return patient;
    } catch (e) {
      state = EditPatientState(
        status: EditPatientStatus.error,
        errorMessage: e.toString(),
      );
      return null;
    }
  }
}

final editPatientNotifierProvider =
    StateNotifierProvider.autoDispose<EditPatientNotifier, EditPatientState>(
      (ref) => EditPatientNotifier(ref),
    );
