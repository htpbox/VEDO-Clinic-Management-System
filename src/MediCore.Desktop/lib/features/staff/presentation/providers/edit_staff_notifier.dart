import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/staff_di.dart';
import '../../domain/entities/staff_member.dart';
import '../../domain/entities/update_staff_params.dart';

enum EditStaffStatus { initial, loading, success, error }

class EditStaffState {
  final EditStaffStatus status;
  final String? errorMessage;

  const EditStaffState({
    this.status = EditStaffStatus.initial,
    this.errorMessage,
  });

  bool get isLoading => status == EditStaffStatus.loading;
}

class EditStaffNotifier extends StateNotifier<EditStaffState> {
  final Ref _ref;

  EditStaffNotifier(this._ref) : super(const EditStaffState());

  Future<StaffMember?> submit(String id, UpdateStaffParams params) async {
    state = const EditStaffState(status: EditStaffStatus.loading);
    try {
      final useCase = _ref.read(updateStaffUseCaseProvider);
      final staffMember = await useCase.execute(id, params);
      state = const EditStaffState(status: EditStaffStatus.success);
      return staffMember;
    } catch (e) {
      state = EditStaffState(
        status: EditStaffStatus.error,
        errorMessage: e.toString(),
      );
      return null;
    }
  }
}

final editStaffNotifierProvider =
    StateNotifierProvider.autoDispose<EditStaffNotifier, EditStaffState>(
      (ref) => EditStaffNotifier(ref),
    );
