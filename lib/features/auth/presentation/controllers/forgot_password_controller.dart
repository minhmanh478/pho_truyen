// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/request_forgot_password_usecase.dart';
import '../pages/account/forgot_password/verify_code_page.dart';

class ForgotPasswordController extends GetxController {
  final RequestForgotPasswordUseCase requestForgotPasswordUseCase;

  ForgotPasswordController({required this.requestForgotPasswordUseCase});

  final emailController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onClose() {
    // Không dispose controller ở đây để tránh lỗi "used after being disposed"
    // khi chuyển màn hình bằng Get.offAll.
    super.onClose();
  }

  Future<void> sendResetLink() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        "Lỗi",
        "Vui lòng nhập địa chỉ email",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        "Lỗi",
        "Địa chỉ email không hợp lệ",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    final result = await requestForgotPasswordUseCase(email);

    result.fold(
      (failure) {
        Get.snackbar(
          "Lỗi",
          failure.message,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      },
      (transactionId) {
        if (transactionId.isNotEmpty) {
          // Print transaction_id khi nhận được từ API request
          print(
            "ForgotPasswordController - Received Transaction ID: $transactionId",
          );

          Get.to(
            () => const VerifyCodePage(),
            arguments: {'email': email, 'transaction_id': transactionId},
          );
        } else {
          Get.snackbar(
            "Lỗi",
            "Không thể gửi yêu cầu",
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      },
    );

    isLoading.value = false;
  }
}
