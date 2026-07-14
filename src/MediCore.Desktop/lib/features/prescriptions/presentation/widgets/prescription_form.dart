import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/create_prescription_item_params.dart';
import '../../domain/entities/create_prescription_params.dart';
import '../providers/prescription_notifier.dart';

class _DrugRow {
  final TextEditingController drugNameController = TextEditingController();
  final TextEditingController doseController = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();

  void dispose() {
    drugNameController.dispose();
    doseController.dispose();
    frequencyController.dispose();
  }
}

class PrescriptionForm extends ConsumerStatefulWidget {
  final String encounterId;
  final String patientId;

  const PrescriptionForm({
    super.key,
    required this.encounterId,
    required this.patientId,
  });

  @override
  ConsumerState<PrescriptionForm> createState() => _PrescriptionFormState();
}

class _PrescriptionFormState extends ConsumerState<PrescriptionForm> {
  final List<_DrugRow> _rows = [_DrugRow()];

  @override
  void dispose() {
    for (final row in _rows) {
      row.dispose();
    }
    super.dispose();
  }

  void _addRow() {
    setState(() => _rows.add(_DrugRow()));
  }

  void _removeRow(int index) {
    setState(() {
      _rows[index].dispose();
      _rows.removeAt(index);
    });
  }

  Future<void> _submit() async {
    final items = _rows
        .where((r) => r.drugNameController.text.trim().isNotEmpty)
        .map(
          (r) => CreatePrescriptionItemParams(
            drugName: r.drugNameController.text.trim(),
            dose: r.doseController.text.trim().isEmpty
                ? null
                : r.doseController.text.trim(),
            frequency: r.frequencyController.text.trim().isEmpty
                ? null
                : r.frequencyController.text.trim(),
          ),
        )
        .toList();

    if (items.isEmpty) return;

    await ref
        .read(prescriptionNotifierProvider.notifier)
        .create(
          CreatePrescriptionParams(
            encounterId: widget.encounterId,
            patientId: widget.patientId,
            items: items,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(prescriptionNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'الروشتة',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (state.status == PrescriptionStatus.success)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'تم إصدار الروشتة رقم: ${state.prescription!.prescriptionNumber}',
              style: const TextStyle(color: AppTheme.secondaryColor),
            ),
          ),
        if (state.errorMessage != null)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppTheme.errorColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              state.errorMessage!,
              style: const TextStyle(color: AppTheme.errorColor, fontSize: 13),
            ),
          ),
        ..._rows.asMap().entries.map((entry) {
          final index = entry.key;
          final row = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: row.drugNameController,
                    decoration: const InputDecoration(labelText: 'اسم الدواء'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: row.doseController,
                    decoration: const InputDecoration(labelText: 'الجرعة'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: row.frequencyController,
                    decoration: const InputDecoration(labelText: 'التكرار'),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: AppTheme.errorColor,
                  ),
                  onPressed: _rows.length > 1 ? () => _removeRow(index) : null,
                ),
              ],
            ),
          );
        }),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _addRow,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('إضافة دواء'),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: state.isLoading ? null : _submit,
          child: state.isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('إصدار الروشتة'),
        ),
      ],
    );
  }
}
