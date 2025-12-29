import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:pho_truyen/core/constants/app_paths.dart';
import 'package:pho_truyen/core/constants/app_style.dart';
import 'package:pho_truyen/features/auth/presentation/controllers/login_controller.dart';
import 'package:pho_truyen/features/auth/presentation/controllers/social_auth_controller.dart';

import 'package:pho_truyen/core/router/app_routes.dart';
import 'package:pho_truyen/shared/widgets/button/auth_widget.dart';
import '../../widgets/auth_label.dart';
import '../../widgets/auth_password_field.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<LoginController>()) {}

    final socialAuthController = Get.put(SocialAuthController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'Đăng nhập',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColor.primaryBlue,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 0),
                // Header Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Image.asset(AppPaths.imgLogo, height: 80),
                ),
                const SizedBox(height: 8),
                // Welcome Text
                const Text(
                  'Chào mừng trở lại!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Đăng nhập để tiếp tục khám phá',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 40),

                // Email Input
                const AuthLabel(text: 'Email hoặc Tên người dùng'),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: TextFormField(
                    controller: controller.usernameController,
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập email hoặc tên người dùng';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Nhập email hoặc tên người dùng',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.grey.shade500,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Password Input
                const AuthLabel(text: 'Mật khẩu'),
                const SizedBox(height: 8),
                Obx(
                  () => AuthPasswordField(
                    controller: controller.passwordController,
                    isHidden: controller.isPasswordHidden.value,
                    onToggle: controller.togglePasswordVisibility,
                    hintText: 'Nhập mật khẩu của bạn',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 0),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.forgotPassword);
                    },
                    child: Text(
                      'Quên mật khẩu?',
                      style: AppStyle.s12w600.copyWith(
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.login,
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
                              'Đăng nhập',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.white10)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'hoặc',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ),
                    const Expanded(child: Divider(color: Colors.white10)),
                  ],
                ),
                const SizedBox(height: 28),

                // Social Buttons
                Obx(
                  () => AuthWidget(
                    imagePath: AppPaths.icGoogle,
                    label: socialAuthController.isLoading.value
                        ? 'Đang xử lý...'
                        : 'Google',
                    color: AppColor.cardColor,
                    textColor: Colors.white,
                    onPress: socialAuthController.isLoading.value
                        ? null
                        : socialAuthController.loginWithGoogle,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => AuthWidget(
                    imagePath: AppPaths.icFacebook,
                    label: socialAuthController.isLoading.value
                        ? 'Đang xử lý...'
                        : 'Facebook',
                    color: AppColor.cardColor,
                    textColor: Colors.white,
                    onPress: socialAuthController.isLoading.value
                        ? null
                        : socialAuthController.loginWithFacebook,
                  ),
                ),
                const SizedBox(height: 40),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Chưa có tài khoản? ',
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.register);
                      },
                      child: Text(
                        'Đăng ký ngay',
                        style: TextStyle(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
