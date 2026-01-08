import 'package:get/get.dart';
import '../../domain/usecases/get_author_chapter_detail_usecase.dart';
import '../../domain/usecases/send_chapter_approved_usecase.dart';
import 'author_chapter_detail_controller.dart';

class AuthorChapterDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetAuthorChapterDetailUseCase(Get.find()));
    Get.lazyPut(() => SendChapterApprovedUseCase(Get.find()));
    Get.lazyPut<AuthorChapterDetailController>(
      () => AuthorChapterDetailController(
        getAuthorChapterDetailUseCase: Get.find(),
        sendChapterApprovedUseCase: Get.find(),
      ),
    );
  }
}
