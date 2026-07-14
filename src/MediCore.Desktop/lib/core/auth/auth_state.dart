import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'session_manager.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final String? error;

  const AuthState({this.status = AuthStatus.unknown, this.error});

  AuthState copyWith({AuthStatus? status, String? error}) {
    return AuthState(status: status ?? this.status, error: error);
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get isUnknown => status == AuthStatus.unknown;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _init();
  }

  Future<void> _init() async {
    await SessionManager.instance.initialize();
    final isAuth = await SessionManager.instance.isAuthenticated();
    state = AuthState(
      status: isAuth ? AuthStatus.authenticated : AuthStatus.unauthenticated,
    );
  }

  Future<void> setAuthenticated() async {
    state = state.copyWith(status: AuthStatus.authenticated);
  }

  Future<void> setUnauthenticated() async {
    await SessionManager.instance.endSession();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void setError(String error) {
    state = state.copyWith(error: error);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
