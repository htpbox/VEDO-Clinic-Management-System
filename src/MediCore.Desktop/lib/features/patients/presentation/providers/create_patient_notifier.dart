import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/patient_di.dart';
import '../../domain/entities/create_patient_params.dart';
import '../../domain/entities/patient.dart';

enum CreatePatientStatus { initial, loading, success, error }

class CreatePatientState {
  final CreatePatientStatus status;
  final String? errorMessage;

  const CreatePatientState({
    this.status = CreatePatientStatus.initial,
    this.errorMessage,
  });

  bool get isLoading => status == CreatePatientStatus.loading;
}

class CreatePatientNotifier extends StateNotifier<CreatePatientState> {
  final Ref _ref;

  CreatePatientNotifier(this._ref) : super(const CreatePatientState());

  Future<Patient?> submit(CreatePatientParams params) async {
    state = const CreatePatientState(status: CreatePatientStatus.loading);
    try {
      final useCase = _ref.read(createPatientUseCaseProvider);
      final patient = await useCase.execute(params);
      state = const CreatePatientState(status: CreatePatientStatus.success);
      return patient;
    } catch (e) {
      state = CreatePatientState(
        status: CreatePatientStatus.error,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  void reset() {
    state = const CreatePatientState();
  }
}

final createPatientNotifierProvider =
    StateNotifierProvider.autoDispose<
      CreatePatientNotifier,
      CreatePatientState
    >((ref) => CreatePatientNotifier(ref));
