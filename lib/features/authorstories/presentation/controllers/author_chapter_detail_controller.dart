import 'package:get/get.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/author_chapter_detail_entity.dart';
import '../../domain/entities/author_story_detail_entity.dart';
import '../../domain/usecases/get_author_chapter_detail_usecase.dart';
import '../../domain/usecases/send_chapter_approved_usecase.dart';

class AuthorChapterDetailController extends GetxController {
  final GetAuthorChapterDetailUseCase getAuthorChapterDetailUseCase;
  final SendChapterApprovedUseCase sendChapterApprovedUseCase;

  AuthorChapterDetailController({
    required this.getAuthorChapterDetailUseCase,
    required this.sendChapterApprovedUseCase,
  });

  final detail = Rxn<AuthorChapterDetailEntity>();
  final buttons = <StoryButton>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is int) {
      final id = Get.arguments as int;
      fetchDetail(id);
    } else {
      Get.back();
      Get.snackbar('Lỗi', 'Không tìm thấy thông tin chương');
    }
  }

  Future<void> fetchDetail(int id) async {
    isLoading.value = true;
    final result = await getAuthorChapterDetailUseCase(id);
    result.fold(
      (failure) {
        Get.snackbar('Lỗi', failure.message);
      },
      (data) {
        detail.value = data.detail;
        if (data.buttons != null) {
          buttons.assignAll(data.buttons!);
        }
      },
    );
    isLoading.value = false;
  }

  Future<void> sendApproved(int status) async {
    if (detail.value == null) return;

    isLoading.value = true;
    final result = await sendChapterApprovedUseCase(
      SendChapterApprovedParams(id: detail.value!.id, status: status),
    );

    result.fold(
      (failure) {
        isLoading.value = false;
        Get.snackbar('Lỗi', failure.message);
      },
      (success) async {
        final message = status == 1
            ? 'Gửi duyệt chương thành công'
            : 'Hủy duyệt chương thành công';
        Get.snackbar('Thành công', message);
        await fetchDetail(detail.value!.id);
      },
    );
  }

  void onButtonAction(String code) {
    if (code == 'edit_chapter') {
      if (detail.value != null) {
        Get.toNamed(AppRoutes.editChapter, arguments: detail.value);
      }
    } else if (code == 'send_approved') {
      sendApproved(1);
    } else if (code == 'cancel_send_approved') {
      sendApproved(0);
    } else {
      Get.snackbar('Thông báo', 'Hành động $code chưa được hỗ trợ');
    }
  }
}
