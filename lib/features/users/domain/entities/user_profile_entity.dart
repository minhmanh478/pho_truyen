import '../../../auth/domain/entities/user_entity.dart';
import 'wallet_entity.dart';

class UserProfileEntity {
  final UserEntity user;
  final WalletEntity? wallet;
  final List<dynamic> vip;

  UserProfileEntity({required this.user, this.wallet, required this.vip});
}
