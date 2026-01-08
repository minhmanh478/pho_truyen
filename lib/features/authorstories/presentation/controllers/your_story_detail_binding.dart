import 'package:get/get.dart';
import '../../domain/usecases/get_author_story_detail_usecase.dart';
import '../../domain/usecases/get_author_chapters_usecase.dart';
import 'your_story_detail_controller.dart';
import '../../domain/usecases/send_story_approved_usecase.dart';
import '../../domain/usecases/finish_story_usecase.dart';

class YourStoryDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetAuthorStoryDetailUseCase(Get.find()));
    Get.lazyPut(() => GetAuthorChaptersUseCase(Get.find()));
    Get.lazyPut(() => SendStoryApprovedUseCase(Get.find()));
    Get.lazyPut(() => FinishStoryUseCase(Get.find()));
    Get.lazyPut<YourStoryDetailController>(
      () => YourStoryDetailController(
        getAuthorStoryDetailUseCase: Get.find(),
        getAuthorChaptersUseCase: Get.find(),
        sendStoryApprovedUseCase: Get.find(),
        finishStoryUseCase: Get.find(),
      ),
    );
  }
}
