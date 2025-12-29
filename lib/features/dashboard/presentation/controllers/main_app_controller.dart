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
          // Dự phòng nếu không tìm thấy UseCase (sẽ không xảy ra nếu liên kết là chính xác)
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
    index.value = 3;

    // Xóa trạng thái UserController nếu nó tồn tại
    if (Get.isRegistered<UserController>()) {
      final userController = Get.find<UserController>();
      userController.userProfile.value = null;
    }

    // Điều hướng đến ứng dụng chính (tab tài khoản)
    Get.offAllNamed(AppRoutes.mainApp);
  }
}
