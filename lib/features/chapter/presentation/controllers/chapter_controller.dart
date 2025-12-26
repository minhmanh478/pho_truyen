import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/features/chapter/data/datasources/chapter_remote_data_source.dart';
import 'package:pho_truyen/features/chapter/data/models/chapter_model.dart';
import 'package:pho_truyen/features/chapter/data/repositories/chapter_repository_impl.dart';
import 'package:pho_truyen/features/chapter/domain/repositories/chapter_repository.dart';
import 'package:pho_truyen/features/chapter/domain/usecases/get_chapter_detail_usecase.dart';
import 'package:pho_truyen/features/chapter/domain/usecases/buy_chapter_usecase.dart';
import 'package:pho_truyen/features/story/data/models/comic_model.dart';
import 'package:pho_truyen/features/story/presentation/controllers/comic/comic_detail_controller.dart';

class ChapterController extends GetxController {
  late final GetChapterDetailUseCase _getChapterDetailUseCase;
  late final BuyChapterUseCase _buyChapterUseCase;
  late final ChapterRepository _chapterRepository;

  final RxBool isLoading = true.obs;
  final RxBool showControls = true.obs;
  Timer? _hideTimer;

  // Data
  final Rx<ChapterDetailModel?> chapterDetail = Rx<ChapterDetailModel?>(null);
  final RxList<ChapterModel> chapters = <ChapterModel>[].obs;
  final RxString errorMessage = ''.obs;
  final RxString storyName = ''.obs;
  final RxInt currentChapterId = 0.obs;

  // Settings State
  final RxDouble fontSize = 18.0.obs;
  final RxString fontFamily = 'Roboto'.obs;
  final Rx<FontWeight> fontWeight = FontWeight.normal.obs;
  final Rx<Color> backgroundColor = const Color(0xFF1A1A1A).obs;
  final Rx<Color> textColor = Colors.white.obs;

  @override
  void onInit() {
    super.onInit();
    final remoteDataSource = ChapterRemoteDataSourceImpl();
    _chapterRepository = ChapterRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
    _getChapterDetailUseCase = GetChapterDetailUseCase(_chapterRepository);
    _buyChapterUseCase = BuyChapterUseCase(_chapterRepository);

    final dynamic args = Get.arguments;
    int? id;
    if (args != null && args is int) {
      id = args;
    } else if (args != null && args is Map) {
      if (args['id'] != null) id = args['id'];
      if (args['storyName'] != null) storyName.value = args['storyName'];
    }

    if (id != null) {
      fetchChapterDetail(id);
    } else {
      errorMessage.value = "Invalid ID";
      isLoading.value = false;
    }

    // Start auto-hide timer
    _resetHideTimer();
  }

  @override
  void onClose() {
    _hideTimer?.cancel();
    super.onClose();
  }

  void updateTheme(Color bg, Color text) {
    backgroundColor.value = bg;
    textColor.value = text;
  }

  void toggleControls() {
    showControls.value = !showControls.value;
    if (showControls.value) {
      _resetHideTimer();
    } else {
      _hideTimer?.cancel();
    }
  }

  void _resetHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 5), () {
      showControls.value = false;
    });
  }

  Future<void> fetchChapterDetail(int id) async {
    currentChapterId.value = id;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _getChapterDetailUseCase.call(id);
      if ((response.code == 'SUCCESS' || response.code == 'success') &&
          response.data?.detail != null) {
        chapterDetail.value = response.data!.detail;

        // Notify ComicDetailController that this chapter is read
        if (Get.isRegistered<ComicDetailController>()) {
          Get.find<ComicDetailController>().markChapterAsRead(id);
        }

        // Fetch chapter list if not already loaded or if storyId changed
        if (chapters.isEmpty ||
            (chapters.isNotEmpty &&
                chapterDetail.value != null &&
                chapters.first.id != id)) {
          // Note: checking chapters.first.id != id is weak, ideally check storyId.
          // But we can just fetch chapters every time or check if storyId matches.
          // Since we don't store storyId separately, let's just fetch.
          // Actually, chapterDetail has storyId.
          fetchChapters(chapterDetail.value!.storyId);
        }
      } else {
        errorMessage.value = response.message;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchChapters(int storyId) async {
    try {
      final response = await _chapterRepository.getChapters(storyId);
      if (response.code == 'SUCCESS' || response.code == 'success') {
        chapters.assignAll(response.data);
        // Sort chapters by chapterNumber ascending
        chapters.sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber));
      }
    } catch (e) {
      print('Error fetching chapters: $e');
    }
  }

  Future<void> buyChapter(int id) async {
    try {
      final response = await _buyChapterUseCase(id);
      if (response.code == 'SUCCESS' || response.code == 'success') {
        Get.snackbar("Thành công", "Mở khóa chương thành công");
        await Future.delayed(const Duration(seconds: 3));
        fetchChapterDetail(id);
      } else {
        Get.snackbar("Lỗi", response.message);
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Có lỗi xảy ra: $e");
    }
  }

  void jumpToChapter(int chapterId) {
    fetchChapterDetail(chapterId);
    showControls.value = false;
  }

  void nextChapter() {
    if (chapterDetail.value == null || chapters.isEmpty) return;

    final currentIndex = chapters.indexWhere(
      (c) => c.id == chapterDetail.value!.id,
    );
    if (currentIndex != -1 && currentIndex < chapters.length - 1) {
      jumpToChapter(chapters[currentIndex + 1].id);
    }
  }

  void previousChapter() {
    if (chapterDetail.value == null || chapters.isEmpty) return;

    final currentIndex = chapters.indexWhere(
      (c) => c.id == chapterDetail.value!.id,
    );
    if (currentIndex > 0) {
      jumpToChapter(chapters[currentIndex - 1].id);
    }
  }

  bool get hasNextChapter {
    if (chapterDetail.value == null || chapters.isEmpty) return false;
    final currentIndex = chapters.indexWhere(
      (c) => c.id == chapterDetail.value!.id,
    );
    return currentIndex != -1 && currentIndex < chapters.length - 1;
  }

  bool get hasPreviousChapter {
    if (chapterDetail.value == null || chapters.isEmpty) return false;
    final currentIndex = chapters.indexWhere(
      (c) => c.id == chapterDetail.value!.id,
    );
    return currentIndex > 0;
  }
}
