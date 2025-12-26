class PaymentInfoModel {
  final String qrCodeUrl;
  final String bankAccount;
  final String bankName;
  final String accountName;
  final int amount;
  final String content;
  final String note;

  PaymentInfoModel({
    required this.qrCodeUrl,
    required this.bankAccount,
    required this.bankName,
    required this.accountName,
    required this.amount,
    required this.content,
    required this.note,
  });
}
