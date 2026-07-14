import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/dialog_service.dart';
import '../providers/appointments_notifier.dart';
import 'add_appointment_screen.dart';

class AppointmentsListScreen extends ConsumerWidget {
  const AppointmentsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appointmentsNotifierProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  ref
                      .read(appointmentsNotifierProvider.notifier)
                      .loadByDate(
                        state.selectedDate.subtract(const Duration(days: 1)),
                      );
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '${state.selectedDate.year}-${state.selectedDate.month.toString().padLeft(2, '0')}-${state.selectedDate.day.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  ref
                      .read(appointmentsNotifierProvider.notifier)
                      .loadByDate(
                        state.selectedDate.add(const Duration(days: 1)),
                      );
                },
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 40,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: state.selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      ref
                          .read(appointmentsNotifierProvider.notifier)
                          .loadByDate(picked);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  icon: const Icon(Icons.calendar_month, size: 18),
                  label: const Text('اختيار تاريخ'),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const AddAppointmentScreen(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('حجز موعد'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(child: _buildBody(context, ref, state)),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AppointmentsState state,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == AppointmentsStatus.error) {
      return Center(
        child: Text(
          state.errorMessage ?? 'حدث خطأ',
          style: const TextStyle(color: AppTheme.errorColor),
        ),
      );
    }

    if (state.appointments.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد مواعيد في هذا اليوم',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      );
    }

    return ListView.separated(
      itemCount: state.appointments.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final appointment = state.appointments[index];
        final isCancelled = appointment.status == 'Cancelled';

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: _statusColor(appointment.status),
            child: const Icon(Icons.event, color: Colors.white, size: 18),
          ),
          title: Text('${appointment.startTime} - ${appointment.endTime}'),
          subtitle: Text(appointment.chiefComplaint ?? '-'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Chip(
                label: Text(
                  appointment.status,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                backgroundColor: _statusColor(appointment.status),
              ),
              if (!isCancelled) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: AppTheme.errorColor,
                    size: 20,
                  ),
                  tooltip: 'إلغاء الموعد',
                  onPressed: () async {
                    final confirmed = await DialogService.instance.showConfirm(
                      context,
                      message: 'هل أنت متأكد من إلغاء هذا الموعد؟',
                      title: 'تأكيد الإلغاء',
                    );
                    if (confirmed && context.mounted) {
                      await ref
                          .read(appointmentsNotifierProvider.notifier)
                          .cancel(appointment.id, 'ألغي بواسطة المستخدم');
                    }
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Cancelled':
        return AppTheme.errorColor;
      case 'Booked':
        return AppTheme.primaryColor;
      default:
        return AppTheme.textSecondary;
    }
  }
}
