import 'package:get/get.dart';
import 'package:pho_truyen/features/story/data/datasources/comic_remote_data_source.dart';
import 'package:pho_truyen/features/story/data/models/comic_model.dart';
import 'package:pho_truyen/features/story/data/repositories/comic_repository_impl.dart';
import 'package:pho_truyen/features/story/domain/usecases/get_comic_detail_usecase.dart';
import 'package:pho_truyen/features/chapter/data/datasources/chapter_remote_data_source.dart';
import 'package:pho_truyen/features/chapter/data/repositories/chapter_repository_impl.dart';
import 'package:pho_truyen/features/chapter/domain/usecases/get_chapters_usecase.dart';

import 'package:pho_truyen/features/story/domain/usecases/toggle_favorite_story_usecase.dart';
import 'package:pho_truyen/features/story/presentation/controllers/bookcase/bookcase_controller.dart';

class ComicDetailController extends GetxController {
  final GetComicDetailUseCase _getComicDetailUseCase = GetComicDetailUseCase(
    repository: ComicRepositoryImpl(
      remoteDataSource: ComicRemoteDataSourceImpl(),
    ),
  );

  final GetChaptersUseCase _getChaptersUseCase = GetChaptersUseCase(
    ChapterRepositoryImpl(remoteDataSource: ChapterRemoteDataSourceImpl()),
  );

  final ToggleFavoriteStoryUseCase _toggleFavoriteStoryUseCase =
      ToggleFavoriteStoryUseCase(
        ComicRepositoryImpl(remoteDataSource: ComicRemoteDataSourceImpl()),
      );

  late Future<ComicDetailModel?> comicDetailFuture;
  final RxList<ChapterModel> chapters = <ChapterModel>[].obs;
  final RxBool isLoadingChapters = false.obs;
  final RxBool isFavorite = false.obs;
  final RxSet<int> readChapterIds = <int>{}.obs; // Local state for now

  @override
  void onInit() {
    super.onInit();
    final dynamic args = Get.arguments;
    int? id;

    if (args != null) {
      if (args is int) {
        id = args;
      } else if (args is String) {
        // Handle legacy string args if necessary, or log error
        print('Error: Expected ID (int) but got String: $args');
        // Try to parse if it happens to be a numeric string
        id = int.tryParse(args);
      } else if (args is Map) {
        id = args['id'];
      }
    }

    if (id != null) {
      print('ComicDetailController initialized with ID: $id');
      comicDetailFuture = getComicDetail(id);
      fetchChapters(id);
      _checkIfFavorite(id);
    } else {
      comicDetailFuture = Future.error("Invalid ID");
    }
  }

  Future<ComicDetailModel?> getComicDetail(int id) async {
    try {
      final result = await _getComicDetailUseCase(id);
      fetchChapters(result.id);
      _checkIfFavorite(result.id);
      return result;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> fetchChapters(int id) async {
    try {
      isLoadingChapters.value = true;
      final response = await _getChaptersUseCase(id);
      if (response.code == 'SUCCESS' || response.code == 'success') {
        chapters.assignAll(response.data);
        readChapterIds.assignAll(
          response.data.where((c) => c.isRead == 1).map((c) => c.id).toSet(),
        );
      }
    } catch (e) {
      print("Error fetching chapters: $e");
    } finally {
      isLoadingChapters.value = false;
    }
  }

  Future<void> toggleFavorite(int storyId) async {
    // 1: Favorite, 0: Unfavorite
    print('ComicDetailController: Current isFavorite: ${isFavorite.value}');
    final newState = isFavorite.value ? 0 : 1;
    print('ComicDetailController: Toggling to state: $newState');
    final success = await _toggleFavoriteStoryUseCase(storyId, newState);
    if (success) {
      isFavorite.value = !isFavorite.value;
      Get.snackbar(
        'Thành công',
        newState == 1 ? 'Đã lưu truyện' : 'Đã bỏ lưu truyện',
      );

      // Refresh BookcaseController if registered
      if (Get.isRegistered<BookcaseController>()) {
        Get.find<BookcaseController>().fetchFavoriteStories();
      }
    } else {
      Get.snackbar('Lỗi', 'Không thể thay đổi trạng thái yêu thích');
    }
  }

  void _checkIfFavorite(int storyId) {
    if (Get.isRegistered<BookcaseController>()) {
      final bookcaseController = Get.find<BookcaseController>();
      final favIds = bookcaseController.favoriteStories
          .map((s) => s.id)
          .toList();
      print('ComicDetailController: Favorite IDs in Bookcase: $favIds');
      final isFav = favIds.contains(storyId);
      print(
        'ComicDetailController: Checking if story $storyId is favorite: $isFav',
      );
      isFavorite.value = isFav;
    } else {
      print('ComicDetailController: BookcaseController not registered');
    }
  }

  void markChapterAsRead(int id) {
    readChapterIds.add(id);
  }
}
