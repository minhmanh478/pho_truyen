// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:pho_truyen/core/constants/app_style.dart';
import 'package:pho_truyen/features/comment/presentation/widgets/comment_section.dart';
import 'package:pho_truyen/shared/widgets/button/auth_widget.dart';
import 'package:pho_truyen/shared/widgets/button/dialog_login.dart';
import 'package:pho_truyen/shared/widgets/item_hashtags.dart';
import 'package:pho_truyen/features/auth/presentation/widgets/profile_detail.dart';
import 'package:pho_truyen/features/author/presentation/widgets/donate_dialog.dart';
import 'package:pho_truyen/features/story/presentation/controllers/comic/comic_detail_controller.dart';
import 'package:pho_truyen/core/router/app_routes.dart';
import 'package:pho_truyen/features/story/data/models/comic_model.dart';
import 'package:pho_truyen/core/utils/app_actions.dart';
import 'package:pho_truyen/features/dashboard/presentation/controllers/main_app_controller.dart';
import 'package:share_plus/share_plus.dart';

class ComicDetailPage extends StatelessWidget {
  const ComicDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ComicDetailController());

    return FutureBuilder<ComicDetailModel?>(
      future: controller.comicDetailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }
        final comicDetail = snapshot.data;
        if (comicDetail == null) {
          return const SizedBox();
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 280,
                    pinned: true,
                    backgroundColor: Colors.black,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                    actions: [
                      Obx(
                        () => IconButton(
                          icon: Icon(
                            controller.isFavorite.value
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: controller.isFavorite.value
                                ? Colors.red
                                : Colors.white,
                          ),
                          onPressed: () =>
                              controller.toggleFavorite(comicDetail.id),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () {
                          Share.share(
                            'Đọc truyện ${comicDetail.name} tại Phố Truyện',
                            subject: 'Chia sẻ truyện ${comicDetail.name}',
                          );
                        },
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          (comicDetail.image != null &&
                                  comicDetail.image!.isNotEmpty)
                              ? Image.network(
                                  comicDetail.image!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(color: Colors.grey[900]),
                                )
                              : Container(color: Colors.grey[900]),
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child:
                                          (comicDetail.image != null &&
                                              comicDetail.image!.isNotEmpty)
                                          ? Image.network(
                                              comicDetail.image!,
                                              width: 108,
                                              height: 155,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Container(
                                                    width: 100,
                                                    height: 150,
                                                    color: Colors.grey,
                                                  ),
                                            )
                                          : Container(
                                              width: 100,
                                              height: 150,
                                              color: Colors.grey,
                                            ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Container(
                                        height: 150,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          comicDetail.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            height: 1.3,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildStatItem(
                                        Icons.library_books_rounded,
                                        'Chương',
                                        comicDetail.chapterCount.toString(),
                                      ),
                                      _buildStatItem(
                                        Icons.visibility_rounded,
                                        'Lượt xem',
                                        comicDetail.readCount.toString(),
                                      ),
                                      _buildStatItem(
                                        Icons.favorite_rounded,
                                        'Yêu thích',
                                        comicDetail.nominations.toString(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      color: AppColor.slate900,
                      child: const TabBar(
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.blue,
                        tabs: [
                          Tab(text: 'Thông tin'),
                          Tab(text: 'Chương'),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: Container(
                color: AppColor.slate900,
                child: TabBarView(
                  children: [
                    _buildInfoTab(context, comicDetail),
                    _buildChaptersTab(comicDetail),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            color: AppColor.backgroundDark1,
            child: Obx(() {
              final history = controller.userReadingHistory.value;
              final hasHistory =
                  history != null && history.currentChapterId != null;

              return AuthWidget(
                label: hasHistory
                    ? 'Đọc tiếp (Chương ${history.currentChapterNumber ?? ""})'
                    : 'Đọc ngay (Chương 1)',
                color: AppColor.backgroundDark1,
                textColor: Colors.white,
                onPress: () {
                  if (hasHistory) {
                    print("Đọc tiếp chương ID: ${history.currentChapterId}");
                    Get.toNamed(
                      AppRoutes.chapter,
                      arguments: {
                        'id': history.currentChapterId,
                        'storyName': comicDetail.name,
                      },
                    );
                  } else {
                    if (controller.chapters.isNotEmpty) {
                      final firstChapterId = controller.chapters.first.id;
                      print("Đọc chương ID: $firstChapterId");
                      Get.toNamed(
                        AppRoutes.chapter,
                        arguments: {
                          'id': firstChapterId,
                          'storyName': comicDetail.name,
                        },
                      );
                    } else {
                      Get.snackbar('Thông báo', 'Chưa có chương nào để đọc');
                    }
                  }
                },
              );
            }),
          ),
        );
      },
    );
  }

  //Widget TAB CHƯƠNG
  Widget _buildChaptersTab(ComicDetailModel comicDetail) {
    final controller = Get.find<ComicDetailController>();
    return Obx(() {
      if (controller.isLoadingChapters.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.chapters.isEmpty) {
        return const Center(
          child: Text(
            'Chưa có chương nào',
            style: TextStyle(color: Colors.white),
          ),
        );
      }
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: controller.chapters.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final chapter = controller.chapters[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                print("Đọc chương ID: ${chapter.id}");
                controller.markChapterAsRead(chapter.id);
                Get.toNamed(
                  AppRoutes.chapter,
                  arguments: {'id': chapter.id, 'storyName': comicDetail.name},
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Text(
                              'Chương ${chapter.chapterNumber}: ${chapter.name}',
                              style: TextStyle(
                                color:
                                    controller.readChapterIds.contains(
                                      chapter.id,
                                    )
                                    ? Colors.white54
                                    : Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              chapter.isLock == 1
                                  ? 'Giá: ${chapter.price} xu'
                                  : 'Miễn phí',
                              style: TextStyle(
                                color: chapter.isLock == 1
                                    ? Colors.amber
                                    : Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (chapter.isLock == 1)
                      const Icon(Icons.lock, size: 16, color: Colors.amber)
                    //TODO: nếu mua chương rồi thì icon ổ khóa mở
                    else if (chapter.price > 0)
                      const Icon(Icons.lock_open, size: 16, color: Colors.green)
                    else
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.white30,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoTab(BuildContext context, ComicDetailModel comicDetail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileDetail(
            avatarUrl:
                comicDetail.authorAvatar ??
                'https://ui-avatars.com/api/?name=${comicDetail.authorName ?? "Unknown"}',
            name: comicDetail.authorName ?? 'Unknown',
            followers:
                "${comicDetail.authorFollowers} người theo dõi", // Default
            onGiftPressed: () {
              if (Get.isRegistered<MainAppController>() &&
                  Get.find<MainAppController>().isLoggedIn.value) {
                showDialog(
                  context: context,
                  builder: (context) => DonateDialog(
                    onDonate: (amount) {
                      Get.find<ComicDetailController>().donate(
                        comicDetail.authorId,
                        amount,
                      );
                    },
                  ),
                );
              } else {
                Get.dialog(const DialogLogin());
              }
            },
            onTap: () {
              print('Author ID: ${comicDetail.authorId}');
              if (comicDetail.authorId != 0) {
                Get.toNamed(
                  AppRoutes.authorDetail,
                  arguments: comicDetail.authorId,
                );
              } else {
                Get.snackbar('Thông báo', 'Không tìm thấy thông tin tác giả');
              }
            },
          ),
          const Divider(height: 32, thickness: 1, color: Colors.white10),

          const Text('Thể loại', style: AppStyle.s14w600),
          const SizedBox(height: 8),
          Text(
            comicDetail.categories.isNotEmpty
                ? comicDetail.categories.join(', ')
                : 'Đang cập nhật',
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 8),
          const Divider(height: 30, thickness: 1, color: Colors.white10),

          const Text('Hashtags', style: AppStyle.s14w600),
          const SizedBox(height: 8),
          Wrap(
            spacing: 0,
            runSpacing: 8,
            children: comicDetail.genres
                .map((tag) => ItemHashtags(tag: tag))
                .toList(),
          ),
          const Divider(height: 30, thickness: 1, color: Colors.white10),
          Wrap(
            spacing: 0,
            runSpacing: 8,
            children: comicDetail.hashtags
                .map((tag) => ItemHashtags(tag: tag))
                .toList(),
          ),
          const SizedBox(height: 8),
          const Divider(height: 20, thickness: 1, color: Colors.white10),
          const SizedBox(height: 8),

          const Text('Nội dung', style: AppStyle.s14w600),
          const SizedBox(height: 8),
          _ExpandableText(text: comicDetail.content ?? ''),

          //Hiển thị Comment
          CommentSection(comicId: comicDetail.id),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _ExpandableText extends StatefulWidget {
  final String text;
  const _ExpandableText({required this.text});

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _isExpanded = false;
  static const int _maxLines = 3;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final TextStyle textStyle = const TextStyle(color: Colors.white70);
        final TextStyle linkStyle = TextStyle(
          color: AppColor.primaryColor,
          // fontWeight: FontWeight.bold,
        );

        final span = TextSpan(text: widget.text, style: textStyle);
        final tp = TextPainter(
          text: span,
          maxLines: _maxLines,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: constraints.maxWidth);

        if (!tp.didExceedMaxLines) {
          return Text(widget.text, style: textStyle);
        }

        if (_isExpanded) {
          return RichText(
            text: TextSpan(
              children: [
                TextSpan(text: widget.text, style: textStyle),
                TextSpan(
                  text: '< Thu gọn',
                  style: linkStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      setState(() {
                        _isExpanded = false;
                      });
                    },
                ),
              ],
            ),
          );
        }

        final linkSpan = TextSpan(text: '... Xem thêm >', style: linkStyle);
        final linkTp = TextPainter(
          text: linkSpan,
          textDirection: TextDirection.ltr,
        );
        linkTp.layout();
        final linkWidth = linkTp.width;

        final pos = tp.getPositionForOffset(
          Offset(constraints.maxWidth - linkWidth, tp.height),
        );
        int endIndex = pos.offset;

        if (endIndex > widget.text.length) {
          endIndex = widget.text.length;
        }

        final truncated = widget.text.substring(0, endIndex);

        return RichText(
          text: TextSpan(
            children: [
              TextSpan(text: truncated, style: textStyle),
              TextSpan(
                text: '... Xem thêm >',
                style: linkStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() {
                      _isExpanded = true;
                    });
                  },
              ),
            ],
          ),
        );
      },
    );
  }
}
