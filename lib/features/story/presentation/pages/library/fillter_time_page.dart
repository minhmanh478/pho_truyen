// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/constants/app_color.dart'; // Giả định path theo code bạn
import 'package:pho_truyen/features/story/presentation/controllers/library/filler_time_controller.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SortBottomSheet extends GetView<FillerTimeController> {
  const SortBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FillerTimeController());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: AppColor.backgroundDark1,
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.15), width: 1.5),
          left: BorderSide(color: Colors.white.withOpacity(0.15), width: 1.5),
          right: BorderSide(color: Colors.white.withOpacity(0.15), width: 1.5),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // HEADER: Line Indicator & Title & Close
          // Center(
          //   child: Container(
          //     width: 40,
          //     height: 4,
          //     margin: const EdgeInsets.only(bottom: 20),
          //     decoration: BoxDecoration(
          //       color: Colors.white.withOpacity(0.2),
          //       borderRadius: BorderRadius.circular(2),
          //     ),
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40),
              const Text(
                'Sắp xếp',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  LucideIcons.x,
                  color: Colors.white.withOpacity(0.7),
                  size: 24,
                ),
              ),
            ],
          ),
          Divider(color: Colors.white.withOpacity(0.1), height: 1),
          const SizedBox(height: 16),
          Obx(
            () => Column(
              children: TimeType.values.map((type) {
                final isSelected = controller.currentSort.value == type;
                return _buildSortOptionItem(
                  title: controller.getTitle(type),
                  isSelected: isSelected,
                  onTap: () => controller.changeSortType(type),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortOptionItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Colors.white.withOpacity(0.2))
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            // Radio Circle Custom
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.white54,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            // Text Title
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
