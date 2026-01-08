import 'dart:io';

import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/features/common/domain/usecases/upload_image_usecase.dart';
import 'package:pho_truyen/features/story/domain/usecases/get_filter_settings_usecase.dart';
import 'package:pho_truyen/features/story/domain/usecases/get_story_tags_usecase.dart';
import '../../data/models/create_story_request.dart';
import '../../domain/usecases/create_story_usecase.dart';

import '../../domain/entities/author_story_detail_entity.dart';

import 'package:pho_truyen/features/story/data/models/filter_settings_model.dart';

class EditStoryController extends GetxController {
  final CreateStoryUseCase createStoryUseCase;
  final GetStoryTagsUseCase getStoryTagsUseCase;
  final GetFilterSettingsUseCase getFilterSettingsUseCase;
  final UploadImageUseCase uploadImageUseCase;

  EditStoryController({
    required this.createStoryUseCase,
    required this.getStoryTagsUseCase,
    required this.getFilterSettingsUseCase,
    required this.uploadImageUseCase,
  });

  // State variables
  final RxBool isLoading = false.obs;
  final RxList<String> categories = <String>[].obs;
  final RxList<Map<String, dynamic>> tags = <Map<String, dynamic>>[].obs;

  // Selected values
  final RxString selectedCategory = ''.obs;
  final RxList<String> selectedTags = <String>[].obs;
  final RxString selectedImagePath = ''.obs;
  final RxString uploadedImageUrl = ''.obs;

  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController scheduleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Maps for IDs
  final Map<String, String> _categoryMap = {}; // Name -> ID
  final Map<String, String> _tagMap = {}; // Name -> ID
  final Map<String, String> _tagIdToNameMap = {}; // ID -> Name

  UserStoryDetail? _storyDetail;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is UserStoryDetail) {
      _storyDetail = Get.arguments as UserStoryDetail;
    }
    fetchInitialData();
  }

  @override
  void onClose() {
    nameController.dispose();
    scheduleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> fetchInitialData() async {
    isLoading.value = true;
    try {
      await Future.wait([_fetchCategories(), _fetchTags()]);
      _populateExistingData();
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải dữ liệu: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _populateExistingData() {
    if (_storyDetail != null) {
      final story = _storyDetail!;
      nameController.text = story.name ?? '';
      descriptionController.text = story.description ?? '';
      scheduleController.text = story.chapterReleaseSchedule ?? '';

      if (story.image != null && story.image!.isNotEmpty) {
        uploadedImageUrl.value = story.image!;
        selectedImagePath.value = story.image!; // Prepare for visual display
      }

      if (story.categoryIds != null) {
        final catId = story.categoryIds!.split(',').first.trim();
        final catEntry = _categoryMap.entries.firstWhereOrNull(
          (element) => element.value == catId,
        );
        if (catEntry != null) {
          selectedCategory.value = catEntry.key;
        }
      }

      // Populate Tags
      if (story.tagIds != null && story.tagIds!.isNotEmpty) {
        final existingTagIds = story.tagIds!
            .split(',')
            .map((e) => e.trim())
            .toList();
        selectedTags.assignAll(existingTagIds);
      }
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final settings = await getFilterSettingsUseCase();
      for (var group in settings.filter) {
        if (group.code == 'category') {
          _populateCategoryMap(group.data);
          break;
        }
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  void _populateCategoryMap(List<FilterOption> options) {
    categories.clear();
    _categoryMap.clear();
    for (var option in options) {
      categories.add(option.title);
      if (option.value != null) {
        _categoryMap[option.title] = option.value!;
      }
    }
  }

  Future<void> _fetchTags() async {
    try {
      final result = await getStoryTagsUseCase();
      tags.clear();
      _tagMap.clear();
      _tagIdToNameMap.clear();

      for (var tag in result) {
        tags.add({'id': tag.id.toString(), 'name': tag.name});
        _tagMap[tag.name] = tag.id.toString();
        _tagIdToNameMap[tag.id.toString()] = tag.name;
      }
    } catch (e) {
      print('Error fetching tags: $e');
    }
  }

  void onCategoryChanged(String? value) {
    if (value != null) {
      selectedCategory.value = value;
    }
  }

  void toggleTag(String tagId) {
    if (selectedTags.contains(tagId)) {
      selectedTags.remove(tagId);
    } else {
      if (selectedTags.length < 3) {
        selectedTags.add(tagId);
      } else {
        Get.snackbar('Thông báo', 'Chỉ được chọn tối đa 3 thẻ');
      }
    }
  }

  Future<void> uploadImage(File file) async {
    isLoading.value = true;
    final result = await uploadImageUseCase(file);
    result.fold(
      (failure) {
        Get.snackbar('Lỗi', failure.message);
        isLoading.value = false;
      },
      (uploadedFile) {
        selectedImagePath.value = file.path;
        uploadedImageUrl.value = uploadedFile.url;
        isLoading.value = false;
      },
    );
  }

  Future<void> submitStory() async {
    if (nameController.text.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng nhập tên truyện');
      return;
    }
    if (selectedCategory.value.isEmpty ||
        !_categoryMap.containsKey(selectedCategory.value)) {
      Get.snackbar('Lỗi', 'Vui lòng chọn thể loại');
      return;
    }
    if (uploadedImageUrl.value.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng tải lên ảnh bìa');
      return;
    }
    if (selectedTags.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng chọn ít nhất 1 thẻ');
      return;
    }

    isLoading.value = true;

    final request = CreateStoryRequest(
      id: _storyDetail?.id,
      image: uploadedImageUrl.value,
      name: nameController.text,
      content: _storyDetail?.content ?? 'Truyện được đăng bởi tác giả',
      description: descriptionController.text,
      categoryIds: _categoryMap[selectedCategory.value]!,
      chapterReleaseSchedule: scheduleController.text,
      tagIds: selectedTags.join(','),
      limitAge: _storyDetail?.limitAge ?? 0,
    );

    final result = await createStoryUseCase(request);

    result.fold(
      (failure) {
        Get.snackbar('Lỗi', failure.message);
      },
      (success) {
        if (success) {
          Get.back(result: true);
          Get.snackbar('Thành công', 'Cập nhật truyện thành công');
        } else {
          Get.snackbar('Lỗi', 'Cập nhật truyện thất bại');
        }
      },
    );
    isLoading.value = false;
  }
}
