// ignore_for_file: use_super_parameters

import '../../../auth/data/models/responses/user_model.dart';
import '../../domain/entities/user_profile_entity.dart';
import 'wallet_model.dart';

class UserProfileModel extends UserProfileEntity {
  UserProfileModel({
    required UserModel user,
    WalletModel? wallet,
    required List<dynamic> vip,
  }) : super(user: user, wallet: wallet, vip: vip);

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      user: UserModel.fromJson(json['user']),
      wallet: json['wallet_ruby'] != null
          ? WalletModel.fromJson(json['wallet_ruby'])
          : null,
      vip: json['vip'] ?? [],
    );
  }
}
