// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:pho_truyen/features/users/presentation/widgets/info_user/info_user_avatar.dart';

class ProfileDetail extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String followers;
  final VoidCallback onGiftPressed;
  final VoidCallback? onTap;

  const ProfileDetail({
    super.key,
    required this.avatarUrl,
    required this.name,
    required this.followers,
    required this.onGiftPressed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          InfoUserAvatar(
            avatarUrl: avatarUrl,
            isDarkMode: true,
            radius: 29,
            showEditIcon: false,
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên tác giả
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColor.primary,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text(
                        'Tác giả',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),

                    // Số lượng follow
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  followers,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          // 3. Nút Tặng quà
          Container(
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF4081), Color(0xFFD81B60)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF4081).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onGiftPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.card_giftcard, size: 16, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Tặng Quà',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
