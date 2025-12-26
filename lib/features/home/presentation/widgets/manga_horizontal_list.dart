import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:pho_truyen/features/story/presentation/pages/comic/comic_detail_page.dart';
import 'package:pho_truyen/features/home/data/models/home_model.dart';

class MangaHorizontalList extends StatelessWidget {
  final List<StoryModel> data;
  final bool isLatest;

  const MangaHorizontalList({
    super.key,
    required this.data,
    this.isLatest = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDarkMode ? Colors.white : AppColor.slate900;
    final Color secondaryTextColor = isDarkMode
        ? AppColor.gray400
        : AppColor.slate600;

    const double itemWidth = 140.0;
    const double aspectRatio = 3 / 4;

    const double imageHeight = itemWidth / aspectRatio;

    const double listHeight = imageHeight + 65.0;

    if (data.isEmpty) return const SizedBox();

    return SizedBox(
      height: listHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final item = data[index];
          return GestureDetector(
            onTap: () {
              Get.to(() => const ComicDetailPage(), arguments: item.id);
            },
            child: Container(
              width: itemWidth,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Phần ảnh
                  SizedBox(
                    height: imageHeight,
                    width: itemWidth,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        item.image ?? '',
                        fit: BoxFit.cover,
                        // Xử lý khi lỗi ảnh
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Phần Tên truyện
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Phần Tác giả
                  Text(
                    item.authorName ?? 'Unknown',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
