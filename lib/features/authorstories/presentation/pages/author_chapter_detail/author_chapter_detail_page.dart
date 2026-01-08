import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/features/authorstories/presentation/controllers/author_chapter_detail_controller.dart';
import '../../../../../../core/constants/app_color.dart';
import '../your_story_detail/widgets/story_detail_bottom_actions.dart';

class AuthorChapterDetailPage extends GetView<AuthorChapterDetailController> {
  const AuthorChapterDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppColor.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết chương',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.transparent : AppColor.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final detail = controller.detail.value;
        if (detail == null) {
          return const Center(child: Text('Không có dữ liệu'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      label: 'Số chương',
                      value: 'Chương ${detail.chapterNumber}',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      label: 'Ruby chương',
                      value: detail.price.toString(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildInfoItem(context, label: 'Tên chương', value: detail.name),
              const SizedBox(height: 24),
              _buildInfoItem(
                context,
                label: 'Nội dung',
                value: detail.content ?? '',
              ),
              const SizedBox(height: 24),
              _buildInfoItem(
                context,
                label: 'Ghi chú',
                value: detail.note ?? '',
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value) return const SizedBox.shrink();
        return StoryDetailBottomActions(
          buttons: controller.buttons,
          onAction: controller.onButtonAction,
        );
      }),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.textColor(context),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: AppColor.secondaryTextColor(context),
          ),
        ),
      ],
    );
  }
}
