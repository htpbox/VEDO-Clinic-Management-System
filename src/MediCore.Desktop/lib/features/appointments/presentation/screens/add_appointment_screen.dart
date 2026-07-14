import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../patients/domain/entities/patient.dart';
import '../../../patients/presentation/providers/patients_notifier.dart';
import '../../../staff/di/staff_di.dart';
import '../../../staff/domain/entities/staff_member.dart';
import '../../domain/entities/create_appointment_params.dart';
import '../providers/appointments_notifier.dart';
import '../providers/create_appointment_notifier.dart';

class AddAppointmentScreen extends ConsumerStatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  ConsumerState<AddAppointmentScreen> createState() =>
      _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends ConsumerState<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _chiefComplaintController = TextEditingController();
  Patient? _selectedPatient;
  String? _selectedDoctorId;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 9, minute: 30);

  @override
  void initState() {
    super.initState();
    // Smart Default: pre-fill with the last doctor used this session.
    _selectedDoctorId = ref.read(lastSelectedDoctorProvider);
  }

  @override
  void dispose() {
    _chiefComplaintController.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) {
      setState(() => _startTime = picked);
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (picked != null) {
      setState(() => _endTime = picked);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPatient == null || _selectedDoctorId == null) return;

    final params = CreateAppointmentParams(
      patientId: _selectedPatient!.id,
      doctorId: _selectedDoctorId!,
      appointmentDate: _selectedDate,
      startTime: _formatTime(_startTime),
      endTime: _formatTime(_endTime),
      chiefComplaint: _chiefComplaintController.text.trim().isEmpty
          ? null
          : _chiefComplaintController.text.trim(),
    );

    final appointment = await ref
        .read(createAppointmentNotifierProvider.notifier)
        .submit(params);

    if (appointment != null && mounted) {
      // Remember this doctor as the Smart Default for next time.
      ref.read(lastSelectedDoctorProvider.notifier).state = _selectedDoctorId;
      ref.read(appointmentsNotifierProvider.notifier).loadByDate(_selectedDate);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createAppointmentNotifierProvider);
    final patientsState = ref.watch(patientsNotifierProvider);
    final doctorsAsync = ref.watch(doctorsListProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 480,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'حجز موعد جديد',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              if (createState.errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    createState.errorMessage!,
                    style: const TextStyle(
                      color: AppTheme.errorColor,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              DropdownButtonFormField<Patient>(
                initialValue: _selectedPatient,
                decoration: const InputDecoration(labelText: 'المريض'),
                items: patientsState.patients
                    .map(
                      (p) =>
                          DropdownMenuItem(value: p, child: Text(p.fullName)),
                    )
                    .toList(),
                onChanged: createState.isLoading
                    ? null
                    : (value) => setState(() => _selectedPatient = value),
                validator: (value) => value == null ? 'يجب اختيار مريض' : null,
              ),
              const SizedBox(height: 16),
              doctorsAsync.when(
                data: (doctors) => DropdownButtonFormField<String>(
                  initialValue: _selectedDoctorId,
                  decoration: const InputDecoration(labelText: 'الطبيب'),
                  items: doctors
                      .map<DropdownMenuItem<String>>(
                        (StaffMember d) => DropdownMenuItem(
                          value: d.id,
                          child: Text(d.fullName),
                        ),
                      )
                      .toList(),
                  onChanged: createState.isLoading
                      ? null
                      : (value) => setState(() => _selectedDoctorId = value),
                  validator: (value) =>
                      value == null ? 'يجب اختيار الطبيب' : null,
                ),
                loading: () => const LinearProgressIndicator(),
                error: (err, _) => const Text(
                  'تعذر تحميل قائمة الأطباء',
                  style: TextStyle(color: AppTheme.errorColor),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: createState.isLoading ? null : _pickDate,
                child: Text(
                  'التاريخ: ${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: createState.isLoading ? null : _pickStartTime,
                      child: Text('من: ${_formatTime(_startTime)}'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: createState.isLoading ? null : _pickEndTime,
                      child: Text('إلى: ${_formatTime(_endTime)}'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _chiefComplaintController,
                enabled: !createState.isLoading,
                decoration: const InputDecoration(labelText: 'الشكوى الرئيسية'),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: createState.isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('إلغاء'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: createState.isLoading ? null : _handleSubmit,
                      child: createState.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('حجز الموعد'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
