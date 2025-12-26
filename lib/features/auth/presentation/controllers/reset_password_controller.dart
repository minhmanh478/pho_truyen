import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/usecases/update_password_usecase.dart';

class ResetPasswordController extends GetxController {
  final UpdatePasswordUseCase updatePasswordUseCase;

  ResetPasswordController({required this.updatePasswordUseCase});

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isNewPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  String? transactionId;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      transactionId = Get.arguments['transaction_id'];
    }
  }

  @override
  void onClose() {
    // Không dispose controller ở đây để tránh lỗi "used after being disposed"
    // khi chuyển màn hình bằng Get.offAll.
    // Flutter/GetX sẽ tự động dọn dẹp khi Widget tree bị hủy.
    super.onClose();
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordHidden.value = !isNewPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  Future<void> resetPassword() async {
    final newPass = newPasswordController.text;
    final confirmPass = confirmPasswordController.text;

    if (newPass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar(
        "Lỗi",
        "Vui lòng nhập đầy đủ thông tin",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (newPass.length < 6) {
      Get.snackbar(
        "Lỗi",
        "Mật khẩu phải có ít nhất 6 ký tự",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (newPass != confirmPass) {
      Get.snackbar(
        "Lỗi",
        "Mật khẩu xác nhận không trùng khớp",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (transactionId == null) {
      Get.snackbar(
        "Lỗi",
        "Thiếu Transaction ID",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    final result = await updatePasswordUseCase(transactionId!, newPass);

    isLoading.value = false;

    result.fold(
      (failure) {
        Get.snackbar(
          "Lỗi",
          failure.message,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      },
      (success) async {
        if (success) {
          Get.snackbar(
            "Thành công",
            "Đổi mật khẩu thành công! Vui lòng đăng nhập lại.",
            backgroundColor: const Color(0xFF4CAF50),
            colorText: Colors.white,
          );
          // Unfocus để đóng bàn phím và tránh lỗi controller disposed
          FocusManager.instance.primaryFocus?.unfocus();

          // Delay nhỏ để đảm bảo UI cập nhật xong trước khi chuyển màn
          await Future.delayed(const Duration(milliseconds: 300));

          Get.offAllNamed(AppRoutes.login);
        } else {
          Get.snackbar(
            "Lỗi",
            "Đổi mật khẩu thất bại",
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      },
    );
  }
}
