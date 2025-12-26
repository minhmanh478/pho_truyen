class UpdateInfoExtendRequest {
  final String bankName;
  final String bankNumber;
  final String bankAccountHolderName;
  final String identifyNumber;
  final String introduce;
  final String noti;

  UpdateInfoExtendRequest({
    required this.bankName,
    required this.bankNumber,
    required this.bankAccountHolderName,
    required this.identifyNumber,
    required this.introduce,
    required this.noti,
  });

  Map<String, dynamic> toJson() {
    return {
      'bank_name': bankName,
      'bank_number': bankNumber,
      'bank_account_holder_name': bankAccountHolderName,
      'identify_number': identifyNumber,
      'introduce': introduce,
      'noti': noti,
    };
  }
}
