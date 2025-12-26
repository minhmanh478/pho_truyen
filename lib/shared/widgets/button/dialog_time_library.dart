// ignore_for_file: deprecated_member_use, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

enum SortType {
  newest('Cập nhật mới nhất'),
  oldest('Cập nhật cũ nhất'),
  mostChapters('Nhiều chương nhất'),
  leastChapters('Ít chương nhất');

  final String label;
  const SortType(this.label);
}

class SortBottomSheet extends StatelessWidget {
  final SortType currentSort;
  final Function(SortType) onSortSelected;

  const SortBottomSheet({
    super.key,
    required this.currentSort,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Sử dụng Container với decoration giống hệt DialogLogin bạn cung cấp
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, bottom: 32),
      decoration: BoxDecoration(
        color: AppColor.backgroundDark1,
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.15), width: 1.5),
          left: BorderSide(color: Colors.white.withOpacity(0.15), width: 1.5),
          right: BorderSide(color: Colors.white.withOpacity(0.15), width: 1.5),
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 24),
                const Text(
                  'Sắp xếp',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Nút đóng (X)
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    color: Colors.transparent,
                    child: const Icon(
                      LucideIcons.x,
                      color: Colors.white70,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          // Divider mờ
          Divider(color: Colors.white.withOpacity(0.1), height: 1),
          const SizedBox(height: 8),

          //LIST OPTIONS
          ...SortType.values.map((type) {
            final isSelected = currentSort == type;
            return InkWell(
              onTap: () {
                onSortSelected(type);
                Navigator.of(context).pop();
              },
              overlayColor: MaterialStateProperty.all(
                Colors.white.withOpacity(0.05),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(3),
                      child: isSelected
                          ? Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    // Text Label
                    Text(
                      type.label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 15,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
