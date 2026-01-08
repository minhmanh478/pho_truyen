import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:pho_truyen/core/router/app_routes.dart';
import 'package:pho_truyen/shared/widgets/item_hashtags.dart';

class LibraryItem {
  final int id;
  final String title;
  final String chapters;
  final String imageUrl;
  final List<String> tags;

  const LibraryItem({
    required this.id,
    required this.title,
    required this.chapters,
    required this.imageUrl,
    this.tags = const [],
  });
}

class LibraryListItem extends StatelessWidget {
  final LibraryItem item;
  final VoidCallback? onTap;

  const LibraryListItem({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDarkMode ? Colors.white : AppColor.slate900;
    final Color secondaryTextColor = isDarkMode
        ? Colors.white70
        : AppColor.slate600;

    return GestureDetector(
      onTap:
          onTap ?? () => Get.toNamed(AppRoutes.comicDetail, arguments: item.id),
      child: Container(
        padding: const EdgeInsets.only(bottom: 12.0),
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                width: 80,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(width: 80, height: 110, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.chapters,
                    style: TextStyle(color: secondaryTextColor, fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: item.tags
                        .map((tag) => ItemHashtags(tag: tag))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
