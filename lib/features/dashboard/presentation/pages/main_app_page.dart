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
        // extendBody: true, // Removed to prevent blocking content
        // ignore: sort_child_properties_last
        body: IndexedStack(index: i, children: _contents),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.fromLTRB(14, 0, 14, 18),
          decoration: BoxDecoration(
            color: AppColor.backgroundDark1,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[800]!, width: 0.6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
