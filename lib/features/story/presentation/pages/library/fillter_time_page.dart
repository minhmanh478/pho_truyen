// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:pho_truyen/features/story/presentation/controllers/library/filter_hastags_controller.dart';
import 'package:pho_truyen/features/story/presentation/controllers/library_controller.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SortBottomSheet extends StatelessWidget {
  const SortBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized to fetch sort options if not already
    final filterController = Get.put(FilterHastagsController());
    final libraryController = Get.find<LibraryController>();

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
          Obx(() {
            if (filterController.sortOptions.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: filterController.sortOptions.map((option) {
                // Check selection based on currentOrder and currentSort in LibraryController
                final isSelected =
                    libraryController.currentOrder == option.order &&
                    libraryController.currentSort == option.sort;

                return _buildSortOptionItem(
                  title: option.title,
                  isSelected: isSelected,
                  onTap: () {
                    libraryController.applySort(option.order, option.sort);
                    Get.back();
                  },
                );
              }).toList(),
            );
          }),
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
