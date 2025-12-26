class UpdatePasswordRequest {
  final String transactionId;
  final String newPassword;

  UpdatePasswordRequest({
    required this.transactionId,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    'transaction_id': transactionId,
    'new_password': newPassword,
  };
}
