import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/domain/enums/user_role.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../di/settings_di.dart';
import '../../domain/entities/tenant_settings.dart';
import '../../domain/entities/update_tenant_settings_params.dart';
import '../providers/update_settings_notifier.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _governorateController = TextEditingController();
  final _taxNumberController = TextEditingController();

  bool _initialized = false;

  void _populateFrom(TenantSettings settings) {
    if (_initialized) return;
    _nameController.text = settings.name;
    _nameEnController.text = settings.nameEn ?? '';
    _phoneController.text = settings.phone ?? '';
    _emailController.text = settings.email ?? '';
    _addressController.text = settings.address ?? '';
    _cityController.text = settings.city ?? '';
    _governorateController.text = settings.governorate ?? '';
    _taxNumberController.text = settings.taxNumber ?? '';
    _initialized = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameEnController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _governorateController.dispose();
    _taxNumberController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final params = UpdateTenantSettingsParams(
      name: _nameController.text.trim(),
      nameEn: _nameEnController.text.trim().isEmpty
          ? null
          : _nameEnController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      city: _cityController.text.trim().isEmpty
          ? null
          : _cityController.text.trim(),
      governorate: _governorateController.text.trim().isEmpty
          ? null
          : _governorateController.text.trim(),
      taxNumber: _taxNumberController.text.trim().isEmpty
          ? null
          : _taxNumberController.text.trim(),
    );

    final result = await ref
        .read(updateSettingsNotifierProvider.notifier)
        .submit(params);

    if (result != null && mounted) {
      ref.invalidate(settingsProvider);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم حفظ الإعدادات بنجاح')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final updateState = ref.watch(updateSettingsNotifierProvider);
    final currentUser = ref.watch(authNotifierProvider).user;
    final canEdit =
        currentUser?.role == UserRole.superAdmin ||
        currentUser?.role == UserRole.clinicAdmin;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: settingsAsync.when(
        data: (settings) {
          _populateFrom(settings);
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'بيانات العيادة',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    if (!canEdit) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'للاطلاع فقط - يمكن لمدير العيادة أو المدير العام تعديل هذه البيانات',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    if (updateState.errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.errorColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          updateState.errorMessage!,
                          style: const TextStyle(
                            color: AppTheme.errorColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextFormField(
                      controller: _nameController,
                      enabled: canEdit && !updateState.isLoading,
                      decoration: const InputDecoration(
                        labelText: 'اسم العيادة',
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'اسم العيادة مطلوب'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameEnController,
                      enabled: canEdit && !updateState.isLoading,
                      decoration: const InputDecoration(
                        labelText: 'اسم العيادة (إنجليزي)',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      enabled: canEdit && !updateState.isLoading,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'رقم الهاتف',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      enabled: canEdit && !updateState.isLoading,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      enabled: canEdit && !updateState.isLoading,
                      decoration: const InputDecoration(labelText: 'العنوان'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            enabled: canEdit && !updateState.isLoading,
                            decoration: const InputDecoration(
                              labelText: 'المدينة',
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _governorateController,
                            enabled: canEdit && !updateState.isLoading,
                            decoration: const InputDecoration(
                              labelText: 'المحافظة',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _taxNumberController,
                      enabled: canEdit && !updateState.isLoading,
                      decoration: const InputDecoration(
                        labelText: 'الرقم الضريبي',
                      ),
                    ),
                    if (canEdit) ...[
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: updateState.isLoading
                              ? null
                              : _handleSave,
                          child: updateState.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('حفظ التغييرات'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => const Center(
          child: Text(
            'تعذر تحميل الإعدادات',
            style: TextStyle(color: AppTheme.errorColor),
          ),
        ),
      ),
    );
  }
}
