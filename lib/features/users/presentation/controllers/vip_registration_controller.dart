import 'package:get/get.dart';
import '../../domain/repositories/user_repository.dart';
import '../../data/models/vip_package_model.dart';
import 'package:pho_truyen/core/error/failures.dart';
import 'package:pho_truyen/core/utils/app_dialogs.dart';
import '../../domain/usecases/buy_vip_usecase.dart';
import 'account/user_controller.dart';

import 'package:pho_truyen/core/router/app_routes.dart';

class VipRegistrationController extends GetxController {
  final UserRepository userRepository;
  final BuyVipUseCase buyVipUseCase;

  VipRegistrationController({
    required this.userRepository,
    required this.buyVipUseCase,
  });

  final vipBundles = <VipBundleModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVipPackages();
  }

  Future<void> fetchVipPackages() async {
    isLoading.value = true;
    final result = await userRepository.getVipPackages();
    result.fold(
      (failure) {
        Get.snackbar('Error', _mapFailureToMessage(failure));
      },
      (data) {
        vipBundles.assignAll(data);
      },
    );
    isLoading.value = false;
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case CacheFailure:
        return 'Cache Failure';
      default:
        return 'Unexpected Error';
    }
  }

  void onRegisterVip(VipTimeModel vipTime) {
    if (Get.isRegistered<UserController>()) {
      final userController = Get.find<UserController>();
      final currentUser = userController.userProfile.value;

      final currentBalance = currentUser?.wallet?.availableBalance ?? 0;

      if (currentBalance < vipTime.price) {
        AppDialogs.showConfirmDialog(
          title: "Thông báo",
          message: "Số ruby trong tài khoản của bạn không đủ",
          confirmText: "Nạp",
          cancelText: "Đóng",
          onConfirm: () {
            Get.back();
            Get.toNamed(AppRoutes.loadedRuby);
          },
          onCancel: () {
            Get.back();
          },
        );
      } else {
        AppDialogs.showConfirmDialog(
          title: "Thông báo",
          message:
              "Bạn có chắc chắn đăng ký Gói Vip với giá ${vipTime.price} không ?",
          confirmText: "Ok",
          cancelText: "Đóng",
          onConfirm: () async {
            Get.back();
            await _buyVip(vipTime.id);
          },
          onCancel: () {
            Get.back();
          },
        );
      }
    } else {
      Get.snackbar('Lỗi', 'Không tìm thấy thông tin người dùng');
    }
  }

  Future<void> _buyVip(int timeId) async {
    isLoading.value = true;
    final result = await buyVipUseCase(timeId);
    result.fold(
      (failure) {
        Get.snackbar("Lỗi", _mapFailureToMessage(failure));
      },
      (success) {
        Get.snackbar("Thành công", "Đăng ký gói VIP thành công");
        // Update user profile to reflect balance change/vip status if needed
        if (Get.isRegistered<UserController>()) {
          Get.find<UserController>().fetchUserProfile();
        }
      },
    );
    isLoading.value = false;
  }
}
