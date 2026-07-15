import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';

class AppSidebar extends StatelessWidget {
  final String currentLocation;

  const AppSidebar({super.key, required this.currentLocation});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: AppTheme.surfaceColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_hospital_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 8),
          _SidebarItem(
            icon: Icons.dashboard_outlined,
            label: 'لوحة التحكم',
            isActive: currentLocation == AppConstants.dashboardRoute,
            onTap: () => context.go(AppConstants.dashboardRoute),
          ),
          _SidebarItem(
            icon: Icons.people_outline,
            label: 'المرضى',
            isActive: currentLocation == AppConstants.patientsRoute,
            onTap: () => context.go(AppConstants.patientsRoute),
          ),
          _SidebarItem(
            icon: Icons.dashboard_customize_outlined,
            label: 'قائمة الانتظار',
            isActive: currentLocation == AppConstants.queueRoute,
            onTap: () => context.go(AppConstants.queueRoute),
          ),
          _SidebarItem(
            icon: Icons.event_outlined,
            label: 'المواعيد',
            isActive: currentLocation == AppConstants.appointmentsRoute,
            onTap: () => context.go(AppConstants.appointmentsRoute),
          ),
          _SidebarItem(
            icon: Icons.badge_outlined,
            label: 'الموظفون',
            isActive: currentLocation == AppConstants.staffRoute,
            onTap: () => context.go(AppConstants.staffRoute),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: isActive
            ? AppTheme.primaryColor.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isActive
                      ? AppTheme.primaryColor
                      : AppTheme.textSecondary,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive
                        ? AppTheme.primaryColor
                        : AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
