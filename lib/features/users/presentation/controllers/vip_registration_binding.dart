import 'package:get/get.dart';
import '../../domain/usecases/buy_vip_usecase.dart';
import 'vip_registration_controller.dart';

class VipRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BuyVipUseCase(Get.find()));
    Get.lazyPut<VipRegistrationController>(
      () => VipRegistrationController(
        userRepository: Get.find(),
        buyVipUseCase: Get.find(),
      ),
    );
  }
}
