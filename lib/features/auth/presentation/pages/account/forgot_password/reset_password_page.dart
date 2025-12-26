import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:pho_truyen/core/constants/app_paths.dart';
import 'package:pho_truyen/features/auth/presentation/controllers/reset_password_controller.dart';
import '../../../widgets/auth_label.dart';
import '../../../widgets/auth_password_field.dart';

class ResetPasswordPage extends GetView<ResetPasswordController> {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ResetPasswordController>()) {}

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'Đặt lại mật khẩu',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColor.primaryBlue,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                child: Image.asset(AppPaths.imgLogo, height: 80),
              ),
              const SizedBox(height: 16),

              const Text(
                'Tạo mật khẩu mới',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                'Mật khẩu mới của bạn phải khác với mật khẩu cũ đã sử dụng trước đó.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 40),

              // Input: Mật khẩu mới
              const AuthLabel(text: 'Mật khẩu mới'),
              const SizedBox(height: 8),
              Obx(
                () => AuthPasswordField(
                  controller: controller.newPasswordController,
                  isHidden: controller.isNewPasswordHidden.value,
                  onToggle: controller.toggleNewPasswordVisibility,
                  hintText: 'Nhập mật khẩu mới',
                ),
              ),

              const SizedBox(height: 20),

              // Input: Xác nhận mật khẩu
              const AuthLabel(text: 'Xác nhận mật khẩu'),
              const SizedBox(height: 8),
              Obx(
                () => AuthPasswordField(
                  controller: controller.confirmPasswordController,
                  isHidden: controller.isConfirmPasswordHidden.value,
                  onToggle: controller.toggleConfirmPasswordVisibility,
                  hintText: 'Nhập lại mật khẩu mới',
                ),
              ),

              const SizedBox(height: 30),

              // Button Xác nhận
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.resetPassword(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Đổi mật khẩu',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
