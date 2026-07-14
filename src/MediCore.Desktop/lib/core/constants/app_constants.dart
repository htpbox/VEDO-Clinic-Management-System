class AppConstants {
  AppConstants._();

  static const String appName = 'VEDO';
  static const String appVersion = '1.0.0';

  static const String baseUrl = 'http://localhost:5243';
  static const String apiVersion = '/api';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  static const String tokenKey = 'jwt_token';
  static const String userKey = 'user_data';
  static const String tenantKey = 'tenant_id';
  static const String branchKey = 'branch_id';
  static const String expiresAtKey = 'expires_at';

  static const String loginRoute = '/login';
  static const String dashboardRoute = '/dashboard';
  static const String patientsRoute = '/patients';
  static const String appointmentsRoute = '/appointments';
  static const String queueRoute = '/queue';
}
