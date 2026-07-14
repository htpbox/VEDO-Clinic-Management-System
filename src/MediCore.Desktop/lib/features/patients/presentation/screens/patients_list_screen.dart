import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/patients_notifier.dart';
import 'add_patient_screen.dart';
import 'patient_details_dialog.dart';

class PatientsListScreen extends ConsumerStatefulWidget {
  const PatientsListScreen({super.key});

  @override
  ConsumerState<PatientsListScreen> createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends ConsumerState<PatientsListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(patientsNotifierProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'البحث بالاسم أو رقم الهاتف',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (value) {
                    ref.read(patientsNotifierProvider.notifier).search(value);
                  },
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref
                        .read(patientsNotifierProvider.notifier)
                        .search(_searchController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  icon: const Icon(Icons.search, size: 18),
                  label: const Text('بحث'),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const AddPatientScreen(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('إضافة مريض'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(child: _buildBody(state)),
        ],
      ),
    );
  }

  Widget _buildBody(PatientsState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == PatientsStatus.error) {
      return Center(
        child: Text(
          state.errorMessage ?? 'حدث خطأ',
          style: const TextStyle(color: AppTheme.errorColor),
        ),
      );
    }

    if (state.patients.isEmpty) {
      return const Center(
        child: Text(
          'لا يوجد مرضى مسجلون',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      );
    }

    return ListView.separated(
      itemCount: state.patients.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final patient = state.patients[index];
        return ListTile(
          onTap: () => showDialog(
            context: context,
            builder: (_) => PatientDetailsDialog(patient: patient),
          ),
          leading: CircleAvatar(
            backgroundColor: AppTheme.primaryColor,
            child: Text(
              patient.fullName.isNotEmpty
                  ? patient.fullName.substring(0, 1)
                  : '?',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(patient.fullName),
          subtitle: Text('رقم الملف: ${patient.fileNumber}'),
          trailing: Text(patient.phone ?? '-'),
        );
      },
    );
  }
}
