import 'user_entity.dart';

class AuthEntity {
  final UserEntity user;
  final String token;
  final String? refreshToken;

  AuthEntity({required this.user, required this.token, this.refreshToken});
}
