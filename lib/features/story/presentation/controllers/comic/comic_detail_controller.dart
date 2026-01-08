import 'package:get/get.dart';
import 'package:pho_truyen/features/story/data/datasources/comic_remote_data_source.dart';
import 'package:pho_truyen/features/story/data/models/comic_model.dart';
import 'package:pho_truyen/features/home/data/models/story_model.dart';
import 'package:pho_truyen/features/story/data/repositories/comic_repository_impl.dart';
import 'package:pho_truyen/features/story/domain/usecases/get_comic_detail_usecase.dart';
import 'package:pho_truyen/features/chapter/data/datasources/chapter_remote_data_source.dart';
import 'package:pho_truyen/features/chapter/data/repositories/chapter_repository_impl.dart';
import 'package:pho_truyen/features/chapter/domain/usecases/get_chapters_usecase.dart';
import 'package:pho_truyen/features/users/domain/usecases/donate_to_author_usecase.dart';
import 'package:pho_truyen/features/users/data/repositories/user_repository_impl.dart';
import 'package:pho_truyen/features/users/data/datasources/user_remote_datasource.dart';

import 'package:pho_truyen/features/story/domain/usecases/toggle_favorite_story_usecase.dart';
import 'package:pho_truyen/features/story/presentation/controllers/bookcase/bookcase_controller.dart';

class ComicDetailController extends GetxController {
  final GetComicDetailUseCase _getComicDetailUseCase = GetComicDetailUseCase(
    repository: ComicRepositoryImpl(
      remoteDataSource: ComicRemoteDataSourceImpl(dioClient: Get.find()),
    ),
  );

  final GetChaptersUseCase _getChaptersUseCase = GetChaptersUseCase(
    ChapterRepositoryImpl(remoteDataSource: ChapterRemoteDataSourceImpl()),
  );

  final ToggleFavoriteStoryUseCase _toggleFavoriteStoryUseCase =
      ToggleFavoriteStoryUseCase(
        ComicRepositoryImpl(
          remoteDataSource: ComicRemoteDataSourceImpl(dioClient: Get.find()),
        ),
      );

  final DonateToAuthorUseCase _donateToAuthorUseCase = DonateToAuthorUseCase(
    UserRepositoryImpl(
      remoteDataSource: UserRemoteDataSourceImpl(dioClient: Get.find()),
    ),
  );

  late Future<ComicDetailModel?> comicDetailFuture;
  final RxList<ChapterModel> chapters = <ChapterModel>[].obs;
  final RxBool isLoadingChapters = false.obs;
  final RxBool isFavorite = false.obs;
  final RxSet<int> readChapterIds = <int>{}.obs;
  final Rx<StoryModel?> userReadingHistory = Rx<StoryModel?>(null);

  @override
  void onInit() {
    super.onInit();
    final dynamic args = Get.arguments;
    int? id;

    if (args != null) {
      if (args is int) {
        id = args;
      } else if (args is String) {
        print('Error: Expected ID (int) but got String: $args');
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
      _checkReadingHistory(id);
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

  void _checkReadingHistory(int storyId) {
    if (Get.isRegistered<BookcaseController>()) {
      final bookcaseController = Get.find<BookcaseController>();
      if (bookcaseController.userId.value != 0 &&
          bookcaseController.readStories.isEmpty) {
        bookcaseController.fetchReadStories();
      }

      final history = bookcaseController.readStories.firstWhereOrNull(
        (s) => s.id == storyId,
      );
      userReadingHistory.value = history;

      ever(bookcaseController.readStories, (List<StoryModel> stories) {
        final updatedHistory = stories.firstWhereOrNull((s) => s.id == storyId);
        userReadingHistory.value = updatedHistory;
      });
    } else {
      print(
        'ComicDetailController: BookcaseController not registered for history check',
      );
    }
  }

  void markChapterAsRead(int id) {
    readChapterIds.add(id);
  }

  Future<void> donate(int authorId, int amount) async {
    try {
      final result = await _donateToAuthorUseCase(
        authorId: authorId,
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
}
