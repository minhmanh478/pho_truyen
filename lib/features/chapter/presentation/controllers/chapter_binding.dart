import 'package:get/get.dart';
import 'package:pho_truyen/features/chapter/presentation/controllers/chapter_controller.dart';

class ChapterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChapterController>(() => ChapterController());
  }
}
