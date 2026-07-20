import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/appointments/presentation/screens/appointments_list_screen.dart';
import '../../features/auth/presentation/providers/auth_notifier.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/appointments/presentation/screens/queue_screen.dart';
import '../../features/patients/presentation/screens/patients_list_screen.dart';
import '../../features/staff/presentation/screens/staff_list_screen.dart';
import '../../features/reports/presentation/screens/reports_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/backup/presentation/screens/backup_screen.dart';
import '../../features/inventory/presentation/screens/inventory_list_screen.dart';
import '../../features/pharmacy/presentation/screens/pharmacy_sale_screen.dart';
import '../constants/app_constants.dart';
import '../widgets/app_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AppConstants.loginRoute,
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isLoading =
          authState.status == AuthStatus.initial ||
          authState.status == AuthStatus.loading;
      final isOnLogin = state.matchedLocation == AppConstants.loginRoute;

      if (isLoading) return null;
      if (!isLoggedIn && !isOnLogin) return AppConstants.loginRoute;
      if (isLoggedIn && isOnLogin) return AppConstants.dashboardRoute;
      return null;
    },
    routes: [
      GoRoute(
        path: AppConstants.loginRoute,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(
            path: AppConstants.dashboardRoute,
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppConstants.patientsRoute,
            name: 'patients',
            builder: (context, state) => const PatientsListScreen(),
          ),
          GoRoute(
            path: AppConstants.queueRoute,
            name: 'queue',
            builder: (context, state) => const QueueScreen(),
          ),
          GoRoute(
            path: AppConstants.appointmentsRoute,
            name: 'appointments',
            builder: (context, state) => const AppointmentsListScreen(),
          ),
          GoRoute(
            path: AppConstants.staffRoute,
            name: 'staff',
            builder: (context, state) => const StaffListScreen(),
          ),
          GoRoute(
            path: AppConstants.reportsRoute,
            name: 'reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: AppConstants.settingsRoute,
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: AppConstants.backupRoute,
            name: 'backup',
            builder: (context, state) => const BackupScreen(),
          ),
          GoRoute(
            path: AppConstants.inventoryRoute,
            name: 'inventory',
            builder: (context, state) => const InventoryListScreen(),
          ),
          GoRoute(
            path: AppConstants.pharmacyRoute,
            name: 'pharmacy',
            builder: (context, state) => const PharmacySaleScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('صفحة غير موجودة: ${state.error}'))),
  );
});
