// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:pho_truyen/features/story/presentation/controllers/library/filter_hastags_controller.dart';
// import 'filter_controller.dart';

class FillterHastagsPage extends StatelessWidget {
  FillterHastagsPage({Key? key}) : super(key: key);

  // Khởi tạo Controller (Dependency Injection)
  final FilterHastagsController controller = Get.put(FilterHastagsController());

  final Color primaryColor = const Color(0xFF2C3E50);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          'Lọc truyện',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColor.primaryBlue,
        scrolledUnderElevation: 0,

        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    "Thể loại truyện",
                    controller.genres,
                    controller.selectedGenre,
                    controller.setGenre,
                  ),
                  _buildSection(
                    "Trạng thái",
                    controller.status,
                    controller.selectedStatus,
                    controller.setStatus,
                  ),
                  _buildSection(
                    "Chương",
                    controller.chapters,
                    controller.selectedChapter,
                    controller.setChapter,
                  ),
                  _buildSection(
                    "Thời gian cập nhật",
                    controller.updateTimes,
                    controller.selectedTime,
                    controller.setTime,
                  ),
                  _buildSection(
                    "Tags",
                    controller.tags,
                    controller.selectedTag,
                    controller.setTag,
                  ),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColor.backgroundDark1,
        boxShadow: [
          // BoxShadow(
          //   color: Colors.grey.withOpacity(0.2),
          //   spreadRadius: 1,
          //   blurRadius: 5,
          //   offset: const Offset(0, -3),
          // ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: controller.resetFilters,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Hủy chọn",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: controller.applyFilter,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Lọc",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    List<String> options,
    RxString rxValue,
    Function(String) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),

        Obx(
          () => Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: options.map((option) {
              final isSelected = option == rxValue.value;

              return GestureDetector(
                onTap: () => onSelect(option),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? primaryColor : Colors.white24,
                    ),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
