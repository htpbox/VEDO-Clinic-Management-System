import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/appointment_di.dart';
import '../../domain/entities/queue_appointment.dart';

enum QueueLoadStatus { initial, loading, loaded, error }

class QueueState {
  final QueueLoadStatus status;
  final List<QueueAppointment> appointments;
  final String? errorMessage;

  const QueueState({
    this.status = QueueLoadStatus.initial,
    this.appointments = const [],
    this.errorMessage,
  });

  QueueState copyWith({
    QueueLoadStatus? status,
    List<QueueAppointment>? appointments,
    String? errorMessage,
  }) {
    return QueueState(
      status: status ?? this.status,
      appointments: appointments ?? this.appointments,
      errorMessage: errorMessage,
    );
  }
}

/// Reception Operations Center notifier.
/// Polls the same `/appointments/queue` contract used later by Doctor
/// Workspace (Sprint 3) — polling today, upgradeable to SignalR later
/// without any contract or screen change.
class QueueNotifier extends StateNotifier<QueueState> {
  final Ref _ref;
  Timer? _pollTimer;

  QueueNotifier(this._ref) : super(const QueueState()) {
    _load();
    _pollTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _load(silent: true),
    );
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) state = state.copyWith(status: QueueLoadStatus.loading);
    try {
      final useCase = _ref.read(getQueueUseCaseProvider);
      final results = await useCase.execute(DateTime.now());
      state = state.copyWith(
        status: QueueLoadStatus.loaded,
        appointments: results,
      );
    } catch (e) {
      if (!silent) {
        state = state.copyWith(
          status: QueueLoadStatus.error,
          errorMessage: e.toString(),
        );
      }
    }
  }

  Future<void> refresh() => _load();

  Future<void> checkIn(String id) async {
    await _ref.read(checkInUseCaseProvider).execute(id);
    await refresh();
  }

  Future<void> addToQueue(String id) async {
    await _ref.read(addToQueueUseCaseProvider).execute(id);
    await refresh();
  }

  Future<void> callPatient(String id) async {
    await _ref.read(callPatientUseCaseProvider).execute(id);
    await refresh();
  }

  Future<void> completeVisit(String id) async {
    await _ref.read(completeVisitUseCaseProvider).execute(id);
    await refresh();
  }
}

final queueNotifierProvider = StateNotifierProvider<QueueNotifier, QueueState>(
  (ref) => QueueNotifier(ref),
);
