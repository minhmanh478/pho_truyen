import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/router/app_routes.dart';
import 'package:pho_truyen/features/story/presentation/widgets/library/library_list_item.dart';
import 'package:pho_truyen/features/story/presentation/controllers/bookcase/bookcase_controller.dart';
import 'package:pho_truyen/features/story/presentation/widgets/bookcase/bookcase_header.dart';
import 'package:pho_truyen/features/story/presentation/widgets/bookcase/bookcase_tab_bar.dart';
import 'package:pho_truyen/features/story/presentation/widgets/bookcase/read_history_list_item.dart';

class BookcasePage extends StatefulWidget {
  const BookcasePage({super.key});

  @override
  State<BookcasePage> createState() => _BookcasePageState();
}

class _BookcasePageState extends State<BookcasePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookcaseController());
    controller.refreshUserId();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDarkMode
        ? Theme.of(context).scaffoldBackgroundColor
        : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: BookcaseHeader(
                isGridView: _isGridView,
                onViewModeChanged: (isGrid) {
                  setState(() {
                    _isGridView = isGrid;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BookcaseTabBar(tabController: _tabController),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRequireLoginContent(
                    Obx(() {
                      if (controller.isLoadingRead.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final items = controller.readStories;
                      if (items.isEmpty) {
                        return const Center(child: Text("Chưa có truyện nào"));
                      }

                      if (_isGridView) {
                        final libraryItems = items.map((story) {
                          return LibraryItem(
                            id: story.id,
                            title: story.name,
                            chapters: '${story.chapterCount} chương',
                            imageUrl:
                                story.image ?? 'https://picsum.photos/100/150',
                            tags: story.hashtags.map((e) => e.name).toList(),
                          );
                        }).toList();
                        return _buildBookList(
                          libraryItems,
                          controller.fetchReadStories,
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: controller.fetchReadStories,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final story = items[index];
                            return ReadHistoryListItem(
                              id: story.id,
                              title: story.name,
                              imageUrl:
                                  story.image ??
                                  'https://picsum.photos/100/150',
                              currentChapterName: story.currentChapterName,
                              currentChapterNumber: story.currentChapterNumber,
                              onTap: () {
                                if (story.currentChapterId != null) {
                                  Get.toNamed(
                                    AppRoutes.chapter,
                                    arguments: {
                                      'id': story.currentChapterId,
                                      'storyName': story.name,
                                    },
                                  );
                                } else {
                                  Get.toNamed(
                                    AppRoutes.comicDetail,
                                    arguments: story.id,
                                  );
                                }
                              },
                              onContentTap: () {
                                Get.toNamed(
                                  AppRoutes.comicDetail,
                                  arguments: story.id,
                                );
                              },
                            );
                          },
                        ),
                      );
                    }),
                  ), // Đã đọc
                  _buildRequireLoginContent(
                    Obx(() {
                      if (controller.isLoadingFavorites.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final items = controller.favoriteStories.map((story) {
                        return LibraryItem(
                          id: story.id,
                          title: story.name,
                          chapters: '${story.chapterCount} chương',
                          imageUrl:
                              story.image ?? 'https://picsum.photos/100/150',
                          tags: story.hashtags.map((e) => e.name).toList(),
                        );
                      }).toList();
                      return _buildBookList(
                        items,
                        controller.fetchFavoriteStories,
                      );
                    }),
                  ), // Yêu thích
                  _buildRequireLoginContent(
                    Obx(() {
                      if (controller.isLoadingViewed.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final items = controller.viewedStories.map((story) {
                        return LibraryItem(
                          id: story.id,
                          title: story.name,
                          chapters: '${story.chapterCount} chương',
                          imageUrl:
                              story.image ?? 'https://picsum.photos/100/150',
                          tags: story.hashtags.map((e) => e.name).toList(),
                        );
                      }).toList();
                      return _buildBookList(
                        items,
                        controller.fetchViewedStories,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequireLoginContent(Widget content) {
    final controller = Get.find<BookcaseController>();
    return Obx(() {
      if (controller.userId.value == 0) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Vui lòng đăng nhập để xem tủ sách",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.toNamed(AppRoutes.login),
                child: const Text("Đăng nhập"),
              ),
            ],
          ),
        );
      }
      return content;
    });
  }

  Widget _buildBookList(
    List<LibraryItem> items,
    Future<void> Function() onRefresh,
  ) {
    Widget content;
    if (items.isEmpty) {
      content = const Center(child: Text("Chưa có truyện nào"));
    } else if (_isGridView) {
      content = GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.55,
          crossAxisSpacing: 10,
          mainAxisSpacing: 16,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () async {
              await Get.toNamed(AppRoutes.comicDetail, arguments: item.id);
              onRefresh();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 2 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      content = ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return LibraryListItem(
            item: item,
            onTap: () async {
              await Get.toNamed(AppRoutes.comicDetail, arguments: item.id);
              onRefresh();
            },
          );
        },
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: items.isEmpty ? Stack(children: [ListView(), content]) : content,
    );
  }
}
