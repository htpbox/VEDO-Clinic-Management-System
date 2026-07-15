import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'app_sidebar.dart';
import 'app_top_bar.dart';

class AppShell extends StatelessWidget {
  final String location;
  final Widget child;

  const AppShell({super.key, required this.location, required this.child});

  String get _title {
    if (location == AppConstants.dashboardRoute) return 'لوحة التحكم';
    if (location == AppConstants.patientsRoute) return 'المرضى';
    if (location == AppConstants.appointmentsRoute) return 'المواعيد';
    if (location == AppConstants.queueRoute) return 'قائمة الانتظار';
    if (location == AppConstants.staffRoute) return 'الموظفون';
    return AppConstants.appName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AppSidebar(currentLocation: location),
          Expanded(
            child: Column(
              children: [
                AppTopBar(title: _title),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
