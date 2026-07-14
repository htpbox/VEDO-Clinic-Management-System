import 'dart:convert';
import '../storage/storage_service.dart';

class CurrentUser {
  CurrentUser._();
  static final CurrentUser instance = CurrentUser._();

  String? _userId;
  String? _fullName;
  String? _email;
  String? _role;
  String? _tenantId;
  String? _branchId;

  String? get userId => _userId;
  String? get fullName => _fullName;
  String? get email => _email;
  String? get role => _role;
  String? get tenantId => _tenantId;
  String? get branchId => _branchId;
  bool get isLoaded => _userId != null;

  Future<void> loadFromStorage() async {
    final userData = await StorageService.instance.getUserData();
    if (userData == null) return;
    final map = jsonDecode(userData) as Map<String, dynamic>;
    _userId = map['userId'] as String?;
    _fullName = map['fullName'] as String?;
    _email = map['email'] as String?;
    _role = map['role'] as String?;
    _tenantId = map['tenantId'] as String?;
    _branchId = map['branchId'] as String?;
  }

  Future<void> save({
    required String userId,
    required String fullName,
    required String email,
    required String role,
    required String tenantId,
    String? branchId,
  }) async {
    _userId = userId;
    _fullName = fullName;
    _email = email;
    _role = role;
    _tenantId = tenantId;
    _branchId = branchId;
    final map = {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'role': role,
      'tenantId': tenantId,
      'branchId': branchId,
    };
    await StorageService.instance.saveUserData(jsonEncode(map));
  }

  Future<void> clear() async {
    _userId = null;
    _fullName = null;
    _email = null;
    _role = null;
    _tenantId = null;
    _branchId = null;
  }
}
