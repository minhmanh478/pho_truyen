import 'dart:async';

import 'package:get/get.dart';
import 'package:pho_truyen/core/router/app_routes.dart';
import 'package:pho_truyen/features/home/data/models/home_model.dart';
import 'package:pho_truyen/features/search/domain/usecases/search_stories_usecase.dart';

import 'package:pho_truyen/features/story/data/datasources/comic_remote_data_source.dart';
import 'package:pho_truyen/features/story/data/repositories/comic_repository_impl.dart';
import 'package:pho_truyen/features/story/domain/usecases/get_stories_usecase.dart';

class LibraryController extends GetxController {
  final SearchStoriesUseCase searchStoriesUseCase;
  final GetStoriesUseCase _getStoriesUseCase = GetStoriesUseCase(
    repository: ComicRepositoryImpl(
      remoteDataSource: ComicRemoteDataSourceImpl(dioClient: Get.find()),
    ),
  );

  LibraryController({required this.searchStoriesUseCase});

  final RxList<StoryModel> libraryStories = <StoryModel>[].obs;
  final RxBool isLoadingLibrary = false.obs;

  String? _currentCategoryId;
  String? _currentState;
  String? _currentChapterMin;
  String? _currentChapterMax;
  String? _currentTimeUpdate;
  String? _currentTag;

  String _currentOrder = 'update';
  String _currentSort = 'desc';

  String? get currentCategoryId => _currentCategoryId;
  String? get currentState => _currentState;
  String? get currentChapterMin => _currentChapterMin;
  String? get currentChapterMax => _currentChapterMax;
  String? get currentTimeUpdate => _currentTimeUpdate;
  String? get currentTag => _currentTag;
  String get currentOrder => _currentOrder;
  String get currentSort => _currentSort;

  @override
  void onInit() {
    super.onInit();
    fetchLibraryStories();
  }

  Future<void> fetchLibraryStories() async {
    isLoadingLibrary.value = true;
    try {
      final stories = await _getStoriesUseCase(
        categoryId: _currentCategoryId,
        state: _currentState,
        chapterMin: _currentChapterMin,
        chapterMax: _currentChapterMax,
        timeUpdate: _currentTimeUpdate,
        tag: _currentTag,
        order: _currentOrder,
        sort: _currentSort,
        code: 'STORY_FULL',
      );

      libraryStories.assignAll(stories);
    } catch (e) {
      print("Fetch Library error: $e");
    } finally {
      isLoadingLibrary.value = false;
    }
  }

  void applyFilters({
    String? categoryId,
    String? state,
    String? chapterMin,
    String? chapterMax,
    String? timeUpdate,
    String? tag,
  }) {
    _currentCategoryId = categoryId;
    _currentState = state;
    _currentChapterMin = chapterMin;
    _currentChapterMax = chapterMax;
    _currentTimeUpdate = timeUpdate;
    _currentTag = tag;

    fetchLibraryStories();
  }

  void applySort(String order, String sort) {
    _currentOrder = order;
    _currentSort = sort;
    fetchLibraryStories();
  }

  Future<List<StoryModel>> searchStories(String query) async {
    final result = await searchStoriesUseCase(query: query);

    return result.fold(
      (failure) {
        print("Search error: ${failure.message}");
        return [];
      },
      (stories) {
        return stories
            .map(
              (e) => StoryModel(
                id: int.tryParse(e.id) ?? 0,
                userId: 0,
                name: e.name,
                image: e.coverImage,
                chapterCount: e.chapterCount,
                readCount: 0,
                nominations: 0,
                hashtags: e.hashtags
                    .map((tag) => StoryHashtag(name: tag, color: '000000'))
                    .toList(),
                slug: e.slug,
              ),
            )
            .toList();
      },
    );
  }

  void goToComicDetail(StoryModel story) {
    if (story.slug != null) {
      Get.toNamed(AppRoutes.comicDetail, arguments: story.id);
    } else {
      print("Error: Missing slug for story ${story.id}");
      Get.snackbar('Lỗi', 'Không tìm thấy thông tin truyện (thiếu slug)');
    }
  }
}
