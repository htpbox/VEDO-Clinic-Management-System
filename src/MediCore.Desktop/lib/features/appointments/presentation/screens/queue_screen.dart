import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/queue_appointment.dart';
import '../providers/queue_notifier.dart';
import 'add_appointment_screen.dart';

class QueueScreen extends ConsumerWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(queueNotifierProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text(
                'قائمة الانتظار — اليوم',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Spacer(),
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
          const SizedBox(height: 16),
          Expanded(child: _buildBody(state)),
        ],
      ),
    );
  }

  Widget _buildBody(QueueState state) {
    if (state.status == QueueLoadStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == QueueLoadStatus.error) {
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
          'لا توجد مواعيد اليوم',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      );
    }

    return ListView.separated(
      itemCount: state.appointments.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) =>
          _QueueRow(appointment: state.appointments[index]),
    );
  }
}

class _QueueRow extends ConsumerWidget {
  final QueueAppointment appointment;

  const _QueueRow({required this.appointment});

  bool get _isLate {
    if (appointment.status != 'Booked') return false;
    final now = TimeOfDay.now();
    final parts = appointment.startTime.split(':');
    final startMinutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);
    final nowMinutes = now.hour * 60 + now.minute;
    return nowMinutes - startMinutes > 15;
  }

  Color _statusColor() {
    switch (appointment.status) {
      case 'Booked':
        return _isLate ? AppTheme.warningColor : AppTheme.textSecondary;
      case 'Arrived':
        return AppTheme.primaryColor;
      case 'Waiting':
        return AppTheme.secondaryColor;
      case 'InProgress':
        return const Color(0xFF9B59B6);
      case 'Done':
        return AppTheme.textSecondary;
      case 'NoShow':
      case 'Cancelled':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _statusLabel() {
    switch (appointment.status) {
      case 'Booked':
        return _isLate ? 'متأخر' : 'محجوز';
      case 'Arrived':
        return 'حضر';
      case 'Waiting':
        return 'في الانتظار';
      case 'InProgress':
        return 'مع الطبيب';
      case 'Done':
        return 'انتهى';
      case 'NoShow':
        return 'لم يحضر';
      case 'Cancelled':
        return 'ملغي';
      default:
        return appointment.status;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(queueNotifierProvider.notifier);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _statusColor(),
        child: Text(
          appointment.patientFullName.isNotEmpty
              ? appointment.patientFullName.substring(0, 1)
              : '?',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(appointment.patientFullName),
      subtitle: Text(
        '${appointment.startTime} — ${appointment.doctorFullName}'
        '${appointment.chiefComplaint != null ? ' — ${appointment.chiefComplaint}' : ''}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Chip(
            label: Text(
              _statusLabel(),
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
            backgroundColor: _statusColor(),
          ),
          const SizedBox(width: 8),
          _buildActionButton(notifier),
        ],
      ),
    );
  }

  Widget _buildActionButton(QueueNotifier notifier) {
    late final VoidCallback onPressed;
    late final String label;

    switch (appointment.status) {
      case 'Booked':
        onPressed = () => notifier.checkIn(appointment.id);
        label = 'تسجيل وصول';
        break;
      case 'Arrived':
        onPressed = () => notifier.addToQueue(appointment.id);
        label = 'إضافة للطابور';
        break;
      case 'Waiting':
        onPressed = () => notifier.callPatient(appointment.id);
        label = 'استدعاء';
        break;
      case 'InProgress':
        onPressed = () => notifier.completeVisit(appointment.id);
        label = 'إنهاء';
        break;
      default:
        return const SizedBox.shrink();
    }

    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          textStyle: const TextStyle(fontSize: 13),
        ),
        child: Text(label),
      ),
    );
  }
}
