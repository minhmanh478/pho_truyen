import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/author_chapter_detail_entity.dart';
import '../../domain/usecases/update_chapter_usecase.dart';
import '../../data/models/update_chapter_request.dart';
import 'author_chapter_detail_controller.dart';

class EditChapterController extends GetxController {
  final UpdateChapterUseCase updateChapterUseCase;

  EditChapterController({required this.updateChapterUseCase});

  final nameController = TextEditingController();
  final contentController = TextEditingController();
  final noteController = TextEditingController();
  final priceController = TextEditingController();

  final selectedPrice = 0.obs;
  final isLoading = false.obs;

  late AuthorChapterDetailEntity chapterDetail;
  late int storyId;
  bool isCreateMode = false;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is AuthorChapterDetailEntity) {
      chapterDetail = Get.arguments as AuthorChapterDetailEntity;
      storyId = chapterDetail.storyId;
      isCreateMode = false;
      _initFormData();
    } else if (Get.arguments is int) {
      storyId = Get.arguments as int;
      isCreateMode = true;
    } else {
      Get.back();
      Get.snackbar('Lỗi', 'Không tìm thấy thông tin chương');
    }
  }

  void _initFormData() {
    nameController.text = chapterDetail.name;
    contentController.text = chapterDetail.content ?? '';
    noteController.text = chapterDetail.note ?? '';
    selectedPrice.value = chapterDetail.price;
  }

  void updatePrice(int? value) {
    if (value != null) {
      selectedPrice.value = value;
    }
  }

  Future<void> updateChapter() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Lỗi', 'Tên chương không được để trống');
      return;
    }
    if (contentController.text.trim().isEmpty) {
      Get.snackbar('Lỗi', 'Nội dung chương không được để trống');
      return;
    }

    isLoading.value = true;

    final request = UpdateChapterRequest(
      id: isCreateMode ? 0 : chapterDetail.id,
      storyId: storyId,
      name: nameController.text.trim(),
      content: contentController.text.trim(),
      note: noteController.text.trim(),
      price: selectedPrice.value,
    );

    final result = await updateChapterUseCase(request);

    result.fold(
      (failure) {
        Get.snackbar('Lỗi', failure.message);
      },
      (success) {
        Get.back(result: true);
        Get.snackbar(
          'Thành công',
          isCreateMode
              ? 'Thêm chương thành công'
              : 'Cập nhật chương thành công',
        );

        if (!isCreateMode &&
            Get.isRegistered<AuthorChapterDetailController>()) {
          Get.find<AuthorChapterDetailController>().fetchDetail(
            chapterDetail.id,
          );
        }
      },
    );

    isLoading.value = false;
  }

  @override
  void onClose() {
    nameController.dispose();
    contentController.dispose();
    noteController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
