// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/router/app_routes.dart';
import 'package:pho_truyen/core/utils/app_actions.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:pho_truyen/features/auth/presentation/controllers/auth_binding.dart';
import 'package:pho_truyen/features/auth/presentation/pages/account/register/register_page.dart';
import 'package:pho_truyen/shared/widgets/button/section_header.dart';
import 'package:pho_truyen/shared/widgets/button/settings_item.dart';
// Hãy chắc chắn đường dẫn import này đúng với cấu trúc thư mục của bạn

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDarkMode ? Colors.white : AppColor.slate900;
    final Color secondaryTextColor = isDarkMode
        ? Colors.grey.shade400
        : AppColor.slate600;
    final Color cardBgColor = isDarkMode
        ? AppColor.cardColor
        : Colors.grey.shade100;
    final Color primaryColor = AppColor.primaryColor;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tài khoản',
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode
            ? Colors.transparent
            : Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 40,
              backgroundColor: cardBgColor,
              child: Icon(
                Icons.person_outline,
                size: 40,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Khách',
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Đăng nhập để xử dụng các chức năng cần thiết',
              style: TextStyle(color: secondaryTextColor, fontSize: 14),
            ),
            const SizedBox(height: 24),

            //Auth Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.to(
                      () => const RegisterPage(),
                      binding: AuthBinding(),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: cardBgColor,
                      side: isDarkMode
                          ? const BorderSide(color: Colors.white10)
                          : BorderSide.none,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Đăng ký',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.toNamed(AppRoutes.login),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Personalization
            // SectionHeader(title: 'Cá Nhân Hóa', textColor: secondaryTextColor),
            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.all(24),
            //   decoration: BoxDecoration(
            //     color: cardBgColor,
            //     borderRadius: BorderRadius.circular(12),
            //     border: isDarkMode ? Border.all(color: Colors.white10) : null,
            //   ),
            //   child: Column(
            //     children: [
            //       Icon(Icons.cloud_off, size: 40, color: secondaryTextColor),
            //       const SizedBox(height: 12),
            //       Text(
            //         'Đăng nhập để xem lịch sử và tủ truyện của bạn',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(color: secondaryTextColor, fontSize: 14),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 10),

            // Reading Experience
            // SectionHeader(
            //   title: 'Trải Nghiệm Đọc',
            //   textColor: secondaryTextColor,
            // ),
            // SettingsItem(
            //   icon: Icons.tune,
            //   title: 'Giao diện đọc',
            //   textColor: textColor,
            //   secondaryTextColor: secondaryTextColor,
            //   cardBgColor: cardBgColor,
            //   onTap: () {},
            //   isDarkMode: isDarkMode,
            // ),
            // SettingsItem(
            //   icon: Icons.swap_horiz,
            //   title: 'Chế độ cuộn',
            //   trailingText: 'Dọc',
            //   textColor: textColor,
            //   secondaryTextColor: secondaryTextColor,
            //   cardBgColor: cardBgColor,
            //   onTap: () {},
            //   isDarkMode: isDarkMode,
            // ),
            // const SizedBox(height: 0),

            // //  General
            // SectionHeader(title: 'Chung', textColor: secondaryTextColor),
            // SettingsItem(
            //   icon: Icons.notifications_none,
            //   title: 'Thông báo',
            //   textColor: textColor,
            //   secondaryTextColor: secondaryTextColor,
            //   cardBgColor: cardBgColor,
            //   isDarkMode: isDarkMode,
            //   trailingWidget: Switch(
            //     value: _isNotificationEnabled,
            //     onChanged: (value) =>
            //         setState(() => _isNotificationEnabled = value),
            //     activeColor: primaryColor,
            //   ),
            // ),
            // SettingsItem(
            //   icon: Icons.language,
            //   title: 'Ngôn ngữ',
            //   textColor: textColor,
            //   secondaryTextColor: secondaryTextColor,
            //   cardBgColor: cardBgColor,
            //   onTap: () {},
            //   isDarkMode: isDarkMode,
            // ),
            // SettingsItem(
            //   icon: Icons.cleaning_services_outlined,
            //   title: 'Xóa bộ nhớ đệm',
            //   trailingText: '123 MB',
            //   textColor: textColor,
            //   secondaryTextColor: secondaryTextColor,
            //   cardBgColor: cardBgColor,
            //   onTap: () {},
            //   isDarkMode: isDarkMode,
            // ),
            // const SizedBox(height: 0),

            // Support
            SectionHeader(title: 'Ứng Dụng', textColor: secondaryTextColor),
            SettingsItem(
              icon: Icons.help_outline,
              title: 'Hỗ trợ & Phản hồi',
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              cardBgColor: cardBgColor,
              onTap: () {
                AppActions.openbaomat();
              },
              isDarkMode: isDarkMode,
            ),
            SettingsItem(
              icon: Icons.description_outlined,
              title: 'Điều khoản & Chính sách',
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              cardBgColor: cardBgColor,
              onTap: () {
                AppActions.openchinhsachquydinh();
              },
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
