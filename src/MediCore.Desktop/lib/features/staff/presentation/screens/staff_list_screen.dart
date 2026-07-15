import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../di/staff_di.dart';
import '../../domain/entities/staff_member.dart';
import '../../domain/entities/staff_role_option.dart';
import 'add_staff_screen.dart';
import 'edit_staff_screen.dart';

class StaffListScreen extends ConsumerWidget {
  const StaffListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(staffListProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const AddStaffScreen(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('إضافة موظف'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: staffAsync.when(
              data: (staff) => _StaffListView(staff: staff),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => const Center(
                child: Text(
                  'تعذر تحميل قائمة الموظفين',
                  style: TextStyle(color: AppTheme.errorColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StaffListView extends StatelessWidget {
  final List<StaffMember> staff;

  const _StaffListView({required this.staff});

  @override
  Widget build(BuildContext context) {
    if (staff.isEmpty) {
      return const Center(
        child: Text(
          'لا يوجد موظفون مسجلون',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
      );
    }

    return ListView.separated(
      itemCount: staff.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) => _StaffTile(member: staff[index]),
    );
  }
}

class _StaffTile extends ConsumerStatefulWidget {
  final StaffMember member;

  const _StaffTile({required this.member});

  @override
  ConsumerState<_StaffTile> createState() => _StaffTileState();
}

class _StaffTileState extends ConsumerState<_StaffTile> {
  bool _isToggling = false;

  Future<void> _toggleActive() async {
    setState(() => _isToggling = true);
    try {
      final useCase = ref.read(setStaffActiveStatusUseCaseProvider);
      await useCase.execute(widget.member.id, !widget.member.isActive);
      ref.invalidate(staffListProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تعذر تحديث حالة الموظف: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isToggling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final member = widget.member;
    return ListTile(
      onTap: () => showDialog(
        context: context,
        builder: (_) => EditStaffScreen(staffMember: member),
      ),
      leading: CircleAvatar(
        backgroundColor: member.isActive
            ? AppTheme.primaryColor
            : AppTheme.textSecondary,
        child: Text(
          member.fullName.isNotEmpty ? member.fullName.substring(0, 1) : '?',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(member.fullName),
      subtitle: Text('${staffRoleLabel(member.role)} • ${member.email}'),
      trailing: _isToggling
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : TextButton(
              onPressed: _toggleActive,
              child: Text(
                member.isActive ? 'نشط' : 'غير نشط',
                style: TextStyle(
                  color: member.isActive
                      ? AppTheme.secondaryColor
                      : AppTheme.errorColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }
}
