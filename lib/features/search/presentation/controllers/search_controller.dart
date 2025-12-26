import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/router/app_routes.dart';
import '../../domain/entities/search_story_entity.dart';
import '../../domain/usecases/search_stories_usecase.dart';

class SearchController extends GetxController {
  final SearchStoriesUseCase searchStoriesUseCase;

  SearchController({required this.searchStoriesUseCase});

  final searchController = TextEditingController();
  Future<List<SearchStoryEntity>> searchStories(String query) async {
    final result = await searchStoriesUseCase(query: query);

    return result.fold(
      (failure) {
        print("Search error: ${failure.message}");
        return [];
      },
      (stories) {
        return stories;
      },
    );
  }

  void goToComicDetail(SearchStoryEntity story) {
    if (story.slug != null) {
      Get.toNamed(AppRoutes.comicDetail, arguments: int.tryParse(story.id));
    } else {
      // Phương án dự phòng: thử dùng ID nếu thiếu slug, nhưng ComicDetailController yêu cầu phải có slug
      // Có nên thử lấy slug thông qua ID không? Hay chỉ hiển thị lỗi thôi
      // Hiện tại, cứ báo lỗi vì slug là bắt buộc
      Get.snackbar(
        "Lỗi",
        "Truyện này bị lỗi dữ liệu (thiếu slug)",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
