// ignore_for_file: avoid_print

import 'package:get/get.dart';
import '../../../../core/network/token_service.dart';
import '../../../../core/router/app_routes.dart';
import '../../../users/presentation/controllers/account/user_controller.dart';
import '../../../story/presentation/controllers/library_controller.dart';
import '../../../story/presentation/controllers/bookcase/bookcase_controller.dart';
import '../../../auth/domain/usecases/refresh_token_usecase.dart';

class MainAppController extends GetxController {
  final RxInt index = 0.obs;
  final RxBool isLoggedIn = false.obs;
  final RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  void onTabChange(int i) {
    index.value = i;
    if (i == 1) {
      // Library Tab
      if (Get.isRegistered<LibraryController>()) {
        Get.find<LibraryController>().fetchLibraryStories();
      }
    } else if (i == 2) {
      // Bookcase Tab
      if (Get.isRegistered<BookcaseController>()) {
        Get.find<BookcaseController>().refreshData();
      }
    }
  }

  Future<void> checkLoginStatus() async {
    try {
      final refreshToken = await TokenService().getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        print("CheckLoginStatus: Refresh token found. Refreshing...");
        if (Get.isRegistered<RefreshTokenUseCase>()) {
          final result = await Get.find<RefreshTokenUseCase>().call(
            refreshToken,
          );
          result.fold(
            (failure) {
              print("CheckLoginStatus: Refresh failed: ${failure.message}");
              logout();
            },
            (tokenData) {
              print("CheckLoginStatus: Refresh success");
              isLoggedIn.value = true;
            },
          );
        } else {
          // Fallback if UseCase not found (shouldn't happen if binding is correct)
          final token = await TokenService().getToken();
          isLoggedIn.value = token != null && token.isNotEmpty;
        }
      } else {
        final token = await TokenService().getToken();
        isLoggedIn.value = token != null && token.isNotEmpty;
        print("CheckLoginStatus: Token found: ${isLoggedIn.value}");
      }
    } catch (e) {
      print("CheckLoginStatus Error: $e");
      isLoggedIn.value = false;
    } finally {
      isInitialized.value = true;
    }
  }

  Future<void> logout() async {
    await TokenService().removeToken();
    isLoggedIn.value = false;
    index.value = 3; // Keep at Account tab (which will show Guest view)

    // Clear UserController state if it exists
    if (Get.isRegistered<UserController>()) {
      final userController = Get.find<UserController>();
      userController.userProfile.value = null;
    }

    // Navigate to Main App (Account Tab)
    Get.offAllNamed(AppRoutes.mainApp);
  }
}
