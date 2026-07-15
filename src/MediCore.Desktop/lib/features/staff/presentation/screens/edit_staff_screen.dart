import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../di/staff_di.dart';
import '../../domain/entities/staff_member.dart';
import '../../domain/entities/staff_role_option.dart';
import '../../domain/entities/update_staff_params.dart';
import '../providers/edit_staff_notifier.dart';

class EditStaffScreen extends ConsumerStatefulWidget {
  final StaffMember staffMember;

  const EditStaffScreen({super.key, required this.staffMember});

  @override
  ConsumerState<EditStaffScreen> createState() => _EditStaffScreenState();
}

class _EditStaffScreenState extends ConsumerState<EditStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late String _role;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(
      text: widget.staffMember.fullName,
    );
    _phoneController = TextEditingController(
      text: widget.staffMember.phone ?? '',
    );
    // Fall back to the first assignable role if the member currently holds
    // a role not offered on this screen (e.g. SuperAdmin).
    _role = assignableStaffRoles.any((o) => o.value == widget.staffMember.role)
        ? widget.staffMember.role
        : assignableStaffRoles.first.value;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final params = UpdateStaffParams(
      fullName: _fullNameController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      role: _role,
    );

    final staffMember = await ref
        .read(editStaffNotifierProvider.notifier)
        .submit(widget.staffMember.id, params);

    if (staffMember != null && mounted) {
      ref.invalidate(staffListProvider);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editStaffNotifierProvider);

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
                'تعديل بيانات الموظف',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
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
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _fullNameController,
                enabled: !state.isLoading,
                decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'الاسم الكامل مطلوب'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                enabled: !state.isLoading,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'رقم الهاتف'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _role,
                decoration: const InputDecoration(labelText: 'الدور الوظيفي'),
                items: [
                  for (final option in assignableStaffRoles)
                    DropdownMenuItem(
                      value: option.value,
                      child: Text(option.label),
                    ),
                ],
                onChanged: state.isLoading
                    ? null
                    : (value) => setState(
                        () => _role = value ?? assignableStaffRoles.first.value,
                      ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: state.isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('إلغاء'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _handleSubmit,
                      child: state.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('حفظ'),
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
