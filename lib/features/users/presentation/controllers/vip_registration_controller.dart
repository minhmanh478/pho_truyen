import 'package:get/get.dart';
import '../../domain/repositories/user_repository.dart';
import '../../data/models/vip_package_model.dart';
import 'package:pho_truyen/core/error/failures.dart';

class VipRegistrationController extends GetxController {
  final UserRepository userRepository;

  VipRegistrationController({required this.userRepository});

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
}
