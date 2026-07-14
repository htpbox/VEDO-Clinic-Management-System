import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/update_encounter_params.dart';
import '../providers/encounter_notifier.dart';
import '../../../prescriptions/presentation/widgets/prescription_form.dart';
import '../../../invoices/presentation/widgets/invoice_form.dart';

class EncounterScreen extends ConsumerStatefulWidget {
  final String patientId;
  final String patientName;

  const EncounterScreen({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  ConsumerState<EncounterScreen> createState() => _EncounterScreenState();
}

class _EncounterScreenState extends ConsumerState<EncounterScreen> {
  final _chiefComplaintController = TextEditingController();
  final _hpiController = TextEditingController();
  final _physicalExamController = TextEditingController();
  final _clinicalNotesController = TextEditingController();
  final _treatmentPlanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(encounterNotifierProvider.notifier)
          .startEncounter(widget.patientId);
    });
  }

  @override
  void dispose() {
    _chiefComplaintController.dispose();
    _hpiController.dispose();
    _physicalExamController.dispose();
    _clinicalNotesController.dispose();
    _treatmentPlanController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final params = UpdateEncounterParams(
      chiefComplaint: _chiefComplaintController.text.trim().isEmpty
          ? null
          : _chiefComplaintController.text.trim(),
      hpi: _hpiController.text.trim().isEmpty
          ? null
          : _hpiController.text.trim(),
      physicalExam: _physicalExamController.text.trim().isEmpty
          ? null
          : _physicalExamController.text.trim(),
      clinicalNotes: _clinicalNotesController.text.trim().isEmpty
          ? null
          : _clinicalNotesController.text.trim(),
      treatmentPlan: _treatmentPlanController.text.trim().isEmpty
          ? null
          : _treatmentPlanController.text.trim(),
    );

    await ref.read(encounterNotifierProvider.notifier).save(params);
  }

  Future<void> _handleClose() async {
    await _handleSave();
    if (!mounted) return;
    await ref.read(encounterNotifierProvider.notifier).close();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(encounterNotifierProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        height: 650,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'كشف طبي — ${widget.patientName}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 24),
            if (state.status == EncounterStatus.initial ||
                (state.isLoading && state.encounter == null))
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else ...[
              if (state.errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    state.errorMessage!,
                    style: const TextStyle(
                      color: AppTheme.errorColor,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _chiefComplaintController,
                        decoration: const InputDecoration(
                          labelText: 'الشكوى الرئيسية',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _hpiController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'تاريخ المرض الحالي (HPI)',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _physicalExamController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'الفحص السريري',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _clinicalNotesController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'ملاحظات الطبيب',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _treatmentPlanController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'خطة العلاج',
                        ),
                      ),
                      const Divider(height: 32),
                      if (state.encounter != null)
                        PrescriptionForm(
                          encounterId: state.encounter!.id,
                          patientId: widget.patientId,
                        ),
                      const Divider(height: 32),
                      InvoiceForm(patientId: widget.patientId),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: state.isLoading ? null : _handleSave,
                      child: const Text('حفظ (بدون إغلاق)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _handleClose,
                      child: state.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('حفظ وإغلاق الزيارة'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
