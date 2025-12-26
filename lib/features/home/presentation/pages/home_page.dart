// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/constants/constants.dart';
import 'package:pho_truyen/shared/widgets/button/dialog_login.dart';
import 'package:pho_truyen/features/home/presentation/widgets/featured_carousel.dart';
import 'package:pho_truyen/features/home/presentation/widgets/home_section_header.dart';
import 'package:pho_truyen/features/home/presentation/widgets/manga_horizontal_list.dart';
import 'package:pho_truyen/features/home/presentation/widgets/ranking_item.dart';
import 'package:pho_truyen/features/dashboard/presentation/controllers/main_app_controller.dart';
import 'package:pho_truyen/features/home/data/models/home_model.dart';
import 'package:pho_truyen/features/home/presentation/controllers/home_controller.dart';
import 'package:pho_truyen/features/home/presentation/pages/notification_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDarkMode ? Colors.white : AppColor.slate900;
    final Color headerBgColor = isDarkMode
        ? AppColor.backgroundDark1.withOpacity(0.8)
        : AppColor.backgroundLight1.withOpacity(0.8);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRect(
          child: Container(
            decoration: BoxDecoration(
              color: headerBgColor,
              border: Border(
                bottom: BorderSide(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.05)
                      : Colors.black.withOpacity(0.05),
                ),
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Text(
                  'Truyện App',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.015,
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: Icon(
                      Icons.notifications_none,
                      color: textColor,
                      size: 24,
                    ),
                    onPressed: () {
                      final mainController = Get.find<MainAppController>();
                      if (mainController.isLoggedIn.value) {
                        Get.to(() => const NotificationPage());
                      } else {
                        Get.dialog(const DialogLogin());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<GetHomeResponse?>(
        future: controller.getHomeData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final homeData = snapshot.data?.data;
          if (homeData == null) {
            return const SizedBox();
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 0),
                ...homeData.listHome.map((section) {
                  if (section.title == 'TEST thêm') return const SizedBox();
                  switch (section.sectionType) {
                    case HomeSectionType.banner:
                      return FeaturedCarousel(data: section.banners ?? []);
                    case HomeSectionType.storyList:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HomeSectionHeader(title: section.title),
                          MangaHorizontalList(
                            data: _ensureMinLength(section.stories ?? [], 10),
                          ),
                        ],
                      );
                    case HomeSectionType.top:
                      if (section.subSections != null &&
                          section.subSections!.isNotEmpty) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: section.subSections!.map((sub) {
                              // Determine icon and score based on title or code
                              String iconPath = AppPaths.icEye; // Default
                              int Function(StoryModel) scoreSelector = (s) =>
                                  s.readCount;

                              if (sub.title.contains('Mở khóa') ||
                                  sub.code == 'TOP_UNLOCK') {
                                iconPath = AppPaths.icRuby;
                                scoreSelector = (s) => s.readCount;
                              } else if (sub.title.contains('Yêu thích') ||
                                  sub.code == 'TOP_FAVORITE') {
                                iconPath = AppPaths.icHeart;
                                scoreSelector = (s) => s.nominations;
                              }

                              final stories = _ensureMinLength(
                                sub.stories ?? [],
                                10,
                              );
                              final rankingItems = stories
                                  .map(
                                    (s) => RankingItem(
                                      id: s.id,
                                      title: s.name,
                                      score: scoreSelector(s),
                                      imageUrl: s.image ?? '',
                                    ),
                                  )
                                  .toList();

                              if (rankingItems.isEmpty) return const SizedBox();

                              return TopUnlockWidget(
                                title: sub.title,
                                items: rankingItems,
                                iconPath: iconPath,
                              );
                            }).toList(),
                          ),
                        );
                      }
                      return const SizedBox();
                    default:
                      return const SizedBox();
                  }
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  List<T> _ensureMinLength<T>(List<T> list, int minLength) {
    if (list.isEmpty) return [];
    if (list.length >= minLength) return list;

    final List<T> result = [...list];
    while (result.length < minLength) {
      result.addAll(list);
    }
    return result.sublist(0, minLength);
  }
}
