import 'package:get/get.dart';
import 'package:pho_truyen/features/home/data/models/home_model.dart';
import 'package:pho_truyen/features/story/data/datasources/comic_remote_data_source.dart';
import 'package:pho_truyen/features/story/data/repositories/comic_repository_impl.dart';
import 'package:pho_truyen/features/story/domain/usecases/get_favorite_stories_usecase.dart';
import 'package:pho_truyen/features/story/domain/usecases/get_viewed_stories_usecase.dart';
import 'package:pho_truyen/features/story/domain/usecases/get_read_history_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookcaseController extends GetxController {
  final GetFavoriteStoriesUseCase _getFavoriteStoriesUseCase =
      GetFavoriteStoriesUseCase(
        ComicRepositoryImpl(
          remoteDataSource: ComicRemoteDataSourceImpl(dioClient: Get.find()),
        ),
      );

  final GetViewedStoriesUseCase _getViewedStoriesUseCase =
      GetViewedStoriesUseCase(
        ComicRepositoryImpl(
          remoteDataSource: ComicRemoteDataSourceImpl(dioClient: Get.find()),
        ),
      );

  final GetReadHistoryUseCase _getReadHistoryUseCase = GetReadHistoryUseCase(
    ComicRepositoryImpl(
      remoteDataSource: ComicRemoteDataSourceImpl(dioClient: Get.find()),
    ),
  );

  final RxList<StoryModel> favoriteStories = <StoryModel>[].obs;
  final RxList<StoryModel> viewedStories = <StoryModel>[].obs;
  final RxList<StoryModel> readStories = <StoryModel>[].obs;
  final RxBool isLoadingFavorites = false.obs;
  final RxBool isLoadingViewed = false.obs;
  final RxBool isLoadingRead = false.obs;
  final RxInt userId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserIdAndFetchData();
  }

  Future<void> _loadUserIdAndFetchData() async {
    await refreshUserId();
    if (userId.value != 0) {
      fetchFavoriteStories();
      fetchViewedStories();
      fetchReadStories();
    }
  }

  Future<void> refreshData() async {
    print("BookcaseController: Refreshing data...");
    await _loadUserIdAndFetchData();
  }

  Future<void> refreshUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('user_id');
    print('BookcaseController: Loaded user_id from prefs: $id');
    userId.value = id ?? 0;
  }

  Future<void> fetchFavoriteStories() async {
    if (userId.value == 0) return;

    try {
      isLoadingFavorites.value = true;
      print("BookcaseController: Fetching favorites for user ${userId.value}");
      final stories = await _getFavoriteStoriesUseCase(userId.value);
      print("BookcaseController: Fetched ${stories.length} favorites");
      favoriteStories.assignAll(stories);
    } catch (e) {
      print("Error fetching favorite stories: $e");
      Get.snackbar("Lỗi", "Không thể tải danh sách yêu thích");
    } finally {
      isLoadingFavorites.value = false;
    }
  }

  Future<void> fetchViewedStories() async {
    if (userId.value == 0) return;

    try {
      isLoadingViewed.value = true;
      print(
        "BookcaseController: Fetching viewed stories for user ${userId.value}",
      );
      final stories = await _getViewedStoriesUseCase(userId.value);
      print("BookcaseController: Fetched ${stories.length} viewed stories");
      viewedStories.assignAll(stories);
    } catch (e) {
      print("Error fetching viewed stories: $e");
      Get.snackbar("Lỗi", "Không thể tải danh sách đã xem");
    } finally {
      isLoadingViewed.value = false;
    }
  }

  Future<void> fetchReadStories() async {
    if (userId.value == 0) return;

    try {
      isLoadingRead.value = true;
      print(
        "BookcaseController: Fetching read stories for user ${userId.value}",
      );
      final stories = await _getReadHistoryUseCase(userId.value);
      print("BookcaseController: Fetched ${stories.length} read stories");
      readStories.assignAll(stories);
    } catch (e) {
      print("Error fetching read stories: $e");
      Get.snackbar("Lỗi", "Không thể tải danh sách đã đọc");
    } finally {
      isLoadingRead.value = false;
    }
  }
}
