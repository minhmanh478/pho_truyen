import 'package:pho_truyen/features/auth/domain/entities/token_entity.dart';

class TokenModel extends TokenEntity {
  TokenModel({required String accessToken, String? refreshToken})
    : super(accessToken: accessToken, refreshToken: refreshToken);

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'],
    );
  }
}
