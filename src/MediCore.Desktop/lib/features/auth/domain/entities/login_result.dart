import 'authenticated_user.dart';

class LoginResult {
  final AuthenticatedUser user;
  final String accessToken;
  final DateTime accessTokenExpiresAt;

  const LoginResult({
    required this.user,
    required this.accessToken,
    required this.accessTokenExpiresAt,
  });
}
