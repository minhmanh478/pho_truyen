import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pho_truyen/core/constants/app_color.dart';
import 'package:pho_truyen/features/chapter/presentation/controllers/chapter_controller.dart';

class ChapterSettingsBottomSheet extends StatelessWidget {
  const ChapterSettingsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChapterController>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.backgroundDark1,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Center(
            child: Text(
              'Cài đặt',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 1. Giao diện đọc
          const Text(
            'Giao diện đọc',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildThemeOption(
                  label: 'Dark Mode',
                  bgColor: const Color(0xFF1A1A1A),
                  textColor: Colors.white,
                  controller: controller,
                ),
                const SizedBox(width: 12),
                _buildThemeOption(
                  label: 'Light Mode',
                  bgColor: Colors.white,
                  textColor: Colors.black,
                  controller: controller,
                  borderColor: Colors.grey[300],
                ),
                const SizedBox(width: 12),
                _buildThemeOption(
                  label: 'Light Read',
                  bgColor: const Color(0xFFF5F5DC),
                  textColor: Colors.black87,
                  controller: controller,
                ),
                const SizedBox(width: 12),
                _buildThemeOption(
                  label: 'Sepia',
                  bgColor: const Color(0xFFE3D4B9),
                  textColor: const Color(0xFF5F4B32),
                  controller: controller,
                ),
                const SizedBox(width: 12),
                _buildThemeOption(
                  label: 'Sepia Read',
                  bgColor: const Color(0xFFEFDBB2),
                  textColor: const Color(0xFF5F4B32),
                  controller: controller,
                ),
                const SizedBox(width: 12),
                _buildThemeOption(
                  label: 'Manga',
                  bgColor: const Color(0xFFF4F4F4),
                  textColor: Colors.black,
                  controller: controller,
                ),
                const SizedBox(width: 12),
                _buildThemeOption(
                  label: 'OLED',
                  bgColor: Colors.black,
                  textColor: Colors.white,
                  controller: controller,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 2. Cỡ chữ
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cỡ chữ (${controller.fontSize.value.toInt()})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => Slider(
              value: controller.fontSize.value,
              min: 12,
              max: 30,
              divisions: 18,
              activeColor: AppColor.primaryColor,
              onChanged: (value) => controller.fontSize.value = value,
            ),
          ),
          const SizedBox(height: 4),

          // 3. Font chữ
          const Text(
            'Font chữ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildFontOption('Montserrat', controller),
              const SizedBox(width: 12),
              _buildFontOption('Roboto', controller),
              const SizedBox(width: 12),
              _buildFontOption('Quicksand', controller),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Độ đậm',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildWeightOption('ExtraLight', FontWeight.w200, controller),
              const SizedBox(width: 12),
              _buildWeightOption('Light', FontWeight.w300, controller),
              const SizedBox(width: 12),
              _buildWeightOption('Normal', FontWeight.normal, controller),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required String label,
    required Color bgColor,
    required Color textColor,
    required ChapterController controller,
    Color? borderColor,
  }) {
    return GestureDetector(
      onTap: () => controller.updateTheme(bgColor, textColor),
      child: Obx(() {
        final isSelected = controller.backgroundColor.value == bgColor;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppColor.primaryColor
                  : (borderColor ?? Colors.transparent),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
          ),
        );
      }),
    );
  }

  Widget _buildFontOption(String font, ChapterController controller) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.fontFamily.value = font,
        child: Obx(() {
          final isSelected = controller.fontFamily.value == font;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? AppColor.primaryColor : Colors.transparent,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              font,
              style: TextStyle(
                fontFamily: font,
                color: isSelected ? AppColor.primaryColor : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWeightOption(
    String label,
    FontWeight weight,
    ChapterController controller,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.fontWeight.value = weight,
        child: Obx(() {
          final isSelected = controller.fontWeight.value == weight;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? AppColor.primaryColor : Colors.transparent,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: weight,
                color: isSelected ? AppColor.primaryColor : Colors.black87,
              ),
            ),
          );
        }),
      ),
    );
  }
}
