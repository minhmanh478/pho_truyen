// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/router/app_routes.dart';
import '../../data/models/requests/login_request.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../../dashboard/presentation/controllers/main_app_controller.dart';

class LoginController extends GetxController {
  final LoginUseCase loginUseCase;

  LoginController({required this.loginUseCase});

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final errorMessage = ''.obs;

  @override
  void onClose() {
    // Không dispose controller ở đây để tránh lỗi "used after being disposed"
    // khi chuyển màn hình bằng Get.offAll.
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await loginUseCase(
        LoginRequest(
          userName: usernameController.text,
          password: passwordController.text,
        ),
      );

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          Get.snackbar('Error', failure.message);
        },
        (authEntity) async {
          // Save token and user info
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', authEntity.token);
          await prefs.setInt('user_id', authEntity.user.id);

          print('Login Success');
          print('Access Token: ${authEntity.token}');
          print('User ID: ${authEntity.user.id}');

          // Update MainAppController state
          try {
            final mainAppController = Get.find<MainAppController>();
            mainAppController.checkLoginStatus();
            mainAppController.onTabChange(3); // Switch to Account tab
          } catch (e) {
            print("MainAppController not found: $e");
          }

          Get.offAllNamed(AppRoutes.mainApp);
        },
      );

      isLoading.value = false;
    }
  }
}
