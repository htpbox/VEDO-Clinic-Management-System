import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/dialog_service.dart';
import '../../di/patient_di.dart';
import '../../domain/entities/patient.dart';
import '../providers/patients_notifier.dart';
import 'edit_patient_screen.dart';
import '../../../encounters/presentation/screens/encounter_screen.dart';
import '../../../laboratory/presentation/screens/create_lab_order_screen.dart';
import '../../../auth/domain/enums/user_role.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';

class PatientDetailsDialog extends ConsumerWidget {
  final Patient patient;

  const PatientDetailsDialog({super.key, required this.patient});

  bool _canOrderTests(WidgetRef ref) {
    final role = ref.read(authNotifierProvider).user?.role;
    return role == UserRole.doctor ||
        role == UserRole.seniorDoctor ||
        role == UserRole.superAdmin ||
        role == UserRole.clinicAdmin;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primaryColor,
                  child: Text(
                    patient.fullName.isNotEmpty
                        ? patient.fullName.substring(0, 1)
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'رقم الملف: ${patient.fileNumber}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _InfoRow(label: 'الجنس', value: patient.gender),
            _InfoRow(
              label: 'تاريخ الميلاد',
              value: patient.dateOfBirth != null
                  ? '${patient.dateOfBirth!.year}-${patient.dateOfBirth!.month.toString().padLeft(2, '0')}-${patient.dateOfBirth!.day.toString().padLeft(2, '0')}'
                  : '-',
            ),
            _InfoRow(label: 'الهاتف', value: patient.phone ?? '-'),
            _InfoRow(label: 'البريد الإلكتروني', value: patient.email ?? '-'),
            _InfoRow(label: 'فصيلة الدم', value: patient.bloodType ?? '-'),
            _InfoRow(
              label: 'شركة التأمين',
              value: patient.insuranceCompany ?? '-',
            ),
            _InfoRow(label: 'الحالة', value: patient.status),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (_) => EncounterScreen(
                    patientId: patient.id,
                    patientName: patient.fullName,
                  ),
                );
              },
              icon: const Icon(Icons.medical_services_outlined, size: 18),
              label: const Text('بدء كشف طبي'),
            ),
            if (_canOrderTests(ref)) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (_) => CreateLabOrderScreen(
                      patientId: patient.id,
                      patientName: patient.fullName,
                    ),
                  );
                },
                icon: const Icon(Icons.science_outlined, size: 18),
                label: const Text('طلب تحاليل'),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('إغلاق'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (_) => EditPatientScreen(patient: patient),
                      );
                    },
                    child: const Text('تعديل'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.errorColor,
                side: const BorderSide(color: AppTheme.errorColor),
              ),
              onPressed: () async {
                final confirmed = await DialogService.instance.showConfirm(
                  context,
                  message: 'هل أنت متأكد من حذف هذا المريض؟',
                  title: 'تأكيد الحذف',
                );
                if (confirmed && context.mounted) {
                  await ref
                      .read(deletePatientUseCaseProvider)
                      .execute(patient.id);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ref.read(patientsNotifierProvider.notifier).search('');
                  }
                }
              },
              child: const Text('حذف المريض'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
