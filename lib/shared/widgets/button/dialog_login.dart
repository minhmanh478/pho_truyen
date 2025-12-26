// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:pho_truyen/features/auth/presentation/pages/account/login_page.dart';
import 'package:pho_truyen/features/auth/presentation/controllers/auth_binding.dart';

class DialogLogin extends StatelessWidget {
  const DialogLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColor.backgroundDark1,
          border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                ), // Viền icon
              ),
              child: const Icon(
                LucideIcons.lock,
                size: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'Yêu cầu đăng nhập',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Description
            const Text(
              'Bạn cần đăng nhập để truy cập tính năng này. Vui lòng đăng nhập để tiếp tục.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            // Buttons Row
            Row(
              children: [
                //2 LINE BUTTON (NÚT DẠNG VIỀN)
                Expanded(
                  child: ShadButton.outline(
                    height: 48,
                    backgroundColor: Colors.transparent,
                    decoration: ShadDecoration(
                      border: ShadBorder.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    foregroundColor: Colors.white70,
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Đóng'),
                  ),
                ),
                const SizedBox(width: 16),

                // Nút Đăng nhập (Solid - Màu đặc)
                Expanded(
                  child: ShadButton(
                    height: 48,
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1F2235),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Get.to(() => const LoginPage(), binding: AuthBinding());
                    },
                    child: const Text(
                      'Đăng nhập',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
