import 'package:get/get.dart';
import '../../domain/usecases/update_chapter_usecase.dart';
import 'edit_chapter_controller.dart';

class EditChapterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdateChapterUseCase(Get.find()));
    Get.lazyPut<EditChapterController>(
      () => EditChapterController(updateChapterUseCase: Get.find()),
    );
  }
}
