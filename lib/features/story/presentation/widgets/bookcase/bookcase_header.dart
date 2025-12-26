import 'package:flutter/material.dart';
import 'package:pho_truyen/core/constants/app_color.dart';

class BookcaseHeader extends StatelessWidget {
  final bool isGridView;
  final Function(bool) onViewModeChanged;

  const BookcaseHeader({
    super.key,
    required this.isGridView,
    required this.onViewModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDarkMode ? Colors.white : AppColor.slate900;
    final Color elementBgColor = isDarkMode
        ? const Color(0xFF1F2235)
        : Colors.grey.shade100;
    final Color activeColor = const Color(0xFF4C8EF9);
    final Color secondaryTextColor = isDarkMode
        ? Colors.white70
        : AppColor.slate600;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Tủ sách',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.015,
          ),
        ),
        // Nút chuyển đổi Grid/List
        Container(
          height: 36,
          decoration: BoxDecoration(
            color: elementBgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              _buildIcon(
                Icons.grid_view_rounded,
                true,
                activeColor,
                secondaryTextColor,
              ),
              Container(
                width: 1,
                height: 16,
                color: secondaryTextColor.withOpacity(0.2),
              ),
              _buildIcon(
                Icons.view_list_rounded,
                false,
                activeColor,
                secondaryTextColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIcon(
    IconData icon,
    bool isGridButton,
    Color activeColor,
    Color inactiveColor,
  ) {
    final bool isActive = isGridView == isGridButton;
    return GestureDetector(
      onTap: () => onViewModeChanged(isGridButton),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Icon(
          icon,
          color: isActive ? activeColor : inactiveColor,
          size: 20,
        ),
      ),
    );
  }
}
