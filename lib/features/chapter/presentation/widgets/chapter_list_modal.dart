import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:pho_truyen/features/chapter/presentation/controllers/chapter_controller.dart';

class ChapterListModal extends StatelessWidget {
  const ChapterListModal({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChapterController>();
    final RxString searchQuery = ''.obs;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: AppColor.backgroundDark1,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (value) => searchQuery.value = value,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm tên chương',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[700]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColor.primary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Chapter List
          Expanded(
            child: Obx(() {
              final allChapters = controller.chapters;
              final query = searchQuery.value.toLowerCase();
              final filteredChapters = allChapters
                  .where(
                    (c) =>
                        c.name.toLowerCase().contains(query) ||
                        'Chương ${c.chapterNumber}'.toLowerCase().contains(
                          query,
                        ),
                  )
                  .toList();

              if (filteredChapters.isEmpty) {
                return const Center(
                  child: Text(
                    'Không tìm thấy chương nào',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: filteredChapters.length,
                separatorBuilder: (context, index) =>
                    Divider(height: 1, color: Colors.grey[800]),
                itemBuilder: (context, index) {
                  final chapter = filteredChapters[index];
                  final isCurrent =
                      chapter.id == controller.chapterDetail.value?.id;

                  return ListTile(
                    leading: Icon(
                      isCurrent
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: isCurrent ? AppColor.primary : Colors.grey,
                    ),
                    title: Text(
                      chapter.name,
                      style: TextStyle(
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isCurrent ? AppColor.primary : Colors.white,
                      ),
                    ),
                    onTap: () {
                      if (!isCurrent) {
                        controller.jumpToChapter(chapter.id);
                        Get.back(); // Close modal
                      }
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
