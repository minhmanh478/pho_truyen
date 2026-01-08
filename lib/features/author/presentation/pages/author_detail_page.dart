// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:pho_truyen/features/author/presentation/controllers/author_detail_controller.dart';
import 'package:pho_truyen/features/author/presentation/widgets/donate_dialog.dart';
import 'package:pho_truyen/shared/widgets/item_hashtags.dart';

class AuthorDetailPage extends GetView<AuthorDetailController> {
  const AuthorDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : AppColor.slate900;
    final secondaryTextColor = isDarkMode ? Colors.white70 : AppColor.slate600;

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        final author = controller.author.value;
        if (author == null) {
          return const Center(child: Text('Không tìm thấy thông tin tác giả'));
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200.0,
              pinned: true,
              backgroundColor: isDarkMode ? Colors.black : Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Blurred Background Image
                    Image.network(
                      author.avatar ?? 'https://picsum.photos/200',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.grey),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(color: Colors.black.withOpacity(0.3)),
                    ),
                    // Avatar
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          print('Author user ID: ${author.id}');
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              author.avatar ?? 'https://picsum.photos/200',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      author.fullName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      author.authorLevelName,
                      style: TextStyle(fontSize: 14, color: secondaryTextColor),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Text(
                        '${controller.followCount.value} người theo dõi',
                        style: TextStyle(
                          fontSize: 14,
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => DonateDialog(
                                onDonate: (amount) {
                                  controller.donate(amount);
                                },
                              ),
                            );
                          },
                          icon: const Icon(Icons.card_giftcard, size: 18),
                          label: const Text('Tặng Quà'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Obx(
                          () => ElevatedButton.icon(
                            onPressed: controller.toggleFollow,
                            icon: Icon(
                              controller.isFollow.value
                                  ? Icons.check
                                  : Icons.add,
                              size: 18,
                            ),
                            label: Text(
                              controller.isFollow.value
                                  ? 'Đang theo dõi'
                                  : 'Theo dõi',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: controller.isFollow.value
                                  ? Colors.grey
                                  : Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Truyện của tác giả',
                        // TODO: Add author book
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final story = controller.stories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 0.0,
                  ),
                  child: GestureDetector(
                    onTap: () => controller.goToComicDetail(story),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        // color: AppColor.slate900,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cover Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              story.image ?? 'https://picsum.photos/100/150',
                              width: 80,
                              height: 110,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 80,
                                    height: 110,
                                    color: Colors.grey[800],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.white24,
                                    ),
                                  ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  story.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${story.chapterCount} chương',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Hashtags
                                if (story.hashtags.isNotEmpty)
                                  Wrap(
                                    children: story.hashtags
                                        .take(3)
                                        .map(
                                          (tag) => ItemHashtags(tag: tag.name),
                                        )
                                        .toList(),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }, childCount: controller.stories.length),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
          ],
        );
      }),
    );
  }
}
