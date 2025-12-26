// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:pho_truyen/core/constants/app_color.dart';

class BookcaseTabBar extends StatelessWidget {
  final TabController tabController;

  const BookcaseTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color elementBgColor = isDarkMode
        ? const Color(0xFF1F2235)
        : Colors.grey.shade100;
    final Color activeColor = const Color(0xFF4C8EF9);
    final Color secondaryTextColor = isDarkMode
        ? Colors.white70
        : AppColor.slate600;

    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: elementBgColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: tabController,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: activeColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: activeColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: secondaryTextColor,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: "Đã đọc"),
          Tab(text: "Yêu thích"),
          Tab(text: "Đã xem"),
        ],
      ),
    );
  }
}
