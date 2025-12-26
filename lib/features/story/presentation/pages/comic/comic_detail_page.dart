// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:pho_truyen/core/constants/app_style.dart';
import 'package:pho_truyen/core/widgets/comment_profile.dart';
import 'package:pho_truyen/shared/widgets/button/auth_widget.dart';
import 'package:pho_truyen/shared/widgets/button/dialog_login.dart';
import 'package:pho_truyen/shared/widgets/item_hashtags.dart';
import 'package:pho_truyen/features/auth/presentation/widgets/profile_detail.dart';
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
                    expandedHeight: 300,
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
                                              width: 100,
                                              height: 150,
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 14,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildStatItem(
                                        Icons.menu_book,
                                        'Chương',
                                        comicDetail.chapterCount.toString(),
                                      ),
                                      _buildStatItem(
                                        Icons.remove_red_eye,
                                        'Lượt xem',
                                        comicDetail.readCount.toString(),
                                      ),
                                      _buildStatItem(
                                        Icons.favorite,
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
            child: AuthWidget(
              label: 'Đọc ngay (Chương 1)',
              color: AppColor.backgroundDark1,
              textColor: Colors.white,
              onPress: () {
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
              },
            ),
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
                          if (chapter.isLock == 1)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'Giá: ${chapter.price} xu',
                                style: const TextStyle(
                                  color: Colors.amber,
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
    // Mock comments for now as they were in controller
    final comments = [
      {
        'name': 'Lê Minh Mạnh',
        'avatarUrl':
            'https://scontent.fhan14-3.fna.fbcdn.net/v/t39.30808-6/491924549_1183614206476982_1175671270079321138_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=PqZ3-Hbi6f4Q7kNvwEcXBJ3&_nc_oc=AdlDBkKRsh5eO1xo9M3dw2vz_VIbJ3jUfx18QYZp85kiSUhj0uLFR00AIfsgtqv2J9M&_nc_zt=23&_nc_ht=scontent.fhan14-3.fna&_nc_gid=A6HF_gWfVIskUj141CDY5w&oh=00_AfnsAJBraAsTfB-S1435nDlVPaIUcqcABcysn5Frz6fF7g&oe=6946FB04',
        'comment': '(Tính năng đang phát triển)',
        'date': '7 tháng trước',
      },
    ];

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
                AppActions.opentoast(context);
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
          Text('   Tiểu thuyết'),

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

          const Divider(height: 20, thickness: 1, color: Colors.white10),
          Row(children: [const Text('Bình luận', style: AppStyle.s14w600)]),
          const SizedBox(height: 16),

          //Hiển thị Comment
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: comments.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: SizedBox(
                    width: 320,
                    child: CommentProfile(
                      name: e['name'] ?? 'Ẩn danh',
                      avatarUrl: e['avatarUrl'] ?? '',
                      comment: e['comment'] ?? '',
                      date: e['date'] ?? '',
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
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
