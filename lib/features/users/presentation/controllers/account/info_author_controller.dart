import 'package:get/get.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../data/models/update_info_extend_request.dart';
import '../../../data/models/user_extend_info_model.dart';
import 'package:pho_truyen/core/error/failures.dart';

class InfoAuthorController extends GetxController {
  final UserRepository userRepository;

  InfoAuthorController({required this.userRepository});

  final userExtendInfo = Rxn<UserExtendInfoModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getUserExtendInfo();
  }

  Future<void> getUserExtendInfo() async {
    isLoading.value = true;
    final result = await userRepository.getUserExtendInfo();
    isLoading.value = false;

    result.fold(
      (failure) {
        Get.snackbar('Error', _mapFailureToMessage(failure));
      },
      (data) {
        userExtendInfo.value = data;
      },
    );
  }

  Future<bool> updateInfoExtend({
    required String bankName,
    required String bankNumber,
    required String bankAccountHolderName,
    required String identifyNumber,
    required String introduce,
    required String noti,
  }) async {
    isLoading.value = true;
    final request = UpdateInfoExtendRequest(
      bankName: bankName,
      bankNumber: bankNumber,
      bankAccountHolderName: bankAccountHolderName,
      identifyNumber: identifyNumber,
      introduce: introduce,
      noti: noti,
    );

    final result = await userRepository.updateInfoExtend(request);
    isLoading.value = false;

    return result.fold(
      (failure) {
        Get.snackbar('Error', _mapFailureToMessage(failure));
        return false;
      },
      (success) {
        if (success) {
          Get.snackbar('Success', 'Cập nhật thông tin thành công');
          // Refresh data after update
          getUserExtendInfo();
        } else {
          Get.snackbar('Error', 'Cập nhật thất bại');
        }
        return success;
      },
    );
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
}
