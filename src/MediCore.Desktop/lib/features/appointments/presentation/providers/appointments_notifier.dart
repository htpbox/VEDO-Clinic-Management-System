import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/appointment_di.dart';
import '../../domain/entities/appointment.dart';

enum AppointmentsStatus { initial, loading, loaded, error }

class AppointmentsState {
  final AppointmentsStatus status;
  final List<Appointment> appointments;
  final DateTime selectedDate;
  final String? errorMessage;

  AppointmentsState({
    this.status = AppointmentsStatus.initial,
    this.appointments = const [],
    DateTime? selectedDate,
    this.errorMessage,
  }) : selectedDate = selectedDate ?? DateTime.now();

  bool get isLoading => status == AppointmentsStatus.loading;

  AppointmentsState copyWith({
    AppointmentsStatus? status,
    List<Appointment>? appointments,
    DateTime? selectedDate,
    String? errorMessage,
  }) {
    return AppointmentsState(
      status: status ?? this.status,
      appointments: appointments ?? this.appointments,
      selectedDate: selectedDate ?? this.selectedDate,
      errorMessage: errorMessage,
    );
  }
}

class AppointmentsNotifier extends StateNotifier<AppointmentsState> {
  final Ref _ref;

  AppointmentsNotifier(this._ref) : super(AppointmentsState()) {
    loadByDate(DateTime.now());
  }

  Future<void> loadByDate(DateTime date) async {
    state = state.copyWith(
      status: AppointmentsStatus.loading,
      selectedDate: date,
    );
    try {
      final useCase = _ref.read(searchAppointmentsUseCaseProvider);
      final results = await useCase.execute(date);
      state = state.copyWith(
        status: AppointmentsStatus.loaded,
        appointments: results,
      );
    } catch (e) {
      state = state.copyWith(
        status: AppointmentsStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refresh() => loadByDate(state.selectedDate);

  Future<void> cancel(String appointmentId, String reason) async {
    try {
      final useCase = _ref.read(cancelAppointmentUseCaseProvider);
      await useCase.execute(appointmentId, reason);
      await refresh();
    } catch (e) {
      state = state.copyWith(
        status: AppointmentsStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

final appointmentsNotifierProvider =
    StateNotifierProvider<AppointmentsNotifier, AppointmentsState>(
      (ref) => AppointmentsNotifier(ref),
    );
