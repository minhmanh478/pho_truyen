import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:pho_truyen/features/auth/presentation/pages/account/account_page.dart';
import 'package:pho_truyen/features/home/presentation/pages/home_page.dart';
import 'package:pho_truyen/features/story/presentation/pages/library/library_page.dart';
import 'package:pho_truyen/features/story/presentation/pages/bookcase/bookcase_page.dart';
import 'package:pho_truyen/features/dashboard/presentation/controllers/main_app_controller.dart';
import 'package:pho_truyen/features/users/presentation/pages/user_profile_page.dart';
// ignore_for_file: unused_import

class MainAppPage extends GetView<MainAppController> {
  const MainAppPage({super.key});

  List<Widget> get _contents => [
    const HomePage(),
    const LibraryPage(),
    const BookcasePage(),
    Obx(
      () => controller.isLoggedIn.value
          ? const UserProfilePage()
          : const AccountPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final i = controller.index.value;

      return Scaffold(
        body: IndexedStack(index: i, children: _contents),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColor.backgroundDark1,
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  Icons.home_rounded,
                  'Trang chủ',
                  0 == i,
                  () => controller.onTabChange(0),
                ),
                _buildNavItem(
                  Icons.grid_view_rounded,
                  'Thư viện',
                  1 == i,
                  () => controller.onTabChange(1),
                ),
                _buildNavItem(
                  Icons.menu_book_rounded,
                  'Tủ sách',
                  2 == i,
                  () => controller.onTabChange(2),
                ),
                _buildNavItem(
                  Icons.person_rounded,
                  'Tài khoản',
                  3 == i,
                  () => controller.onTabChange(3),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final color = isSelected ? AppColor.primaryColor : Colors.grey;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.fromLTRB(14, 11, 14, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
