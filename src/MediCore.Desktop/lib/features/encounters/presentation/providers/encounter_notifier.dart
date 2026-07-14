import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/encounter_di.dart';
import '../../domain/entities/encounter.dart';
import '../../domain/entities/create_encounter_params.dart';
import '../../domain/entities/update_encounter_params.dart';

enum EncounterStatus { initial, loading, loaded, error }

class EncounterState {
  final EncounterStatus status;
  final Encounter? encounter;
  final String? errorMessage;

  const EncounterState({
    this.status = EncounterStatus.initial,
    this.encounter,
    this.errorMessage,
  });

  bool get isLoading => status == EncounterStatus.loading;

  EncounterState copyWith({
    EncounterStatus? status,
    Encounter? encounter,
    String? errorMessage,
  }) {
    return EncounterState(
      status: status ?? this.status,
      encounter: encounter ?? this.encounter,
      errorMessage: errorMessage,
    );
  }
}

class EncounterNotifier extends StateNotifier<EncounterState> {
  final Ref _ref;

  EncounterNotifier(this._ref) : super(const EncounterState());

  Future<void> startEncounter(String patientId) async {
    state = state.copyWith(status: EncounterStatus.loading);
    try {
      final useCase = _ref.read(createEncounterUseCaseProvider);
      final encounter = await useCase.execute(
        CreateEncounterParams(patientId: patientId),
      );
      state = state.copyWith(
        status: EncounterStatus.loaded,
        encounter: encounter,
      );
    } catch (e) {
      state = state.copyWith(
        status: EncounterStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> save(UpdateEncounterParams params) async {
    final current = state.encounter;
    if (current == null) return;

    state = state.copyWith(status: EncounterStatus.loading);
    try {
      final useCase = _ref.read(updateEncounterUseCaseProvider);
      final updated = await useCase.execute(current.id, params);
      state = state.copyWith(
        status: EncounterStatus.loaded,
        encounter: updated,
      );
    } catch (e) {
      state = state.copyWith(
        status: EncounterStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> close() async {
    final current = state.encounter;
    if (current == null) return;

    state = state.copyWith(status: EncounterStatus.loading);
    try {
      final useCase = _ref.read(closeEncounterUseCaseProvider);
      final closed = await useCase.execute(current.id);
      state = state.copyWith(status: EncounterStatus.loaded, encounter: closed);
    } catch (e) {
      state = state.copyWith(
        status: EncounterStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    state = const EncounterState();
  }
}

final encounterNotifierProvider =
    StateNotifierProvider.autoDispose<EncounterNotifier, EncounterState>(
      (ref) => EncounterNotifier(ref),
    );
