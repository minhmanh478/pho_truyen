import '../../../auth/domain/entities/user_entity.dart';
import 'wallet_entity.dart';

import 'user_vip_entity.dart';

class UserProfileEntity {
  final UserEntity user;
  final WalletEntity? wallet;
  final List<UserVipEntity> vip;

  UserProfileEntity({required this.user, this.wallet, required this.vip});
}
