import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/constants/app_paths.dart';
import 'package:pho_truyen/core/utils/app_actions.dart';
import 'package:pho_truyen/core/utils/app_dialogs.dart';
import 'package:pho_truyen/core/router/app_routes.dart';
import 'package:pho_truyen/features/users/presentation/widgets/info_user/info_user_avatar.dart';
import '../widgets/info_user/vip_badge.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../shared/widgets/button/section_header.dart';
import '../../../../shared/widgets/button/settings_item.dart';
import '../controllers/account/user_controller.dart';
import '../controllers/account/user_binding.dart';
import '../../../dashboard/presentation/controllers/main_app_controller.dart';
import '../../domain/entities/user_profile_entity.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late UserController controller;
  late Future<UserProfileEntity?> _profileFuture;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<UserController>()) {
      UserBinding().dependencies();
    }
    controller = Get.find<UserController>();
    _profileFuture = controller.fetchUserProfile();
  }

  void _refreshProfile() {
    setState(() {
      _profileFuture = controller.fetchUserProfile();
    });
  }

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
      body: FutureBuilder<UserProfileEntity?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 10),
                  const Text("Có lỗi xảy ra khi tải dữ liệu"),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _refreshProfile,
                    child: const Text("Thử lại"),
                  ),
                ],
              ),
            );
          }

          final profile = snapshot.data;
          if (profile == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Đăng nhập lại để refesh token"),
                  TextButton(
                    onPressed: () {
                      Get.find<MainAppController>().logout();
                    },
                    child: const Text("Đăng xuất"),
                  ),
                ],
              ),
            );
          }

          final user = profile.user;
          final wallet = profile.wallet;

          return RefreshIndicator(
            onRefresh: () async {
              _refreshProfile();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar (Left)
                        InfoUserAvatar(
                          icon: Icons.camera_alt,
                          avatarUrl: user.avatar,
                          isDarkMode: isDarkMode,
                          onCameraTap: () {
                            _refreshProfile();
                          },
                          radius: 50,
                        ),
                        const SizedBox(width: 16),

                        // User Details (Right)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.fullName,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${user.email} (${user.id})',
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 13,
                                ),
                              ),
                              if (profile.vip.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                VipBadge(vipId: profile.vip.first.vipId),
                              ],
                              if (wallet != null) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Số dư: ${wallet.totalBalance}',
                                      style: const TextStyle(
                                        color: Colors.amber,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Image.asset(
                                      AppPaths.icRuby,
                                      width: 14,
                                      height: 14,
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 0),

                  // Account Actions
                  SectionHeader(
                    title: 'Tài khoản',
                    textColor: secondaryTextColor,
                  ),
                  SettingsItem(
                    icon: Icons.edit,
                    title: 'Thông tin cá nhân',
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    cardBgColor: cardBgColor,
                    onTap: () async {
                      final result = await Get.toNamed(AppRoutes.infoUser);
                      if (result == true) {
                        Get.snackbar(
                          "Thành công",
                          "Cập nhật thông tin thành công",
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                        _refreshProfile();
                      }
                    },
                    isDarkMode: isDarkMode,
                  ),

                  SettingsItem(
                    icon: Icons.badge_outlined,
                    title: 'Thông tin tác giả',
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    cardBgColor: cardBgColor,
                    onTap: () async {
                      await Get.toNamed(AppRoutes.infoAuthor);
                      _refreshProfile();
                    },
                    isDarkMode: isDarkMode,
                  ),
                  // Personalization
                  SectionHeader(
                    title: 'Tác giả',
                    textColor: secondaryTextColor,
                  ),
                  SettingsItem(
                    icon: Icons.library_books_outlined,
                    title: 'Truyện của bạn',
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    cardBgColor: cardBgColor,
                    onTap: () async {
                      await Get.toNamed(AppRoutes.yourStories);
                    },
                    isDarkMode: isDarkMode,
                  ),
                  SettingsItem(
                    icon: Icons.post_add_outlined,
                    title: 'Đăng truyện mới',
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    cardBgColor: cardBgColor,
                    onTap: () async {
                      await Get.toNamed(AppRoutes.postNewStory);
                    },
                    isDarkMode: isDarkMode,
                  ),

                  // -- ryby
                  SectionHeader(title: 'Ruby', textColor: secondaryTextColor),
                  SettingsItem(
                    icon: Icons.diamond_outlined,
                    title: 'Đăng ký VIP',
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    cardBgColor: cardBgColor,
                    onTap: () {
                      Get.toNamed(AppRoutes.vipRegistration);
                    },
                    isDarkMode: isDarkMode,
                  ),
                  SettingsItem(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Nạp Ruby',
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    cardBgColor: cardBgColor,
                    onTap: () {
                      Get.toNamed(AppRoutes.loadedRuby);
                    },
                    isDarkMode: isDarkMode,
                  ),
                  SettingsItem(
                    icon: Icons.receipt_long_outlined,
                    title: 'Lịch sử giao dịch',
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    cardBgColor: cardBgColor,
                    onTap: () {
                      Get.toNamed(AppRoutes.transactionHistory);
                    },
                    isDarkMode: isDarkMode,
                  ),

                  // General
                  SectionHeader(
                    title: 'Ứng dụng',
                    textColor: secondaryTextColor,
                  ),
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
                  SettingsItem(
                    icon: Icons.delete_forever_outlined,
                    title: 'Xóa tài khoản',
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    cardBgColor: cardBgColor,
                    onTap: () {
                      AppDialogs.showConfirmDialog(
                        title: "Xóa tài khoản",
                        message:
                            "Bạn có muốn xóa tài khoản khỏi hệ thống không?\nLưu ý: bạn không thể đăng nhập khi đã xóa tài khoản.",
                        confirmText: "Xóa tài khoản",
                        cancelText: "Đóng",
                        onConfirm: () {
                          Get.back();
                          Get.find<MainAppController>().logout();
                        },
                        onCancel: () {
                          Get.back();
                        },
                      );
                    },
                    isDarkMode: isDarkMode,
                  ),
                  SettingsItem(
                    icon: Icons.logout,
                    title: 'Đăng xuất',
                    textColor: Colors.redAccent,
                    secondaryTextColor: secondaryTextColor,
                    cardBgColor: cardBgColor,
                    onTap: () {
                      Get.find<MainAppController>().logout();
                    },
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
