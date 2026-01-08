// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:pho_truyen/features/story/data/datasources/comic_remote_data_source.dart';
import 'package:pho_truyen/features/story/data/repositories/comic_repository_impl.dart';
import 'package:pho_truyen/features/story/data/models/filter_settings_model.dart';
import 'package:pho_truyen/features/story/domain/usecases/get_filter_settings_usecase.dart';
import 'package:pho_truyen/features/story/domain/usecases/get_story_tags_usecase.dart';
import 'package:pho_truyen/features/story/presentation/controllers/library_controller.dart';

class FilterHastagsController extends GetxController {
  final GetStoryTagsUseCase _getStoryTagsUseCase = GetStoryTagsUseCase(
    repository: ComicRepositoryImpl(
      remoteDataSource: ComicRemoteDataSourceImpl(dioClient: Get.find()),
    ),
  );

  final GetFilterSettingsUseCase _getFilterSettingsUseCase =
      GetFilterSettingsUseCase(
        repository: ComicRepositoryImpl(
          remoteDataSource: ComicRemoteDataSourceImpl(dioClient: Get.find()),
        ),
      );

  // --------------------------------------------------------
  // DATA SOURCE (Dữ liệu tĩnh -> Động)
  // --------------------------------------------------------
  final RxList<String> genres = <String>['Tất cả'].obs;
  final RxList<String> status = <String>['Tất cả'].obs;
  final RxList<String> chapters = <String>['Tất cả'].obs;
  final RxList<String> updateTimes = <String>['Tất cả'].obs;
  final RxList<String> tags = <String>['Tất cả'].obs;
  final RxList<SortOption> sortOptions = <SortOption>[].obs;

  // Maps to store values for API
  final Map<String, String?> _genreValues = {'Tất cả': null};
  final Map<String, String?> _statusValues = {'Tất cả': null};
  final Map<String, String?> _chapterValues = {'Tất cả': null};
  final Map<String, String?> _timeValues = {'Tất cả': null};
  final Map<String, String?> _tagValues = {'Tất cả': null};

  @override
  void onInit() {
    super.onInit();
    fetchTags();
    fetchFilterSettings();
  }

  Future<void> fetchTags() async {
    try {
      final result = await _getStoryTagsUseCase();

      // Populate tag values map
      _tagValues.clear();
      _tagValues['Tất cả'] = null;
      for (var tag in result) {
        _tagValues[tag.name] = tag.id.toString();
      }

      final tagNames = result.map((e) => e.name).toList();
      tags.assignAll(['Tất cả', ...tagNames]);
      _syncWithLibraryState();
    } catch (e) {
      print('Error fetching tags: $e');
    }
  }

  Future<void> fetchFilterSettings() async {
    try {
      final settings = await _getFilterSettingsUseCase();

      for (var group in settings.filter) {
        if (group.code == 'category') {
          _populateFilter(genres, _genreValues, group.data);
        } else if (group.code == 'status') {
          _populateFilter(status, _statusValues, group.data);
        } else if (group.code == 'chapter') {
          _populateFilter(chapters, _chapterValues, group.data);
        } else if (group.code == 'time_update') {
          _populateFilter(updateTimes, _timeValues, group.data);
        }
      }

      sortOptions.assignAll(settings.sort);
      _syncWithLibraryState();
    } catch (e) {
      print('Error fetching filter settings: $e');
    }
  }

  void _syncWithLibraryState() {
    if (Get.isRegistered<LibraryController>()) {
      final libraryController = Get.find<LibraryController>();

      // Sync Genre
      if (libraryController.currentCategoryId != null) {
        final key = _genreValues.keys.firstWhere(
          (k) => _genreValues[k] == libraryController.currentCategoryId,
          orElse: () => 'Tất cả',
        );
        selectedGenre.value = key;
      }

      // Sync Status
      if (libraryController.currentState != null) {
        final key = _statusValues.keys.firstWhere(
          (k) => _statusValues[k] == libraryController.currentState,
          orElse: () => 'Tất cả',
        );
        selectedStatus.value = key;
      }

      // Sync Chapter
      if (libraryController.currentChapterMin != null &&
          libraryController.currentChapterMax != null) {
        final combinedValue =
            '${libraryController.currentChapterMin}_${libraryController.currentChapterMax}';
        final key = _chapterValues.keys.firstWhere(
          (k) => _chapterValues[k] == combinedValue,
          orElse: () => 'Tất cả',
        );
        selectedChapter.value = key;
      }

      // Sync Time Update
      if (libraryController.currentTimeUpdate != null) {
        final key = _timeValues.keys.firstWhere(
          (k) => _timeValues[k] == libraryController.currentTimeUpdate,
          orElse: () => 'Tất cả',
        );
        selectedTime.value = key;
      }

      // Sync Tags
      if (libraryController.currentTag != null) {
        final key = _tagValues.keys.firstWhere(
          (k) => _tagValues[k] == libraryController.currentTag,
          orElse: () => 'Tất cả',
        );
        // Only set if key exists in current tags list (though it should since _tagValues is built from fetchTags)
        if (tags.contains(key)) {
          selectedTag.value = key;
        }
      }
    }
  }

  void _populateFilter(
    RxList<String> list,
    Map<String, String?> valueMap,
    List<FilterOption> options,
  ) {
    list.clear();
    valueMap.clear();

    // Ensure "Tất cả" is always first if not present in API or to force order
    // The API seems to return "Tất cả" as the first item with value null, so we can just use the API order.

    for (var option in options) {
      list.add(option.title);
      valueMap[option.title] = option.value;
    }

    // Fallback if API doesn't return anything
    if (list.isEmpty) {
      list.add('Tất cả');
      valueMap['Tất cả'] = null;
    }
  }

  var selectedGenre = 'Tất cả'.obs;
  var selectedStatus = 'Tất cả'.obs;
  var selectedChapter = 'Tất cả'.obs;
  var selectedTime = 'Tất cả'.obs;
  var selectedTag = 'Tất cả'.obs;

  // Các hàm set giá trị (chỉ cần gán .value, UI sẽ tự cập nhật)
  void setGenre(String value) => selectedGenre.value = value;
  void setStatus(String value) => selectedStatus.value = value;
  void setChapter(String value) => selectedChapter.value = value;
  void setTime(String value) => selectedTime.value = value;
  void setTag(String value) => selectedTag.value = value;

  // Hàm Hủy chọn (Reset về mặc định)
  void resetFilters() {
    selectedGenre.value = 'Tất cả';
    selectedStatus.value = 'Tất cả';
    selectedChapter.value = 'Tất cả';
    selectedTime.value = 'Tất cả';
    selectedTag.value = 'Tất cả';

    print("--- Đã Hủy chọn (Reset) ---");
  }

  // Hàm Lọc
  void applyFilter() {
    print("--------------------------------");
    final genreValue = _genreValues[selectedGenre.value];
    final statusValue = _statusValues[selectedStatus.value];
    final chapterValue = _chapterValues[selectedChapter.value];
    final timeValue = _timeValues[selectedTime.value];
    final tagValue = _tagValues[selectedTag.value];

    print("• Thể loại: ${selectedGenre.value} (Value: $genreValue)");
    print("• Trạng thái: ${selectedStatus.value} (Value: $statusValue)");
    print("• Số chương: ${selectedChapter.value} (Value: $chapterValue)");
    print("• Thời gian: ${selectedTime.value} (Value: $timeValue)");
    print("• Tags: ${selectedTag.value} (Value: $tagValue)");
    print("--------------------------------");

    // Parse chapter min/max from value string (e.g., "0_200", "2000_10000000")
    String? chapterMin;
    String? chapterMax;
    if (chapterValue != null && chapterValue.contains('_')) {
      final parts = chapterValue.split('_');
      if (parts.length == 2) {
        chapterMin = parts[0];
        chapterMax = parts[1];
      }
    }

    if (Get.isRegistered<LibraryController>()) {
      final libraryController = Get.find<LibraryController>();
      libraryController.applyFilters(
        categoryId: genreValue,
        state: statusValue,
        chapterMin: chapterMin,
        chapterMax: chapterMax,
        timeUpdate: timeValue,
        tag: tagValue,
      );
      Get.back();
    } else {
      print('LibraryController not registered');
    }
  }
}
