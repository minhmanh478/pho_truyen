// ignore_for_file: use_super_parameters

import '../../../domain/entities/auth_entity.dart';
import 'user_model.dart';

class AuthModel extends AuthEntity {
  AuthModel({
    required UserModel user,
    required String token,
    String? refreshToken,
  }) : super(user: user, token: token, refreshToken: refreshToken);

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      // Check if 'user' key exists, otherwise try to parse the json itself as UserModel
      user: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : UserModel.fromJson(json),
      token: json['access_token'] ?? '',
      refreshToken: json['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ...(user as UserModel).toJson(),
      'access_token': token,
      'refresh_token': refreshToken,
    };
  }
}
