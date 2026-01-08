import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_color.dart';
import '../../../../domain/entities/author_story_detail_entity.dart';

class StoryDetailTab extends StatelessWidget {
  final UserStoryDetail story;

  const StoryDetailTab({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppColor.isDarkMode(context);
    final textColor = Colors.white;
    final secondaryTextColor = isDarkMode
        ? Colors.grey.shade400
        : AppColor.slate600;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: story.image != null && story.image!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: story.image!,
                        width: 120,
                        height: 160,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 120,
                          height: 160,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.error),
                        ),
                      )
                    : Container(
                        width: 120,
                        height: 160,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.name ?? '',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Trạng thái',
                      style: TextStyle(fontSize: 14, color: secondaryTextColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      story.stateName ?? 'Chưa cập nhật',
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Giới thiệu',
            style: TextStyle(fontSize: 16, color: secondaryTextColor),
          ),
          const SizedBox(height: 8),
          Text(
            story.description ?? '',
            style: TextStyle(fontSize: 16, color: textColor),
          ),
          const SizedBox(height: 24),
          Text(
            'Nội dung',
            style: TextStyle(fontSize: 16, color: secondaryTextColor),
          ),
          const SizedBox(height: 8),
          Text(
            story.content ?? '',
            style: TextStyle(fontSize: 16, color: textColor),
          ),
        ],
      ),
    );
  }
}
