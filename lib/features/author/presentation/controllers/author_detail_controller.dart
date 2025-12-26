// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:pho_truyen/features/author/data/models/author_model.dart';
import 'package:pho_truyen/features/author/domain/usecases/get_author_detail_usecase.dart';
import 'package:pho_truyen/features/author/domain/usecases/get_stories_by_author_usecase.dart';
import 'package:pho_truyen/features/home/data/models/home_model.dart';
import 'package:pho_truyen/core/router/app_routes.dart';

class AuthorDetailController extends GetxController {
  final GetAuthorDetailUseCase getAuthorDetailUseCase;
  final GetStoriesByAuthorUseCase getStoriesByAuthorUseCase;

  AuthorDetailController({
    required this.getAuthorDetailUseCase,
    required this.getStoriesByAuthorUseCase,
  });

  final RxBool isLoading = true.obs;
  final Rx<AuthorModel?> author = Rx<AuthorModel?>(null);
  final RxList<StoryModel> stories = <StoryModel>[].obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is int) {
      fetchAuthorDetail(args);
    } else {
      errorMessage.value = 'Invalid author ID';
      isLoading.value = false;
    }
  }

  Future<void> fetchAuthorDetail(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await getAuthorDetailUseCase(id);
      author.value = data.author;

      final storyList = await getStoriesByAuthorUseCase(id, 0, 20);
      print('DEBUG: Fetched ${storyList.length} stories');
      stories.assignAll(storyList);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void goToComicDetail(StoryModel story) {
    if (story.slug != null) {
      Get.toNamed(AppRoutes.comicDetail, arguments: story.id);
    } else {
      Get.snackbar('Lỗi', 'Không tìm thấy thông tin truyện (thiếu slug)');
    }
  }
}
