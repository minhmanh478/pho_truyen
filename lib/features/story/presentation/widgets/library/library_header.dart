import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pho_truyen/core/router/app_routes.dart';
import 'package:pho_truyen/features/story/presentation/pages/library/fillter_time_page.dart';

class LibraryHeader extends StatelessWidget {
  final VoidCallback? onFilterTap;
  final VoidCallback? onSortTap;
  final Function(String)? onSearchChanged;

  const LibraryHeader({
    super.key,
    this.onFilterTap,
    this.onSortTap,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color elementBgColor = isDarkMode
        ? const Color(0xFF1F2235)
        : Colors.white;

    final Color borderColor = isDarkMode
        ? Colors.transparent
        : Colors.grey.shade300;

    final Color secondaryTextColor = isDarkMode ? Colors.white70 : Colors.grey;
    final Color iconColor = isDarkMode ? Colors.white70 : Colors.black87;
    return Row(
      children: [
        // 1. THANH TÌM KIẾM
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: elementBgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
            ),
            child: TextField(
              onChanged: onSearchChanged,
              style: TextStyle(color: secondaryTextColor),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm tên truyện',
                hintStyle: TextStyle(color: secondaryTextColor),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: secondaryTextColor),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // 2. NÚT FILTER (LỌC)
        _buildIconButton(
          Icons.tune,
          bgColor: elementBgColor,
          borderColor: borderColor,
          iconColor: iconColor,
          onTap: onFilterTap ?? () => Get.toNamed(AppRoutes.filterHashtags),
        ),

        const SizedBox(width: 12),

        _buildIconButton(
          Icons.swap_vert,
          bgColor: elementBgColor,
          borderColor: borderColor,
          iconColor: iconColor,
          onTap:
              onSortTap ??
              () {
                Get.bottomSheet(
                  const SortBottomSheet(),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  enterBottomSheetDuration: const Duration(milliseconds: 300),
                );
              },
        ),
      ],
    );
  }

  Widget _buildIconButton(
    IconData icon, {
    required Color bgColor,
    required Color borderColor,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: Icon(icon, color: iconColor),
        ),
      ),
    );
  }
}
