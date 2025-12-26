//Gửi Email yêu cầu
class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() => {"email": email};
}

//Xác thực OTP
class VerifyOtpRequest {
  final String transactionId;
  final String otp;

  VerifyOtpRequest({required this.transactionId, required this.otp});

  Map<String, dynamic> toJson() => {
    "transaction_id": transactionId,
    "otp": otp,
  };
}

//Cập nhật mật khẩu mới
class UpdatePasswordRequest {
  final String transactionId;
  final String newPassword;

  UpdatePasswordRequest({
    required this.transactionId,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    "transaction_id": transactionId,
    "password": newPassword,
  };
}
