class VerifyOtpRequest {
  final String transactionId;
  final String otp;

  VerifyOtpRequest({required this.transactionId, required this.otp});

  Map<String, dynamic> toJson() => {
    'transaction_id': transactionId,
    'otp': otp,
  };
}
