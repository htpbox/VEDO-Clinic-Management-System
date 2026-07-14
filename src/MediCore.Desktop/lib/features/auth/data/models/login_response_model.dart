import '../../domain/entities/login_result.dart';
import 'user_model.dart';

class LoginResponseModel {
  final UserModel user;
  final String accessToken;
  final DateTime accessTokenExpiresAt;

  const LoginResponseModel({
    required this.user,
    required this.accessToken,
    required this.accessTokenExpiresAt,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      user: UserModel.fromFlatJson(json),
      accessToken: json['token'] as String,
      accessTokenExpiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  LoginResult toEntity() {
    return LoginResult(
      user: user.toEntity(),
      accessToken: accessToken,
      accessTokenExpiresAt: accessTokenExpiresAt,
    );
  }
}
