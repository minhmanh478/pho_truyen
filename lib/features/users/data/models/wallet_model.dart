import '../../domain/entities/wallet_entity.dart';

class WalletModel extends WalletEntity {
  WalletModel({
    required int userId,
    required int totalBalance,
    required int freezeBalance,
    required int availableBalance,
    required int walletType,
    required String name,
  }) : super(
         userId: userId,
         totalBalance: totalBalance,
         freezeBalance: freezeBalance,
         availableBalance: availableBalance,
         walletType: walletType,
         name: name,
       );

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      userId: json['user_id'] ?? 0,
      totalBalance: json['total_balance'] ?? 0,
      freezeBalance: json['freeze_balance'] ?? 0,
      availableBalance: json['available_balance'] ?? 0,
      walletType: json['wallet_type'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
