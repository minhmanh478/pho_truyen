// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/rendering.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:pho_truyen/core/utils/app_dialogs.dart';
import 'package:pho_truyen/features/chapter/presentation/controllers/chapter_controller.dart';
import 'package:pho_truyen/features/chapter/presentation/widgets/chapter_list_modal.dart';
import 'package:pho_truyen/features/chapter/presentation/widgets/chapter_settings_bottom_sheet.dart';

class ChapterPage extends StatelessWidget {
  const ChapterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChapterController());

    return Obx(
      () => Scaffold(
        backgroundColor: controller.backgroundColor.value,
        body: Stack(
          children: [
            Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (event) => controller.onInteractionStart(event),
              onPointerUp: (event) => controller.onInteractionEnd(event),
              onPointerCancel: (event) => controller.onInteractionCancel(event),
              child: SizedBox.expand(
                child: GestureDetector(
                  onTap: controller.toggleControls,
                  behavior: HitTestBehavior.translucent,
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.errorMessage.isNotEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${controller.errorMessage.value}',
                              style: TextStyle(
                                color: controller.textColor.value,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    AppDialogs.showConfirmDialog(
                                      title: "Xác nhận",
                                      message:
                                          "Bạn có chắc chắn mở chương không?",
                                      confirmText: "Có",
                                      cancelText: "Không",
                                      onConfirm: () {
                                        Get.back();
                                        controller.buyChapter(
                                          controller.currentChapterId.value,
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text("Mở chương"),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    // TODO: Navigate to Top-up page
                                    Get.snackbar(
                                      "Thông báo",
                                      "Chức năng nạp Ruby đang phát triển",
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text("Nạp Ruby"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                    final chapter = controller.chapterDetail.value;
                    if (chapter == null) {
                      return Center(
                        child: Text(
                          'Không tìm thấy nội dung chương',
                          style: TextStyle(color: controller.textColor.value),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      controller: controller.scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 80, 16, 80),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // tên truyện +
                          if (controller.storyName.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                // Thêm .toUpperCase() vào đây
                                controller.storyName.value.toUpperCase(),
                                style: TextStyle(
                                  color: controller.textColor.value,
                                  fontSize: controller.fontSize.value + 0,
                                  fontFamily: controller.fontFamily.value,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14.0),
                            child: Text(
                              'Chương ${chapter.chapterNumber}: ${chapter.name}',
                              style: TextStyle(
                                color: controller.textColor.value,
                                fontSize: controller.fontSize.value + 0,
                                fontFamily: controller.fontFamily.value,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            chapter.content ?? 'Nội dung đang cập nhật...',
                            style: TextStyle(
                              color: controller.textColor.value,
                              fontSize: controller.fontSize.value,
                              fontFamily: controller.fontFamily.value,
                              fontWeight: controller.fontWeight.value,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Top Controls Layer
            Obx(
              () => AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                top: controller.showControls.value ? 0 : -100,
                left: 0,
                right: 0,
                child: Container(
                  color: controller.backgroundColor.value.withOpacity(0.9),
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    bottom: 10,
                    left: 10,
                    right: 10,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: controller.textColor.value,
                        ),
                        onPressed: () => Get.back(),
                      ),
                      Expanded(
                        child: Obx(() {
                          final chapter = controller.chapterDetail.value;
                          if (chapter != null) {
                            return Text(
                              'Chương ${chapter.chapterNumber}: ${chapter.name}',
                              style: TextStyle(
                                color: controller.textColor.value,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          }
                          return const SizedBox();
                        }),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: controller.textColor.value,
                        ),
                        onPressed: () {
                          Get.bottomSheet(
                            const ChapterSettingsBottomSheet(),
                            isScrollControlled: true,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Controls Layer
            Obx(
              () => AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                bottom: controller.showControls.value ? 0 : -100,
                left: 0,
                right: 0,
                child: Container(
                  color: controller.backgroundColor.value.withOpacity(0.9),
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 10,
                    top: 10,
                    left: 20,
                    right: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: controller.hasPreviousChapter
                            ? controller.previousChapter
                            : null,
                        icon: Icon(
                          Icons.skip_previous,
                          color: controller.hasPreviousChapter
                              ? controller.textColor.value
                              : controller.textColor.value.withOpacity(0.3),
                          size: 30,
                        ),
                      ),
                      // Chapter List
                      IconButton(
                        onPressed: () {
                          Get.bottomSheet(
                            const ChapterListModal(),
                            isScrollControlled: true,
                          );
                        },
                        icon: Icon(
                          Icons.list,
                          color: controller.textColor.value,
                          size: 30,
                        ),
                      ),
                      // Next Chapter
                      IconButton(
                        onPressed: controller.hasNextChapter
                            ? controller.nextChapter
                            : null,
                        icon: Icon(
                          Icons.skip_next,
                          color: controller.hasNextChapter
                              ? controller.textColor.value
                              : controller.textColor.value.withOpacity(0.3),
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Toggle Auto Scroll Button
            Obx(
              () => AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                bottom: controller.showControls.value
                    ? MediaQuery.of(context).padding.bottom + 80
                    : -100,
                right: 20,
                child: FloatingActionButton(
                  mini: true,
                  onPressed: () => controller.toggleAutoScroll(
                    !controller.isAutoScroll.value,
                  ),
                  backgroundColor: AppColor.primary.withOpacity(0.1),
                  child: Icon(
                    controller.isAutoScroll.value
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
