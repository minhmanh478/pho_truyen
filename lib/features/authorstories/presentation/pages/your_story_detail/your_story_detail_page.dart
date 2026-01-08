// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/router/app_routes.dart';
import '../../../../../../core/constants/app_color.dart';
import '../../controllers/your_story_detail_controller.dart';
import 'widgets/story_detail_bottom_actions.dart';
import 'widgets/story_detail_tab.dart';

class YourStoryDetailPage extends GetView<YourStoryDetailController> {
  const YourStoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppColor.isDarkMode(context);
    final secondaryTextColor = isDarkMode
        ? Colors.grey.shade400
        : AppColor.slate600;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết truyện của bạn',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.transparent : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        bottom: TabBar(
          controller: controller.tabController,
          labelColor: AppColor.primary,
          unselectedLabelColor: secondaryTextColor,
          indicatorColor: AppColor.primary,
          tabs: const [
            Tab(text: 'Chi tiết truyện đang sửa'),
            Tab(text: 'Danh sách chương'),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.userStory.value == null) {
              return const Center(child: Text("Không có dữ liệu"));
            }
            return StoryDetailTab(story: controller.userStory.value!);
          }),
          Obx(() {
            if (controller.isChaptersLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.chapters.isEmpty) {
              return const Center(child: Text("Chưa có chương nào"));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.chapters.length,
              itemBuilder: (context, index) {
                final chapter = controller.chapters[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B), // Dark slate color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    title: Text(
                      chapter.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        chapter.price > 0
                            ? '${chapter.price} Ruby'
                            : 'Miễn phí',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onTap: () {
                      print(chapter.id);
                      Get.toNamed(
                        AppRoutes.authorChapterDetail,
                        arguments: chapter.id,
                      );
                    },
                  ),
                );
              },
            );
          }),
        ],
      ),
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value) return const SizedBox.shrink();
        return StoryDetailBottomActions(
          buttons: controller.currentButtons,
          onAction: controller.onButtonAction,
        );
      }),
    );
  }
}
