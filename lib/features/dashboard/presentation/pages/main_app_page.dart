import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
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
        // ignore: sort_child_properties_last
        body: IndexedStack(index: i, children: _contents),
        bottomNavigationBar: FBottomNavigationBar(
          index: i,
          onChange: controller.onTabChange,
          children: [
            FBottomNavigationBarItem(
              icon: const Icon(FIcons.house),
              label: const Text(
                'Trang chủ',
                style: TextStyle(decoration: TextDecoration.none, fontSize: 10),
              ),
            ),
            const FBottomNavigationBarItem(
              icon: Icon(FIcons.layoutGrid),
              label: Text(
                'Thư viện',
                style: TextStyle(decoration: TextDecoration.none, fontSize: 10),
              ),
            ),
            const FBottomNavigationBarItem(
              icon: Icon(FIcons.bookOpen),
              label: Text(
                'Tủ sách',
                style: TextStyle(decoration: TextDecoration.none, fontSize: 10),
              ),
            ),
            const FBottomNavigationBarItem(
              icon: Icon(FIcons.user),
              label: Text(
                'Tài khoản',
                style: TextStyle(decoration: TextDecoration.none, fontSize: 10),
              ),
            ),
          ],
        ),
      );
    });
  }
}
