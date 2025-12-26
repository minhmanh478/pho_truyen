import 'package:flutter/material.dart';
// Giả sử đường dẫn của bạn, hãy điều chỉnh nếu cần
// import 'package:pho_truyen/core/constants/app_color.dart';

class InfoUserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final bool isDarkMode;
  final VoidCallback? onCameraTap;
  final IconData? icon;
  final bool showEditIcon;
  final double radius;

  const InfoUserAvatar({
    super.key,
    this.avatarUrl,
    required this.isDarkMode,
    this.onCameraTap,
    this.icon,
    this.showEditIcon = false,
    this.radius = 50,
  });

  @override
  Widget build(BuildContext context) {
    final Color inputFillColor = isDarkMode
        ? Colors.grey.shade800
        : Colors.grey.shade200;

    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDarkMode ? Colors.blue.shade100 : Colors.blue.shade100,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: radius,
              backgroundColor: inputFillColor,
              backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
                  ? NetworkImage(avatarUrl!)
                  : null,
              child: (avatarUrl == null || avatarUrl!.isEmpty)
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),
          ),

          if (showEditIcon)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onCameraTap,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon ?? Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
