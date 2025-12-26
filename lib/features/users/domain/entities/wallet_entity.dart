class WalletEntity {
  final int userId;
  final int totalBalance;
  final int freezeBalance;
  final int availableBalance;
  final int walletType;
  final String name;

  WalletEntity({
    required this.userId,
    required this.totalBalance,
    required this.freezeBalance,
    required this.availableBalance,
    required this.walletType,
    required this.name,
  });
}
