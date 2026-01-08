import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/user_story_entity.dart';
import '../../domain/entities/author_story_detail_entity.dart';
import '../../domain/usecases/get_author_story_detail_usecase.dart';
import '../../domain/usecases/get_author_chapters_usecase.dart';
import '../../domain/entities/author_chapter_entity.dart';
import '../../../../../../core/router/app_routes.dart';
import 'package:pho_truyen/core/utils/app_dialogs.dart';

import '../../domain/usecases/send_story_approved_usecase.dart';
import '../../domain/usecases/finish_story_usecase.dart';

class YourStoryDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final GetAuthorStoryDetailUseCase getAuthorStoryDetailUseCase;
  final GetAuthorChaptersUseCase getAuthorChaptersUseCase;
  final SendStoryApprovedUseCase sendStoryApprovedUseCase;
  final FinishStoryUseCase finishStoryUseCase;

  YourStoryDetailController({
    required this.getAuthorStoryDetailUseCase,
    required this.getAuthorChaptersUseCase,
    required this.sendStoryApprovedUseCase,
    required this.finishStoryUseCase,
  });

  final storyDetail = Rx<AuthorStoryDetailEntity?>(null);
  final userStory = Rx<UserStoryDetail?>(null);
  final buttons = <StoryButton>[].obs;
  final chapters = <AuthorChapterEntity>[].obs;
  final isLoading = true.obs;
  final isChaptersLoading = false.obs;
  final selectedTabIndex = 0.obs;

  late TabController tabController;

  List<StoryButton> get currentButtons {
    if (selectedTabIndex.value == 0) {
      return buttons;
    } else {
      return [
        const StoryButton(title: 'Thêm chương', code: 'create_chapter'),
        const StoryButton(title: 'Báo truyện hoàn thành', code: 'finish_story'),
      ];
    }
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      selectedTabIndex.value = tabController.index;
    });

    if (Get.arguments is UserStoryEntity) {
      final story = Get.arguments as UserStoryEntity;
      userStory.value = UserStoryDetail(
        id: story.id,
        userId: 0,
        name: story.name,
        image: story.image,
        stateName: story.stateName,
      );
      fetchStoryDetail(story.id);
      fetchChapters(story.id);
    } else {
      Get.back();
      Get.snackbar('Lỗi', 'Không tìm thấy thông tin truyện');
    }
  }

  Future<void> fetchStoryDetail(int id) async {
    isLoading.value = true;
    final result = await getAuthorStoryDetailUseCase(id);
    result.fold(
      (failure) {
        Get.snackbar('Lỗi', failure.message);
      },
      (data) {
        storyDetail.value = data;
        userStory.value = data.detail;
        if (data.buttons != null) {
          buttons.assignAll(data.buttons!);
        }
      },
    );
    isLoading.value = false;
  }

  Future<void> fetchChapters(int storyId) async {
    isChaptersLoading.value = true;
    final result = await getAuthorChaptersUseCase(storyId);
    result.fold(
      (failure) {
        print('Error fetching chapters: ${failure.message}');
      },
      (data) {
        chapters.assignAll(data);
      },
    );
    isChaptersLoading.value = false;
  }

  void onButtonAction(String code) {
    switch (code) {
      case 'create_chapter':
        createChapter();
        break;
      case 'finish_story':
        finishStory();
        break;
      case 'send_approved':
        sendApproved(1);
        break;
      case 'cancel_send_approved':
        sendApproved(0);
        break;
      case 'edit_story':
        editStory();
        break;
      default:
        Get.snackbar('Thông báo', 'Chức năng $code chưa được hỗ trợ');
    }
  }

  Future<void> sendApproved(int status) async {
    if (userStory.value == null) return;

    isLoading.value = true;

    final result = await sendStoryApprovedUseCase(
      SendStoryApprovedParams(id: userStory.value!.id, status: status),
    );

    result.fold(
      (failure) {
        isLoading.value = false;
        Get.snackbar("Thất bại", failure.message);
      },
      (success) async {
        Get.snackbar(
          "Thành công",
          status == 1
              ? "Gửi duyệt truyện thành công"
              : "Hủy gửi duyệt thành công",
        );
        await fetchStoryDetail(userStory.value!.id);
      },
    );
  }

  void editStory() async {
    if (userStory.value != null) {
      final result = await Get.toNamed(
        AppRoutes.editStory,
        arguments: userStory.value,
      );
      if (result == true) {
        fetchStoryDetail(userStory.value!.id);
      }
    } else {
      Get.snackbar('Lỗi', 'Không tìm thấy thông tin truyện để sửa');
    }
  }

  void createChapter() async {
    if (userStory.value != null) {
      final result = await Get.toNamed(
        AppRoutes.editChapter,
        arguments: userStory.value!.id,
      );
      if (result == true) {
        fetchChapters(userStory.value!.id);
      }
    }
  }

  void finishStory() {
    AppDialogs.showConfirmDialog(
      title: 'Thông báo',
      message: 'Bạn có muốn thay đổi truyện về trạng thái đã hoàn thành không',
      confirmText: 'Ok',
      cancelText: 'Đóng',
      onConfirm: () async {
        Get.back();
        await _callFinishStoryApi();
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  Future<void> _callFinishStoryApi() async {
    if (userStory.value == null) return;
    isLoading.value = true;
    final result = await finishStoryUseCase(userStory.value!.id);
    result.fold(
      (failure) {
        isLoading.value = false;
        Get.snackbar('Lỗi', failure.message);
      },
      (success) async {
        Get.snackbar('Thành công', 'Cập nhật trạng thái thành công');
        await fetchStoryDetail(userStory.value!.id);
      },
    );
  }

  void updateTabIndex(int index) {
    selectedTabIndex.value = index;
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
