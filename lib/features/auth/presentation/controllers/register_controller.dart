import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/router/app_routes.dart';
import '../../data/models/requests/register_request.dart';
import '../../domain/usecases/register_usecase.dart';

class RegisterController extends GetxController {
  final RegisterUseCase registerUseCase;

  RegisterController({required this.registerUseCase});

  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final errorMessage = ''.obs;

  @override
  void onClose() {
    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await registerUseCase(
        RegisterRequest(
          fullName: fullNameController.text,
          userName: usernameController.text,
          email: emailController.text,
          password: passwordController.text,
        ),
      );

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          Get.snackbar('Lỗi', failure.message);
        },
        (authEntity) {
          Get.snackbar('Thành công', 'Đăng ký tài khoản thành công');
          Get.offAllNamed(AppRoutes.login);
        },
      );

      isLoading.value = false;
    }
  }
}
