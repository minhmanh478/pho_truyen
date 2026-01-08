// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:pho_truyen/features/author/data/models/author_model.dart';
import 'package:pho_truyen/features/author/domain/usecases/get_author_detail_usecase.dart';
import 'package:pho_truyen/features/author/domain/usecases/get_stories_by_author_usecase.dart';
import 'package:pho_truyen/features/author/domain/usecases/follow_author_usecase.dart';
import 'package:pho_truyen/features/users/domain/usecases/donate_to_author_usecase.dart';
import 'package:pho_truyen/features/home/data/models/home_model.dart';
import 'package:pho_truyen/core/router/app_routes.dart';

class AuthorDetailController extends GetxController {
  final GetAuthorDetailUseCase getAuthorDetailUseCase;
  final GetStoriesByAuthorUseCase getStoriesByAuthorUseCase;
  final FollowAuthorUseCase followAuthorUseCase;
  final DonateToAuthorUseCase donateToAuthorUseCase;

  AuthorDetailController({
    required this.getAuthorDetailUseCase,
    required this.getStoriesByAuthorUseCase,
    required this.followAuthorUseCase,
    required this.donateToAuthorUseCase,
  });

  final RxBool isLoading = true.obs;
  final Rx<AuthorModel?> author = Rx<AuthorModel?>(null);
  final RxList<StoryModel> stories = <StoryModel>[].obs;
  final RxString errorMessage = ''.obs;
  final RxBool isFollow = false.obs;
  final RxInt followCount = 0.obs;

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
      isFollow.value = data.author.isFollow == 1;
      followCount.value = data.author.followCount;

      final storyList = await getStoriesByAuthorUseCase(id, 0, 20);
      print('DEBUG: Fetched ${storyList.length} stories');
      stories.assignAll(storyList);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFollow() async {
    if (author.value == null) return;

    final newState = isFollow.value ? 0 : 1;
    final previousState = isFollow.value;
    isFollow.value = !isFollow.value;

    try {
      final success = await followAuthorUseCase(author.value!.id, newState);
      if (success) {
        // Update follow count locally
        if (newState == 1) {
          followCount.value++;
        } else {
          followCount.value--;
        }
      } else {
        isFollow.value = previousState;
        Get.snackbar('Lỗi', 'Không thể cập nhật trạng thái theo dõi');
      }
    } catch (e) {
      isFollow.value = previousState;
      print('Error toggle follow: $e');
      Get.snackbar('Lỗi', 'Có lỗi xảy ra: $e');
    }
  }

  Future<void> donate(int amount) async {
    if (author.value == null) return;
    try {
      final result = await donateToAuthorUseCase(
        authorId: author.value!.id,
        amount: amount,
      );
      result.fold(
        (failure) {
          Get.snackbar('Lỗi', 'Tặng quà thất bại: ${failure.message}');
        },
        (success) {
          if (success) {
            Get.snackbar('Thành công', 'Tặng quà thành công');
          } else {
            Get.snackbar('Lỗi', 'Tặng quà thất bại');
          }
        },
      );
    } catch (e) {
      Get.snackbar('Lỗi', 'Có lỗi xảy ra: $e');
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
