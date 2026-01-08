import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_color.dart';
import '../../domain/entities/user_story_entity.dart';

class YourStoryItem extends StatelessWidget {
  final UserStoryEntity story;
  final VoidCallback? onTap;

  const YourStoryItem({super.key, required this.story, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppColor.isDarkMode(context);
    final textColor = AppColor.textColor(context);
    final secondaryTextColor = isDarkMode
        ? Colors.grey.shade400
        : AppColor.slate600;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColor.cardColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: story.image != null && story.image!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: story.image!,
                      width: 90,
                      height: 120,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 80,
                        height: 110,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.error),
                      ),
                    )
                  : Container(
                      width: 80,
                      height: 110,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.name,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tất cả: ${story.chapterCount} chương',
                    style: TextStyle(color: secondaryTextColor, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Được duyệt: ${story.chapterAuthorCount} chương',
                    style: TextStyle(color: secondaryTextColor, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Trạng thái hiển thị: ${story.stateName}',
                    style: TextStyle(color: secondaryTextColor, fontSize: 13),
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
