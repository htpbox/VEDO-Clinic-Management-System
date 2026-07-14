import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/patient_di.dart';
import '../../domain/entities/patient.dart';

enum PatientsStatus { initial, loading, loaded, error }

class PatientsState {
  final PatientsStatus status;
  final List<Patient> patients;
  final String? errorMessage;

  const PatientsState({
    this.status = PatientsStatus.initial,
    this.patients = const [],
    this.errorMessage,
  });

  bool get isLoading => status == PatientsStatus.loading;

  PatientsState copyWith({
    PatientsStatus? status,
    List<Patient>? patients,
    String? errorMessage,
  }) {
    return PatientsState(
      status: status ?? this.status,
      patients: patients ?? this.patients,
      errorMessage: errorMessage,
    );
  }
}

class PatientsNotifier extends StateNotifier<PatientsState> {
  final Ref _ref;

  PatientsNotifier(this._ref) : super(const PatientsState()) {
    search('');
  }

  Future<void> search(String searchTerm) async {
    state = state.copyWith(status: PatientsStatus.loading);
    try {
      final useCase = _ref.read(searchPatientsUseCaseProvider);
      final results = await useCase.execute(searchTerm);
      state = state.copyWith(status: PatientsStatus.loaded, patients: results);
    } catch (e) {
      state = state.copyWith(
        status: PatientsStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

final patientsNotifierProvider =
    StateNotifierProvider<PatientsNotifier, PatientsState>(
      (ref) => PatientsNotifier(ref),
    );
