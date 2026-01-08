import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/features/common/domain/usecases/upload_image_usecase.dart';
import 'package:pho_truyen/features/story/domain/usecases/get_filter_settings_usecase.dart';
import 'package:pho_truyen/features/story/domain/usecases/get_story_tags_usecase.dart';
import '../../data/models/create_story_request.dart';
import '../../domain/usecases/create_story_usecase.dart';
import 'package:pho_truyen/features/story/data/models/filter_settings_model.dart';
import 'author_stories_controller.dart';
import 'package:pho_truyen/core/utils/app_dialogs.dart';

class PostNewStoryController extends GetxController {
  final CreateStoryUseCase createStoryUseCase;
  final GetStoryTagsUseCase getStoryTagsUseCase;
  final GetFilterSettingsUseCase getFilterSettingsUseCase;
  final UploadImageUseCase uploadImageUseCase;

  PostNewStoryController({
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
  final Map<String, String> _tagMap = {};
  final Map<String, String> _tagIdToNameMap = {};

  @override
  void onInit() {
    super.onInit();
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
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải dữ liệu: $e');
    } finally {
      isLoading.value = false;
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

  Future<void> pickImage() async {}

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
      image: uploadedImageUrl.value,
      name: nameController.text,
      content: 'Truyện được đăng bởi tác giả',
      description: descriptionController.text,
      categoryIds: _categoryMap[selectedCategory.value]!,
      chapterReleaseSchedule: scheduleController.text,
      tagIds: selectedTags.join(','),
      limitAge: 0,
    );

    final result = await createStoryUseCase(request);

    result.fold(
      (failure) {
        Get.snackbar('Lỗi', failure.message);
      },
      (success) {
        if (success) {
          AppDialogs.showInfoDialog(
            title: "Thông báo",
            message: "Lưu truyện thành công",
            buttonText: "Đồng ý",
            onPressed: () {
              if (Get.isRegistered<AuthorStoriesController>()) {
                Get.find<AuthorStoriesController>().fetchStories();
              }
              Get.toNamed('/your-stories');
              Get.snackbar('Thành công', 'Lưu truyện thành công');
            },
          );
        } else {
          Get.snackbar('Lỗi', 'Đăng truyện thất bại');
        }
      },
    );
    isLoading.value = false;
  }
}
