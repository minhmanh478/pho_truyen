// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/request_forgot_password_usecase.dart';
import '../../domain/usecases/verify_code_usecase.dart';
import '../pages/account/forgot_password/reset_password_page.dart';

class VerifyCodeController extends GetxController {
  final VerifyCodeUseCase verifyCodeUseCase;
  final RequestForgotPasswordUseCase requestForgotPasswordUseCase;

  VerifyCodeController({
    required this.verifyCodeUseCase,
    required this.requestForgotPasswordUseCase,
  });

  final codeController = TextEditingController();
  final isLoading = false.obs;

  String email = '';
  String transactionId = '';

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      email = Get.arguments['email'] ?? '';
      transactionId = Get.arguments['transaction_id'] ?? '';
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> verifyCode() async {
    final code = codeController.text.trim();

    if (code.isEmpty || code.length < 6) {
      Get.snackbar(
        "Lỗi",
        "Vui lòng nhập mã xác thực hợp lệ",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (transactionId.isEmpty) {
      Get.snackbar(
        "Lỗi",
        "Lỗi hệ thống: Không tìm thấy Transaction ID",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // Print transaction_id khi verify
    print(
      "VerifyCodeController - Verifying with Transaction ID: $transactionId",
    );
    print("VerifyCodeController - OTP Code: $code");

    isLoading.value = true;

    final result = await verifyCodeUseCase(transactionId, code);

    result.fold(
      (failure) {
        Get.snackbar(
          "Lỗi",
          failure.message,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      },
      (newTransactionId) {
        Get.snackbar(
          "Thành công",
          "Xác thực mã OTP thành công",
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
        );
        Get.off(
          () => const ResetPasswordPage(),
          arguments: {'email': email, 'transaction_id': newTransactionId},
        );
      },
    );

    isLoading.value = false;
  }

  Future<void> resendCode() async {
    if (email.isEmpty) return;

    isLoading.value = true;
    final result = await requestForgotPasswordUseCase(email);
    isLoading.value = false;

    result.fold(
      (failure) {
        Get.snackbar(
          "Lỗi",
          "Không thể gửi lại mã: ${failure.message}",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      },
      (newTransactionId) {
        if (newTransactionId.isNotEmpty) {
          transactionId = newTransactionId;
          Get.snackbar(
            "Thông báo",
            "Mã mới đã được gửi lại vào email: $email",
            colorText: Colors.white,
            backgroundColor: Colors.blueGrey,
          );
        } else {
          Get.snackbar(
            "Lỗi",
            "Không thể gửi lại mã",
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      },
    );
  }
}
